#include "ifftw.h"
/*#include <stddef.h>
typedef double R;
typedef ptrdiff_t INT;
typedef INT *stride;
#define WS(stride, i) (stride[i])*/
const INT an_INT_guaranteed_to_be_zero = 0;
/*#define MAKE_VOLATILE_STRIDE(nptr, x) (x) = (x) + an_INT_guaranteed_to_be_zero

typedef R E;
#define K(x) ((E) x)
#define DK(name, value) const E name = K(value)

#if defined(__GNUC__) && (defined(__powerpc__) || defined(__ppc__) || defined(_POWER))*/
/* The obvious expression a * b + c does not work.  If both x = a * b
   + c and y = a * b - c appear in the source, gcc computes t = a * b,
   x = t + c, y = t - c, thus destroying the fma.

   This peculiar coding seems to do the right thing on all of
   gcc-2.95, gcc-3.1, gcc-3.2, and gcc-3.3.  It does the right thing
   on gcc-3.4 -fno-web (because the ``web'' pass splits the variable
   `x' for the single-assignment form).

   However, gcc-4.0 is a formidable adversary which succeeds in
   pessimizing two fma's into one multiplication and two additions.
   It does it very early in the game---before the optimization passes
   even start.  The only real workaround seems to use fake inline asm
   such as

     asm ("# confuse gcc %0" : "=f"(a) : "0"(a));
     return a * b + c;
     
   in each of the FMA, FMS, FNMA, and FNMS functions.  However, this
   does not solve the problem either, because two equal asm statements
   count as a common subexpression!  One must use *different* fake asm
   statements:

   in FMA:
     asm ("# confuse gcc for fma %0" : "=f"(a) : "0"(a));

   in FMS:
     asm ("# confuse gcc for fms %0" : "=f"(a) : "0"(a));

   etc.

   After these changes, gcc recalcitrantly generates the fma that was
   in the source to begin with.  However, the extra asm() cruft
   confuses other passes of gcc, notably the instruction scheduler.
   (Of course, one could also generate the fma directly via inline
   asm, but this confuses the scheduler even more.)

   Steven and I have submitted more than one bug report to the gcc
   mailing list over the past few years, to no effect.  Thus, I give
   up.  gcc-4.0 can go to hell.  I'll wait at least until gcc-4.3 is
   out before touching this crap again.
*/
/*static __inline__ E FMA(E a, E b, E c)
{
     E x = a * b;
     x = x + c;
     return x;
}

static __inline__ E FMS(E a, E b, E c)
{
     E x = a * b;
     x = x - c;
     return x;
}

static __inline__ E FNMA(E a, E b, E c)
{
     E x = a * b;
     x = - (x + c);
     return x;
}

static __inline__ E FNMS(E a, E b, E c)
{
     E x = a * b;
     x = - (x - c);
     return x;
}
#else
#define FMA(a, b, c) (((a) * (b)) + (c))
#define FMS(a, b, c) (((a) * (b)) - (c))
#define FNMA(a, b, c) (- (((a) * (b)) + (c)))
#define FNMS(a, b, c) ((c) - ((a) * (b)))
#endif
*/

