#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include<signal.h>

#define MSGKEY 1234

struct mybuf {
	long mtype;
	char text[100];
};

int main(){

	int pid1, pid2;
	
	pid1 = fork();
	
	if(pid1 < 0){
		printf("failed to fork a child process!\n");
		return -1;
	}
	else if(pid1 == 0){
		// receiver
		int qid;
		
		// 创建消息队列 获得qid
		qid = msgget(MSGKEY, IPC_CREAT | 0666);
		
		while(1){
			
			struct mybuf buf;
			// qid	存放的地址  消息大小  接受类型  采取的行动
			msgrcv(qid, &buf, sizeof(buf.text), 0, MSG_NOERROR);
			
			printf("message is: %s\n", buf.text);
		}
		
	}
	else {
		
		pid2 = fork();
		
		if(pid2 < 0){
			printf("failed to fork a child process!\n");
			return -1;
		}
		else if(pid2 == 0){
			// sender
			int qid;
			
			qid = msgget(MSGKEY, IPC_CREAT | 0666);
			
			while(1){
				
				sleep(1);
				
				printf("please input: ");
				struct mybuf buf;
				fgets(buf.text, sizeof(buf.text), stdin);
				
				if(strncmp(buf.text,"exit",4)==0){
					msgctl(MSGKEY, IPC_RMID, 0);
					kill(pid1,SIGKILL);
					kill(pid2,SIGKILL);
				}
				
				buf.mtype = 1000;
				
				msgsnd(qid, &buf, sizeof(buf.text), IPC_NOWAIT);
			}
			
		}
		else {
			// parent
			wait(pid1);
			wait(pid2);
		}
		
	}
	
	return 0;
}
