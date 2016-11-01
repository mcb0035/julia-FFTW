#include <stdio.h>
#include <emmintrin.h>

typedef __m128d V;
#define VADD _mm_add_pd
#define VSUB _mm_sub_pd
#define VMUL _mm_mul_pd
#define VXOR _mm_xor_pd
#define SHUFPD _mm_shuffle_pd
#define UNPCKL _mm_unpacklo_pd
#define UNPCKH _mm_unpackhi_pd
#define STOREH _mm_storeh_pd
#define STOREL _mm_storel_pd

const V pm = {0x0000,0x8000};

inline V FLIP_RI(V x) {
    return SHUFPD(x,x,1);
}

inline V VCONJ(V x) {
    return VXOR(pm,x);
}

inline V VBYI(V x) {
    x = VCONJ(x);
    x = FLIP_RI(x);
    return x;
}

#define VFMAI(b, c) VADD(c, VBYI(b))
#define VFNMSI(b, c) VSUM(c, VBYI(B))

int main(int argc, char **argv) {
    double d[2] = {1,2};
    double e[2] = {5,6};
    V a = _mm_load_pd(&d[0]);
    V b = _mm_load_pd(&e[0]);
    printf("a: %f %f \n",a[0],a[1]);
    printf("b: %f %f \n",b[0],b[1]);
    V r = VADD(a,b);
    printf("VADD(a,b): %f %f \n",r[0],r[1]);
    r = VSUB(a,b);
    printf("VSUB(a,b): %f %f \n",r[0],r[1]);
    r = VMUL(a,b);
    printf("VMUL(a,b): %f %f \n",r[0],r[1]);
//    r = VXOR(a,b);
//    printf("VXOR(a,b): %f %f \n",r[0],r[1]);
    r = FLIP_RI(a);
    printf("FLIP_RI(a): %f %f \n",r[0],r[1]);
    r = VCONJ(a);
    printf("VCONJ(a): %f %f \n",r[0],r[1]);
    r = VBYI(a);
    printf("VBYI(a): %f %f \n",r[0],r[1]);
    r = UNPACKL(a,a);
    printf("UNPACKL(a,a): %f %f \n",r[0],r[1]);
    r = UNPACKH(a,a);
    printf("UNPACKH(a,a): %f %f \n",r[0],r[1]);



    return 0;
}
