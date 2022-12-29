#include <stdio.h>
#include <pthread.h>


struct targs{
	int num;
	char c;
};

void myThread1(void *arg){
	struct targs * targ_1;
	targ_1 = (struct targs *) arg;
	
	printf("[myThread1]	recieved: 	%d    %c\n", targ_1->num, targ_1->c);
}

void myThread2(void *arg){
	struct targs * targ_2;
	targ_2 = (struct targs *) arg;
	
	printf("[myThread2]	recieved: 	%d    %c\n", targ_2->num, targ_2->c);
}


int main(){
	
	pthread_t id1, id2;
	int ret1, ret2;
	
	struct targs arg1, arg2;
	arg1.num = 6;
	arg1.c = 'a';
	arg2.num = 8;
	arg2.c = 'b';
	
	ret1 = pthread_create(&id1, NULL, (void*)myThread1, &arg1);
	if(ret1){
		printf("ERROR:	failed to create thread 1!\n");
	}
	
	ret2 = pthread_create(&id2, NULL, (void*)myThread2, &arg2);
	if(ret2){
		printf("ERROR:	failed to create thread 2!\n");
	}
	
	pthread_join(id1, NULL);
	pthread_join(id2, NULL);

	return 0;
}
