#!/bin/sh

#clean old build
rm ./floppy.img ./Stage1/stage1.bin ./Stage2/KRNLDR.SYS ./Stage2/KRNLDR.SYS 

#create virtual floppy image
dd bs=512 count=2880 if=/dev/zero of=./floppy.img

#add the FAT12 file system on the floppy
mkfs.msdos -F 12 ./floppy.img

nasm -f bin ./Stage1/stage1.asm -o ./Stage1/stage1.bin

#copy in parts to not overwrite dos boot record in the FAT12 system
dd if=./Stage1/stage1.bin of=./floppy.img bs=1 count=3 conv=notrunc #copy 0-3
dd if=./Stage1/stage1.bin of=./floppy.img bs=1 seek=62 skip=62 count=450 conv=notrunc  #copy 0x1c2 bytes strating form 0x3e


#now to load the second stage loader onto the floppys FAT12 filesystem
nasm -f bin ./Stage2/stage2.asm -o ./Stage2/KRNLDR.SYS
mount -oloop ./floppy.img /media/floppy0 &
#wait for mount to complete
pid = $!
wait $pid
cp ./Stage2/KRNLDR.SYS /media/floppy0 &
#wait for copy to complete
pid = $!
wait $pid
umount /media/floppy0
#wait for umount to complete
pid = $!
wait $pid

qemu-system-x86_64 -fda ./floppy.img
