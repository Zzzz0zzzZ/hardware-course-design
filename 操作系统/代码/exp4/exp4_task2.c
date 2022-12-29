#include<stdio.h>
#include<unistd.h>
#include<pthread.h>
#include<semaphore.h>

int buf[2];		// 缓冲区
int in;			// index
int counter;	// 奇偶判断

sem_t sem1, sem2, sem3, sem4;

void r1(){

	FILE*fp = fopen("1.dat","r");
    while(1){
        
		sem_wait(&sem1);
		
        fscanf(fp,"%d",&buf[in]);
        in = (in + 1) % 2;
        
        sem_post(&sem2);

        char c11 = fgetc(fp);
        if(c11=='\n' || c11==EOF) break;
    }

}

void r2(){

	FILE*fp = fopen("2.dat","r");
    while(1){
        
        sem_wait(&sem2);

        fscanf(fp,"%d",&buf[in]);  
        in = (in + 1) % 2;
        
        if(!counter){
        	counter = ~counter;
        	sem_post(&sem3);
        }
        else{
        	counter = ~counter;
        	sem_post(&sem4);
        }

        char c11 = fgetc(fp);
        if(c11=='\n' || c11==EOF) break;
    }

}

void w1(){
	
	while(1){	
    	
    	sem_wait(&sem3);
    	
    	printf("Plus:%d+%d=%d\n",buf[0],buf[1],buf[0]+buf[1]);
    	
    	sem_post(&sem1);
    	
    }   
}

void w2(){
	
	while(1){	
    		
    	sem_wait(&sem4);
    	
    	printf("Multi:%d*%d=%d\n",buf[0],buf[1],buf[0]*buf[1]);
    	
    	sem_post(&sem1);
    	
    }   
}

int main(){
	pthread_t id1, id2, id3, id4;
	
	sem_init(&sem1,0,1);
	sem_init(&sem2,0,0);
	sem_init(&sem3,0,0);
	sem_init(&sem4,0,0);
	
	pthread_create(&id1, NULL, (void *)r1, NULL);
	pthread_create(&id2, NULL, (void *)r2, NULL);
	pthread_create(&id3, NULL, (void *)w1, NULL);
	pthread_create(&id4, NULL, (void *)w2, NULL);
	
	pthread_join(id1, NULL);
	pthread_join(id2, NULL);
	pthread_join(id3, NULL);
	pthread_join(id4, NULL);
	
	return 0;
}





