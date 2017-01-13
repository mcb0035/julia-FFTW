CC = gcc -c
LD = ld
CFLAGS = -g -fPIC -std=gnu99
LDFLAGS = -shared
RM = rm -f
TARGET_LIB = libcdl.so
JFFTW_SRC = /home/qm4/julia/deps/srccache/fftw-3.3.4
INCLUDES = -I$(JFFTW_SRC) -I$(JFFTW_SRC)/dft -I$(JFFTW_SRC)/kernel -I$(JFFTW_SRC)/dft/scalar

TOP_DIR = /home/qm4/tests

.DEFAULT: $(TARGET_LIB)

%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) $^ -o $@

#macros.o: $(TOP_DIR)/dft/scalar/macros.c 
#	$(CC) $(CFLAGS) $(INCLUDES) $^ -o $@
	

objects := $(patsubst %.c,%.o,$(wildcard *.c)) #macros.o

$(TARGET_LIB): $(objects) 
	$(LD) $(LDFLAGS) $(INCLUDES) $^ -o $@

.PHONY: clean

clean: 
	$(RM) $(objects) $(TARGET_LIB)


