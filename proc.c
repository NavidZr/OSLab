#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "syscall.h"

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

struct semaphore
{
  int max_procs;
  int curr_procs;
  struct spinlock lock;
  struct proc* queue[NPROC];
} semaphores[SEMAPHORE_COUNT];

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

int compareStrings(char* x, char* y)
{
    int flag = 1;
 
    // Iterate a loop till the end
    // of both the strings
    while (*x != '\0' || *y != '\0') {
        if (*x == *y) {
            x++;
            y++;
        }
 
        // If two characters are not same
        // print the difference and exit
        else if ((*x == '\0' && *y != '\0')
                 || (*x != '\0' && *y == '\0')
                 || *x != *y) {
            flag = 0;
            break;
        }
    }
    cprintf("%s", x);
    cprintf("/n");
    cprintf("%s", y);
    cprintf("/n");
    cprintf("%d", flag);
    return flag;
}

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  p->priority = 100/p->pid;
  p->queue = (p->pid == 0 || p->pid == 1 || p->pid == 2) ? 1 : 2;     //FCFS
  p->exec_cycle = 0;
  p->last_cpu_time = 0;
  p->exec_cycle_ratio = 1;
  p->arrival_time_ratio = 1;
  p->priority_ratio = 1;
  p->creation_time = ticks;
  // unlock me!
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S
  
  for(int k=0; k < 25; k++)
  	p->syscnt[k] = 0;

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

int round(float num){
  if(num - (int)(num) <= 0.5)
    return (int)(num);
  return (int)(num) + 1;
}

char*
get_state_string(int state)
{
  if (state == 0) {
    return "UNUSED";
  }
  else if (state == 1) {
    return "EMBRYO";
  }
  else if (state == 2) {
    return "SLEEPING";
  }
  else if (state == 3) {
    return "RUNNABLE";
  }
  else if (state == 4) {
    return "RUNNING";
  }
  else if (state == 5) {
    return "ZOMBIE";
  }
  else {
    return "";
  }
}

char*
get_queue_string(int queue)
{
  if (queue == 1)
    return "RR";
  else if (queue == 2)
    return "FCFS";
  else
    return "BJF";
}

int
get_rank(struct proc* p)
{
  int rank = p->priority * p->priority_ratio
             + p->creation_time * p->arrival_time_ratio
             + p->exec_cycle * p->exec_cycle_ratio;
  
  return rank;
}

void
print_procs(void)
{
  struct proc *p;
  cprintf("name          pid          state          queue_lvl      exec_cycle*10     arrival_time      rank           priority    ratios(priority,arrival_time,exec_cycle)");
  cprintf("\n");
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if (p->state == UNUSED)
      continue;
    cprintf(p->name);
    for(int i=0; i<15-strlen(p->name); i++)
      cprintf(" ");
    cprintf("%d", p->pid);
    cprintf("           ");
    cprintf(get_state_string(p->state));
    cprintf("           ");
    cprintf(get_queue_string(p->queue));
    cprintf("             ");
    cprintf("%d", round(p->exec_cycle * 10));
    cprintf("                ");
    cprintf("%d", p->creation_time);
    cprintf("           ");
    cprintf("%d", get_rank(p));
    cprintf("          ");
    cprintf("%d",p->priority);
    cprintf("                ");
    cprintf("%d", p->arrival_time_ratio);
    cprintf("-");
    cprintf("%d",p->exec_cycle_ratio);
    cprintf("-");
    cprintf("%d",p->priority_ratio);
    cprintf("\n");
  }    
  release(&ptable.lock);
}



struct proc*
find_RR(void)
{
  struct proc *p;
  struct proc *best = 0;

  int now = ticks;
  int max_proc = -100000;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE || p->queue != 1)
        continue;

      if(now - p->last_cpu_time > max_proc){
        max_proc = now - p->last_cpu_time;
        best = p;
      }
  }
  return best;
}

struct proc*
find_FCFS(void)
{
  struct proc *p;
  struct proc *first_proc = 0;

  int first = 2e9;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if (p->state != RUNNABLE || p->queue != 2)
        continue;

      if (p->creation_time < first)
      {
        first = p->creation_time;
        first_proc = p;
      }
  }
  return first_proc;
}

struct proc*
find_BJF(void)
{
  struct proc* p;
  struct proc* min_proc = 0;
  int min_rank = 1000000;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
    if (p->state != RUNNABLE || p->queue != 3)
      continue;
    if (get_rank(p) < min_rank){
      min_proc = p;
      min_rank = get_rank(p);
    }
  }

  return min_proc;
}

void
move_queues()
{
  struct proc* p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
    if (p->state == RUNNABLE && p->age > 8000){
      p->age = 0;
      p->queue = (p->queue == 1) ? 1 : (p->queue-1);
    }
  }
}

void
update_age(struct proc* p_exec, uint cycles)
{
  struct proc* p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
    if (p->state == RUNNABLE){
      p->age += cycles;
    }
  }
  p_exec->age = 0;
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  uint tick1, tick2;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    tick1 = ticks;
    
    p = find_RR();

    if (p == 0)
      p = find_FCFS();

    if (p == 0)
      p = find_BJF();

    if (p == 0) {
      release(&ptable.lock);
      continue;
    }
    move_queues();
    // for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    //   if(p->state != RUNNABLE)
    //     continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
    c->proc = p;

    switchuvm(p);
    p->state = RUNNING;

    swtch(&(c->scheduler), p->context);
    switchkvm();
    tick2 = ticks;
    update_age(p, tick2-tick1);
      // Process is done running for now.
      // It should have changed its p->state before coming back.
    c->proc = 0;
    release(&ptable.lock);

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  myproc()->last_cpu_time = ticks;
  myproc()->exec_cycle += 0.1;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

int 
find_next_prime_number(int n)
{
  int is_prime = 0;
  int temp = 1; 
  while(!is_prime){
      n++;
      temp = 1;
      int i;
      for( i=2; i <= n/i; i++){
          if( n%i == 0 ){
              is_prime = 0;
              temp = 0;
              break;  
          } 
      }
      if(temp) is_prime = 1;
  }
  return n;
}

int 
get_most_caller(int sys_num)
{
  struct proc *p;
  int pid_max = -1;
  int cnt_max = -1;
  acquire(&ptable.lock);
  cprintf("Kernel: The list of onging processes:\n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    int * sys_cnt = p->syscnt;
    int cnt = *(sys_cnt+sys_num-1);
    if(p->pid !=0)
      cprintf("     pid=%d, name: %s \n",p->pid, p->name);
    if(cnt >= cnt_max){
      cnt_max = cnt;
      pid_max = p->pid;
    }

  }
  release(&ptable.lock);
  return pid_max;
}

void
set_queue(int pid, int new_queue)
{
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid)
      p->queue = new_queue;
  }
  release(&ptable.lock);
}

void 
set_global_bjf_params(int p_ratio, int a_ratio, int e_ratio)
{
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    p->arrival_time_ratio = a_ratio;
    p->exec_cycle_ratio = e_ratio;
    p->priority_ratio = p_ratio;
  }
  release(&ptable.lock);
}

void 
set_bjf_params(int pid, int p_ratio, int a_ratio, int e_ratio)
{
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->arrival_time_ratio = a_ratio;
      p->exec_cycle_ratio = e_ratio;
      p->priority_ratio = p_ratio;
    }
  }
  release(&ptable.lock);
}

// Process must have acquired lock before
// calling these two functions
void 
add_to_sem_queue(int i, struct proc* proc)
{
  for (int j = 0; j < NPROC; j++) {
    if (semaphores[i].queue[j] == 0) {
      semaphores[i].queue[j] = proc;
      return;
    }
  }
}

struct proc*
pop_sem_queue(int i)
{
  struct proc* p = 0;
  int j = 0;

  if (semaphores[i].queue[0] == 0)
    return 0;
  
  p = semaphores[i].queue[0];

  for (j = 0; j < NPROC - 1; j++) {
    if (semaphores[i].queue[j+1] != 0)
      semaphores[i].queue[j] = semaphores[i].queue[j+1];
    else {
      semaphores[i].queue[j] = 0;
      break;
    }
  }

  return p;
}

int
sem_init(int i, int v) 
{
  semaphores[i].max_procs = v;
  // if (i == 1)
  //   semaphores[i].curr_procs = 5;
  // else
    semaphores[i].curr_procs = 0;
  
  initlock(&(semaphores[i].lock), (char*)i + '0');
  
  return 1;
}

int 
sem_acquire(int i)
{
  struct proc* p = myproc();
  acquire(&(semaphores[i].lock));
  if (semaphores[i].curr_procs < semaphores[i].max_procs) {
    semaphores[i].curr_procs += 1;
  }
  else {
    add_to_sem_queue(i, p);
    cprintf("Process %d going to sleep\n", p->pid);
    sleep(p, &(semaphores[i].lock));
    semaphores[i].curr_procs += 1;
  }
  release(&(semaphores[i].lock));

  return 1;
}

int 
sem_release(int i)
{
  struct proc* p = 0;
  acquire(&(semaphores[i].lock));
  
  semaphores[i].curr_procs -= 1;
  p = pop_sem_queue(i);
  release(&(semaphores[i].lock));
  if (p != 0) {
    cprintf("Process %d is waking up\n", p->pid);
    wakeup(p);
  }
  
  return 1;
}

int
wait_for_process(int proc_pid)
{
  struct proc *p;
  struct proc *curproc = myproc();
  int exist=0;
  acquire(&ptable.lock);
  for(;;){
    exist=0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->pid == proc_pid)
        exist = 1;
      if(p->state == ZOMBIE && p->pid == proc_pid){
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return proc_pid;
      }
    }
    if(!exist || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}