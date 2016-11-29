#include <stdio.h>
#include <stdlib.h>
#include <complex.h>
#include <stddef.h>
#include <math.h>
#include <string.h>
#include <sys/types.h>
#include <sys/time.h>
#include <time.h>
#include <fftw3.h>
//#include <api.h>

const int N = 10;

enum {nt};

typedef ptrdiff_t INT;

typedef struct {
    INT n;
    INT is;
    INT os;
} iodim;

typedef struct {
    int rnk;
    iodim *dims;
} tensor;

typedef struct {
    int rnk;
    //STRUCT_HACK_KR
    iodim dims[1];
} tensorkr;

typedef struct {
    int rnk;
    //STRUCT_HACK_C99
    iodim dims[];
} tensorc99;

typedef struct {
    int kind;
    void (*zero) (const int n);
} adttest;

void zero(const int n) {
    printf("n: %d\n",n);   
}

const adttest tadt = 
{
    nt,
    zero
};

typedef struct {
    const adttest *adt;
} cadt;

cadt* mkcadt(adttest *adt) {
    cadt *x = (cadt *)malloc(sizeof(cadt));
    x->adt = adt;
    return x;
}

typedef struct {
    double (*func) (const double n);
    int n;
    int arr[8];
    double m;
} arrstruct;

typedef struct {
    double (*func) (const double n);
    int n;
    int* arr;
    double m;
} jarrstruct;

static double mysqrt(const double n) {
    return 1.0/sqrt(n);
}

arrstruct* mkarrstruct() {
    arrstruct *x;
    x = (arrstruct*)malloc(sizeof(arrstruct));
    x->func = mysqrt;
    x->n = 71;
    int i;
    for (i=0; i<8; ++i)
        x->arr[i] = i;
    x->m = 0.01;
    return x;
}

jarrstruct* changearrstruct(const arrstruct* a) {
    jarrstruct *x;
    x = (jarrstruct*)malloc(sizeof(jarrstruct));
    x->func = a->func;
    x->n = a->n;
    x->arr = (int*)malloc(sizeof(int)*8);
    memcpy(x->arr, a->arr, 8*sizeof(int));    
    x->m = a->m;
    return x;
}

void printarrstruct(const arrstruct* x) {
    printf(" start printarrstruct\n");
    printf("func(4): %f\n", x->func(4));
    printf("n      : %d\n", x->n);
    int i;
    for (i=0; i<8; ++i) 
        printf("arr[%d] : %d\n", x->arr[i]);
    printf("m      : %f\n", x->m);
    printf(" end printarrstruct\n");
}

void mkprintarr() {
    printf("size   : %d\n", sizeof(arrstruct));
    printf("size f : %d\n", sizeof(void*));
    printf("size n : %d\n", sizeof(int));
    printf("size ar: %d\n", sizeof(int)*8);
    printf("size m : %d\n", sizeof(double));
    arrstruct *x;
    x = (arrstruct*)malloc(sizeof(arrstruct));
    x->func = sqrt;
    x->n = 71;
    int i;
    for (i=0; i<8; ++i)
        x->arr[i] = i;
    x->m = 0.01;
    printarrstruct(x);
    printf("size   : %d\n", sizeof(*x));
}



tensor* mktensor(int rnk) {
    tensor* x;

    x = (tensor*)malloc(sizeof(tensor));
    if (rnk > 0)
        x->dims = (iodim*)malloc(sizeof(iodim) * (unsigned)rnk);
    else
        x->dims = 0;

    x->rnk = rnk;
    for (int i=0; i<rnk; ++i) {
        x->dims[i].n = i;
        x->dims[i].is = i+1;
        x->dims[i].os = i+2;
    }
    return x;
}

void showtensor(tensor* t) {
    printf("rnk: %d\n", t->rnk);
    for (int i=0; i<t->rnk; ++i) {
        printf("rank %d:\n", i);
        printf("  n: %d\n", t->dims[i].n);
        printf("  is: %d\n", t->dims[i].is);
        printf("  os: %d\n", t->dims[i].os);
    }
}

tensorkr* mktensorkr(int rnk) {
    tensorkr* x;

    //STRUCT_HACK_KR
    if (rnk > 1)
        x = (tensorkr *)malloc(sizeof(tensorkr) + (unsigned)(rnk - 1) * sizeof(iodim));
    else
        x = (tensorkr *)malloc(sizeof(tensorkr));

    x->rnk = rnk;
    for (int i=0; i<rnk; ++i) {
        x->dims[i].n = i;
        x->dims[i].is = i+1;
        x->dims[i].os = i+2;
    }
    return x;
}

void showtensorkr(tensorkr* t) {
    printf("rnk: %d\n", t->rnk);
    for (int i=0; i<t->rnk; ++i) {
        printf("rank %d:\n", i);
        printf("  n: %d\n", t->dims[i].n);
        printf("  is: %d\n", t->dims[i].is);
        printf("  os: %d\n", t->dims[i].os);
    }
}

tensorc99* mktensorc99(int rnk) {
    tensorc99* x;

    //STRUCT_HACK_C99
    x = (tensorc99 *)malloc(sizeof(tensorc99) + (unsigned)rnk * sizeof(iodim));

    x->rnk = rnk;
    for (int i=0; i<rnk; ++i) {
        x->dims[i].n = i;
        x->dims[i].is = i+1;
        x->dims[i].os = i+2;
    }
    return x;
}

void showtensorc99(tensorc99* t) {
    printf("rnk: %d\n", t->rnk);
    for (int i=0; i<t->rnk; ++i) {
        printf("rank %d:\n", i);
        printf("  n: %d\n", t->dims[i].n);
        printf("  is: %d\n", t->dims[i].is);
        printf("  os: %d\n", t->dims[i].os);
    }
}

void tensor_print(tensor* sz) {
    printf("tensor, rank %d\n", sz->rnk);
    int i;
    for (i=0; i<sz->rnk; i++) {
        printf("  dim %d: %d %d %d\n", i, sz->dims[i].n, sz->dims[i].is, sz->dims[i].os);
    }
}

tensor* mktensor_iodims(int rank, const iodim *dims, int is, int os) {
    int i;
    tensor *x = mktensor(rank);
    for (i=0; i<rank; ++i) {
        x->dims[i].n = dims[i].n;
        x->dims[i].is = dims[i].is * is;
        x->dims[i].os = dims[i].os * os;
    }
    return x;
}

tensorkr* mktensorkr_iodims(int rank, const iodim *dims, int is, int os) {
    int i;
    tensorkr *x = mktensorkr(rank);
    for (i=0; i<rank; ++i) {
        x->dims[i].n = dims[i].n;
        x->dims[i].is = dims[i].is * is;
        x->dims[i].os = dims[i].os * os;
    }
    return x;
}

tensorc99* mktensorc99_iodims(int rank, const iodim *dims, int is, int os) {
    int i;
    tensorc99 *x = mktensorc99(rank);
    for (i=0; i<rank; ++i) {
        x->dims[i].n = dims[i].n;
        x->dims[i].is = dims[i].is * is;
        x->dims[i].os = dims[i].os * os;
    }
    return x;
}
void arrtest(double *x, complex *z) {
    int i;
    for (i=0; i<N; i++) {
        printf("%lf\t%lf\n", *(x+i), *(z+i));
    }
}

struct timeval timetest() {
    struct timeval x;
    gettimeofday(&x, 0);
    printf("tv_sec: %ld\n", x.tv_sec);
    printf("tv_usec: %ld\n", x.tv_usec);
    return x;
}

typedef struct {
    int a;
    double b;
} A;

A* mkA() {
    A* rv = (A*)malloc(sizeof(A));
    rv->a = 2;
    rv->b = 3.0;
    return rv;
}

void showA(A* x) {
    printf("struct A:\n");
    printf("A(%d,%lf)\n", x->a, x->b);
}

typedef struct {
    A a;
    A b;
    int c;
} B;

B* mkB() {
    A a = {2, 3.0};
    A b = {4, 5.0};
    B* rv = (B*)malloc(sizeof(B));
    rv->a = a;
    rv->b = b;
    rv->c = 6;
//    B rv = {a, b, 6};
    return rv;
}

void pA() {
    A* x = mkA();
    printf("address of x:    %p\n", x);
    printf("address of x->a: %p\n", &(x->a));
    printf("address of x->b: %p\n", &(x->b));
    A y = {4, 5.0};
    printf("address of y:    %p\n", &y);
    printf("address of y.a:  %p\n", &(y.a));
    printf("address of y.b:  %p\n", &(y.b));
}

void rA(A* x) {
    printf("address of x:    %p\n", x);
    printf("address of x->a: %p\n", &(x->a));
    printf("address of x->b: %p\n", &(x->b));
}
/*
void fftwsizes() {
    printf("size of apiplan:     %u\n", sizeof(fftw_plan_s));
//    printf("size of plan:        %u\n", sizeof(plan));
//    printf("size of plan_dft:    %u\n", sizeof(plan_dft));
//    printf("size of problem:     %u\n", sizeof(problem));
//    printf("size of problem_dft: %u\n", sizeof(problem_dft));
}
*/
typedef struct {
    unsigned l:20;
    unsigned h:3;
    unsigned t:9;
    unsigned u:20;
    unsigned s:12;
} flags_t;

flags_t* pmkflags_t() {
    flags_t* v = (flags_t*)malloc(sizeof(flags_t));
    v->l = 1;
    v->u = 3;
    v->t = 7;
    v->h = 0;
    return v;
}

flags_t* cflags_t(flags_t* f) {
    f->u = 63;
    return f;
}

typedef struct {
    int x;
    flags_t f;
} fstruct;

fstruct* mkfstruct() {
    fstruct* ff = (fstruct*)malloc(sizeof(fstruct));
    ff->x = 31;
    ff->f.l = 0;
    ff->f.h = 3;
    ff->f.t = 7;
    ff->f.u = 15;
    return ff;
}

void inctest() {
    A a = {1, 69.0};
    A b = {10, 666.0};
    printf("a: %d %lf\n", a.a, a.b);
    printf("b: %d %lf\n", b.a, b.b);
    a.a = b.a++;
    printf("a: %d %lf\n", a.a, a.b);
    printf("b: %d %lf\n", b.a, b.b);
}

char* derp() { return "derp"; } 










