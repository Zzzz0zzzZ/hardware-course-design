#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

#define NUM 1000


int total;	// 全局变量 数组和
int pt;		// 加和位置指针

void thread_sum(void *arg){
	printf("[thread_sum]	called\n");
 	int *arr = (int *) arg;
	int sum = 0;
	int i = 0;
	while(i < NUM){
		if(i < pt){
			sum += arr[i++];
		}
	}
  	total = sum;
}

void thread_sort(void *arg){
	printf("[thread_sort]	called\n");
 	int *arr = (int *) arg;
	
	for(int i = 0; i < NUM; i++){
		int tmp = i;
		for(int j = i + 1; j < NUM; j++){
			if(arr[j] > arr[tmp]){
				tmp = j;
			}
		}
		int temp = arr[i];
		arr[i] = arr[tmp];
		arr[tmp] = temp;
		pt++; 
	}
}

int main(){
 	
 	
 	int ret1, ret2;
	int *nums = (int*)malloc((NUM)*sizeof(int));
	
	for(int i = 0; i < NUM ; i++){
		nums[i] = (i % 10) + 1;
		printf("%d ", nums[i]);
		if(((i%10)+1) == 10)
			printf("\n");
	}
	printf("******************************************************\n\n");
	pthread_t id1, id2;

	ret1 = pthread_create(&id1, NULL, (void *)thread_sort, (void*)nums);
	if(ret1){
		printf("ERROR:	failed to create thread_sort!\n");
	}
	
	ret2 = pthread_create(&id2, NULL, (void *)thread_sum, (void*)nums);
	if(ret2){
		printf("ERROR:	failed to create thread_sum!\n");
	}
	
	
	pthread_join(id1, NULL);
	pthread_join(id2, NULL);
	
	printf("after sort:	\n");
	for(int i = 0; i < NUM; i++){
		printf("%d ", nums[i]);
	}
	printf("\n");
	printf("sum: %d \n",total);
	free(nums);
	
	return 0;
}

