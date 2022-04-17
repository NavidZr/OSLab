#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]){
	if(argc < 2){
		printf(2, "You must enter exactly 1 number!\n");
		exit();
	}
    else
    {
		// We will use ebx register for storing input number
		int saved_ebx, number = atoi(argv[1]);
		// 
		asm volatile(
			"movl %%ebx, %0;" // saved_ebx = ebx
			"movl %1, %%ebx;" // ebx = number
			: "=r" (saved_ebx)
			: "r"(number)
		);
		printf(1, "User: find_next_prime_number() called for number: %d\n" , number);
		printf(1, "First prime number after %d is: %d\n" , number , find_next_prime_number());
		asm("movl %0, %%ebx" : : "r"(saved_ebx)); // ebx = saved_ebx -> restore
		exit();  	
    }

    exit();
} 