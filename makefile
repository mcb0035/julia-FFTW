CFLAGS = -c -std=gnu99 -fPIC
CC = gcc -g
SOFLAGS = -shared
FFTWFLAGS = -I/home/qm4/fftw3-debug/include -L/home/qm4/fftw3-debug/lib -lfftw3 -lm

#.DEFAULT_GOAL := libccall.so
.PHONY: default
default: libccall.so

ccalltests.o: ccalltests.c
	$(CC) $(CFLAGS) $(FFTWFLAGS) $^ -o $@

libccall.so: ccalltests.o
	$(CC) $(SOFLAGS) $^ -o $@

