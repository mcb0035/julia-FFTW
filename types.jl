## FFTW Flags from fftw3.h

const FFTW_MEASURE         = UInt32(0)
const FFTW_DESTROY_INPUT   = UInt32(1 << 0)
const FFTW_UNALIGNED       = UInt32(1 << 1)
const FFTW_CONSERVE_MEMORY = UInt32(1 << 2)
const FFTW_EXHAUSTIVE      = UInt32(1 << 3)   # NO_EXHAUSTIVE is default
const FFTW_PRESERVE_INPUT  = UInt32(1 << 4)   # cancels DESTROY_INPUT
const FFTW_PATIENT         = UInt32(1 << 5)   # IMPATIENT is default
const FFTW_ESTIMATE        = UInt32(1 << 6)
const FFTW_WISDOM_ONLY     = UInt32(1 << 21)
const FFTW_NO_SIMD = UInt32(1 << 17) # disable SIMD, useful for benchmarking

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
      PROBLEM_UNSOLVABLE = 0, 
      PROBLEM_DFT = 1, 
      PROBLEM_RDFT = 2,
      PROBLEM_RDFT2 = 3, 
      PROBLEM_MPI_DFT = 4, 
      PROBLEM_MPI_RDFT = 5,
      PROBLEM_MPI_RDFT2 = 6, 
      PROBLEM_MPI_TRANSPOSE = 7, 
      PROBLEM_LAST = 8)

#kernel/ifftw.h:566
@enum(Wakefulness, 
      SLEEPY = 0, 
      AWAKE_ZERO = 1, 
      AWAKE_SQRTN_TABLE = 2, 
      AWAKE_SINCOS = 3)
#=
#kernel/ifftw.h:654
@enum(Patience, 
      BELIEVE_PCOST = 0x0001, 
      ESTIMATE = 0x0002,
      NO_DFT_R2HC = 0x0004,
      NO_SLOW = 0x0008,
      NO_VRECURSE = 0x0010,
      NO_INDIRECT_OP = 0x0020,
      NO_LARGE_GENERIC = 0x0040,
      NO_RANK_SPLITS = 0x0080,
      NO_VRANK_SPLITS = 0x0100,
      NO_NONTHREADED = 0x0200,
      NO_BUFFERING = 0x0400,
      NO_FIXED_RADIX_LARGE_N = 0x0800,
      NO_DESTROY_INPUT = 0x1000,
      NO_SIMD = 0x2000,
      CONSERVE_MEMORY = 0x4000,
      NO_DHT_R2HC = 0x8000,
      NO_UGLY = 0x10000,
      ALLOW_PRUNING = 0x20000)=#

#kernel/ifftw.h:676
@enum(Hashtable_info, 
      BLESSING = 0x1,
      H_VALID = 0x2,
      H_LIVE = 0x4)

#kernel/ifftw.h:709
@enum(amnesia,
      FORGET_ACCURSED = 0,
      FORGET_EVERYTHING = 1)


#kernel/ifftw.h:726
@enum(wisdom_state_t,
      WISDOM_NORMAL = 0,
#      WISDOM_ONLY = 1,
      WISDOM_IS_BOGUS = 2,
      WISDOM_IGNORE_INFEASIBLE = 3,
      WISDOM_IGNORE_ALL = 4)

#kernel/ifftw.h:748
@enum(cost_kind,
      COST_SUM = 0,
      COST_MAX = 1)

#kernel/ifftw.h:452
@enum(inplace_kind,
      INPLACE_IS = 0,
      INPLACE_OS = 1)

#kernel/ifftw.h:320
typealias crude_time Cint

#kernel/ifftw.h:84
typealias INT Cptrdiff_t

#use this instead of macros at kernel/ifftw.h:449
intmax = typemax(Cint)
if is(typeof(1.0), Float64)
    typealias Float Float64
elseif is(typeof(1.0), Float32)
    typealias Float Float32
end

immutable fftw_plan_struct end
typealias PlanPtr Ptr{fftw_plan_struct}

#MINE
immutable fftw_problem_struct end
typealias ProbPtr Ptr{fftw_problem_struct}
immutable fftw_print_struct end
typealias PrintPtr Ptr{fftw_print_struct}
immutable fftw_tensor_struct end
typealias TensPtr Ptr{fftw_tensor_struct}
immutable fftw_planner_struct end
typealias PlannerPtr Ptr{fftw_planner_struct}
stdout = unsafe_load(cglobal(:stdout, Ptr{Void}))
#END MINE

#types
#api/api.h:62
type apiplan
    pln::PlanPtr
    prb::ProbPtr
    sign::Cint
end

#kernel/ifftw.h:363
type opcnt
    add::Cint
    mul::Cint
    fma::Cint
    other::Cint
end

#kernel/ifftw.h:429
type iodim
    n::Cptrdiff_t
    is::Cptrdiff_t
    os::Cptrdiff_t
end

#kernel/ifftw.h:440
type tensor
    rnk::Cint
#    dims::Array{iodim,1}
    dims::Ptr{iodim}

    #mktensor in kernel/tensor.c:24
#=    function tensor(r::Cint)
        @assert r >= 0
        if r != intmax
            t = new(r,fill(iodim(0,0,0),r))
        else
            t = new(r,fill(iodim(0,0,0),0))
        end
        return t
    end=#
end

#kernel/ifftw.h:400
typealias md5sig NTuple{4,Cuint}

#kernel/ifftw.h:409
type md5
    s::md5sig
    
    c::NTuple{64,Cuchar}
    l::Cuint
end
    

type myFFTWPlan
    ops::opcnt
    pcost::Float32
    wakefulness::Wakefulness
    could_prune_now_p::Int16
end

#kernel/ifftw.h:601
type solver
    problem_kind::problems
    refcnt::Cint
end

#kernel/ifftw.h:623
type slvdesc
    slv::solver
    reg_nam::AbstractString
    nam_hash::Cuint
    reg_id::Cint
    next_for_same_problem_kind::Cint
    function slvdesc()
        s = new(solver(PROBLEM_UNSOLVABLE, 0), "", Cuint(0), Cint(0), Cint(0))
        return s
    end
end

function Base.copy(s::slvdesc)
    return slvdesc(s.slv, s.reg_nam, s.nam_hash, s.reg_id, s.next_for_same_problem_kind)
end

#Julia does not yet support bitstypes of sizes not a
#multiple of 8 bits so cannot pack into 64 bits
const BITS_FOR_TIMELIMIT = Cuint(9)
const BITS_FOR_SLVNDX = Cuint(12)
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
function flags_t(l::UInt64, h::UInt64, t::UInt64, u::UInt64)::flags_t
    ll = l & (1<<20-1)
    hh = h & (1<<3-1)
    tt = t & (1<<9-1)
    uu = u & (1<<20-1)
    return reinterpret(flags_t, (ll<<44)|(hh<<41)|(tt<<32)|(uu<<12))
end

function flag(f::flags_t, s::Symbol)::UInt64
    ff = reinterpret(UInt64, f)
    if s == :l
        return (ff>>>44)&(1<<20-1)
    elseif s == :h
        return (ff>>>41)&(1<<3-1)
    elseif s == :t
        return (ff>>>32)&(1<<9-1)
    elseif s == :u
        return (ff>>>12)&(1<<20-1)
    end
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
        sol = new([0, 0, 0, 0,], flags_t())
        return sol
    end
end

#kernel/ifftw.h:746
type hashtab
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
    function hashtab()
        ht = new(solution[], Cuint(0), Cuint(0), 0, 0, 0, 0, 0, 0, 0)
        hgrow(ht)
        return ht
    end
end

#kernel/ifftw.h:527
#Julia cannot yet handle abstract types with fields so each
#concrete problem type must have problem_kind::Cint first
abstract problem

#kernel/ifftw.h:525
immutable problem_adt
    problem_kind::problems
    hash::Ptr{Void}
    zero::Ptr{Void}
    print::Ptr{Void}
    destroy::Ptr{Void}
end

#kernel/ifftw.h:527
type problem_s
    adt::Ptr{problem_adt}
end
    
#kernel/ifftw.h:735
immutable planner_adt
    register_solver::Ptr{Void}
    mkplan::Ptr{Void}
    forget::Ptr{Void}
    exprt::Ptr{Void}
    imprt::Ptr{Void}
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
end


