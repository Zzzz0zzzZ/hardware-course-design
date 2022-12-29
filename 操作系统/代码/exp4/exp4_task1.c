#include<stdio.h>
#include<unistd.h>
#include<pthread.h>
#include<semaphore.h>

int buf[2];		// 缓冲区
int in;			// index
/*
	n			总容量 			2
	mutex[2] 	读、写 两把锁	 	1
	c[2]		记数器			0
*/
sem_t n;
sem_t mutex[2];
sem_t c[2];	

void r1(){

	FILE*fp = fopen("1.dat","r");
    while(1){
        sem_wait(&n);
        sem_wait(&mutex[0]);

        fscanf(fp,"%d",&buf[in]);
        sem_post(&c[in]);
        in = (in + 1) % 2;
        sem_post(&mutex[0]);

        char c11 = fgetc(fp);
        if(c11=='\n' || c11==EOF) break;
    }

}

void r2(){

	FILE*fp = fopen("2.dat","r");
    while(1){
        sem_wait(&n);
        sem_wait(&mutex[0]);

        fscanf(fp,"%d",&buf[in]);
        sem_post(&c[in]);
        in = (in + 1) % 2;
        sem_post(&mutex[0]);

        char c11 = fgetc(fp);
        if(c11=='\n' || c11==EOF) break;
    }

}

void w1(){
	
	while(1)
    {	
    	
    	sem_wait(&mutex[1]);
    	
    	sem_wait(&c[0]);
    	sem_wait(&c[1]);
    	
    	printf("Plus:%d+%d=%d\n",buf[0],buf[1],buf[0]+buf[1]);
    	
    	sem_post(&n);
    	sem_post(&n);
    	
    	sem_post(&mutex[1]);
    	
    }   
}

void w2(){
	
	while(1)
    {	
    		
    	sem_wait(&mutex[1]);
    	
    	sem_wait(&c[0]);
    	sem_wait(&c[1]);
    	
    	printf("Multi:%d*%d=%d\n",buf[0],buf[1],buf[0]*buf[1]);
    	
    	sem_post(&n);
    	sem_post(&n);
    	
    	sem_post(&mutex[1]);
    }   
}

int main(){
	pthread_t id1, id2, id3, id4;
	int ret1, ret2, ret3, ret4;
	
	sem_init(&n, 0, 2);
	sem_init(&mutex[0], 0, 1);
	sem_init(&mutex[1], 0, 1);
	sem_init(&c[0], 0, 0);
	sem_init(&c[1], 0, 0);
	
	ret1 = pthread_create(&id1, NULL, (void *)r1, NULL);
	if(ret1){
		printf("ERROR:	failed to create thread r1!\n");
	}
	ret2 = pthread_create(&id2, NULL, (void *)r2, NULL);
	if(ret2){
		printf("ERROR:	failed to create thread r2!\n");
	}
	ret3 = pthread_create(&id3, NULL, (void *)w1, NULL);
	if(ret3){
		printf("ERROR:	failed to create thread w1!\n");
	}
	ret4 = pthread_create(&id4, NULL, (void *)w2, NULL);
	if(ret4){
		printf("ERROR:	failed to create thread w2!\n");
	}
	
	pthread_join(id1, NULL);
	pthread_join(id2, NULL);
	pthread_join(id3, NULL);
	pthread_join(id4, NULL);
	
	
	return 0;
}





