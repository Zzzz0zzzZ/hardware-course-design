#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv){
    int i;
    printf("argc = %d\n", argc);
    for(int i = 0; i < argc; i++){
        printf("Argument %d: %s\n", i, argv[i]);
    }
    return (EXIT_SUCCESS);
}
