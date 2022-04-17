#include "types.h"
#include "stat.h"
#include "user.h"
#include "stddef.h"
#include "syscall.h"


int main(int argc, char *argv[]){
    int child_a, child_b;
    child_a = fork();
    int child_a_pid = child_a;
    if (child_a == 0) {     
        int cnt=0;
        printf(1,"User: child process 1 with pid=%d is working!\n", getpid());
        while(cnt!=10000000)
            cnt++;
        printf(1,"User: child process 1 with pid=%d is done!\n", getpid());
		exit();
    }
	else{
		child_b = fork();
		if (child_b == 0) {  
            sleep(3);
            wait_for_process(child_a_pid);
            printf(1,"User: child process 2 with waiting done correctly!\n");
			exit();
        }
  	  	else {
      	  	
      		wait();
       		wait();
            sleep(100);
            printf(1,"User: parent process with pid=%d is exiting\n", getpid());

		}  	  		 	
	}
 	exit();
} 