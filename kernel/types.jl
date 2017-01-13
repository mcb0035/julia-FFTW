## FFTW Flags from fftw3.h
import Base: show, ==, Libc.malloc

export problems, Wakefulness, Hashtable_info, amnesia, wisdom_state_t, cost_kind, inplace_kind, printer, crude_time, iodim, tensor, problem_adt, problem, problem_dft, opcnt, plan_adt, plan, plan_dft, probs, plans, apiplan, solver_adt, solver, slvdesc, flags_t, flag, setflag, solution, hashtab, planner_adt, planner 

export FFTW_MEASURE, FFTW_DESTROY_INPUT, FFTW_UNALIGNED, FFTW_CONSERVE_MEMORY, FFTW_EXHAUSTIVE, FFTW_PRESERVE_INPUT, FFTW_PATIENT, FFTW_ESTIMATE, FFTW_WISDOM_ONLY, FFTW_ESTIMATE_PATIENT, FFTW_BELIEVE_PCOST, FFTW_NO_DFT_R2HC, FFTW_NO_NONTHREADED, FFTW_NO_BUFFERING, FFTW_NO_INDIRECT_OP, FFTW_ALLOW_LARGE_GENERIC, FFTW_NO_RANK_SPLITS, FFTW_NO_VRANK_SPLITS, FFTW_NO_VRECURSE, FFTW_NO_SIMD, FFTW_NO_SLOW, FFTW_NO_FIXED_RADIX_LARGE_N, FFTW_ALLOW_PRUNING

export alignment_of

#include("md5.jl")

const FFTW_MEASURE                = UInt32(0)
const FFTW_DESTROY_INPUT          = UInt32(1 << 0)
const FFTW_UNALIGNED              = UInt32(1 << 1)
const FFTW_CONSERVE_MEMORY        = UInt32(1 << 2)
const FFTW_EXHAUSTIVE             = UInt32(1 << 3)   # NO_EXHAUSTIVE is default
const FFTW_PRESERVE_INPUT         = UInt32(1 << 4)   # cancels DESTROY_INPUT
const FFTW_PATIENT                = UInt32(1 << 5)   # IMPATIENT is default
const FFTW_ESTIMATE               = UInt32(1 << 6)
const FFTW_WISDOM_ONLY            = UInt32(1 << 21)

const FFTW_ESTIMATE_PATIENT       = UInt32(1 << 7)
const FFTW_BELIEVE_PCOST          = UInt32(1 << 8)
const FFTW_NO_DFT_R2HC            = UInt32(1 << 9)
const FFTW_NO_NONTHREADED         = UInt32(1 << 10)
const FFTW_NO_BUFFERING           = UInt32(1 << 11)
const FFTW_NO_INDIRECT_OP         = UInt32(1 << 12)
const FFTW_ALLOW_LARGE_GENERIC    = UInt32(1 << 13)
const FFTW_NO_RANK_SPLITS         = UInt32(1 << 14)
const FFTW_NO_VRANK_SPLITS        = UInt32(1 << 15)
const FFTW_NO_VRECURSE            = UInt32(1 << 16)
const FFTW_NO_SIMD                = UInt32(1 << 17)
const FFTW_NO_SLOW                = UInt32(1 << 18)
const FFTW_NO_FIXED_RADIX_LARGE_N = UInt32(1 << 19)
const FFTW_ALLOW_PRUNING          = UInt32(1 << 20)

## R2R transform kinds

const FFTW_R2HC    = 0
const FFTW_HC2R    = 1
const FFTW_DHT     = 2
const FFTW_REDFT00 = 3
const FFTW_REDFT01 = 4
const FFTW_REDFT10 = 5
const FFTW_REDFT11 = 6
const FFTW_RODFT00 = 7
const FFTW_RODFT01 = 8
const FFTW_RODFT10 = 9
const FFTW_RODFT11 = 10

#enums
#kernel/ifftw.h:502
@enum(problems, 
      PROBLEM_UNSOLVABLE    = Cint(0), 
      PROBLEM_DFT           = Cint(1), 
      PROBLEM_RDFT          = Cint(2),
      PROBLEM_RDFT2         = Cint(3), 
      PROBLEM_MPI_DFT       = Cint(4), 
      PROBLEM_MPI_RDFT      = Cint(5),
      PROBLEM_MPI_RDFT2     = Cint(6), 
      PROBLEM_MPI_TRANSPOSE = Cint(7), 
      PROBLEM_LAST          = Cint(8))

#kernel/ifftw.h:566
@enum(Wakefulness, 
      SLEEPY            = Cint(0), 
      AWAKE_ZERO        = Cint(1), 
      AWAKE_SQRTN_TABLE = Cint(2), 
      AWAKE_SINCOS      = Cint(3))

#kernel/ifftw.h:896
const TW_COS  = Cint(0)
const TW_SIN  = Cint(1)
const TW_CEXP = Cint(2)
const TW_NEXT = Cint(3)
const TW_FULL = Cint(4)
const TW_HALF = Cint(5)

#kernel/ifftw.h:654
const BELIEVE_PCOST          = Cuint(0x0001)
const ESTIMATE               = Cuint(0x0002)
const NO_DFT_R2HC            = Cuint(0x0004)
const NO_SLOW                = Cuint(0x0008)
const NO_VRECURSE            = Cuint(0x0010)
const NO_INDIRECT_OP         = Cuint(0x0020)
const NO_LARGE_GENERIC       = Cuint(0x0040)
const NO_RANK_SPLITS         = Cuint(0x0080)
const NO_VRANK_SPLITS        = Cuint(0x0100)
const NO_NONTHREADED         = Cuint(0x0200)
const NO_BUFFERING           = Cuint(0x0400)
const NO_FIXED_RADIX_LARGE_N = Cuint(0x0800)
const NO_DESTROY_INPUT       = Cuint(0x1000)
const NO_SIMD                = Cuint(0x2000)
const CONSERVE_MEMORY        = Cuint(0x4000)
const NO_DHT_R2HC            = Cuint(0x8000)
const NO_UGLY                = Cuint(0x10000)
const ALLOW_PRUNING          = Cuint(0x20000)

#kernel/ifftw.h:676
#=enum(Hashtable_info, 
      BLESSING = 0x1,
      H_VALID = 0x2,
      H_LIVE = 0x4)=#
const BLESSING = Cuint(0x1) #save this entry
const H_VALID  = Cuint(0x2) #valid hashtab entry
const H_LIVE   = Cuint(0x4) #entry is nonempty, implies H_VALID

#kernel/ifftw.h:709
@enum(amnesia,
      FORGET_ACCURSED = Cint(0),
      FORGET_EVERYTHING = Cint(1))


#kernel/ifftw.h:726
@enum(wisdom_state_t,
      WISDOM_NORMAL = Cint(0),
      WISDOM_ONLY = Cint(1),
      WISDOM_IS_BOGUS = Cint(2),
      WISDOM_IGNORE_INFEASIBLE = Cint(3),
      WISDOM_IGNORE_ALL = Cint(4))

#kernel/ifftw.h:748
@enum(cost_kind,
      COST_SUM = Cint(0),
      COST_MAX = Cint(1))

#kernel/ifftw.h:452
@enum(inplace_kind,
      INPLACE_IS = Cint(0),
      INPLACE_OS = Cint(1))

#kernel/ifftw.h:320
#typealias crude_time Cint

#kernel/ifftw.h:64
typealias R Cdouble

#kernel/ifftw.h:84
typealias INT Cptrdiff_t

#macros in kernel/ifftw.h:133
#if HAVE_SIMD
# if defined(HAVE_KCVI) || defined(HAVE_AVX512)
#   define MIN_ALIGNMENT 64
# elif defined(HAVE_AVX) || defined(HAVE_AVX2) || defined(HAVE_GENERIC_SIMD256)
#   define MIN_ALIGNMENT 32
# else
#   define MIN_ALIGNMENT 16
# endif
#endif
const MIN_ALIGNMENT = 32

#macros in kernel/ifftw.h:173
const MAX_STACK_ALLOC = Csize_t(64 * 1024)
#function BUF_ALLOC(T, p, n)
#    if n < MAX_STACK_ALLOC
#        p = T(malloc(n))
        

#ifdef PRECOMPUTE_ARRAY_INDICES
#kernel/ifftw.h:837
typealias fftwstride Ptr{INT}
WS(stride::fftwstride, i::Integer) = unsafe_load(stride, i)
#stride X(mkstride) in kernel/stride.c:26
function mkstride(n::INT, s::INT)::fftwstride
    p = fftwstride(malloc(n * sizeof(INT)))
    for i = 1:n
        unsafe_store!(p, s*(i-1), i)
    end
    return p
end
#void X(stride_destroy) in kernel/stride.c:37
function stride_destroy(p::fftwstride)::Void
    if p != C_NULL
        free(p)
    end
    return nothing
end

#kernel/ifftw.h:91
const FFT_SIGN = Cint(-1)

#if __WORDSIZE == 64
#typedef unsigned long int uintptr_t in /usr/include/stdint.h
typealias Cuintptr_t Culong

#macros in kernel/ifftw.h:449
const RNK_MINFTY = typemax(Cint)
FINITE_RNK(rnk)::Bool = rnk != RNK_MINFTY

if typeof(1.0) === Float64
    typealias Float Float64
elseif is(typeof(1.0), Float32)
    typealias Float Float32
end

#kernel/ifftw.h:381
if sizeof(Cuint) >= 4
    typealias md5uint Cuint
else
    typealias md5uint Culong
end

#kernel/ifftw.h:400
typealias md5sig NTuple{4,md5uint}

#kernel/ifftw.h:409
type md5
    s::md5sig
    c::NTuple{64,Cuchar}
    l::Cuint
    function md5()::md5
        m = new((zeros(md5uint, 4)...), (zeros(Cuchar, 64)...), Cuint(0))
        return m
    end
end

function newmd5()::Ptr{md5}
    m = Ptr{md5}(malloc(sizeof(md5)))
    return m
end

function Base.show(io::IO, m::md5)
    print_with_color(:yellow,"md5:\n")
    println(" s: $(m.s)")
    println(" c: $(m.c)")
    println(" l: $(m.l)")
end

include("$FFTWDIR/kernel/md5.jl")


#macro X in ifftw.h:66
#function X(name)::String
#    return string(fftw,name)
#end

#immutable fftw_plan_struct end
#typealias PlanPtr Ptr{fftw_plan_struct}

#MINE
#immutable fftw_problem_struct end
#typealias ProbPtr Ptr{fftw_problem_struct}
#immutable fftw_print_struct end
#typealias PrintPtr Ptr{fftw_print_struct}
#immutable fftw_tensor_struct end
#typealias TensPtr Ptr{fftw_tensor_struct}
#immutable fftw_planner_struct end
#typealias PlannerPtr Ptr{fftw_planner_struct}
#stdout = unsafe_load(cglobal(:stdout, Ptr{Void}))
#END MINE

#types

#turn string to Cstring
function cstringize(s::String)::Ptr{Cchar}
    n = length(s)
    if n == 0
        return Ptr{Cchar}(C_NULL)
    end

    cstr = Ptr{Cchar}(malloc(n+1))
    for i=1:n
        unsafe_store!(cstr, s[i], i)
    end
    unsafe_store!(cstr, 0, n+1)
    return cstr
end

cstringize(f::Function) = cstringize(string(f))
#cstringize(f::Function) = Base.unsafe_convert(Ptr{Cchar}, string(f))

type solvtab
    reg::Ptr{Void}
    reg_nam::Ptr{Cchar}

    function solvtab(f::Function)
        print_with_color(:cyan,"solvtab constructor: $(string(f)) begin\n")
#        show(methods(f))
#        show(cfunction(f, Void, (Ptr{planner},)))
#        show(stacktrace())
#        print_with_color(:cyan,"solvtab constructor: $(cfunction(f, Void, (Ptr{planner},)))\n")
        st = new(cfunction(f, Void, (Ptr{planner},)), cstringize(f))
        print_with_color(:cyan,"solvtab constructor: $(string(f)) end\n")
        return st
    end

    function solvtab()
        print_with_color(:cyan,"solvtab constructor: null\n")
        return new(C_NULL, C_NULL)
    end
end

function Base.show(io::IO, s::solvtab)::Void
    if s.reg_nam != C_NULL
        print_with_color(:yellow,"solvtab: $(unsafe_wrap(String, s.reg_nam)), $(s.reg_nam)\n")
    end
    return nothing
end

function finalize_solvtab(s::solvtab)::Void
    if s.reg_nam != C_NULL
        print_with_color(:yellow,"finalize_solvtab: freeing $(unsafe_wrap(String, s.reg_nam))\n")
        free(s.reg_nam)
    end
    return nothing
end

#const SOLVTAB_END = solvtab(Ptr{Void}(C_NULL), Ptr{Cchar}(C_NULL))
const SOLVTAB_END = solvtab()


#tw_instr in kernel/ifftw.h:903
type tw_instr
    op::Cuchar
    v::Cchar
    i::Cshort
end

#twid in kernel/ifftw.h:912
type twid
    W::Ptr{R}
    n::INT
    r::INT
    m::INT
    refcnt::Cint
    instr::Ptr{tw_instr}
    cdr::Ptr{twid}
    wakefulness::Cint
    function twid()
        t = new(C_NULL, INT(0), INT(0), INT(0), Cint(0), C_NULL, C_NULL, Cint(0))
    end
end

typealias trigreal Cdouble

type triggen
    cexp::Ptr{Void}
    cexpl::Ptr{Void}
    rotate::Ptr{Void}
    twshft::INT
    twradix::INT
    twmsk::INT
    W0::Ptr{trigreal}
    W1::Ptr{trigreal}
    n::INT
end

include("$FFTWDIR/kernel/trig.jl")
include("$FFTWDIR/kernel/twiddle.jl")

#printer_s in kernel/ifftw.h:537
immutable printer
    print::Ptr{Void}
    vprint::Ptr{Void}
    putchr::Ptr{Void}
    cleanup::Ptr{Void}
    indent::Cint
    indent_incr::Cint
end

include("$FFTWDIR/kernel/print.jl")

#scanner_s in kernel/ifftw.h:553
type scanner
    scan::Ptr{Void}
    vscan::Ptr{Void}
    getchr::Ptr{Void}
    ungotc::Cint
end

#timeval struct contains two longs
#TODO: generalize to any machine
#crude_time in kernel/ifftw.h:341
immutable crude_time
    tv_sec::Clong
    tv_usec::Clong
end

function Base.show(io::IO, t::crude_time)
    println("crude_time:")
    println(" tv_sec: $(t.tv_sec)")
    println(" tv_usec: $(t.tv_usec)")
end

function ==(t1::crude_time, t2::crude_time)
    return (t1.tv_sec==t2.tv_sec) && (t1.tv_usec==t2.tv_usec)
end

#kernel/ifftw.h:429
type iodim
    n::INT
    is::INT
    os::INT
end

function Base.show(io::IO, d::iodim)
    print_with_color(:yellow,"iodim:\n")
    println(" n: $(d.n)")
    println(" is: $(d.is)")
    println(" os: $(d.os)")
end

#kernel/ifftw.h:440
type tensor
    rnk::Cint
#    dims::Array{iodim,1}
    dims::Ptr{iodim}

    #mktensor in kernel/tensor.c:24
#=    function tensor(r::Cint)
        @assert r >= 0
        if FINITE_RNK(r)
            t = new(r,fill(iodim(0,0,0),r))
        else
            t = new(r,fill(iodim(0,0,0),0))
        end
        return t
    end=#
end

function Base.show(io::IO, t::Ptr{tensor})
    print_with_color(:yellow,"tensor from pointer:\n")
    r = unsafe_load(reinterpret(Ptr{Cint}, t))
    println(" rnk: $r")
#    d = unsafe_wrap(Array, reinterpret(Ptr{iodim}, t+sizeof(Cint)), r)
    for i = 1:r
        d = unsafe_load(reinterpret(Ptr{iodim}, t+2*sizeof(Cint)+(i-1)*sizeof(iodim)))
        println(" d at $i:")
        show(d)
#=        n = unsafe_load(reinterpret(Ptr{Cptrdiff_t}, t+2*sizeof(Cint)+(i-1)*sizeof(iodim)))
        is = unsafe_load(reinterpret(Ptr{Cptrdiff_t}, t+2*sizeof(Cint)+(i-1)*sizeof(iodim)+sizeof(Cptrdiff_t)))
        os = unsafe_load(reinterpret(Ptr{Cptrdiff_t}, t+2*sizeof(Cint)+(i-1)*sizeof(iodim)+2*sizeof(Cptrdiff_t)))
        println("d at $i: $n $is $os")=#
    end
end

include("$FFTWDIR/kernel/tensors.jl")

#need abstract type for subtyping
abstract problem_a

#kernel/ifftw.h:525
immutable problem_adt
    problem_kind::problems
    hash::Ptr{Void}
    zero::Ptr{Void}
    print::Ptr{Void}
    destroy::Ptr{Void}
    function problem_adt(k::problems, h::Ptr{Void}, z::Ptr{Void}, p::Ptr{Void}, d::Ptr{Void})::problem_adt
        return new(k, h, z, p, d)
    end
end

function Base.show(io::IO, p::problem_adt)
    print_with_color(:yellow,"problem_adt:\n")
    println(" problem_kind: $(p.problem_kind) ($(Cint(p.problem_kind)))")
    println(" hash: $(p.hash)")
    println(" zero: $(p.zero)")
    println(" print: $(p.print)")
    println(" destroy: $(p.destroy)")
end

#kernel/ifftw.h:527
immutable problem <: problem_a
    adt::Ptr{problem_adt}
end

function Base.show(io::IO, p::problem)
    print_with_color(:yellow,"problem:\n")
    adt = unsafe_load(p.adt)
    if adt.problem_kind == PROBLEM_DFT
        print_with_color(:yellow,"problem_dft:\n")
        
    end
    show(unsafe_load(p.adt))
end

type problem_dft <: problem_a
    super::problem
    sz::Ptr{tensor}
    vecsz::Ptr{tensor}
    ri::Ptr{R}
    ii::Ptr{R}
    ro::Ptr{R}
    io::Ptr{R}
end

function Base.show(io::IO, p::problem_dft)
    print_with_color(:yellow,"problem_dft:\n")
    println("super:")
    show(p.super)
    println("sz:")
    show(p.sz)
    println("vecsz:")
    show(p.vecsz)
    error("fix this for any length")
    println("ri: $(unsafe_wrap(Array{Cdouble}, p.ri, 5))")
    println("ii: $(unsafe_wrap(Array{Cdouble}, p.ii, 5))")
    println("ro: $(unsafe_wrap(Array{Cdouble}, p.ro, 5))")
    println("io: $(unsafe_wrap(Array{Cdouble}, p.io, 5))")
end

function Base.show(io::IO, p::Ptr{problem_dft})
    print_with_color(:yellow,"problem_dft from pointer:\n")
#    print_with_color(:yellow,"arrays in problem:\n")
    pri = reinterpret(Ptr{Ptr{Cdouble}}, p + 24)
    pii = reinterpret(Ptr{Ptr{Cdouble}}, p + 32)
    pro = reinterpret(Ptr{Ptr{Cdouble}}, p + 40)
    pio = reinterpret(Ptr{Ptr{Cdouble}}, p + 48)

    sz = unsafe_load(p).sz
    print_with_color(:yellow,"tensor sz:\n")
    show(sz)
    dim = unsafe_load(reinterpret(Ptr{iodim}, sz + 8))
    n = dim.n

    for i=1:n
        v = unsafe_load(unsafe_load(pri), i)
        println("element $i of ri: $v")
        v = unsafe_load(unsafe_load(pii), i)
        println("element $i of ii: $v")
        v = unsafe_load(pro, i)
        v = unsafe_load(unsafe_load(pro), i)
        println("element $i of ro: $v")
        v = unsafe_load(pio, i)
        v = unsafe_load(unsafe_load(pio), i)
        println("element $i of io: $v")
    end
end

function Base.show(io::IO, p::Ptr{problem})
    if unsafe_load(unsafe_load(p).adt).problem_kind == PROBLEM_DFT
        show(unsafe_load(reinterpret(Ptr{problem_dft}, p)))
    else
        error("problem unsupported")
    end
end

include("$FFTWDIR/dft/problem.jl")

#kernel/ifftw.h:363
immutable opcnt
    add::Cdouble
    mul::Cdouble
    fma::Cdouble
    other::Cdouble

#=    function opcnt(a, m, f, o)::opcnt
        x = new(Cdouble(a), Cdouble(m), Cdouble(f), Cdouble(o))
        return x
    end=#
end

function Base.show(io::IO, c::opcnt)
    print_with_color(:yellow,"opcnt:\n")
    println(" adds: $(c.add)")
    println(" muls: $(c.mul)")
    println(" fmas: $(c.fma)")
    println(" other: $(c.other)")
end

include("$FFTWDIR/kernel/ops.jl")

abstract plan_a

#kernel/ifftw.h:578
immutable plan_adt
    solve::Ptr{Void}
    awake::Ptr{Void}
    print::Ptr{Void}
    destroy::Ptr{Void}

    function plan_adt(s::Function, a::Function, p::Function, d::Function)
        padt = new(cfunction(s, Void, (Ptr{plan}, Ptr{problem})),
                   cfunction(a, Void, (Ptr{plan}, Cint)),
                   cfunction(p, Void, (Ptr{plan}, Ptr{printer})),
                   cfunction(d, Void, (Ptr{plan},)))
        return padt
    end
end

#kernel/ifftw.h:580
immutable plan <: plan_a
    adt::Ptr{plan_adt}
    ops::opcnt
    pcost::Cdouble
    wakefulness::Cint
    could_prune_now_p::Cint
end

#void X(plan_destroy_internal) in kernel/plan.c:45
function plan_destroy_internal(ego::Ptr{plan})::Void
    if ego != C_NULL
        @assert unsafe_load(ego).wakefulness == Cint(SLEEPY)
        dest = unsafe_load(unsafe_load(ego).adt).destroy
        ccall(dest,
              Void,
              (Ptr{plan},),
              ego)
        free(ego)
    end
#=    ccall(("fftw_plan_destroy_internal",FFTWchanges.libfftw),
          Void
          (Ptr{plan},)
          ego)=#
    return nothing
end

#void X(null_awake) in kernel/awake.c:24
function null_awake(ego::Ptr{plan}, wakefulness::Cint)::Void end

function Base.show(io::IO, p::plan)
    print_with_color(:yellow,"plan:\n")
    println(" adt: $(p.adt)")
    println(" ops:")
    show(p.ops)
    println(" pcost: $(p.pcost)")
    println(" wakefulness: $(p.wakefulness)")
    println(" could_prune_now_p: $(p.could_prune_now_p)")
end

immutable planpad
    padding::NTuple{72,UInt8}
end

#kernel/ifftw.h:55
immutable plan_dft <: plan_a
    super::plan
    apply::Ptr{Void}
#    pd::planpad
end

function Base.show(io::IO, p::plan_dft)
    print_with_color(:yellow,"plan_dft:\n")
    show(p.super)
    println(" apply: $(p.apply)")
end

typealias probs Union{problem, problem_dft}
typealias plans Union{plan, plan_dft}

#api/api.h:62
type apiplan
    pln::Ptr{plan}
    prb::Ptr{problem}
    sign::Cint
end

function mkpapiplan(pln::Ptr{plan}, prb::Ptr{problem}, sign::Cint)::Ptr{apiplan}
    p    = Ptr{apiplan}(Base.Libc.malloc(sizeof(apiplan)))
    adt  = unsafe_load(unsafe_load(reinterpret(Ptr{Ptr{problem_adt}}, prb)))
    kind = adt.problem_kind
#    kind = unsafe_load(unsafe_load(prb).super.adt).problem_kind
    if kind == PROBLEM_DFT
#        pt = reinterpret(Ptr{Ptr{plan_dft}}, p)
        pt = reinterpret(Ptr{Ptr{plan}}, p)
        unsafe_store!(pt, pln)
#        pt = reinterpret(Ptr{Ptr{problem_dft}}, p + 8)
        pt = reinterpret(Ptr{Ptr{problem}}, p + 8)
        unsafe_store!(pt, prb)
        pt = reinterpret(Ptr{Cint}, p + 16)
        unsafe_store!(pt, sign)
    else
        error("problem $kind not implemented yet")
    end
#    print_with_color(:red,"mkpapiplan:\n")
#    show(unsafe_load(p).pln)
#    show(unsafe_load(p).prb)
#    show(sign)
    return p
end

function Base.show(io::IO, ap::Ptr{apiplan})
    print_with_color(:yellow,"apiplan:\n")
#    ppln = unsafe_load(ap).pln
#    pprb = unsafe_load(ap).prb
    pln_dft = unsafe_load(ap).pln
    println(" loaded pln")
    prb_dft = unsafe_load(ap).prb
    println(" loaded prb")
    prb     = unsafe_load(prb_dft).super
    adt     = unsafe_load(prb.adt)
    kind    = adt.problem_kind
    kind == PROBLEM_DFT || error("show Ptr{apiplan}: kind $kind not implemented yet")
    print_with_color(:yellow," apiplan.pln:\n")
    show(unsafe_load(pln_dft))
    print_with_color(:yellow," apiplan.prb:\n")
    show(prb_dft)
#=    kind = unsafe_load(unsafe_load(unsafe_load(ap).prb).adt).problem_kind
    if kind == PROBLEM_DFT
        print_with_color(:yellow," kind = PROBLEM_DFT\n")
        ppln = reinterpret(Ptr{Ptr{plan_dft}}, ap)
        pln  = unsafe_load(unsafe_load(ppln))
        pprb = reinterpret(Ptr{Ptr{problem_dft}}, ap + 8)
        prb  = unsafe_load(unsafe_load(pprb))
        show(pln)
        show(prb)=#
#=        println("sign: $(unsafe_load(ap).sign)")
        solve = unsafe_load(pln.super.adt).solve
        print_with_color(:cyan,"solve: $solve\n")
        ccall(solve, Void, (Ptr{plan_dft}, Ptr{problem_dft}), ppln, pprb)
        print_with_color(:cyan,"after solving:\n")
        show(unsafe_load(pprb))=#
#    end      
end

#=
type myFFTWPlan
    ops::opcnt
    pcost::Float32
    wakefulness::Wakefulness
    could_prune_now_p::Int16
end=#

abstract solver_s

#kernel/ifftw.h:599
immutable solver_adt
    problem_kind::problems
    mkplan::Ptr{Void}
    destroy::Ptr{Void}
end

function Base.show(io::IO, sa::solver_adt)::Void
    print_with_color(:yellow,"solver_adt:\n")
    println(" problem_kind: $(Cint(sa.problem_kind))\n")
    println(" mkplan: $(sa.mkplan)\n")
    println(" destroy: $(sa.destroy)\n")
    return nothing
end

#kernel/ifftw.h:601
immutable solver <: solver_s
    adt::Ptr{solver_adt}
    refcnt::Cint
#    padding::planpad
end

function Base.show(io::IO, s::solver)
    adt = unsafe_load(s.adt)
    pk = Int(adt.problem_kind)
    println("solver of problem kind $pk with $(s.refcnt) ref", pk != 1 ? "s" : "")
end


#kernel/ifftw.h:623
type slvdesc
    slv::Ptr{solver}
#    reg_nam::AbstractString
    reg_nam::Ptr{Cchar}
    nam_hash::Cuint
    reg_id::Cint
    next_for_same_problem_kind::Cint
    function slvdesc()
        s = new(solver(PROBLEM_UNSOLVABLE, 0), "", Cuint(0), Cint(0), Cint(0))
        return s
    end
end

function Base.show(io::IO, s::slvdesc)
    println("slvdesc:")
    show(s.slv)
    println(" reg_nam: $(s.reg_nam)")
    println(" nam_hash: $(s.nam_hash)")
    println(" reg_id: $(s.reg_id)")
    println(" next: $(s.next_for_same_problem_kind)")
end

function Base.copy(s::slvdesc)
    return slvdesc(s.slv, s.reg_nam, s.nam_hash, s.reg_id, s.next_for_same_problem_kind)
end

#Julia does not yet support bitstypes of sizes not a
#multiple of 8 bits so cannot pack into 64 bits
const BITS_FOR_TIMELIMIT = Cuint(9)
const BITS_FOR_SLVNDX = Cuint(12)
const INFEASIBLE_SLVNDX = Cuint(1 << BITS_FOR_SLVNDX - 1)
#=-
bitstype 20 f_l <: Unsigned
bitstype 3 f_hash_info <: Unsigned
bitstype BITS_FOR_TIMELIMIT f_timelimit_impatience <: Unsigned
bitstype 20 f_u <: Unsigned
bitstype BITS_FOR_SLVNDX f_slvndx <: Unsigned

type flags_t
    l::f_l
    hash_info::f_hash_info
    timelimit_impatience::f_timelimit_impatience
    u::f_u
    slvndx::f_slvndx
end
=#

#kernel/ifftw.h:651
bitstype 64 flags_t
function flags_t(l::Cuint, h::Cuint, t::Cuint, u::Cuint, s::Cuint)::flags_t
    ll = l & (1<<20-1)
    hh = h & (1<<3-1)
    tt = t & (1<<9-1)
    uu = u & (1<<20-1)
    ss = s & (1<<12-1)
#backwards    return reinterpret(flags_t, (ll<<44)|(hh<<41)|(tt<<32)|(uu<<12)|ss)
    return reinterpret(flags_t, ll|(hh<<20)|(tt<<23)|(uu<<32)|(ss<<52))
end

flags_t(l::Integer, h::Integer, t::Integer, u::Integer, s::Integer) = 
    flags_t(convert(NTuple{5, Cuint}, (l, h, t, u, s))...)

function setflag(f::flags_t, s::Symbol, x::Integer)::flags_t
    ff = reinterpret(UInt64, f)
    x = convert(Cuint, x)
    if s == :l
        v = x & (1<<20-1)
#        ff = (ff << 20 >>> 20) | v << 44
        ff = (ff >>> 20 << 20) | v
    elseif s == :h
        v = x & (1<<3-1)
#        b = ff << 20 >>> 61 << 41
        b = ff >>> 20 << 61 >>> 41
#        ff = (ff & ~b) | v << 41
        ff = (ff & ~b) | v << 20
    elseif s == :t
        v = x & (1<<9-1)
#        b = ff << 23 >>> 55 << 32
        b = ff >>> 23 << 55 >>> 32
#        ff = (ff & ~b) | v << 32
        ff = (ff & ~b) | v << 23
    elseif s == :u
        v = x & (1<<20-1)
#        b = ff << 32 >>> 44 << 12
        b = ff >>> 32 << 44 >>> 12
#        ff = (ff & ~b) | v << 12
        ff = (ff & ~b) | v << 32
    elseif s == :s
        v = x & (1<<12-1)
#        ff = (ff >>> 12 << 12) | v
        ff = (ff << 12 >>> 12) | v << 52
    else
        error("setflag: invalid symbol $s")
    end
    ff = reinterpret(flags_t, ff)
    return ff
end

function flag(f::flags_t, s::Symbol)::Cuint
    ff = reinterpret(UInt64, f)
    if s == :l
#        v = (ff>>>44)&(1<<20-1)
        v = ff&(1<<20-1)
    elseif s == :h
#        v = (ff>>>41)&(1<<3-1)
        v = (ff>>>20)&(1<<3-1)
    elseif s == :t
#        v = (ff>>>32)&(1<<9-1)
        v = (ff>>>23)&(1<<9-1)
    elseif s == :u
#        v = (ff>>>12)&(1<<20-1)
        v = (ff>>>32)&(1<<20-1)
    elseif s == :s
#        v = ff&(1<<12-1)
        v = (ff>>>52)&(1<<12-1)
    else
        error("flag: invalid symbol $s")
    end
    return Cuint(v)
end

function Base.show(io::IO, f::flags_t)
    l = flag(f, :l)
    h = flag(f, :h)
    t = flag(f, :t)
    u = flag(f, :u)
    s = flag(f, :s)
    println("flags:")
    ff = reinterpret(UInt64, f)
    println(" $(bits(ff))")
    println(" l: $(bits(l)[end-19:end])")
    println(" h: $(bits(h)[end-2:end])")
    println(" t: $(bits(t)[end-8:end])")
    println(" u: $(bits(u)[end-19:end])")
    println(" s: $(bits(s)[end-11:end])")
end

#kernel/ifftw.h:651
#=type flags_t
    l::UInt32
    hash_info::UInt8
    timelimit_impatience::UInt16
    u::UInt32
    slvndx::UInt16
    function flags_t()
        f = new(UInt32(0), UInt8(0), UInt16(0), UInt32(0), UInt16(0))
        return f
    end
end=#


#immutable solution_struct end
#typealias solution Ptr{solution_struct}

#kernel/planner.c:198
#forward declared opaque structure in kernel/ifftw.h:625
type solution
    s::md5sig
    flags::flags_t

    function solution()
        sol = new([0, 0, 0, 0,], flags_t(0,0,0,0,0))
        return sol
    end
end

function newsolution()::Ptr{solution}
    s = Ptr{solution}(malloc(sizeof(solution)))
    return s
end

function Base.show(io::IO, s::solution)
    print_with_color(:yellow,"solution:\n")
    println(" s: $(s.s)")
    show(s.flags)
#    println("flags: $(s.flags)")
end

#kernel/ifftw.h:746
#type hashtab
immutable hashtab
    solutions::Ptr{solution}
    hashsiz::Cuint
    nelem::Cuint
    #statistics
    lookup::Cint
    succ_lookup::Cint
    lookup_iter::Cint
    insert::Cint
    insert_iter::Cint
    insert_unknown::Cint
    nrehash::Cint

    #mkhashtab in kernel/planner.c:756
#=    function hashtab()
        ht = new(C_NULL, Cuint(0), Cuint(0), 0, 0, 0, 0, 0, 0, 0)
        hgrow(ht)
        return ht
    end=#
end

function Base.show(io::IO, ht::hashtab)
    print_with_color(:yellow,"hashtab:\n")
#    local hs = ht.hashsiz
#    local s::solution = unsafe_load(ht.solutions)
    for i in 1:ht.hashsiz
        println(" solution $i of $(ht.hashsiz):")
        if ht.solutions + (i-1)*sizeof(solution) != C_NULL
            show(unsafe_load(ht.solutions, i))
        else
            println(" null solution")
        end
    end
    println(" hashsiz: $(ht.hashsiz)")
    println(" nelem: $(ht.nelem)")
    println(" lookup: $(ht.lookup)")
    println(" succ_lookup: $(ht.succ_lookup)")
    println(" lookup_iter: $(ht.lookup_iter)")
    println(" insert: $(ht.insert)")
    println(" insert_iter: $(ht.insert_iter)")
    println(" insert_unknown: $(ht.insert_unknown)")
    println(" nrehash: $(ht.nrehash)")
end
#=
function Base.show(io::IO, ht::Ptr{hashtab})
    print_with_color(:yellow,"hashtab:\n")
    #solution* solutions at 0 bytes in hashtab
    pt = reinterpret(Ptr{Ptr{solution}}, ht)
    sol = unsafe_load(pt)
    #unsigned hashsiz at 8 bytes in hashtab
    pt = reinterpret(Ptr{Cuint}, ht + 8)
    hashsiz = unsafe_load(pt)
    for i in 1:hashsiz
        println(" solution $i of $hashsiz:")
        if sol + (i-1)*sizeof(solution) != C_NULL
            show(unsafe_load(sol, i))
        else
            println(" null solution")
        end
    end
    println(" hashsiz: $hashsiz")
    #unsigned nelem at 12 bytes in hashtab
    pt = reinterpret(Ptr{Cuint}, ht + 12)
    println(" nelem: $(unsafe_load(pt))")
    #int lookup at 16 bytes in hashtab
    pt = reinterpret(Ptr{Cint}, ht + 16)
    println(" lookup: $(unsafe_load(pt))")
    #int succ_lookup at 20 bytes in hashtab
    pt = reinterpret(Ptr{Cint}, ht + 20)
    println(" succ_lookup: $(unsafe_load(pt))")
    #int lookup_iter at 24 bytes in hashtab
    pt = reinterpret(Ptr{Cint}, ht + 24)
    println(" lookup_iter: $(unsafe_load(pt))")
    #int insert at 28 bytes in hashtab
    pt = reinterpret(Ptr{Cint}, ht + 28)
    println(" insert: $(unsafe_load(pt))")
    #int insert_iter at 32 bytes in hashtab
    pt = reinterpret(Ptr{Cint}, ht + 32)
    println(" insert_iter: $(unsafe_load(pt))")
    #int insert_unknown at 36 bytes in hashtab
    pt = reinterpret(Ptr{Cint}, ht + 36)
    println(" insert_unknown: $(unsafe_load(pt))")
    #int nrehash at 40 bytes in hashtab
    pt = reinterpret(Ptr{Cint}, ht + 40)
    println(" nrehash: $(unsafe_load(pt))")
end
=#
    
#kernel/ifftw.h:735
immutable planner_adt
    register_solver::Ptr{Void}
    mkplan::Ptr{Void}
    forget::Ptr{Void}
    exprt::Ptr{Void}
    imprt::Ptr{Void}
end

function Base.show(io::IO, adt::planner_adt)
    print_with_color(:yellow,"planner_adt:\n")
    println("  adt.register_solver: $(adt.register_solver)")
    println("  adt.mkplan: $(adt.mkplan)")
    println("  adt.forget: $(adt.forget)")
    println("  adt.exprt: $(adt.exprt)")
    println("  adt.imprt: $(adt.imprt)")
end

function mkplanner_adt(register_solver::Function, mkplan::Function, forget::Function, exprt::Function = x->x, imprt::Function = x->x)::Ptr{planner_adt}
    padt = Ptr{planner_adt}(malloc(sizeof(planner_adt)))
    #func* register_solver at 0 bytes in planner_adt
    pt = reinterpret(Ptr{Ptr{Void}}, padt)
    unsafe_store!(pt, cfunction(register_solver, Void, (Ptr{planner}, Ptr{solver})))
    #func* mkplan at 8 bytes in planner_adt
    pt = reinterpret(Ptr{Ptr{Void}}, padt + 8)
    unsafe_store!(pt, cfunction(mkplan, Ptr{plan}, (Ptr{planner}, Ptr{problem})))
    #func* forget at 16 bytes in planner_adt
    pt = reinterpret(Ptr{Ptr{Void}}, padt + 16)
    unsafe_store!(pt, cfunction(forget, Void, (Ptr{planner}, amnesia)))
    #func* exprt at 24 bytes in planner_adt
    pt = reinterpret(Ptr{Ptr{Void}}, padt + 24)
    unsafe_store!(pt, C_NULL)
    #func* imprt at 32 bytes in planner_adt
    pt = reinterpret(Ptr{Ptr{Void}}, padt + 32)
    unsafe_store!(pt, C_NULL)

    return padt
end

type planner
    adt::Ptr{planner_adt}
    
    hook::Ptr{Void}
    cost_hook::Ptr{Void}
    wisdom_ok_hook::Ptr{Void}
    nowisdom_hook::Ptr{Void}
    bogosity_hook::Ptr{Void}

    slvdescs::Ptr{slvdesc}
    nslvdesc::Cuint
    slvdescsiz::Cuint
    cur_reg_nam::Ptr{Cchar}
    cur_reg_id::Cint
    slvdescs_for_problem_kind::NTuple{8,Cint}#PROBLEM_LAST = 8 elements

    wisdom_state::wisdom_state_t

    htab_blessed::hashtab
    htab_unblessed::hashtab

    nthr::Cint
    flags::flags_t

    start_time::crude_time
    timelimit::Cdouble
    timed_out::Cint
    need_timeout_check::Cint

    nplan::Cint
    pcost::Cdouble
    epcost::Cdouble
    nprob::Cint

    function planner(p::Ptr{planner})
        local ar = fieldnames(planner)
        local at = [fieldtype(planner, name) for name in ar]
#        local of = [fieldoffset(planner, i) for i in 1:size(ar)[1]]
        local of = [0,8,8,8,8,8,8,8,4,4,8,4,32,4,48,48,8,8,16,8,4,4,8,8,8]
#        rv = Array{Any}(25)
#        add = [p+of[i] for i in 1:size(of)[1]]
        pt = p
        jp = new()
        for i in 1:size(ar)[1]
#            pt = add[i]  
            pt += of[i]  
#            println("at offset $(pt-p):")
#            println(" field: $(ar[i])")
#            println(" type: $(at[i])")
            if at[i] <: Ptr || at[i] <: Real || at[i] == hashtab
                v = unsafe_load(reinterpret(Ptr{at[i]}, pt))
            elseif at[i] == NTuple{8,Cint}
                v = tuple(unsafe_wrap(Array, reinterpret(Ptr{Cint}, pt), 8)...)
            elseif at[i] == crude_time
                v = crude_time(tuple(unsafe_wrap(Array, reinterpret(Ptr{Clong}, pt), 2)...)...)
            elseif at[i] == wisdom_state_t
                v = wisdom_state_t(unsafe_load(reinterpret(Ptr{Cint}, pt)))
            elseif at[i] == flags_t
                v = reinterpret(flags_t, unsafe_load(reinterpret(Ptr{UInt64}, pt)))
            else
                error("planner: type $(at[i]) not accounted for")
            end
#            rv[i] = v
#            println(" value: $v")
            setfield!(jp, ar[i], v)
        end
        return jp
    end
end

function Base.show(io::IO, p::planner)
    local adt::planner_adt = unsafe_load(p.adt)
    print_with_color(:yellow,"Planner:\n")
    println(" adt: $(p.adt)")
    println("  adt.register_solver: $(adt.register_solver)")
    println("  adt.mkplan: $(adt.mkplan)")
    println("  adt.forget: $(adt.forget)")
    println("  adt.exprt: $(adt.exprt)")
    println("  adt.imprt: $(adt.imprt)")
    println(" hook: $(p.hook)")
    println(" cost_hook: $(p.cost_hook)")
    println(" wisdom_ok_hook: $(p.wisdom_ok_hook)")
    println(" nowisdom_hook: $(p.nowisdom_hook)")
    println(" bogosity_hook: $(p.bogosity_hook)")
#    local n = p.nslvdesc
#    local sd::Array{slvdesc,1} = unsafe_wrap(Array, p.slvdescs, n, false)
#    println(" $n slvdescs:")
#    for i in 1:n
#        show(sd[i])
#    end
    println(" nslvdesc: $(p.nslvdesc)")
    println(" slvdescsiz: $(p.slvdescsiz)")
#=    local crn::String
    if p.cur_reg_nam != C_NULL
        crn = unsafe_wrap(String, p.cur_reg_nam, false)
        println(" cur_reg_nam: $(crn)")
    end=#
    println(" cur_reg_id: $(p.cur_reg_id)")
    println(" slvdescs_for_problem_kind: $(p.slvdescs_for_problem_kind)")
    println(" wisdom_state: $(p.wisdom_state)")
    println(" htab_blessed: $(p.htab_blessed)")
#    show(p.htab_blessed)
    println(" htab_unblessed: $(p.htab_unblessed)")
#    show(p.htab_unblessed)
    println(" nthr: $(p.nthr)")
    show(p.flags)
#    show(p.start_time)
    println(" timelimit: $(p.timelimit)")
    println(" timed_out: $(p.timed_out)")
    println(" need_timeout_check: $(p.need_timeout_check)")
    println(" nplan: $(p.nplan)")
    println(" pcost: $(p.pcost)")
    println(" epcost: $(p.epcost)")
    println(" nprob: $(p.nprob)")
end

function ==(p::planner, q::planner)::Bool
    v = true
    for i in fieldnames(planner)
        if getfield(p, i) != getfield(q, i) 
            error("field $i different: $(getfield(p, i)) != $(getfield(q, i))")
            v = false
        end
    end
    return v
end

plnr_p = C_NULL

const planneroffs = [0,8,8,8,8,8,8,8,4,4,8,4,32,4,48,48,8,8,16,8,4,4,8,8,8]
const poffs = cumsum(planneroffs)
const dpoffs = Dict((fieldname(planner, i), poffs[i]) for i in 1:nfields(planner))

function changeplanner(plnr::Ptr{planner}, elem::Symbol, x)
    off = dpoffs[elem]
    pt = reinterpret(Ptr{typeof(x)}, plnr + off)
    unsafe_store!(pt, x)
end
#=
function check(plnr::Ptr{planner})::Void
    jp = unsafe_load(plnr)
#    jp = planner(plnr)
    @assert jp.nplan == Cint(0)
    @assert jp.nprob == Cint(0)
    @assert jp.pcost == Cdouble(0)
    @assert jp.epcost == Cdouble(0)
    @assert jp.hook == C_NULL
    @assert jp.cost_hook == C_NULL
    @assert jp.wisdom_ok_hook == C_NULL
    @assert jp.nowisdom_hook == C_NULL
    @assert jp.bogosity_hook == C_NULL
    @assert jp.cur_reg_nam == C_NULL
    @assert jp.wisdom_state == WISDOM_NORMAL
    @assert jp.slvdescs == C_NULL
    @assert jp.nslvdesc == Cuint(0)
    @assert jp.slvdescsiz == Cuint(0)
    @assert flag(jp.flags, :l) == Cuint(0)
    @assert flag(jp.flags, :u) == Cuint(0)
    @assert flag(jp.flags, :t) == Cuint(0)
    @assert flag(jp.flags, :h) == Cuint(0)
    @assert jp.nthr == Cint(1)
    @assert jp.need_timeout_check == Cint(1)
    @assert jp.timelimit == Cdouble(-1)
    for i=1:Int(PROBLEM_LAST)
        @assert jp.slvdescs_for_problem_kind[i] == Cint(-1)
    end
end
=#








#macros in kernel/ifftw.h:669
PLNR_L(p::Ptr{planner})::Cuint = flag(unsafe_load(p).flags, :l)
PLNR_U(p::Ptr{planner})::Cuint = flag(unsafe_load(p).flags, :u)
PLNR_TIMELIMIT_IMPATIENCE(p::Ptr{planner})::Cuint = flag(unsafe_load(p).flags, :t)

#macros in kernel/ifftw.h:673
ESTIMATEP(p::Ptr{planner})::Cuint = PLNR_U(p) & ESTIMATE
BELIEVE_PCOSTP(p::Ptr{planner})::Cuint = PLNR_U(p) & BELIEVE_PCOST
ALLOW_PRUNINGP(p::Ptr{planner})::Cuint = PLNR_U(p) & ALLOW_PRUNING

#macros in kernel/ifftw.h:677
NO_INDIRECT_OP_P(p::Ptr{planner})::Cuint = PLNR_L(p) & NO_INDIRECT_OP
NO_LARGE_GENERICP(p::Ptr{planner})::Cuint = PLNR_L(p) & NO_LARGE_GENERIC
NO_RANK_SPLITSP(p::Ptr{planner})::Cuint = PLNR_L(p) & NO_RANK_SPLITS
NO_VRANK_SPLITSP(p::Ptr{planner})::Cuint = PLNR_L(p) & NO_VRANK_SPLITS
NO_VRECURSEP(p::Ptr{planner})::Cuint = PLNR_L(p) & NO_VRECURSE
NO_DFT_R2HCP(p::Ptr{planner})::Cuint = PLNR_L(p) & NO_DFT_R2HC
NO_SLOWP(p::Ptr{planner})::Cuint = PLNR_L(p) & NO_SLOW
NO_UGLYP(p::Ptr{planner})::Cuint = PLNR_L(p) & NO_UGLY
NO_FIXED_RADIX_LARGE_NP(p::Ptr{planner})::Cuint = PLNR_L(p) & NO_FIXED_RADIX_LARGE_N
NO_NONTHREADEDP(p::Ptr{planner})::Cuint = (PLNR_L(p) & NO_NONTHREADED) &&
                                          unsafe_load(p).nthr > 1

#macros in kernel/ifftw.h:690
NO_DESTROY_INPUTP(p::Ptr{planner})::Cuint = PLNR_L(p) & NO_DESTROY_INPUT
NO_SIMDP(p::Ptr{planner})::Cuint = PLNR_L(p) & NO_SIMD
NO_CONSERVE_MEMORYP(p::Ptr{planner})::Cuint = PLNR_L(p) & NO_CONSERVE_MEMORY
NO_DHT_R2HCP(p::Ptr{planner})::Cuint = PLNR_L(p) & NO_DHT_R2HC
NO_BUFFERINGP(p::Ptr{planner})::Cuint = PLNR_L(p) & NO_BUFFERING

##if defined(HAVE_SSE2) || defined(HAVE_AVX) #true
## if defined(FFTW_SINGLE) #false 
## else
#macros in simd-support/simd-common.h:31
const ALIGNMENT = Cuintptr_t(16)
const ALIGNMENTA = Cuintptr_t(16)
# endif
#endif

#macros in simd-support/simd-common.h:58
const TAINT_BIT = Cuintptr_t(1)
const TAINT_BITA = Cuintptr_t(2)
PTRINT(p) = Cuintptr_t(p)

#R* X(taint) in simd-support/taint.c:27
function taint(p::Ptr{R}, s::INT)::Ptr{R}
#=    p = ccall(("fftw_taint", libfftw),
              Ptr{R},
              (Ptr{R}, INT),
              p, s)=#
  
    if (Cuint(s) * sizeof(R)) % ALIGNMENT != 0
        p = Ptr{R}(PTRINT(p) | TAINT_BIT)
    end
    if (Cuint(s) * sizeof(R)) % ALIGNMENTA != 0
        p = Ptr{R}(PTRINT(p) | TAINT_BITA)
    end

    return p
end

#R* X(join_taint) in simd-support/taint.c
function join_taint(p1::Ptr{R}, p2::Ptr{R})::Ptr{R}
#=    p = ccall(("fftw_join_taint", libfftw),
              Ptr{R},
              (Ptr{R}, Ptr{R}),
              p1, p2)=#

    @assert UNTAINT(p1) == UNTAINT(p2) "$p1 != $p2"
    p = Ptr{R}(PTRINT(p1) | PTRINT(p2))

    return p
end
 
#macros in kernel/ifftw.h:1055
TAINT(p::Ptr{R}, s::INT) = taint(p ,s)
UNTAINT(p::Ptr{R})       = Ptr{R}(Cuintptr_t(p) & ~Cuintptr_t(3))
TAINTOF(p::Ptr{R})       = Cuintptr_t(p) & 3
JOIN_TAINT(p1, p2)       = join_taint(p1, p2)

ASSERT_ALIGNED_DOUBLE() = @assert Cuintptr_t(pointer_from_objref(Cdouble(1))) & 0x7 == 0

#macro in api/api.h:76
TAINT_UNALIGNED(p, flg) = TAINT(p, INT(flg & FFTW_UNALIGNED != 0))

#macros in simd-support/simd-common.h:64
ALIGNED(p) = PTRINT(UNTAINT(p)) % ALIGNMENT == 0 && !(PTRINT(p) & TAINT_BIT)

#nonportable
const ALGN = Cuintptr_t(16)
#int X(alignment_of) in kernel/align.c
function alignment_of(p::Ptr{R})::Cint
#=    n = ccall(("fftw_alignment_of", libfftw),
              Cint,
              (Ptr{R},),
              p)=#
    return Cint(Cuintptr_t(p) % ALGN)
end

#include("$FFTWDIR/Callocs.jl")
include("$FFTWDIR/kernel/solver.jl")

include("$FFTWDIR/dft/types.jl")
include("$FFTWDIR/dft/dftconf.jl")



