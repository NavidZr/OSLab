#include "types.h"
#include "stat.h"
#include "user.h"
#include "stddef.h"


int main(int argc, char *argv[]){
	if(argc < 2){
		printf(1, "You must enter system call number!\n");
		exit();
	}
    else
    {
		// We will use ebx register for storing input number
		int syscall_number = atoi(argv[1]);
        int saved_ebx;
		//
        asm volatile(
			"movl %%ebx, %0;" // saved_ebx = ebx
			"movl %1, %%ebx;" // ebx = syscall_number
			: "=r" (saved_ebx)
			: "r"(syscall_number)
		);
        int child_a=1;
        //child_b;

        child_a = fork();
        if (child_a == 0) {
           // Child A code /
            //wait();
            
            printf(1,"User: get_call_count() called for system call %d from first child process(pid=%d)\n" , syscall_number, getpid());
            
	    printf(1,"User: the number of times the system call number %d was called in first child process: %d\n" , syscall_number , get_call_count());
            exit();
        }
	//printf(1, "child = %d \n",syscall_number);
        /*child_b = fork();
        if (child_b == 0) {
            //Child B code
            printf(1, "User: get_call_count() called for system call %d from second child process(pid=%d)\n" , syscall_number, getpid());
	        //printf(1, "the number of times the system call number %d was called in second child process: %d\n" , syscall_number , get_call_count());
            exit();
        }*/
        if(child_a){
            // Parent code /
            printf(1,"\nUser: the number of times the system call number %d was called in parent process: %d\n" , syscall_number , get_call_count());
            
            wait();
            printf(1,"\nUser: get_call_count() called for system call %d from parent process(pid=%d)\n" , syscall_number, getpid());
            
        }
        //printf(1, "parent = %d \n",syscall_number);       
		       

        //asm("movl %0, %%ebx" : : "r"(saved_ebx)); // ebx = saved_ebx -> restore
        //while(wait()!=-1);
 	
    }

    exit();
} 
