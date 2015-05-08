#Minimal Bootloader

This bootloader is a minimal bootloader. 
It fulfills the rquirements of the BIOS to be considered as a bootloader.
It is loaded by the BIOS at the address 0x7C00 and is runninf in 16 bit realmode where we are limited to 1MB of memory and 16 bit registers in order to be backward compatible.
We have the boot signature in the last two bytes which is essential for the sector to be considered bootable. If we change this signature the boot will fail.

Executing run.sh will compile the bootloader with nasm and run it with qemu.