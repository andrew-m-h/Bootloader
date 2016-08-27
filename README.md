# Bootloader
basic hello world bootloader. It runs as a floppy or as a cdrom from iso with qemu.

run 
```
make run-floppy     #plain floppy
```
or run
```
make run-iso        #cdrom
```

to test it out.
The source is quite well documented (and quite simple).

### bsect.s
This file represents the initilal 512b program that is loaded into memory by the bios at boot time. It will print out some messages, and then attempt to load the the second sector into memory and jump to it.

It checks for the an error code when from interrupt 0x10 and will print out an error message and loop infinitly if an error occurs.

### sect2.s
This file represents the program that is loaded as the second stage boot loader by bsect.s. It exists to purely write out a hello world message and demonstrate that the alledged jump has infact taken place.

### write.c
This program is a helper program, adding in the magic boot code 0x55aa and combining the two sectors into one 1024b boot loader.
