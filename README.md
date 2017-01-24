# julia-FFTW

## Overview
An implementation of FFTW in native Julia.  Given real or complex arrays for input and output, and tensors describing the dimension of the transform, FFTW generates a "plan" to operate on the data.  Depending on the rank, vector rank, strides, and other user-defined restrictions (buffered, in-place, etc.), the transform is broken down into smaller transforms.  These are then solved by "codelets", pregenerated transforms optimized for a specific size.  The `Base.DFT.FFTW` package included with julia simply provides a wrapper for the FFTW C API.  The goal of this project is to write the logic entirely in Julia, so that the only use of `ccall` is to call the codelets themselves.


## Installation and use
This project replaces `julia/base/fft/FFTW.jl`.  To use, add the project directory to the Julia `LOAD_PATH` by adding the following line to `$HOME/.juliarc`:

    push!(LOAD_PATH, /path/to/dir)
    
The module `FFTWchanges` works exactly like the module `FFTW` and has the same functions.  Only the standard double precision library has been implemented so far.  

## FFTW
The user should be familiar with the [FFTW documentation](http://www.fftw.org/doc/) before attempting any changes.  

## C to Julia
FFTW is written in highly optimized C, using techniques that do not translate neatly to Julia such as packed structs, the "struct hack", and function pointers.  In its current state, the project depends heavily on implementation-specific and even installation-specific sizes and typedefs to calculate offsets.  Whenever possible, these have been marked with comments.  When installing on a new machine, the user should check that these offsets are correct.  Eventually, this will need to be refactored to remove C-like pointer arithmetic and dependence on low-level memory layout.

### C structs and Julia types
When [calling a C function with `ccall`](http://docs.julialang.org/en/latest/manual/calling-c-and-fortran-code.html#Calling-C-and-Fortran-Code-1), all argument types must have the same memory layout as in C.  Julia provides typedefs (`Cint`, `Cdouble`, etc.) to make this straightforward for builtin types.  Composite types consisting of other builtin types work the same way, in that the following definitions are compatible:

    struct A {
        int i;     //4 bytes, 4 offset so double d starts on word boundary
        double d;  //8 bytes
        char c;    //4 bytes, 4 offset
    };             //sizeof A = 24 bytes
    
    type A
        i::Cint    #4 bytes, 4 offset
        d::Cdouble #8 bytes
        c::Cchar   #4 bytes, 4 offset
    end            #sizeof(A) = 24 bytes

In C, structs may contain other structs inline, but in Julia any type defined as a `type` will be represented as a pointer when contained inside another type.  The following definitions are _not_ equivalent:

    struct B {
        A a;     //24 bytes
        int i;   //4 bytes, 4 offset
    };           //sizeof B = 32 bytes
    
    type B
        a::A     #8 bytes since A stored as pointer
        i::Cint  #4 bytes, 4 offset
    end          #sizeof(B) = 16 bytes
    
In order to have the same memory layout, `A` must be defined `immutable` or `bitstype` rather than `type`.  However, this means that the fields of `A` cannot be modified:

    immutable A
        i::Cint    #4 bytes, 4 offset
        d::Cdouble #8 bytes
        c::Cchar   #4 bytes, 4 offset
    end            #sizeof(A) = 24 bytes
    
    type B
        a::A     #24 bytes since A is immutable
        i::Cint  #4 bytes, 4 offset
    end          #sizeof(B) = 32 bytes
    
    julia> b = B(A(1,2,3),4)
    D(A(1,2.0,3),4)
    julia> b.a.i
    1
    julia> b.a.i = 2
    ERROR: type A is immutable
    
Unfortunately, many FFTW structures contain other structures as fields, and these fields must remain mutable.  For now, this can be worked around with pointers, using `unsafe_load` and `unsafe_store!` as long as the byte offset of the field is known.  For example, if instead of creating a `B` in Julia we called a C function that returned a `Ptr{B}` named `pb` with the same data:

    julia> unsafe_load(pb)                    #in C: *pb
    D(A(1,2.0,3),4)
    julia> unsafe_load(Ptr{A}(pb))            #in C: pb->A
    A(1,2.0,3)
    julia> unsafe_load(Ptr{Cint}(pb))         #in C: pb->A.i
    1
    julia> unsafe_load(Ptr{Cdouble}(pb + 8))  #in C: pb->A.d
    2.0                                       #must know offset of 8 bytes
    julia> unsafe_load(Ptr{Cdouble}(pb + 4))  #wrong address, forgot padding
    1.6166e-319                               #garbage
    julia> pt = Ptr{Cdouble}(pb + 8)          #double offset by 8 bytes
    julia> unsafe_store!(pt, 3.0)             #in C: pb->A.d = 3.0
    julia> unsafe_load(pb)
    D(A(1,3.0,3),4)                           #field of A changed even though A is immutable
    
Obviously, this is incredibly unsafe and not portable in the slightest, but it is the only way to ensure a compatible memory layout with C.  However, this is only scaffolding, necessary to interface with FFTW C functions that use these structures.  The codelets only take real arrays and integer values, so once everything else is written in Julia this can be refactored.

### Packed structs
FFTW stores flags in a data type `flags_t`, packed to fit in 64 bits:

    typedef struct {
        unsigned l:20;
        unsigned hash_info:3;
    #define BITS_FOR_TIMELIMIT 9
        unsigned timelimit_impatience:BITS_FOR_TIMELIMIT;
        unsigned u:20;
    #define BITS_FOR_SLVNDX 12
        unsigned slvndx:BITS_FOR_SLVNDX;
    } flags_t;
    
Packed structs are not currently supported in Julia, so instead I created a `bitstype` for `flags_t` with the same layout as in C, and methods `flag` and `setflag` to get and set its fields using bit shifts and masks.  This may need to be done differently on different machines.  

### Struct hack
Transform dimensions are described by the `tensor` struct:
    
    typedef struct {
         INT n;
         INT is;			/* input stride */
         INT os;			/* output stride */
    } iodim;
    
    typedef struct {
         int rnk;
    #if defined(STRUCT_HACK_KR)
         iodim dims[1];
    #elif defined(STRUCT_HACK_C99)
         iodim dims[];
    #else
         iodim *dims;
    #endif
    } tensor;

With either `STRUCT_HACK` defined, `tensor` is of variable length with the `iodim`s appended to the end.  Julia does not currently support variable length structs, so attempting to access the `dims` field directly results in a segfault.  However, all elements can be accessed using explicit memory offsets as described above.  This is cumbersome enough that I have not ported some of the functions in `fftw/kernel/tensor#.c`.  These functions are defined in `julia-fftw/kernel/tensor.jl` as `ccall` wrappers for the C functions.

### C function pointers and Julia callbacks
Many FFTW structs contain function pointers.  Julia currently has an abstract `Function` type, but currently has no way to specify the function signature.  Julia functions can be used to create C function pointers with `cfunction`, but the resulting pointer must called with `ccall`.  A recent change broke these callbacks by adding a "world counter", which increments at every new method definition.  A C function defined in a certain "world age" causes an error if called in a later world age.  The current workaround is to wrap these function calls in `eval` to regenerate the function in the current world age.  However, it should be possible to refactor the code so that C function pointers and `ccall` are no longer needed since `Function` is the same size as a pointer.  I have been waiting for the Julia developers to decide how to implement function signatures before doing too much with the `Function` type.
