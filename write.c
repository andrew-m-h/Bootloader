#include <stdio.h>
#include <stdlib.h>

//read the two nasm compiled binaries, bsect.bin & sect2.bin into a buffer, boot_buf
//write 0x55aa into the 'magic' location (510, 511)
//write out to file defined by argv[1]

int main(int argc, char ** argv)
{
    if (argc != 2){
        printf("Must pass file as argument\n");
        exit(0);
    }

    char boot_buf[1024];        //size of two 512b segments
    FILE * bsect, * sect2, * out;

    //read in first boot segment (only 510 bytes)
    bsect = fopen("bsect.bin", "r");
    fread(boot_buf, sizeof(char), 510, bsect);
    fclose(bsect);

    //write magic code, making drive bootable
    boot_buf[510] = 0x55;
    boot_buf[511] = 0xaa;

    //read second boot sector into second half of boot_buf
    sect2 = fopen("sect2.bin", "r");
    fread(boot_buf+512, sizeof(char), 512, sect2);
    fclose(sect2);

    //write out to given file
    out = fopen(argv[1], "w");
    fwrite(boot_buf, sizeof(char), 1024, out);
    fclose(out);

    return 0;
}
