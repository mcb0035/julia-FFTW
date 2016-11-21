CFLAGS = -c -fPIC -fomit-frame-pointer -fstrict-aliasing -fno-schedule-insns -ffast-math
#CC = gcc -g -m64
CC = gcc -m64 -std=gnu99 -mtune=native -malign-double
SOFLAGS = -shared -fPIC
FFTWFLAGS = -I/home/qm4/fftw3-debug/include -L/home/qm4/fftw3-debug/lib -lfftw3 -lm
#FFTWFLAGS = -I/home/qm4/julia/usr/include -L/home/qm4/julia/usr/lib -lfftw3 -lm

#.DEFAULT_GOAL := libccall.so
.PHONY: default
default: libccall.so

ccalltests.o: ccalltests.c
	$(CC) $(CFLAGS) $(FFTWFLAGS) $^ -o $@

libccall.so: ccalltests.o
	$(CC) $(SOFLAGS) $^ -o $@

