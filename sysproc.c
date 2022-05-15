#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_find_next_prime_number(void)
{
  int number = myproc()->tf->ebx; //register after eax
  cprintf("Kernel: sys_find_next_prime_num() called for number %d\n", number);
  return find_next_prime_number(number);
}

int 
sys_get_call_count(void)
{
  int  *cnt;
  int sys_num;
  struct proc *curproc = myproc();
  argint(0, &sys_num);
  cnt = curproc->syscnt;
  return *(cnt+sys_num-1);
}

int
sys_get_most_caller(void)
{
  int sys_num;
  argint(0, &sys_num);
  return get_most_caller(sys_num);
}

int 
sys_wait_for_process(void)
{
  int pid;
  argint(0, &pid);
  return wait_for_process(pid);

}

void
sys_set_queue(void)
{
  int pid, new_queue;
  argint(0, &pid);
  argint(1, &new_queue);
  set_queue(pid, new_queue);
}

void
sys_print_procs(void)
{
  print_procs();
}

void
sys_set_global_bjf_params(void)
{
  int p_ratio, a_ratio, e_ratio;
  argint(0, &p_ratio);
  argint(1, &a_ratio);
  argint(2, &e_ratio);
  set_global_bjf_params(p_ratio, a_ratio, e_ratio);
}

void
sys_set_bjf_params(void)
{
  int pid, p_ratio, a_ratio, e_ratio;
  argint(0, &pid);
  argint(1, &p_ratio);
  argint(2, &a_ratio);
  argint(3, &e_ratio);
  set_bjf_params(pid, p_ratio, a_ratio, e_ratio);
}