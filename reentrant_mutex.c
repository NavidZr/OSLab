#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"


int first_func(int n)
{
    int temp = n;
    acquire_rl();
    if (n == 0){
        printf(1,"first func done\n");
        release_rl();
        return 1;
    }
    printf(1,"first func run number %d \n",n);
    temp--;
    first_func(temp);
    return 0;
}


int second_func(int n)
{
    int temp = n;
    acquire_rl();
    if (n == 0){
        printf(1,"second func done\n");
        release_rl();
        return 1;
    }
    printf(1,"sec func run number %d \n",n);
    temp--;
    second_func(temp);
    return 0;
}

int main(int argc, char *argv[])
{
    if(fork() == 0)
        initlock_rl();
    else{
        sleep(5);
        acquire_rl();
    }
    // printf(1,"reentrant mutex test\n");
    // if(fork() == 0)
    //     first_func(10);
    // else
    // {
    //     sleep(5);
    //     second_func(10);
    // }
    return 0;
}