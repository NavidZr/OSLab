#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"
#include "syscall.h"

#define PGSIZE 0x1000

int
main(int argc, char *argv[])
{
int ppid = getpid();
if (fork() == 0) {
char addr = 'a'; //test on stack 
char* align = (char*)((((unsigned int)((uint *)&addr)) & ~(PGSIZE-1)));
if(mprotect(align, 1)) {
printf(1, "mprotect FAILED\n");
exit();
}
// should not reach here
printf(1, "line %d: failed to protect the stack\n", __LINE__);
printf(1, "TEST FAILED\n");
kill(ppid);
exit();
} else {
wait();
}

if (fork() == 0) {
char *addr = malloc(1); // test on heap
*addr = 'a';
char *align = (char*)((((unsigned int)((uint *)&addr)) & ~(PGSIZE-1)));
if(mprotect(align, 1)) {
printf(1, "mprotect FAILED\n");
exit();
}
(*addr)++;
// should not reach here
printf(1, "line %d: failed to protect the heap\n", __LINE__);
printf(1, "TEST FAILED\n");
kill(ppid);
exit();
} else {
wait();
}
exit();
}