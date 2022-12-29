#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h> 


int main(){
	int pid_1, pid_2;
	int fd[2];
	char buf1[100] = "Child 1 is sending a message!";	// child1
	char buf2[100] = "Child 2 is sending a message!";	// child2
	char buf3[100];	// parent
	
	pipe(fd);
	
	pid_1 = fork();
	if(pid_1 < 0){
		printf("fork child 1 error!\n");
		return -1;
	}
	// child
	else if(pid_1 == 0){
		printf("[child 1]	ppid:	%d    pid    %d\n", getppid(), getpid());
		close(fd[0]);
		write(fd[1], buf1, 100);
	}
	else{
		pid_2 = fork();
		if(pid_2 < 0){
			printf("fork child 2 error!\n");
			return -1;
		}
		//child 2
		else if(pid_2 == 0){
			printf("[child 2]	ppid:	%d    pid    %d\n", getppid(), getpid());
			close(fd[0]);
			write(fd[1], buf2, 100);
			
		}
		// parent
		else {
			printf("[parent]	pid:    %d\n", getpid());
			// wait(pid_1);
			close(fd[1]);
			read(fd[0], buf3, 100);
			printf("%s\n", buf3);
			// wait(pid_2);
			close(fd[1]);
			read(fd[0], buf3, 100);
			printf("%s\n", buf3);
		}
		
	}
	
	return 0;
}
