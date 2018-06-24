#include <string.h>
#include <unistd.h>
#include <stdio.h>

int main() {
    char fn[] = "temp_file";
    char str[] = "Hacked!\n";
    FILE *fp;
    if(access(fn, W_OK)) {
        puts("No permission.");
        return -1;
    }
    //usleep(1000);
    fp = fopen(fn, "w");
    fwrite(str, sizeof(char), strlen(str), fp);
    fclose(fp);
    return 0;
}
