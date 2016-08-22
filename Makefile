run-floppy : boot.flp
	qemu-system-i386 -fda boot.flp

run-iso : myiso.iso
	qemu-system-i386 -cdrom myiso.iso

myiso.iso: boot.flp
	rm -f myiso/boot.bin
	dd if=boot.flp of=myiso/boot.bin bs=512b count=2
	mkisofs -no-emul-boot -boot-load-size 2 -o myiso.iso -b boot.bin myiso

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

