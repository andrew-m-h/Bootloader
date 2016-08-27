#qemu emulate a raw floppy disk booting
run-floppy : boot.flp
	qemu-system-i386 -fda boot.flp 

#qemu emulate a cdrom (iso) booting
run-iso : myiso.iso
	qemu-system-i386 -cdrom myiso.iso

#create the iso from the boot.bin 
myiso.iso: boot.flp
	rm -f myiso/boot.bin
	dd if=boot.flp of=myiso/boot.bin bs=512b count=2 #copy the boot.bin into myiso/ folder
	truncate myiso/boot.bin --size 1228800           #el torito requires boot disk to be exact size of floppy (1200kB)
	mkisofs -o myiso.iso -b boot.bin myiso           # mkisofs creates an iso from a file and boot disk

bsect.bin: bsect.s 
	nasm -f bin -o bsect.bin bsect.s

sect2.bin : sect2.s 
	nasm -f bin -o sect2.bin sect2.s

write : write.c sect2.bin bsect.bin
	cc write.c -o write

boot.flp: write
	./write boot.flp

clean :
	rm -f boot.flp bsect.bin sect2.bin write myiso.iso myiso/boot.bin

