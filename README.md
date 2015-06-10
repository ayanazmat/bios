#BIOS and Bootloaders

This project is a compilation of different resources to understand bootloaders, some examples implemented in Linux, and my understanding of how the work. The bootloaders directory contains some bootloaders I got running using various tutorials that have been linked to.

This document is meant to summarize the BIOS boot process so that someone new to the topic can understand the basics and dive right into the examples.

##The Boot Sector

Boot sequence:

1. BIOS receives power_good from mother board

2. POST (Power On Self Test) - Check if power is ok and devices are installed. Mouse, keyboard etc.

3. When the CPU is powered up 80386 and later CPUs define the following predefined data in registers:

    1. IP 0xfff0

    2. CS Selector 0xf000

    3. CS base 0xffff0000

4. The processor in now working in real mode.

5. POST loads BIOS at end of memory 0xFFFFF0 and puts a jump instruction to BIOS at 0x0. 

6. The processor’s Instruction Pointer (CS:IP) is set to 0, and the processor takes control.

7. Processor starts executing, jumps to BIOS. Now BIOS code takes control

8. BIOS does the following:

    4. Creates IVT (Interrupt Vector Table)

    5. Tests hardware and memory

    6. Executes INT(0x19) to find bootable device

    7. bootsector is found and loaded at 0x7c00 and jump to it giving control to the bootloader. Only 512 bytes are copied from the bootloader, so the boot loader must be 512 bytes only.

    8. If there is a bug in the bootloader, the system will triple fault.

##BIOS

It’s an acronym for Basic Input/Output System. It has now been widely replaced by UEFI, but we will talk about that later. The bootloaders in the bootloaders folder are all designed to run with BIOS.

The BIOS is a program that has written to an EPROM chip on the motherboard and is integral to the booting process. IT is responsible for making sure all the attachments and peripherals are in place and operational before handing over control to the bootloader. The BIOS  provides a number of interrupts for the bootloader to work with. 

Here is the list of interrupts that it provides:

* https://en.wikipedia.org/wiki/BIOS_interrupt_call

##Bootloader

* Stored with the Master Boot Record (MBR)

* It must be in the first sector of the disk

* Must be size 512 bytes. 

* Bytes 511 and 512 must be 0xAA55

* It is loaded by BIOS INT 0x19 at address 0x7C00

Once the BIOS has loaded the bootloader, the code in the bootloader is in control and is responsible for loading the operating system. Since 512bytes isn’t often enough, BIOS bootloaders are multi-stage, and the first stage is responsible for loading the second stage bootloader which in turn loads the OS.

##The Master Boot Record (MBR)

The Master Boot Record is a special sector at the beginning of a partitioned computer mass storage device. It contains information on 

 (NOTE:  "Master boot record - Wikipedia, the free encyclopedia." 2003. 2 Jun. 2015 <http://en.wikipedia.org/wiki/Master_boot_record>) 

##Real Mode

Real mode is an addressing mode supported in all x86-compatible processors. Real mode is characterized by a 20-[bit](https://en.wikipedia.org/wiki/Bit) segmented [memory address](https://en.wikipedia.org/wiki/Memory_address) space (giving exactly 1 [MiB](https://en.wikipedia.org/wiki/Mebibyte) of addressable memory) and unlimited direct software access to all addressable memory, I/O addresses and peripheral hardware. Real mode provides no support for memory protection, multitasking, or code privilege levels. In the interest of backward compatibility all x86 CPU’s start in this mode when reset. (NOTE:  "Real mode - Wikipedia, the free encyclopedia." 2004. 7 Jun. 2015 <http://en.wikipedia.org/wiki/Real_mode>) The following writeup explains addressing in real mode very well:

[https://github.com/0xAX/linux-insides/blob/master/Booting/linux-bootstrap-1.md#magic-power-button-whats-next](https://github.com/0xAX/linux-insides/blob/master/Booting/linux-bootstrap-1.md#magic-power-button-whats-next)

To sum it up, the reason for this was that had 20 bit bus addresses but 16 bit registers. This means that the bus can address 1MB but registers can individually address only 64KB. Therefore the 1MB memory was divided into segments and the physcial address was calculated using physicalAddress = segment*16 + offset.

##Useful Resources

Here is an intel article for the bare bones functionality required for booting an Intel Architecture Platform. [https://www.cs.cmu.edu/~410/doc/minimal_boot.pdf](https://www.cs.cmu.edu/~410/doc/minimal_boot.pdf)

The following three articles describe how the GRUB2 bootloader loads a Linux image.

* [https://github.com/0xAX/linux-insides/blob/master/Booting/linux-bootstrap-1.md](https://github.com/0xAX/linux-insides/blob/master/Booting/linux-bootstrap-1.md)

* [https://github.com/0xAX/linux-insides/blob/master/Booting/linux-bootstrap-2.md](https://github.com/0xAX/linux-insides/blob/master/Booting/linux-bootstrap-1.md)

* [https://github.com/0xAX/linux-insides/blob/master/Booting/linux-bootstrap-2.md](https://github.com/0xAX/linux-insides/blob/master/Booting/linux-bootstrap-2.md)

Here is a tutorial for writing a basic bootloader:

* WINDOWS - [http://www.codeproject.com/KB/tips/boot-loader.aspx?fid=1541607&df=90&mpp=25&noise=3&sort=Position&view=Quick&fr=1#_Toc231383167](http://www.codeproject.com/KB/tips/boot-loader.aspx?fid=1541607&df=90&mpp=25&noise=3&sort=Position&view=Quick&fr=1#_Toc231383167) for windows

* LINUX - Very well explained for someone with no background at all [http://www.codeproject.com/Articles/664165/Writing-a-boot-loader-in-Assembly-and-C-Part](http://www.codeproject.com/Articles/664165/Writing-a-boot-loader-in-Assembly-and-C-Part)

* [http://wiki.osdev.org/Rolling_Your_Own_Bootloader](http://wiki.osdev.org/Rolling_Your_Own_Bootloader)

Writing a 2 stage bootloader from beginning to end. Very well explained.

* [http://www.brokenthorn.com/Resources/OSDev1.html](http://www.brokenthorn.com/Resources/OSDev1.html)
