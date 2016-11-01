//#include <complex.h>
//#include "fftw3.h"
#include <stdio.h>
//#include "ifftw.h"
#include "ccalltests.c"
#include <math.h>

int main(int argc, char **argv) { 
    arrstruct* x = mkarrstruct();
    printf("%d\n", x->n);
    printf("mkarrstruct succeeded\n");
    printarrstruct(x);
    printf("printarrstruct succeeded\n");
    jarrstruct* j = changearrstruct(x);
    printf("changearrstruct succeeded\n");
    mkprintarr();
    printf("mkprintarr succeeded\n");
    return 0;
}

