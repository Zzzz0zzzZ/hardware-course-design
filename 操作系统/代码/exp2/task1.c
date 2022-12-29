#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h> 

int main(){
	
	int pid_1, pid_2;
	
	pid_1 = fork();
	if(pid_1 < 0){
		printf("fork pid_1 failed!\n");
		return -1;
	}
	else if(pid_1 == 0){
		printf("当前进程pid: %d	父进程pid: %d 当前输出: b\n", getpid(), getppid());
	}
	else{
		pid_2 = fork();
		if(pid_2 < 0){
			printf("fork pid_2 failed!\n");
			return -1;
		}
		else if(pid_2 == 0){
			printf("当前进程pid: %d	父进程pid: %d 当前输出: c\n", getpid(), getppid());
		}
		else{
			printf("当前进程pid: %d	当前输出: a\n", getpid());
		}
	}
	
	return 0;
}
