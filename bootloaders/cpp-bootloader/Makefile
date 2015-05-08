AS = as
CFLAGS	=-Wall -m32
CC	=g++ 


default: BootMain.o StartPoint.o CString.o CDisplay.o
	$(CC) $(CFLAGS) \
	-o boot StartPoint.o BootMain.o CString.o CDisplay.o

CString.o: CString.cpp
	$(CC) $(CFLAGS) \
	-c CString.cpp -o CString.o

CDisplay.o: CDisplay.cpp
	$(CC) $(CFLAGS) \
	-c CDisplay.cpp -o CDisplay.o

BootMain.o: BootMain.cpp
	$(CC) $(CFLAGS) \
	-c BootMain.cpp -o BootMain.o

StartPoint.o: StartPoint.asm
	$(AS) -o StartPoint.o StartPoint.asm

clean:
	rm *.o boot
