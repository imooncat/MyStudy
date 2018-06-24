#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

int res = 0;

void *th1() {
    res = 1;
    sleep(3);
    if(res != 1) {
        puts("Hacked!");
    } else {
        puts("Nice!");
    }
}

void *th2() {
    sleep(1);
    res = 2;
}

int main() {
    pthread_t tid1, tid2;
    
    pthread_create(&tid1, NULL, (void *) th1, NULL);
    pthread_create(&tid2, NULL, (void *) th2, NULL);

    pthread_join(tid1, NULL);
    pthread_join(tid2, NULL);

    return 0;
}
