#include <stdio.h>
#include <pthread.h>


void myThread1(){
	printf("[myThread1]	Hello World!\n");
}

void myThread2(){
	printf("[myThread2]	Hello World!\n");
}


int main(){
	
	pthread_t id1, id2;
	int ret1, ret2;
	
	ret1 = pthread_create(&id1, NULL, (void*)myThread1, NULL);
	if(ret1){
		printf("ERROR:	failed to create thread 1!\n");
	}
	
	ret2 = pthread_create(&id2, NULL, (void*)myThread2, NULL);
	if(ret2){
		printf("ERROR:	failed to create thread 2!\n");
	}
	
	pthread_join(id1, NULL);
	pthread_join(id2, NULL);

	return 0;
}
