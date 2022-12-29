#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h> 

#define LOOP 1000

int main(){
	
	int pid_1, pid_2;
	
	pid_1 = fork();
	if(pid_1 < 0){
		printf("fork pid_1 failed!\n");
		return -1;
	}
	else if(pid_1 == 0){
		for(int i=0; i<LOOP; i++)
			printf("b");
		printf("\n");
	}
	else{
		pid_2 = fork();
		if(pid_2 < 0){
			printf("fork pid_2 failed!\n");
			return -1;
		}
		else if(pid_2 == 0){
			for(int i=0; i<LOOP; i++)
				printf("c");
			printf("\n");
		}
		else{
			for(int i=0; i<LOOP; i++)
				printf("a");
			printf("\n");
		}
	}
	
	return 0;
}
