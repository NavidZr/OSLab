#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"


#define MUTEX 0

int func_A(int n){
  mutex_acquire(MUTEX);
  if(n == 0){
    printf(1, "func_A is done\n");
    mutex_release(MUTEX);
    return 0;
  }
  printf(1, "func_A running num = %d\n", n);
  n--;
  return func_A(n);
}

int func_B(int n){
  sleep(3);
  mutex_acquire(MUTEX);
  if(n == 0){
    printf(1, "func_B is done\n");
    mutex_release(MUTEX);
    return 0;
  }
  printf(1, "func_B running num = %d\n", n);
  n--;
  return func_B(n);
}

int
main(int argc, char *argv[])
{
  mutex_init(MUTEX);
  int pid = fork();
  if(pid == 0){
    func_A(10);
  }
  else{
    func_B(15);
  }
  wait();
  exit();
  return 0;
}