export mkplan0, mkplan, mkapiplan
using Base.Libc
using Primes
#=type problem_dft <: problem
    problem_kind::problems
    sz::tensor
    vecsz::tensor
    ri::Array{Float,1}
    ii::Array{Float,1}
    ro::Array{Float,1}
    io::Array{Float,1}

    #X(mkproblem_dft) in dft/problem.c:77
    function problem_dft(sz::tensor, vecsz::tensor, ri::Float, ii::Float, ro::Float, io::Float)
        if ri == ro || ii == io
            if ri != ro || ii != io || !tensor_inplace_locations(sz, vecsz)
                p = new(PROBLEM_UNSOLVABLE)
                return p
           end
        end

        p = new(PROBLEM_DFT, tensor_compress(sz), tensor_compress_contiguous(vecsz), ri, ii, ro, io)
        return p
    end
end=#

#MKTENSOR_IODIMS in api/mktensor-iodims.h:23
function MKTENSOR_IODIMS(rank::Cint, dims::Array{iodim,1}, is::Cint, os::Cint)
    x = tensor(rank)    
    if rank != intmax
        for i=1:rank
            x.dims[i].n = dims[i].n
            x.dims[i].is = dims[i].is * is
            x.dims[i].os = dims[i].os * os
        end
    end
    return x
end

#iodims_kosherp in api/mktensor-iodims.h:38
function iodims_kosherp(rank::Cint, dims::Array{Cint,2}, allow_minfty::Cint)
    if rank < 0
        return false
    end
    if allow_minfty != 0
#        if rank == typemax(typeof(rank))
        if rank == intmax
            return true
        end
        for i=1:rank
            if dims[i][1] < 0
                return false
            end
        end
    else
#        if rank == typemax(typeof(rank))
        if rank == intmax
            return false
        end
        for i=1:rank
            if dims[i][1] <= 0
                return false
            end
        end
    end
    return true
end

#X(extract_reim) in kernel/extract-reim.c:27
function extract_reim(sign::Cint, c::Array{Complex{Float}})
   if sign == -1 
       r = real(c)
       i = imag(c)
   else
       r = imag(c)
       i = real(c)
   end
   return (r, i)
end

#GURU_KOSHERP in api/mktensor-iodims.h:57
function GURU_KOSHERP(rank::Cint, dims::Array{Cint,2}, howmany_rank::Cint, howmany_dims::Array{Cint,2})
    return iodims_kosherp(rank, dims, Cint(0)) && iodims_kosherp(howmany_rank, howmany_dims, Cint(1))
end

#macros in kernel/planner.c:33
VALIDP(sol::Ptr{solution})::Cuint = flag(unsafe_load(sol).flags, :h) & H_VALID
LIVEP(sol::Ptr{solution})::Cuint  = flag(unsafe_load(sol).flags, :h) & H_LIVE
SLVNDX(sol::Ptr{solution})::Cuint = flag(unsafe_load(sol).flags, :s)
BLISS(f::flags_t)::Cuint = flag(f, :h) & BLESSING

#macro LEQ in kernel/planner.c:50
LEQ{T<:Unsigned}(x::T, y::T)::Bool = (x & y) == x

#static unsigned addmod in kernel/planner.c:64
function addmod(a::Cuint, b::Cuint, p::Cuint)
    c = a + b
    return c >= p ? c - p : c
end

#unsigned X(hash) in kernel/hash.c:23
function jhash(s::Ptr{Cchar})::Cuint
    ss = s
    h::Cuint = 0xDEADBEEF
    while true
        h = h * Cuint(17) + Cuint(unsafe_load(ss))
        
        unsafe_load(ss) == 0 && break
        ss += sizeof(Cchar)
    end
    return h
end

function jhash(s::String)::Cuint
    h::Cuint = 0xDEADBEEF
    for i in s 
        h = h * Cuint(17) + Cuint(i)
    end
    return h * Cuint(17)
end

#static int subsumes in kernel/planner.c:53
function subsumes(a::Ptr{flags_t}, slvndx_a::Cuint, b::Ptr{flags_t})::Bool
    aa = unsafe_load(a)
    bb = unsafe_load(b)
    if slvndx_a != INFEASIBLE_SLVNDX
        @assert flag(aa, :t) == 0
        return LEQ(flag(aa, :u), flag(bb, :u)) && LEQ(flag(bb, :l), flag(aa, :l))
    else
        return LEQ(flag(aa, :l), flag(bb, :l)) && flag(aa, :t) <= flag(bb, :t)
    end
end

#static void invoke_hook in kernel/planner.c:397
function invoke_hook(ego::Ptr{planner}, pln::Ptr{plan}, p::Ptr{problem}, optimalp::Cint)::Void
    if unsafe_load(ego).hook != C_NULL
        ccall(unsafe_load(ego).hook, 
              Void, 
              (Ptr{planner}, Ptr{plan}, Ptr{problem}, Cint),
              ego, pln, p, optimalp)
    end
    return nothing
end

#unsigned X(random_estimate_seed) in kernel/planner.c:408
random_estimate_seed() = Cuint(0)

#static double random_estimate in kernel/planner.c:410
function random_estimate(ego::Ptr{planner}, pln::Ptr{plan}, p::Ptr{problem})::Cdouble
    m = newmd5()

    ccall(("fftw_md5begin", libfftw), 
          Void, 
          (Ptr{md5},), 
          m)
    ccall(("fftw_md5unsigned", libfftw), 
          Void, 
          (Ptr{md5}, Cuint), 
          m, random_estimate_seed())
    ccall(("fftw_md5int", libfftw), 
          Void, 
          (Ptr{md5}, Cint), 
          m, unsafe_load(ego).nthr)

    padt = unsafe_load(unsafe_load(reinterpret(Ptr{Ptr{problem_adt}}, p)))
#    ccall(unsafe_load(unsafe_load(p).super.adt).hash, 
    ccall(padt.hash, 
          Void, 
          (Ptr{problem}, Ptr{md5}),
          p, m)
    ccall(("fftw_md5putb", libfftw),
          Void,
          (Ptr{md5}, Ptr{Void}, Csize_t),
          m, unsafe_load(pln).ops, sizeof(opcnt)) #sizeof(pln.ops)
    ccall(("fftw_md5putb", libfftw),
          Void,
          (Ptr{md5}, Ptr{Void}, Csize_t),
          m, unsafe_load(pln).adt, sizeof(plan_adt)) #sizeof(pln.adt)
    ccall(("fftw_md5end", libfftw),
          Void,
          (Ptr{md5},),
          m)

end

#double X(iestimate_cost) in kernel/planner.c:426
function iestimate_cost(ego::Ptr{planner}, pln::Ptr{plan}, p::Ptr{problem})::Cdouble
    ops  = unsafe_load(pln).ops
    cost = ops.add + ops.mul + ops.fma + ops.other
#if !HAVE_FMA cost += ops.fma
    if unsafe_load(ego).cost_hook != C_NULL
        error("iestimate_cost: cost_hook not implemented yet")
    end
    
    return cost
end

#=
#macros in kernel/ifftw.h:669
PLNR_L(p::Ptr{planner})::Cuint = flag(unsafe_load(p).flags, :l)
PLNR_U(p::Ptr{planner})::Cuint = flag(unsafe_load(p).flags, :u)
PLNR_TIMELIMIT_IMPATIENCE(p::Ptr{planner})::Cuint = flag(unsafe_load(p).flags, :t)

#macros in kernel/ifftw.h:673
ESTIMATEP(p::Ptr{planner})::Cuint = PLNR_U(p) & ESTIMATE
BELIEVE_PCOSTP(p::Ptr{planner})::Cuint = PLNR_U(p) & BELIEVE_PCOST
ALLOW_PRUNING(p::Ptr{planner})::Cuint = PLNR_U(p) & ALLOW_PRUNING

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
NO_DESTROYINPUTP(p::Ptr{planner})::Cuint = PLNR_L(p) & NO_DESTROY_INPUT
NO_SIMDP(p::Ptr{planner})::Cuint = PLNR_L(p) & NO_SIMD
NO_CONSERVE_MEMORYP(p::Ptr{planner})::Cuint = PLNR_L(p) & NO_CONSERVE_MEMORY
NO_DHT_R2HCP(p::Ptr{planner})::Cuint = PLNR_L(p) & NO_DHT_R2HC
NO_BUFFERINGP(p::Ptr{planner})::Cuint = PLNR_L(p) & NO_BUFFERING
=#
#macro CHECK_FOR_BOGOSITY in kernel/planner.c:617
macro CHECK_FOR_BOGOSITY()
    quote
#    mpl = unsafe_load($(esc(ego)))
        mpl = unsafe_load(ego)
        if (mpl.bogosity_hook != C_NULL ?
            (mpl.wisdom_state = mpl.bogosity_hook(mpl.wisdom_state, p))
            : mpl.wisdom_state) == WISDOM_IS_BOGUS
            @goto wisdom_is_bogus
        end
    end
end

#macro FORALL_SOLVERS in kernel/ifftw.h:787
macro FORALL_SOLVERS(ego, s, p, what)
    quote
        for cnt=0:unsafe_load($(esc(ego))).nslvdesc - 1
            $(esc(p)) = unsafe_load($(esc(ego))).slvdescs + cnt * sizeof(slvdesc)
            $(esc(s)) = unsafe_load($(esc(p))).slv
            $(esc(what))
        end
    end
end

#macro FORALL_SOLVERS_OF_KIND in kernel/ifftw.h:797
macro FORALL_SOLVERS_OF_KIND(kind, ego, s, p, what)
    quote
        cnt = unsafe_load($(esc(ego))).slvdescs_for_problem_kind[$(esc(kind))]
        while cnt >= 0
            $(esc(p)) = unsafe_load($(esc(ego))).slvdescs + cnt * sizeof(slvdesc)
            $(esc(s)) = unsafe_load($(esc(p))).slv
            $(esc(what))
            cnt = $(esc(p)).next_for_same_problem_kind
        end
    end
end

#static void evaluate_plan in kernel/planner.c:444
#function evaluate_plan(ego::Ptr{planner}, pln::Ptr{plan_dft}, p::Ptr{problem_dft})::Void
function evaluate_plan(ego::Ptr{planner}, pln::Ptr{plan}, p::Ptr{problem})::Void
    if ESTIMATEP(ego) != 0 || BELIEVE_PCOSTP(ego) == 0 || unsafe_load(reinterpret(Ptr{plan}, pln)).pcost == 0.0
        #ego->nplan++
        #int nplan at 256 bytes in planner
        pt = reinterpret(Ptr{Cint}, ego + 256)
        unsafe_store!(pt, unsafe_load(ego).nplan + 1)

        if ESTIMATEP(ego) != 0
@label estimate
#ifdef FFTW_RANDOM_ESTIMATOR
#=            #pln->pcost = random_estimate(ego, pln, p)
            #double pcost at 40 bytes in plan
            cost = random_estimate(ego, pln, p)
            pt = reinterpret(Ptr{Cdouble}, pln + 40)
            unsafe_store!(pt, cost)

            #ego->epcost += X(iestimate_cost)(ego, pln, p)
            #double epcost at 272 bytes in planner
            cost = unsafe_load(ego).epcost + iestimate_cost(ego, pln, p)
            pt = reinterpret(Ptr{Cdouble}, ego + 272)
            unsafe_store!(pt, cost)=#
#else
            #pln->pcost = X(iestimate_cost)(ego, pln, p)
            #double pcost at 40 bytes in plan
            cost = iestimate_cost(ego, 
                                  reinterpret(Ptr{plan}, pln), 
                                  reinterpret(Ptr{problem}, p))
            pt = reinterpret(Ptr{Cdouble}, pln + 40)
            unsafe_store!(pt, cost)

            #ego->epcost += pln->pcost
            #double epcost at 272 bytes in planner
            cost = unsafe_load(ego).epcost + unsafe_load(reinterpret(Ptr{plan}, pln)).pcost
            pt = reinterpret(Ptr{Cdouble}, ego + 272)
            unsafe_store!(pt, cost)
#endif           
        else
            t = measure_execution_time(ego, pln, p)
            
            if t < 0 #unavailable cycle counter
                @goto estimate
            end

            #pln->pcost = t
            #double pcost at 40 bytes in plan
            pt = reinterpret(Ptr{Cdouble}, pln + 40)
            unsafe_store!(pt, t)

            #ego->pcost += t
            #double pcost at 264 bytes in planner
            pt = reinterpret(Ptr{Cdouble}, ego + 264)
            unsafe_store!(pt, t + unsafe_load(ego).pcost)

            #ego->need_timeout_check = 1
            #int need_timeout_check at 252 bytes in planner
            pt = reinterpret(Ptr{Cint}, ego + 252)
            unsafe_store!(pt, Cint(1))
        end
    end

    invoke_hook(ego, pln, p, Cint(0))
    return nothing
end

#static plan* invoke_solver in kernel/planner.c:477
#function invoke_solver(ego::Ptr{planner}, p::Ptr{problem_dft}, s::Ptr{solver}, nflags::Ptr{flags_t})::Ptr{plan_dft}
function invoke_solver(ego::Ptr{planner}, p::Ptr{problem}, s::Ptr{solver}, nflags::Ptr{flags_t})::Ptr{plan}
#    print_with_color(28,"invoke_solver: begin\n")

    flags = unsafe_load(ego).flags
    nthr = unsafe_load(ego).nthr

    #ego->flags = *nflags; PLNR_TIMELIMIT_IMPATIENCE(ego) = 0
    #flags_t flags at 216 bytes in planner
    pt = reinterpret(Ptr{flags_t}, ego + 216)
    unsafe_store!(pt, setflag(unsafe_load(nflags), :t, Cuint(0)))

#    @assert unsafe_load(unsafe_load(p).super.adt).problem_kind == unsafe_load(unsafe_load(s).adt).problem_kind
    padt = unsafe_load(unsafe_load(reinterpret(Ptr{Ptr{problem_adt}}, p)))
    sadt = unsafe_load(unsafe_load(reinterpret(Ptr{Ptr{solver_adt}}, s)))
    @assert padt.problem_kind == sadt.problem_kind

#    pln = unsafe_load(unsafe_load(s).adt).mkplan(s, p, ego)
    pt = reinterpret(Ptr{Ptr{solver_adt}}, s)
    fmkplan = unsafe_load(unsafe_load(pt)).mkplan
#    fmkplan = unsafe_load(unsafe_load(s).adt).mkplan
    pln = ccall(fmkplan, Ptr{plan_dft}, 
                (Ptr{solver}, Ptr{problem_dft}, Ptr{planner}),
                s, p, ego)

    

    #ego->nthr = nthr
    #int nthr at 208 bytes in planner
    pt = reinterpret(Ptr{Cint}, ego + 208)
    unsafe_store!(pt, nthr)

    #ego->flags = flags
    #flags_t flags at 216 bytes in planner
    pt = reinterpret(Ptr{flags_t}, ego + 216)
    unsafe_store!(pt, flags)
    
#    print_with_color(28,"invoke_solver: end\n")
    return pln
end
    

#static void md5hash in planner.c:170
#function md5hash(m::Ptr{md5}, p::Ptr{problem_dft}, plnr::Ptr{planner})::Void
function md5hash(m::Ptr{md5}, p::Ptr{problem}, plnr::Ptr{planner})::Void
    ccall(("fftw_md5begin", libfftw), 
          Void, 
          (Ptr{md5},), 
          m)
    ccall(("fftw_md5unsigned", libfftw), 
          Void, 
          (Ptr{md5}, Cuint), 
          m, sizeof(Cdouble))
    ccall(("fftw_md5int", libfftw), 
          Void, 
          (Ptr{md5}, Cint), 
          m, unsafe_load(plnr).nthr)
    padt = unsafe_load(unsafe_load(reinterpret(Ptr{Ptr{problem_adt}}, p)))
#    ccall(unsafe_load(unsafe_load(p).super.adt).hash, 
    ccall(padt.hash, 
          Void, 
#          (Ptr{problem_dft}, Ptr{md5}),
          (Ptr{problem}, Ptr{md5}),
          p, m)
    ccall(("fftw_md5end", libfftw),
          Void,
          (Ptr{md5},),
          m)
    return nothing
end

#static void signature_of_configuration in kernel/planner.c:138
function signature_of_configuration(m::Ptr{md5}, ego::Ptr{planner})::Void
     ccall(("fftw_md5begin", libfftw), 
          Void, 
          (Ptr{md5},), 
          m)
     ccall(("fftw_md5unsigned", libfftw), 
          Void, 
          (Ptr{md5}, Cuint), 
          m, sizeof(Cdouble))
     @FORALL_SOLVERS(ego, s, sp, begin
          ccall(("fftw_md5int", libfftw), 
               Void, 
               (Ptr{md5}, Cint), 
               m, unsafe_load(sp).reg_id)
          ccall(("fftw_md5puts", libfftw), 
               Void, 
               (Ptr{md5}, Ptr{Cchar}), 
               m, unsafe_load(sp).reg_nam)
     end)

#=    for i = 1:unsafe_load(ego).nslvdesc
        p = unsafe_load(ego).slvdescs + (i-1)*sizeof(slvdesc)
        s = unsafe_load(p).slv
        ccall(("fftw_md5int", libfftw), 
             Void, 
             (Ptr{md5}, Cint), 
             m, unsafe_load(sp).reg_id)
        ccall(("fftw_md5puts", libfftw), 
             Void, 
             (Ptr{md5}, Ptr{Cchar}), 
             m, unsafe_load(sp).reg_nam)
    end=#

    ccall(("fftw_md5end", libfftw),
          Void,
          (Ptr{md5},),
          m)
    return nothing
end

#static void check in planner.c:995
function check(ht::Ptr{hashtab})::Void
#    print_with_color(199,"check: hashtab:\n")
#    show(unsafe_load(ht))

    live = Cuint(0)

#    nelem = unsafe_load(ht).nelem
#    hashsiz = unsafe_load(ht).hashsiz
    #nelem at 12 bytes in hashtab
    pt = reinterpret(Ptr{Cuint}, ht + 12)
    nelem = unsafe_load(pt)
#    print_with_color(199,"nelem: $(unsafe_load(ht).nelem) = $nelem\n")
#    print_with_color(199,"nelem: $(bits(unsafe_load(ht).nelem)) = $(bits(nelem))\n")
    #hashsiz at 8 bytes in hashtab
    pt = reinterpret(Ptr{Cuint}, ht + 8)
    hashsiz = unsafe_load(pt)
#    print_with_color(199,"hashsiz: $(unsafe_load(ht).hashsiz) = $hashsiz\n")
#    print_with_color(199,"hashsiz: $(bits(unsafe_load(ht).hashsiz)) = $(bits(hashsiz))\n")
#    print_with_color(199,"$(typeof(nelem)) $nelem < $(typeof(hashsiz)) $hashsiz\n")
#    print_with_color(199,"nelem: $nelem = $(bits(nelem)), hashsiz: $hashsiz = $(bits(hashsiz))\n")
#    @assert nelem < hashsiz
    
#    print_with_color(199,"$(typeof(unsafe_load(ht).nelem)) nelem = $(unsafe_load(ht).nelem), $(typeof(unsafe_load(ht).hashsiz)) hashsiz = $(unsafe_load(ht).hashsiz), $(unsafe_load(ht).nelem < unsafe_load(ht).hashsiz), $(nelem < hashsiz), $(isless(nelem, hashsiz))\n")
    @assert unsafe_load(ht).nelem < unsafe_load(ht).hashsiz "nelem ≮ hashsiz: $(unsafe_load(ht).nelem) ≮ $(unsafe_load(ht).hashsiz)"

    for i = 1:unsafe_load(ht).hashsiz
        l = unsafe_load(ht).solutions + (i-1) * sizeof(solution)
        if LIVEP(l) != 0
#            show(unsafe_load(l).flags)
            live += 1
        end
    end

#    print_with_color(199,"live = $live, ht.nelem = $(unsafe_load(ht).nelem)\n")
    @assert unsafe_load(ht).nelem == live "nelem != live: $(unsafe_load(ht).nelem) != $live"

    for i = 1:unsafe_load(ht).hashsiz
        l1 = unsafe_load(ht).solutions + (i-1) * sizeof(solution)
        foundit = 0
        if LIVEP(l1) != 0
            h = h1(ht, unsafe_load(l1).s)
            d = h2(ht, unsafe_load(l1).s)
            g = h
            while true
                l = unsafe_load(ht).solutions + g * sizeof(solution)
                if VALIDP(l) != 0
                    if l1 == l
                        foundit = 1
                    elseif LIVEP(l) != 0 && unsafe_load(l1).s == unsafe_load(l).s
#                        @assert !subsumes(unsafe_load(l).flags, SLVNDX(l), unsafe_load(l1).flags)
#                        @assert !subsumes(unsafe_load(l1).flags, SLVNDX(l1), unsafe_load(l).flags)
                        #flags_t flags at 16 bytes in solution
                        lflgp  = reinterpret(Ptr{flags_t}, l + 16)
                        l1flgp = reinterpret(Ptr{flags_t}, l1 + 16)
                        @assert !subsumes(lflgp, SLVNDX(l), l1flgp) "lflgp:\n$(show(unsafe_load(lflgp)))\nl1flgp:\n$(show(unsafe_load(l1flgp)))"
                        @assert !subsumes(l1flgp, SLVNDX(l1), lflgp) "l1flgp:\n$(show(unsafe_load(l1flgp)))\nlflgp:\n$(show(unsafe_load(lflgp)))"

                    end
                else
                    break
                end
                g = addmod(g, d, unsafe_load(ht).hashsiz)
                g == h && break
            end
            @assert foundit != 0
        end
    end
end



#static unsigned h1 in kernel/planner.c:155
function h1(ht::Ptr{hashtab}, s::md5sig)::Cuint
    h = s[1] % unsafe_load(ht).hashsiz
    @assert h == s[1] % unsafe_load(ht).hashsiz
    return h
end

#static unsigned h2 in kernel/planner.c:163
function h2(ht::Ptr{hashtab}, s::md5sig)::Cuint
    h = Cuint(1) + s[2] % (unsafe_load(ht).hashsiz - 1)
    @assert h == 1 + s[2] % (unsafe_load(ht).hashsiz - 1)
    return h
end

#static unsigned minsz in kernel/planner.c:320
function minsz(nelem::Cuint)::Cuint
#    return Cuint(div(1 + nelem + nelem, 8))
    return Cuint(1 + nelem + div(nelem, 8))
end

#static unsigned nextsz in kernel/planner.c:325
function nextsz(nelem::Cuint)::Cuint
    return minsz(minsz(nelem))
end

#INT X(next_prime) in kernel/primes.c:144
function next_prime(n::Integer)::Cint
    while !isprime(n)
        n += 1
    end
    return n
end

#static void fill_slot in kernel/planner.c:247
function fill_slot(ht::Ptr{hashtab}, s::md5sig, flagsp::Ptr{flags_t}, slvndx::Cuint, slot::Ptr{solution})::Void
#    print_with_color(177,"fill_slot: begin\n")
#    print_with_color(177,"fill_slot: hashtab:\n")
#    show(unsafe_load(ht))

    #insert at 28 bytes in hashtab
    pt = reinterpret(Ptr{Cint}, ht + 28)
    unsafe_store!(pt, unsafe_load(ht).insert + 1)
    #nelem at 12 bytes in hashtab
    pt = reinterpret(Ptr{Cuint}, ht + 12)
    unsafe_store!(pt, unsafe_load(ht).nelem + 1)

#    print_with_color(177,"fill_slot: nelem after: $(unsafe_load(ht).nelem)\n")
    
    @assert LIVEP(slot) == 0
    u = flag(unsafe_load(flagsp), :u)
    l = flag(unsafe_load(flagsp), :l)
    t = flag(unsafe_load(flagsp), :t)
    h = flag(unsafe_load(flagsp), :h) | H_VALID | H_LIVE
    #flags at 16 bytes in solution
    pt = reinterpret(Ptr{flags_t}, slot + 16)
    unsafe_store!(pt, flags_t(l,h,t,u,slvndx))
#    print_with_color(177,"fill_slot: new flags\n")

#    show(unsafe_load(slot))

    @assert SLVNDX(slot) == slvndx
    
    for i=1:4
        pt = reinterpret(Ptr{md5uint}, slot + (i-1) * sizeof(md5uint))
        unsafe_store!(pt, s[i])
    end
#    print_with_color(177,"fill_slot: end\n")
    return nothing
end

#static void kill_slot in kernel/planner.c:265
function kill_slot(ht::Ptr{hashtab}, slot::Ptr{solution})::Void
    @assert LIVEP(slot) != 0
    @assert VALIDP(slot) != 0

    #nelem at 12 bytes in hashtab
    pt = reinterpret(Ptr{Cuint}, ht + 12)
    unsafe_store!(pt, unsafe_load(ht).nelem - 1)

    ff = setflag(unsafe_load(slot).flags, :h, H_VALID)
    #flags at 16 bytes in solution
    pt = reinterpret(Ptr{flags_t}, slot + 16)
    unsafe_store!(pt, ff)

    return nothing
end


#static void hinsert0 in kernel/planner.c:273
function hinsert0(ht::Ptr{hashtab}, s::md5sig, flagsp::Ptr{flags_t}, slvndx::Cuint)::Void
#    print_with_color(37,"hinsert0: begin\n")
    h = h1(ht, s)
    d = h2(ht, s)

    local l::Ptr{solution}

    #++ht->insert_unknown
    #int insert_unknown at 36 bytes in hashtab
    pt = reinterpret(Ptr{Cint}, ht + 36)
    unsafe_store!(pt, unsafe_load(ht).insert_unknown + 1)

    #search for nonfull slot
    g = h
    while true
        #++ht->insert_iter
        #int insert_iter at 32 bytes in hashtab
        pt = reinterpret(Ptr{Cint}, ht + 32)
        unsafe_store!(pt, unsafe_load(ht).insert_iter + 1)

        l = unsafe_load(ht).solutions + g*sizeof(solution)
        if LIVEP(l) == 0 
            break
        end
        g = addmod(g, d, unsafe_load(ht).hashsiz)
        @assert (g + d) % unsafe_load(ht).hashsiz != h
    end

#    print_with_color(37,"hinsert0: before fill_slot\n")
#    show(unsafe_load(ht))
#    print_with_color(37,"hinsert0: nelem before: $(unsafe_load(ht).nelem)\n")

    fill_slot(ht, s, flagsp, slvndx, l)

#    print_with_color(37,"hinsert0: after fill_slot\n")
#    show(unsafe_load(ht))
#    print_with_color(37,"hinsert0: nelem after: $(unsafe_load(ht).nelem)\n")
#    print_with_color(37,"hinsert0: end\n")
    return nothing
end

#static void rehash in kernel/planner.c:292
function rehash(ht::Ptr{hashtab}, nsz::Cuint)
    osiz = unsafe_load(ht).hashsiz
    osol = unsafe_load(ht).solutions

    nsiz = next_prime(nsz)
    nsol = Ptr{solution}(malloc(nsiz*sizeof(solution)))

    #++ht->nrehash
    #nrehash at 40 bytes in hashtab
    pt = reinterpret(Ptr{Cint}, ht + 40)
    unsafe_store!(pt, unsafe_load(ht).nrehash + 1)

    for h = 0:nsiz-1
        #nsol[h].flags.hash_info = 0
        #flags at 16 bytes in solution
        pt = reinterpret(Ptr{flags_t}, nsol + 16 + h*sizeof(solution))
        ff = unsafe_load(nsol + h * sizeof(solution)).flags
#        unsafe_store!(pt, setflag(ff, :h, 0))
#TMP
        unsafe_store!(pt, flags_t(0,0,0,0,0))
        for i=0:3
            pt = reinterpret(Ptr{Cuint}, nsol + h*sizeof(solution) + i*sizeof(Cuint))
            unsafe_store!(pt, Cuint(0))
        end
    end

    #ht->hashsiz = nsiz
    #hashsiz at 8 bytes in hashtab
    pt = reinterpret(Ptr{Cuint}, ht + 8)
    unsafe_store!(pt, nsiz)

    #ht->solutions = nsol
    #solutions at 0 bytes in hashtab
    pt = reinterpret(Ptr{Ptr{solution}}, ht)
    unsafe_store!(pt, nsol)

    #ht->nelem = 0
    #nelem at 12 bytes in hashtab
    pt = reinterpret(Ptr{Cuint}, ht + 12)
    unsafe_store!(pt, Cuint(0))

    for h = 0:osiz-1
        l = osol + h*sizeof(solution)
        if LIVEP(l) != 0
#            print_with_color(39,"rehash: solution $(h+1) of $osiz:\n")
#            show(unsafe_load(l))
            #flags at 16 bytes in solution
            pt = reinterpret(Ptr{flags_t}, l + 16)
            hinsert0(ht, unsafe_load(l).s, pt, SLVNDX(l))
        end
    end
    free(osol)
    return nothing
end

#static void hgrow in kernel/planner.c:330
function hgrow(ht::Ptr{hashtab})::Void
    nelem = unsafe_load(ht).nelem
    if minsz(nelem) >= unsafe_load(ht).hashsiz
        rehash(ht, nextsz(nelem))
    end
    return nothing
end

#static void htab_insert in kernel/planner.c:347
function htab_insert(ht::Ptr{hashtab}, s::md5sig, flagsp::Ptr{flags_t}, slvndx::Cuint)::Void
#    print_with_color(148,"htab_insert: begin\n")
    h = h1(ht, s)
    d = h2(ht, s)

    first = reinterpret(Ptr{solution}, C_NULL)

    #remove all entries subsumed by new one
    #loop may traverse entire table: at least one guaranteed !LIVEP
    #but all may be VALIDP -- stop at first invalid element or after
    #traversing entire table

    g = h
    while true
        l = unsafe_load(ht).solutions + g*sizeof(solution)

        #++ht->insert_iter
        #int insert_iter at 32 bytes in hashtab
        pt = reinterpret(Ptr{Cint}, ht + 32)
        unsafe_store!(pt, unsafe_load(ht).insert_iter + 1)

        if VALIDP(l) != 0
#            print_with_color(148,"htab_insert: valid solution:\n")
#            show(unsafe_load(l))
            if LIVEP(l) != 0 && s == unsafe_load(l).s
#                print_with_color(148,"htab_insert: live solution:\n")
#                show(unsafe_load(l))
                #flags_t flags at 16 bytes in solution
                ff = reinterpret(Ptr{flags_t}, l + 16)
                if subsumes(flagsp, slvndx, ff)
                    if first == C_NULL
                        first = l
                    end
                    kill_slot(ht, l)
                else
                    #error to insert element subsumed by existing entry
                    @assert !subsumes(ff, SLVNDX(l), flagsp)
                end
            end
        else
#            print_with_color(148,"htab_insert: invalid solution:\n")
#            show(unsafe_load(l))
            break
        end
        g = addmod(g, d, unsafe_load(ht).hashsiz)
        g == h || break
    end

    if first != C_NULL
#        print_with_color(148,"htab_insert: first not null, filling slot\n")
        fill_slot(ht, s, flagsp, slvndx, first)
    else
#        print_with_color(148,"htab_insert: first null, growing hashtab\n")
        hgrow(ht)
        hinsert0(ht, s, flagsp, slvndx)
    end
#    print_with_color(148,"htab_insert: end\n")
    return nothing
end

#static void hinsert in kernel/planner.c:389
function hinsert(ego::Ptr{planner}, s::md5sig, flagsp::Ptr{flags_t}, slvndx::Cuint)::Void
#    print_with_color(74,"hinsert: begin\n")
    if BLISS(unsafe_load(flagsp)) != 0
#        print_with_color(74,"hinsert: insert in htab_blessed\n")
        #htab_blessed at 112 bytes in planner
        ht = reinterpret(Ptr{hashtab}, ego + 112)
    else
#        print_with_color(74,"hinsert: insert in htab_unblessed\n")
        #htab_unblessed at 160 bytes in planner
        ht = reinterpret(Ptr{hashtab}, ego + 160)
    end

    htab_insert(ht, s, flagsp, slvndx)
#    print_with_color(74,"hinsert: end\n")
    return nothing
end

#static void mkhashtab in kernel/planner.c:756
function mkhashtab(ht::Ptr{hashtab})::Void
#    print_with_color(184,"mkhashtab: begin\n")
    #solutions at 0 bytes in hashtab
    pt = reinterpret(Ptr{Ptr{solution}}, ht)
    unsafe_store!(pt, reinterpret(Ptr{solution}, C_NULL))
    #hashsiz at 8 bytes in hashtab
    pt = reinterpret(Ptr{Cuint}, ht + 8)
    unsafe_store!(pt, Cuint(0))
    #nelem at 12 bytes in hashtab
    pt = reinterpret(Ptr{Cuint}, ht + 12)
    unsafe_store!(pt, Cuint(0))
    #lookup at 16 bytes in hashtab
    pt = reinterpret(Ptr{Cint}, ht + 16)
    unsafe_store!(pt, Cint(0))
    #succ_lookup at 20 bytes in hashtab
    pt = reinterpret(Ptr{Cint}, ht + 20)
    unsafe_store!(pt, Cint(0))
    #lookup_iter at 24 bytes in hashtab
    pt = reinterpret(Ptr{Cint}, ht + 24)
    unsafe_store!(pt, Cint(0))
    #insert at 28 bytes in hashtab
    pt = reinterpret(Ptr{Cint}, ht + 28)
    unsafe_store!(pt, Cint(0))
    #insert_iter at 32 bytes in hashtab
    pt = reinterpret(Ptr{Cint}, ht + 32)
    unsafe_store!(pt, Cint(0))
    #insert_unknown at 36 bytes in hashtab
    pt = reinterpret(Ptr{Cint}, ht + 36)
    unsafe_store!(pt, Cint(0))
    #nrehash at 40 bytes in hashtab
    pt = reinterpret(Ptr{Cint}, ht + 40)
    unsafe_store!(pt, Cint(0))
#    print_with_color(184,"mkhashtab: before grow\n")
#    show(unsafe_load(ht))
    hgrow(ht)

#    print_with_color(184,"mkhashtab: after grow\n")
#    show(unsafe_load(ht))
    check(ht)

    return nothing
end

#static void htab_destroy in planner.c:749
function htab_destroy(ht::Ptr{hashtab})
    free(unsafe_load(ht).solutions)
    #Ptr{solution} solutions at 0 bytes in hashtab
    pt = reinterpret(Ptr{Ptr{solution}}, ht)
    unsafe_store!(pt, Ptr{solution}(C_NULL))
    #Cuint nelem at 12 bytes in hashtab
    pt = reinterpret(Ptr{Cuint}, ht + 12)
    unsafe_store!(pt, Cuint(0))
    return nothing
end

#static void forget in planner.c:769
function forget(ego::Ptr{planner}, a::amnesia)::Void
    if a == FORGET_EVERYTHING
        #htab_blessed at 112 bytes in planner
        pt = reinterpret(Ptr{hashtab}, ego + 112)
        htab_destroy(pt)
        mkhashtab(pt)
    elseif a != FORGET_ACCURSED
        error("planner.forget: invalid amnesia $a")
    end
    #fall through and FORGET_ACCURSED regardless
    #htab_unblessed at 160 bytes in planner
    pt = reinterpret(Ptr{hashtab}, ego + 160)
    htab_destroy(pt)
    mkhashtab(pt)
    return nothing
end

#static solution* htab_lookup in planner.c:203
function htab_lookup(ht::Ptr{hashtab}, s::md5sig, flagsp::Ptr{flags_t})::Ptr{solution}
#    print_with_color(70,"begin htab_lookup\n")
    println(unsafe_load(reinterpret(Ptr{Ptr{solution}}, ht)))
    h = h1(ht, s)
    d = h2(ht, s)
    best = Ptr{solution}(C_NULL)

    #++ht->lookup
    #int lookup at 16 bytes in hashtab
    pt = reinterpret(Ptr{Cint}, ht + 16)
    unsafe_store!(pt, unsafe_load(pt) + 1)

#    print_with_color(70,"ht:\n")
#    show(unsafe_load(ht))

    #search all matching entries and select one with lowest flags.u
    #stop at first invalid element or after traversing whole table
    g = h
#    print_with_color(70,"htab_lookup: h=$h, d=$d\n")
#    print_with_color(70,"htab_lookup: begin while\n")
    while true
#        l = unsafe_load(reinterpret(Ptr{Ptr{solution}}, ht), g+1)
        l = unsafe_load(ht).solutions + g * sizeof(solution)
#        print_with_color(70,"flagsp:\n")
#        show(unsafe_load(flagsp))
#        print_with_color(70,"l flags:\n")
#        show(unsafe_load(reinterpret(Ptr{flags_t}, l + 16)))
#        print_with_color(70,"htab_lookup: solution l\n")
#        show(unsafe_load(l))
        #lookup_iter at 24 bytes in hashtab
        pt = reinterpret(Ptr{Cint}, ht + 24)
        unsafe_store!(pt, unsafe_load(pt) + 1)
        if VALIDP(l) != 0
#            print_with_color(70,"htab_lookup: valid l\n")
            if (LIVEP(l) != 0
              && s == unsafe_load(l).s
              #flags at 16 bytes in solution
              &&subsumes(reinterpret(Ptr{flags_t},l + 16), SLVNDX(l), flagsp))
#                print_with_color(70,"htab_lookup: live l\n")
                if (best == C_NULL 
                  || LEQ(flag(unsafe_load(l).flags, :u), 
                  flag(unsafe_load(best).flags, :u)))
#                    print_with_color(70,"htab_lookup: setting best\n")
                    best = l
                end
            end
        else
#            print_with_color(70,"htab_lookup: breaking at invalid l\n")
            break
        end

        g = addmod(g, d, unsafe_load(ht).hashsiz)
        g == h && break
    end

    if best != C_NULL
#        print_with_color(70,"htab_lookup: found best\n")
        #succ_lookup at 20 bytes in hashtab
        pt = reinterpret(Ptr{Cint}, ht + 20)
        unsafe_store!(pt, unsafe_load(pt) + 1)
    end

#    print_with_color(70,"end htab_lookup\n")
    return best
end

#static solution* hlookup in planner.c:239
function hlookup(ego::Ptr{planner}, s::md5sig, flagsp::Ptr{flags_t})::Ptr{solution}
#    print_with_color(202,"begin hlookup\n")
#    print_with_color(202,"hlookup: md5sig: $s\n")
#    print_with_color(202,"hlookup: flagsp:\n")
#    show(unsafe_load(flagsp))

    #htab_blessed at 112 bytes in planner
    pt = reinterpret(Ptr{hashtab}, ego + 112)
#    print_with_color(202,"hlookup: htab_blessed:\n")
#    show(unsafe_load(pt))
    sol = htab_lookup(pt, s, flagsp)
    if sol == C_NULL
#        print_with_color(202,"hlookup: null solution, try unblessed\n")
        #htab_unblessed at 160 bytes in planner
        pt = reinterpret(Ptr{hashtab}, ego + 160)
        sol = htab_lookup(pt, s, flagsp)
    end
#    print_with_color(202,"end hlookup\n")
    return sol
end

#X(solver_use) in kernel/solver.c:33
function solver_use(ego::Ptr{solver})::Void
    #ego.refcnt += 1
    rc = unsafe_load(ego).refcnt + 1
    #int refcnt at 8 bytes in solver
    pt = reinterpret(Ptr{Cint}, ego + 8)
    unsafe_store!(pt, rc)
    return nothing
end

#static void sgrow in kernel/planner.c:80
function sgrow(ego::Ptr{planner})::Void
    plnr = unsafe_load(ego)
    osiz = plnr.slvdescsiz
    nsiz = 1 + osiz + div(osiz, 4)
    ntab = Ptr{slvdesc}(malloc(nsiz*sizeof(slvdesc)))
    otab = plnr.slvdescs

    #ego->slvdescs = ntab
    #slvdesc* slvdescs at 48 bytes in planner
    pt = reinterpret(Ptr{Ptr{slvdesc}}, ego + 48)
    unsafe_store!(pt, ntab)

    #ego->slvdescsiz = nsiz
    #unsigned slvdescsiz at 60 bytes in planner
    pt = reinterpret(Ptr{Cuint}, ego + 60)
    unsafe_store!(pt, nsiz)

    for i=1:osiz
        pt = ntab + (i-1)*sizeof(slvdesc)
        unsafe_store!(pt, unsafe_load(otab, i))
    end
    free(otab)

    return nothing
end

#static void register_solver in kernel/planner.c:94
function register_solver(ego::Ptr{planner}, s::Ptr{solver})
    if s != C_NULL
        plnr = unsafe_load(ego)
        solver_use(s)
        @assert plnr.nslvdesc < INFEASIBLE_SLVNDX
        if plnr.nslvdesc >= plnr.slvdescsiz
            sgrow(ego)
        end

        n = unsafe_load(ego).slvdescs + unsafe_load(ego).nslvdesc*sizeof(slvdesc)

        #n->slv = s
        #solver* slv at 0 bytes in slvdesc
        pt = reinterpret(Ptr{Ptr{solver}}, n)
        unsafe_store!(pt, s)

        #n->reg_nam = ego->cur_reg_nam
        #char* reg_nam at 8 bytes in slvdesc
        pt = reinterpret(Ptr{Ptr{Cchar}}, n + 8)
        unsafe_store!(pt, unsafe_load(ego).cur_reg_nam)

        #  n->reg_id = ego->cur_reg_id++
        # →n->reg_id = ego->cur_reg_id; ego->cur_reg_id = ego_cur_reg_id + 1;
        #int reg_id at 20 bytes in slvdesc
        pt = reinterpret(Ptr{Cint}, n + 20)
        unsafe_store!(pt, unsafe_load(ego).cur_reg_id)
        #int cur_reg_id at 72 bytes in planner
        pt = reinterpret(Ptr{Cint}, ego + 72)
        unsafe_store!(pt, unsafe_load(ego).cur_reg_id + 1)

        @assert length(unsafe_wrap(String, unsafe_load(n).reg_nam)) < MAXNAM

        #n->nam_hash = X(hash)(n->reg_nam)
        #nam_hash at 16 bytes in slvdesc
        pt = reinterpret(Ptr{Cuint}, n + 16)
        unsafe_store!(pt, jhash(unsafe_load(n).reg_nam))

        kind = Cint(unsafe_load(unsafe_load(s).adt).problem_kind)
        #n->next_for_same_problem_kind = ego->slvdescs_for_problem_kind[kind]
        #next_for_same_problem_kind at 24 bytes in slvdesc
        pt = reinterpret(Ptr{Cint}, n + 24)
        unsafe_store!(pt, unsafe_load(ego).slvdescs_for_problem_kind[kind + 1])

        #ego->slvdescs_for_problem_kind[kind] = (int)ego->nslvdesc
        #slvdescs_for_problem_kind at 76 bytes in planner
        pt = reinterpret(Ptr{Cint}, ego + 76 + kind * sizeof(Cint))
        unsafe_store!(pt, Cint(unsafe_load(ego).nslvdesc))

        #ego->nslvdesc++
        #nslvdesc at 56 bytes in planner
        pt = reinterpret(Ptr{Cuint}, ego + 56)
        unsafe_store!(pt, unsafe_load(ego).nslvdesc + 1)
    end
    return nothing
end

#double X(elapsed_since) in kernel/timer.c:101
function elapsed_since(plnr::Ptr{planner}, p::Ptr{problem}, t0::crude_time)::Cdouble
    return ccall((fftw_elapsed_since, libfftw), 
                 Cdouble, 
                 (Ptr{planner}, Ptr{problem}, crude_time), 
                 plnr, p, t0)
end

#static int timeout_p in kernel/planner.c:493
#function timeout_p(ego::Ptr{planner}, p::Ptr{problem_dft})
function timeout_p(ego::Ptr{planner}, p::Ptr{problem})
    if ESTIMATEP(ego) == 0
        if unsafe_load(ego).timed_out
            @assert unsafe_load(ego).need_timeout_check != 0
            return 1
        end
        plnr = unsafe_load(ego)
        if plnr.timelimit >= 0 && 
                    elapsed_since(ego, p, plnr.start_time) >= plnr.timelimit
            #timed_out at 248 bytes in planner
            pt = reinterpret(Ptr{Cint}, ego + 248)
            unsafe_store!(pt, 1)
            #need_timeout_check at 252 bytes in planner
            pt = reinterpret(Ptr{Cint}, ego + 252)
            unsafe_store!(pt, 1)
            return 1
        end
    end

    @assert unsafe_load(ego).timed_out == 0
    #need_timeout_check at 252 bytes in planner
    pt = reinterpret(Ptr{Cint}, ego + 252)
    unsafe_store!(pt, 0)
    return 0
end

#static plan* search0 in kernel/planner.c:518
#function search0(ego::Ptr{planner}, p::Ptr{problem_dft}, slvndx::Ptr{Cuint}, flagsp::Ptr{flags_t})::Ptr{plan}
function search0(ego::Ptr{planner}, p::Ptr{problem}, slvndx::Ptr{Cuint}, flagsp::Ptr{flags_t})::Ptr{plan}
#    print_with_color(162,"search0: begin\n")
#    print_with_color(162,"search0: htab_blessed at begin:\n")
#    show(unsafe_load(ego).htab_blessed)
#    print_with_color(162,"search0: htab_unblessed at begin:\n")
#    show(unsafe_load(ego).htab_unblessed)

    best = convert(Ptr{plan}, C_NULL)
    pln  = convert(Ptr{plan}, C_NULL)
    best_not_yet_timed = Cint(1)

    #do not start search if planner timed out
    #relaxation triggers otherwise
    if timeout_p(ego, p) != 0
        return C_NULL
    end

#try without macro
    padt = unsafe_load(unsafe_load(reinterpret(Ptr{Ptr{problem_adt}}, p)))
    kind = Cint(padt.problem_kind)
#    kind = Cint(unsafe_load(unsafe_load(p).super.adt).problem_kind)
    cnt = unsafe_load(ego).slvdescs_for_problem_kind[kind+1]

#    print_with_color(162,"search0: FORALL_SOLVERS_OF_KIND $kind\n")
    while cnt >= 0
#        print_with_color(162,"search0: cnt: $cnt\n")
        sp = unsafe_load(ego).slvdescs + cnt * sizeof(slvdesc)
        s = unsafe_load(sp).slv
        nam = unsafe_wrap(String, unsafe_load(sp).reg_nam)
#        print_with_color(162,"search0: invoking solver $nam\n")
        pln = invoke_solver(ego, p, s, flagsp)

        if unsafe_load(ego).need_timeout_check != 0
            if timeout_p(ego, p) != 0
                plan_destroy_internal(pln)
                plan_destroy_internal(best)
#                print_with_color(162,"search0: timed out, returning null plan")
                return C_NULL
            end
        end

        if pln != C_NULL
#            print_with_color(162,"search0: obtained plan\n")
            #pln may be destroyed so read could_prune_now_pp now
            could_prune_now_p = unsafe_load(reinterpret(Ptr{plan}, pln)).could_prune_now_p
#            could_prune_now_p = unsafe_load(pln).could_prune_now_p

            if best != C_NULL
                if best_not_yet_timed != 0
                    evaluate_plan(ego, best, p)
                    best_not_yet_timed = 0
                end

                evaluate_plan(ego, pln, p)
                if unsafe_load(pln).pcost < unsafe_load(best).pcost

                    plan_destroy_internal(best)
                    best = pln
                    unsafe_store!(slvndx, div(Cuint(sp - unsafe_load(ego).slvdescs), sizeof(slvdesc)))
#                    print_with_color(162,"search0: new best plan at slvndx $(unsafe_load(slvndx))\n")
                else
#                    print_with_color(162,"search0: new plan at slvndx $(unsafe_load(slvndx)) not better, destroying\n")
                    plan_destroy_internal(pln)
                end
            else
                best = pln
                unsafe_store!(slvndx, div(Cuint(sp - unsafe_load(ego).slvdescs), sizeof(slvdesc)))
#                print_with_color(162,"search0: best plan null, new best at slvndx $(unsafe_load(slvndx))\n")
            end

            if ALLOW_PRUNINGP(ego) != 0 && could_prune_now_p != 0
                print_with_color(162,"search0: pruning\n")
                break
            end
        end
        cnt = unsafe_load(sp).next_for_same_problem_kind
    end
#    print_with_color(162,"search0: end loop\n")
#end FORALL_SOLVERS_OF_KIND

#=    @FORALL_SOLVERS_OF_KIND(unsafe_load(unsafe_load(p).super.adt).problem_kind,
                            ego,
                            s,
                            sp,
                            begin
        pln = invoke_solver(ego, p, s, flagsp)

        if unsafe_load(ego).need_timeout_check != 0
            if timeout_p(ego, p) != 0
                plan_destroy_internal(pln)
                plan_destroy_internal(best)
                return C_NULL
            end
        end

        if pln != C_NULL
            #pln may be destroyed so read could_prune_now_pp now
            could_prune_now_p = unsafe_load(pln).could_prune_now_p

            if best != C_NULL
                if best_not_yet_timed != 0
                    evaluate_plan(ego, best, p)
                    best_not_yet_timed = 0
                end

                evaluate_plan(ego, pln, p)
                if unsafe_load(pln).pcost < unsafe_load(best).pcost
                    plan_destroy_internal(best)
                    best = pln
                    unsafe_store!(slvndx, div(Cuint(sp - unsafe_load(ego).slvdescs), sizeof(slvdesc)))
                else
                    plan_destroy_internal(pln)
                end
            else
                best = pln
                unsafe_store!(slvndx, div(Cuint(sp - unsafe_load(ego).slvdescs), sizeof(slvdesc)))
            end

            if ALLOW_PRUNINGP(ego) && could_prune_now_p != 0
                break
            end
        end
        end)=#
#    print_with_color(162,"search0: htab_blessed at end:\n")
#    show(unsafe_load(ego).htab_blessed)
#    print_with_color(162,"search0: htab_unblessed at end:\n")
#    show(unsafe_load(ego).htab_unblessed)

#    print_with_color(162,"search0: end\n")
    return best
end

#static plan* search in kernel/planner.c:572
#function search(ego::Ptr{planner}, p::Ptr{problem_dft}, slvndx::Ptr{Cuint}, flagsp::Ptr{flags_t})::Ptr{plan}
function search(ego::Ptr{planner}, p::Ptr{problem}, slvndx::Ptr{Cuint}, flagsp::Ptr{flags_t})::Ptr{plan}
#    print_with_color(123,"search: begin\n")
#    print_with_color(123,"search: flagsp:\n")
#    show(unsafe_load(flagsp))
#    print_with_color(123,"search: htab_blessed at begin:\n")
#    show(unsafe_load(ego).htab_blessed)
#    print_with_color(123,"search: htab_unblessed at begin:\n")
#    show(unsafe_load(ego).htab_unblessed)

    pln = Ptr{plan}(C_NULL)
    #relax patience in this order
    relax_tab = (Cuint(0), #relax nothing
                 NO_VRECURSE,
                 NO_FIXED_RADIX_LARGE_N,
                 NO_SLOW,
                 NO_UGLY)

    l_orig = flag(unsafe_load(flagsp), :l)
    x      = flag(unsafe_load(flagsp), :u)

    #guaranteed different from x
    last_x = ~x

    for i=1:length(relax_tab)
#        print_with_color(123,"relaxation: $(bits(UInt(relax_tab[i])))\n")
        if LEQ(l_orig, x & ~relax_tab[i])
            x = x & ~relax_tab[i]
        end
        
        if x != last_x
            last_x = x
            #flagsp->l = x
            tf = unsafe_load(flagsp)
            tf = setflag(tf, :l, x)
#            unsafe_store!(flagsp, setflag(tf, :l, x))
#            print_with_color(123,"search: changing flagsp:\n")
#            show(unsafe_load(flagsp))
#            show(tf)
            unsafe_store!(flagsp, tf)
#            show(unsafe_load(flagsp))
#            print_with_color(123,"search: begin search0\n")
            pln = search0(ego, p, slvndx, flagsp)
            if pln != C_NULL
#                print_with_color(123,"search: found plan, breaking out\n")
                break
            end
        end
    end
        
    if pln == C_NULL
#        print_with_color(123,"search: null plan, searching again\n")
        if l_orig != last_x
            last_x = l_orig
            #flagsp->l = l_orig
            tf = unsafe_load(flagsp)
            tf = setflag(tf, :l, l_orig)
#            unsafe_store!(flagsp, setflag(tf, :l, l_orig))
#            print_with_color(123,"search: changing flagsp after null plan:\n")
#            show(unsafe_load(flagsp))
#            show(tf)
            unsafe_store!(flagsp, tf)
#            show(unsafe_load(flagsp))
#            print_with_color(123,"search: begin search0 after null plan\n")
            pln = search0(ego, p, slvndx, flagsp)
        end
    end

#    print_with_color(123,"search: flagsp at end:\n")
#    show(unsafe_load(flagsp))
#    print_with_color(123,"search: htab_blessed at end:\n")
#    show(unsafe_load(ego).htab_blessed)
#    print_with_color(123,"search: htab_unblessed at end:\n")
#    show(unsafe_load(ego).htab_unblessed)
#    print_with_color(123,"search: end\n")

    return pln
end

#static plan* mkplan in kernel/planner.c:623
#function mkplan(ego::Ptr{planner}, p::Ptr{problem_dft})::Ptr{plan_dft}
function mkplan(ego::Ptr{planner}, p::Ptr{problem})::Ptr{plan}
#    print_with_color(213,"planner.mkplan: begin\n")
    pln = Ptr{plan}(C_NULL)

    m = newmd5()

#    slvndx = Cuint(0)
    slvndx = Ptr{Cuint}(malloc(sizeof(Cuint)))
    unsafe_store!(slvndx, Cuint(0))

    sol = newsolution()

    flags_of_solution = Ptr{flags_t}(malloc(sizeof(flags_t)))

#    show(unsafe_load(ego))

#    print_with_color(213,"PLNR_L: $(bits(PLNR_L(ego))[end-19:end])\n")
#    print_with_color(213,"PLNR_U: $(bits(PLNR_U(ego))[end-19:end])\n")
    @assert LEQ(PLNR_L(ego), PLNR_U(ego))
    
    if ESTIMATEP(ego) != 0
#        print_with_color(213,"planner.mkplan: estimate, setting plnr.flags.t = 0\n")
        #PLNR_TIMELIMIT_IMPATIENCE(ego) = 0
        #flags at 216 bytes in planner
        pt = reinterpret(Ptr{flags_t}, ego + 216)
        ff = unsafe_load(ego).flags
        ff = setflag(ff, :t, Cuint(0))
#        ll = flag(ff, :l)
#        hh = flag(ff, :h)
#        uu = flag(ff, :u)
#        ss = flag(ff, :s)
#        ff = flags_t(ll, hh, Cuint(0), uu, ss)
#        show(unsafe_load(pt))
        unsafe_store!(pt, ff)
#        show(unsafe_load(pt))
#        show(unsafe_load(ego).flags)
#        print_with_color(213,"planner.mkplan: new flags:\n")
#        show(unsafe_load(ego).flags)
    end

    check(reinterpret(Ptr{hashtab}, ego + 112))
    check(reinterpret(Ptr{hashtab}, ego + 160))

    #ego->timed_out = 0
    #timed_out at 248 bytes in planner
    pt = reinterpret(Ptr{Cint}, ego + 248)
    unsafe_store!(pt, Cint(0))

    #++ego->nprob
    #nprob at 280 bytes in planner
    pt = reinterpret(Ptr{Cint}, ego + 280)
    unsafe_store!(pt, unsafe_load(pt) + 1)
    md5hash(m, p, ego)

    plnr = unsafe_load(ego)
#    show(plnr)

#    flags_of_solution = plnr.flags
    #flags_t flags at 216 bytes in planner
#    pt = reinterpret(Ptr{flags_t}, ego + 216)
#    unsafe_store!(flags_of_solution, unsafe_load(pt))
    unsafe_store!(flags_of_solution, plnr.flags)

    if plnr.wisdom_state != WISDOM_IGNORE_ALL
#TMP
#        print_with_color(213,"planner.mkplan: not ignoring wisdom\n")
#        print_with_color(213,"planner.mkplan: md5:\n")
#        show(unsafe_load(m))
#        print_with_color(213,"planner.mkplan: flags_of_solution:\n")
#        show(flags_of_solution)
#        print_with_color(213,"planner.mkplan: begin hlookup\n")
#        sol = hlookup(ego, unsafe_load(m).s, Ptr{flags_t}(pointer_from_objref(flags_of_solution)))
        sol = hlookup(ego, unsafe_load(m).s, flags_of_solution)
#        print_with_color(213,"planner.mkplan: hlookup ended\n")
        if sol != C_NULL
#        if sol == hlookup(ego, unsafe_load(m).s, 
#                          Ptr{flags_t}(pointer_from_objref(flags_of_solution)))
#            print_with_color(213,"planner.mkplan: wisdom acceptable\n")
            #wisdom is acceptable
            owisdom_state = plnr.wisdom_state

            if plnr.wisdom_ok_hook != C_NULL && plnr.wisdom_ok_hook(p, 
                                                       unsafe_load(sol).flags) == 0
#                print_with_color(213,"planner.mkplan: wisdom not ok, ignoring\n")
                @goto do_search
            end

#            slvndx = SLVNDX(sol)
            unsafe_store!(slvndx, SLVNDX(sol))
#            if slvndx == INFEASIBLE_SLVNDX
            if unsafe_load(slvndx) == INFEASIBLE_SLVNDX
#                print_with_color(213,"planner.mkplan: infeasible slvndx $(unsafe_load(slvndx))\n")
                if plnr.wisdom_state == WISDOM_IGNORE_INFEASIBLE
#                    print_with_color(213,"planner.mkplan: ignore infeasible wisdom\n")
                    @goto do_search
                else
#                    print_with_color(213,"planner.mkplan: returning null plan\n")
                    return C_NULL
                end
            end

#            flags_of_solution = unsafe_load(sol).flags
#            flags_of_solution = setflag(flags_of_solution, :h, flag(flags_of_solution, :h) | BLISS(ego))
            #flags_t flags at 16 bytes in solution
#            pt = reinterpret(Ptr{flags_t}, sol + 16)
#            ff = setflag(unsafe_load(pt), :h, flag(unsafe_load(pt), :h) | BLISS(ego))
            ff = unsafe_load(sol).flags
            ff = setflag(ff, :h, flag(ff, :h) | BLISS(unsafe_load(ego).flags))
            unsafe_store!(flags_of_solution, ff)

            #wisdom_state at 108 bytes in planner
            pt = reinterpret(Ptr{wisdom_state_t}, ego + 108)
            unsafe_store!(pt, WISDOM_ONLY)

#            s = unsafe_load(unsafe_load(ego).slvdescs, slvndx+1).slv
            s = unsafe_load(unsafe_load(ego).slvdescs, unsafe_load(slvndx)+1).slv
            if unsafe_load(unsafe_load(p).adt).problem_kind != 
                             unsafe_load(unsafe_load(s).adt).problem_kind
#                print_with_color(213,"planner.mkplan: problem_kind mismatch\n")
                @goto wisdom_is_bogus
            end

#            pln = invoke_solver(ego, p, s, Ptr{flags_t}(pointer_from_objref(flags_of_solution)))
            pln = invoke_solver(ego, p, s, flags_of_solution)

            @CHECK_FOR_BOGOSITY

            sol = C_NULL

            if pln == C_NULL
                @goto wisdom_is_bogus
            end

            #wisdom_state at 108 bytes in planner
            pt = reinterpret(Ptr{wisdom_state_t}, ego + 108)
            unsafe_store!(pt, owisdom_state)

            @goto skip_search
        elseif unsafe_load(ego).nowisdom_hook != C_NULL
#            print_with_color(213,"planner.mkplan: nowisdom_hook\n")
            unsafe_load(ego).nowisdom_hook(p)
        end
    end

  @label do_search
#TMP
#    print_with_color(213,"planner.mkplan: do_search\n")
#    if sol == C_NULL
#        error("null solution, cannot continue")
#    end

    if unsafe_load(ego).wisdom_state == WISDOM_ONLY
#        print_with_color(213,"planner.mkplan: wisdom only, no search\n")
        @goto wisdom_is_bogus
    end

#    flags_of_solution = unsafe_load(ego).flags
    unsafe_store!(flags_of_solution, unsafe_load(ego).flags)
#    print_with_color(213,"planner.mkplan: begin search\n")
#    pln = search(ego, p, Ptr{Cuint}(pointer_from_objref(slvndx)), Ptr{flags_t}(pointer_from_objref(flags_of_solution)))
    pln = search(ego, p, slvndx, flags_of_solution)
    @CHECK_FOR_BOGOSITY

    if unsafe_load(ego).timed_out != 0
#        print_with_color(213,"planner.mkplan: search timed out\n")
        @assert pln == C_NULL
        if PLNR_TIMELIMIT_IMPATIENCE(ego) != 0
#            print_with_color(213,"planner.mkplan: bless solution\n")
#            flags_of_solution = setflag(flags_of_solution, :h, flag(flags_of_solution, :h) | BLESSING)
            ff = unsafe_load(flags_of_solution)
            ff = setflag(ff, :h, flag(ff, :h) | BLESSING)
            unsafe_store!(flags_of_solution, ff)
        else
#            print_with_color(213,"planner.mkplan: timed out, too impatient to try again -- returning null plan\n")
            return C_NULL
        end
    else
#        print_with_color(213,"planner.mkplan: search did not time out, reset impatience\n")
#        flags_of_solution = setflag(flags_of_solution, :t, 0)
        ff = unsafe_load(flags_of_solution)
        ff = setflag(ff, :t, 0)
        unsafe_store!(flags_of_solution, ff)
    end

  @label skip_search
#    print_with_color(213,"planner.mkplan: skip_search\n")
    if unsafe_load(ego).wisdom_state == WISDOM_NORMAL || 
              unsafe_load(ego).wisdom_state == WISDOM_ONLY
#        fs = Ptr{flags_t}(pointer_from_objref(flags_of_solution))
        if pln != C_NULL
#            print_with_color(213,"planner.mkplan: plan exists, insert in hashtab\n")
#            hinsert(ego, unsafe_load(m).s, fs, slvndx)
            hinsert(ego, unsafe_load(m).s, flags_of_solution, unsafe_load(slvndx))
            invoke_hook(ego, pln, p, Cint(1))
        else
#            hinsert(ego, unsafe_load(m).s, fs, INFEASIBLE_SLVNDX)
            hinsert(ego, unsafe_load(m).s, flags_of_solution, INFEASIBLE_SLVNDX)
        end
    end
    return pln

  @label wisdom_is_bogus
#    print_with_color(213,"planner.mkplan: wisdom_is_bogus\n")
    plan_destroy_internal(pln)
    #wisdom_state at 108 bytes in planner
    pt = reinterpret(Ptr{wisdom_state_t}, ego + 108)
    unsafe_store!(pt, WISDOM_IS_BOGUS)
    return C_NULL
end

function testplan(ap::Ptr{apiplan})
    print_with_color(99,"testplan: testing plan\n")
    show(ap)
    adt = unsafe_load(unsafe_load(reinterpret(Ptr{Ptr{problem_adt}}, unsafe_load(ap).prb)))
    print_with_color(99,"testplan: problem kind $(adt.problem_kind)\n")
    if adt.problem_kind != PROBLEM_DFT
        error("problem $(adt.problem_kind) not supported")
    end
    prb = unsafe_load(unsafe_load(ap).prb)
    sz = unsafe_load(prb.sz)
    rnk = sz.rnk
    n = unsafe_load(sz.dims, rnk).n
    X = convert(Array{Complex{Float64}}, [1:n;])
    Y = fill(Complex{Float64}(0), n)
    pln_dft = unsafe_load(ap).pln
    apply   = unsafe_load(pln_dft).apply
    XR      = Base.unsafe_convert(Ptr{Float64}, X)
    XC      = XR + sizeof(Float64)
    YR      = Base.unsafe_convert(Ptr{Float64}, Y)
    YC      = YR + sizeof(Float64)

#    ccall(("fftw_execute_dft",libfftw),
#          Void,
#          (Ptr{apiplan}, Ptr{Complex{Float64}}, Ptr{Complex{Float64}}),
#          ap, X, Y)
    print_with_color(99,"testplan: applying plan\n")
    ccall(apply, Void, 
          (Ptr{plan_dft}, Ptr{Float64}, Ptr{Float64}, Ptr{Float64}, Ptr{Float64}),
          pln_dft, XR, XC, YR, YC)
    println("$X")
    println("$Y")
end

function testplan(p::Ptr{plan_dft})::Void
    X = convert(Array{Complex{Float64}}, [1:5;])
    Y = fill(Complex{Float64}(0), 5)
    print_with_color(99,"testing plan_dft\n")
    apply   = unsafe_load(p).apply
    XR      = Base.unsafe_convert(Ptr{Float64}, X)
    XC      = XR + sizeof(Float64)
    YR      = Base.unsafe_convert(Ptr{Float64}, Y)
    YC      = YR + sizeof(Float64)
    print_with_color(99,"applying plan_dft\n")
    ccall(apply, Void, 
          (Ptr{plan_dft}, Ptr{Float64}, Ptr{Float64}, Ptr{Float64}, Ptr{Float64}),
          p, XR, XC, YR, YC)
    println("$X")
    println("$Y")
end

#force_estimator in api/apiplan.c:45
function force_estimator(flags::Cuint)::Cuint
    flags &= ~(FFTW_MEASURE | FFTW_PATIENT | FFTW_EXHAUSTIVE)
    return flags | FFTW_ESTIMATE
end

#planner* X(mkplanner) in kernel/planner.c:911
function mkplanner()::Ptr{planner}
    print_with_color(58,"mkplanner: begin\n")
    #fill planner_adt
#=    padt = Ptr{planner_adt}(malloc(sizeof(planner_adt)))
    pt = reinterpret(Ptr{Ptr{Void}}, padt)
    unsafe_store!(pt, cfunction(register_solver, Void, (Ptr{planner}, Ptr{solver})))
    pt = reinterpret(Ptr{Ptr{Void}}, padt + 8)
    unsafe_store!(pt, cfunction(mkplan, Ptr{plan}, (Ptr{planner}, Ptr{problem})))
    pt = reinterpret(Ptr{Ptr{Void}}, padt + 16)
    unsafe_store!(pt, cfunction(forget, Void, (Ptr{planner}, amnesia)))
    pt = reinterpret(Ptr{Ptr{Void}}, padt + 24)
    unsafe_store!(pt, C_NULL)
    pt = reinterpret(Ptr{Ptr{Void}}, padt + 32)
    unsafe_store!(pt, C_NULL)=#

#=    padt = planner_adt(cfunction(register_solver, Void, (Ptr{planner}, Ptr{solver})),
                       cfunction(mkplan, Ptr{plan}, (Ptr{planner}, Ptr{problem})),
                       cfunction(forget, Void, (Ptr{planner}, amnesia)),
                       C_NULL,
                       C_NULL)=#
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

    p = Ptr{planner}(malloc(sizeof(planner))) 
  
    #planner_adt* adt at 0 bytes in planner
    pt = reinterpret(Ptr{Ptr{planner_adt}}, p)
#    unsafe_store!(pt, pointer_from_objref(padt))
    unsafe_store!(pt, padt)

    #func* hook at 8 bytes in planner
    pt = reinterpret(Ptr{Ptr{Void}}, p + 8)
    unsafe_store!(pt, C_NULL)
    #func* cost_hook at 16 bytes in planner
    pt = reinterpret(Ptr{Ptr{Void}}, p + 16)
    unsafe_store!(pt, C_NULL)
    #func* wisdom_ok_hook at 24 bytes in planner
    pt = reinterpret(Ptr{Ptr{Void}}, p + 24)
    unsafe_store!(pt, C_NULL)
    #func* nowisdom_hook at 32 bytes in planner
    pt = reinterpret(Ptr{Ptr{Void}}, p + 32)
    unsafe_store!(pt, C_NULL)
    #func* bogosity_hook at 40 bytes in planner
    pt = reinterpret(Ptr{Ptr{Void}}, p + 40)
    unsafe_store!(pt, C_NULL)

    #slvdesc* slvdescs at 48 bytes in planner
    pt = reinterpret(Ptr{Ptr{slvdesc}}, p + 48)
    unsafe_store!(pt, reinterpret(Ptr{slvdesc}, C_NULL))
    #unsigned nslvdesc at 56 bytes in planner
    pt = reinterpret(Ptr{Cuint}, p + 56)
    unsafe_store!(pt, Cuint(0))
    #unsigned slvdescsiz at 60 bytes in planner
    pt = reinterpret(Ptr{Cuint}, p + 60)
    unsafe_store!(pt, Cuint(0))

    #char* cur_reg_nam at 64 bytes in planner
    pt = reinterpret(Ptr{Ptr{Cchar}}, p + 64)
    unsafe_store!(pt, C_NULL)
    #int cur_reg_id at 72 bytes in planner
    pt = reinterpret(Ptr{Cint}, p + 72)
    unsafe_store!(pt, Cint(0))

    #int[PROBLEM_LAST] slvdescs_for_problem_kind at 76 bytes in planner
    for i in 1:Cint(PROBLEM_LAST) #should be 8
        pt = reinterpret(Ptr{Cint}, p + 76 + (i-1)*sizeof(Cint))
        unsafe_store!(pt, Cint(-1))
    end

    #wisdom_state_t (int) wisdom_state at 108 bytes in planner
    pt = reinterpret(Ptr{Cint}, p + 108)
    unsafe_store!(pt, Cint(WISDOM_NORMAL))

    #hashtab htab_blessed at 112 bytes in planner
    pt = reinterpret(Ptr{hashtab}, p + 112)
    mkhashtab(pt)
    #hashtab htab_unblessed at 160 bytes in planner
    pt = reinterpret(Ptr{hashtab}, p + 160)
    mkhashtab(pt)

    #int nthr at 208 bytes in planner
    pt = reinterpret(Ptr{Cint}, p + 208)
    unsafe_store!(pt, Cint(1))

    #flags_t flags at 216 bytes in planner
    pt = reinterpret(Ptr{flags_t}, p + 216)
    unsafe_store!(pt, flags_t(0,0,0,0,0))

    #crude_time start_time at 224 bytes in planner
    pt = reinterpret(Ptr{crude_time}, p + 224)
    unsafe_store!(pt, crude_time(0,0))
    #double timelimit at 240 bytes in planner
    pt = reinterpret(Ptr{Cdouble}, p + 240)
    unsafe_store!(pt, Cdouble(-1.0))
    #int timed_out at 248 bytes in planner
    pt = reinterpret(Ptr{Cint}, p + 248)
    unsafe_store!(pt, Cint(0))
    #int need_timeout_check at 252 bytes in planner
    pt = reinterpret(Ptr{Cint}, p + 252)
    unsafe_store!(pt, Cint(1))

    #int nplan at 256 bytes in planner
    pt = reinterpret(Ptr{Cint}, p + 256)
    unsafe_store!(pt, Cint(0))

    #double pcost at 264 bytes in planner
    pt = reinterpret(Ptr{Cdouble}, p + 264)
    unsafe_store!(pt, Cdouble(0.0))
    #double epcost at 272 bytes in planner
    pt = reinterpret(Ptr{Cdouble}, p + 272)
    unsafe_store!(pt, Cdouble(0.0))

    #int nprob at 280 bytes in planner
    pt = reinterpret(Ptr{Cint}, p + 280)
    unsafe_store!(pt, Cint(0.0))

    print_with_color(58,"mkplanner: end\n")
    return p
end

fftw = "fftw"
lib  = FFTWchanges.libfftw
#for (fftw,lib) in (("fftw",FFTWchanges.libfftw),("fftwf",FFTWchanges.libfftwf))

#mkplan0 in api/apiplan.c:31
#@eval function mkplan0(plnr::Ptr{planner}, flags::Cuint, prb::Ptr{problem_dft}, hash_info::Cuint, wisdom_state::wisdom_state_t)::Ptr{plan_dft}
@eval function mkplan0(plnr::Ptr{planner}, flags::Cuint, prb::Ptr{problem}, hash_info::Cuint, wisdom_state::wisdom_state_t)::Ptr{plan}
#TMP
    print_with_color(:magenta,"starting mkplan0\n")
#    print_with_color(:magenta,"hash_info: $hash_info\n")
#    print_with_color(:magenta,"mkplan0: planner flags:\n")
#    show(unsafe_load(plnr).flags)
#    show(unsafe_load(reinterpret(Ptr{flags_t}, plnr + 216)))
#    print_with_color(:green,$(string("library: ",fftw," ",lib,"\n")))
#    print_with_color(:green,"problem at beginning of mkplan0:\n")
#    show(unsafe_load(prb))
#    show(prb)

#    ccall(($(string(fftw,"_mapflags")),$lib), Void, (Ptr{planner}, Cuint), plnr, flags)
#    print_with_color(:magenta," C mapped flags:\n")
#    show(unsafe_load(plnr).flags)
#TMP
    ff = mapflags(plnr, flags)
#    print_with_color(:magenta," mapped flags:\n")
    tflags = unsafe_load(plnr).flags
#    show(tflags)
#    print_with_color(:magenta," returned flags:\n")
#    show(ff)

    l = flag(tflags, :l)
    t = flag(tflags, :t)
    u = flag(tflags, :u)
    s = flag(tflags, :s)
#    plnr.flags.hash_info = hash_info
#    plnr.flags = flags_t(l, hash_info, t, u)
#    plnr.wisdom_state = wisdom_state
    pt = reinterpret(Ptr{flags_t}, plnr + 216)
    unsafe_store!(pt, flags_t(l, hash_info, t, u, s))
#    print_with_color(:magenta,"flags with hash_info $hash_info:\n")
#    show(unsafe_load(plnr).flags)
    pt = reinterpret(Ptr{Cint}, plnr + 108)
    unsafe_store!(pt, Cint(wisdom_state))
#TMP    
#    print_with_color(:green,"problem after storage in mkplan0:\n")
#    show(unsafe_load(prb))
#    show(prb)
   
#    adt = unsafe_load(unsafe_load(plnr).adt)
#=    print_with_color(:magenta,"planner in mkplan0:\n")
    show(plnr)
    prbb = unsafe_load(prb)
    print_with_color(:magenta,"problem in mkplan0:\n")
    show(prbb)
    print_with_color(:magenta,"adt in mkplan0:\n")
    show(adt)
    print_with_color(:magenta,"adt.mkplan0\n")=#

#=    pln = ccall(adt.mkplan,
                 Ptr{plan_dft},
                 (Ptr{planner}, Ptr{problem_dft}),
                 plnr, prb)
                 =#
     pln = mkplan(plnr, prb)
#TMP    
#    print_with_color(:green,"plan made in mkplan0:\n")
#    show(unsafe_load(pln))
#    print_with_color(:green,"problem at end of mkplan0:\n")
#    show(unsafe_load(prb))
#    show(prb)
#    testplan(reinterpret(Ptr{plan_dft}, pln))

    return pln
end

#mkplan in api/apiplan.c:51
#@eval function mkplan(plnr::planner, flags::Cuint, prb::Ptr{problem}, hash_info::Cuint)::Ptr{plan}
#@eval function mkplan(plnr::Ptr{planner}, flags::Cuint, prb::Ptr{problem_dft}, hash_info::Cuint)::Ptr{plan_dft}
@eval function mkplan(plnr::Ptr{planner}, flags::Cuint, prb::Ptr{problem}, hash_info::Cuint)::Ptr{plan}
#TMP
    print_with_color(90,"starting mkplan\n")
    print_with_color(90,"hash_info: $hash_info\n")
    print_with_color(90,"mkplan: planner flags:\n")
    show(unsafe_load(plnr).flags)
#    show(unsafe_load(reinterpret(Ptr{flags_t}, plnr + 216)))
#    print_with_color(:green,$(string("library: ",fftw," ",lib,"\n")))

    print_with_color(90,"mkplan: starting mkplan0\n")
    pln = mkplan0(plnr, flags, prb, hash_info, WISDOM_NORMAL)

    if (unsafe_load(plnr).wisdom_state == WISDOM_NORMAL) && (pln == C_NULL)
        print_with_color(90,"null plan generated, forcing estimate plan\n")
        print_with_color(90,"mkplan: starting mkplan0 again\n")
        pln = mkplan0(plnr, force_estimator(flags), prb, hash_info, WISDOM_IGNORE_INFEASIBLE)
    end

    if unsafe_load(plnr).wisdom_state == WISDOM_IS_BOGUS
#TMP
        print_with_color(90," bogus wisdom in mkplan\n")

        adt = unsafe_load(unsafe_load(plnr).adt)
        ccall(adt.forget, Void, (Ptr{planner}, Cint), plnr, Cint(FORGET_EVERYTHING))


        @assert pln == C_NULL

        print_with_color(90,"mkplan: starting mkplan0 with bogus wisdom\n")
        pln = mkplan0(plnr, flags, prb, hash_info, WISDOM_NORMAL)

        if unsafe_load(plnr).wisdom_state == WISDOM_IS_BOGUS
            print_with_color(90,"mkplan: wisdom still bogus\n")
            adt = unsafe_load(unsafe_load(plnr).adt)
            ccall(adt.forget, Void, (Ptr{planner}, Cint),
                  plnr, Cint(FORGET_EVERYTHING))

            @assert pln == C_NULL
            print_with_color(90,"mkplan: starting mkplan0 one more timewith bogus wisdom\n")
            pln = mkplan0(plnr, force_estimator(flags), prb, 
                          hash_info, WISDOM_IGNORE_ALL)
        end
    end

    return pln
end

#void X(configure_planner) in api/configure.c:26
function configure_planner(plnr::Ptr{planner})::Void
    dft_conf_standard(plnr)
#    rdft_conf_standard(plnr)
#    reodft_conf_standard(plnr)
    return nothing
end

#X(mkapiplan) in api/apiplan.c:86
#@eval function mkapiplan(sign::Cint, flags::Cuint, prb::Ptr{problem_dft})::Ptr{apiplan}
@eval function mkapiplan(sign::Cint, flags::Cuint, prb::Ptr{problem})::Ptr{apiplan}

    print_with_color(:cyan,"mkapiplan: starting mkapiplan\n")
#    show(prb)

    pcost = 0
    local flags_used_for_planning::Cuint
    local pats = [FFTW_ESTIMATE, FFTW_MEASURE, FFTW_PATIENT, FFTW_EXHAUSTIVE]

#X(the_planner) creates and configures planner
#use X(the_planner) XOR X(mkplanner) and X(configure_planner)
#   plnr = ccall(($(string(fftw,"_the_planner")),$lib),
#                 Ptr{planner}, ())
#    println("completed X(the_planner)")

#=    plnr = ccall(($(string(fftw,"_mkplanner")),$lib), Ptr{planner}, ())

    ff = flags_t(Cuint(0),Cuint(0),Cuint(0),Cuint(0),Cuint(0))
    #flags at 216 bytes in planner
    pt = reinterpret(Ptr{flags_t}, plnr + 216)
    unsafe_store!(pt, ff)
    print_with_color(:cyan,"mkapiplan: make htab_blessed\n")
    #htab_blessed at 112 bytes in planner
    pt = reinterpret(Ptr{hashtab}, plnr + 112)
    mkhashtab(pt)
    print_with_color(:cyan,"mkapiplan: make htab_unblessed\n")
    #htab_unblessed at 160 bytes in planner
    pt = reinterpret(Ptr{hashtab}, plnr + 160)
    mkhashtab(pt)=#
    plnr = mkplanner()
   
    check(plnr)
#    print_with_color(:cyan,"mkapiplan: ",$(string(fftw,"_mkplanner"))," completed\n")
    print_with_color(:cyan,"mkapiplan: mkplanner completed\n")
#TMP
#    local jplnr = unsafe_load(plnr)
#    show(jplnr)

    print_with_color(:cyan,"mkapiplan: configuring planner\n")
    
#    ccall(($(string(fftw,"_configure_planner")),$lib), Void, (Ptr{planner},), plnr)
    configure_planner(plnr)
    

    print_with_color(:cyan,"mkapiplan: ",$(string(fftw,"_configure_planner"))," completed\n")
#    print_with_color(:green,$(string("library: ",fftw," ",lib,"\n")))
#TMP
#    jplnr = unsafe_load(plnr);
#    jplnr = planner(plnr)
#    show(jplnr)
#    print_with_color(:cyan,"mkapiplan: configured planner flags\n")
#    show(unsafe_load(plnr).flags)
#    show(unsafe_load(reinterpret(Ptr{flags_t}, plnr + 216)))

    if flags & FFTW_WISDOM_ONLY != 0
        #return plan only if wisdom is present
#TMP
#        print_with_color(:cyan,"mkapiplan: using wisdom only\n")

        flags_used_for_planning = flags
#=        pln = ccall(("mkplan0",$lib),
                 PlanPtr,
                 (Ptr{planner}, Cuint, Ptr{problem}, Cuint, wisdom_state_t),
                 plnr, flags, prb, 0, 1) #1 is WISDOM_ONLY=#
#        pln = mkplan0(unsafe_load(plnr), flags, prb, Cuint(0), WISDOM_ONLY)
        pln = mkplan0(plnr, flags, prb, Cuint(0), WISDOM_ONLY)
    else
#TMP        
#        print_with_color(:cyan,"mkapiplan: not using wisdom only\n")

        pat_max = flags & FFTW_ESTIMATE != 0 ? 0 :
            (flags & FFTW_EXHAUSTIVE != 0 ? 3 :
             (flags & FFTW_PATIENT != 0 ? 2 : 1))
        pat = unsafe_load(plnr).timelimit >= 0 ? 0 : pat_max

        flags &= ~(FFTW_ESTIMATE | FFTW_MEASURE | FFTW_PATIENT | FFTW_EXHAUSTIVE)
        start_time = ccall(($(string(fftw,"_get_crude_time")),$lib),
                                 crude_time, ())
        #start_time offset by 224 bytes from beginning of plan
        pt = reinterpret(Ptr{crude_time}, plnr + 224)
        unsafe_store!(pt, start_time)

#TMP        
#        print_with_color(:cyan,"mkapiplan: got start_time\n")

        pln = reinterpret(Ptr{plan}, C_NULL)
        flags_used_for_planning = Cuint(0)
        #plan at increasing patience until running out of time
        for i in pat:pat_max
#TMP
            print_with_color(:cyan," mkapiplan: patience $i of $pat_max\n")
            
            tmpflags = flags | pats[i+1]
            pln1 = mkplan(plnr, tmpflags, prb, Cuint(0))
#TMP
            print_with_color(:cyan," mkapiplan: made plan with patience $i\n")

            if pln1 == C_NULL
                #abort if planner failed or timed out
                @assert pln == C_NULL || unsafe_load(plnr).timed_out
                break
            end
            ccall(($(string(fftw,"_plan_destroy_internal")),$lib),
#                     Void, (Ptr{plan_dft},), pln)
                     Void, (Ptr{plan},), pln)
            pln = pln1
            flags_used_for_planning = tmpflags
#            tpln = unsafe_load(unsafe_convert(Ptr{plan}, pln))
#            tpln = unsafe_load(pln)
#            pcost = unsafe_load(pln).pcost
            pcost = unsafe_load(reinterpret(Ptr{plan}, pln)).pcost
#            pcost = unsafe_load(pln).super.pcost
        end
    end

    if pln != C_NULL
        print_with_color(:cyan,"mkapiplan: plan exists, recreating with blessing\n")
        #build apiplan
        #recreate plan from wisdom, add blessing
#        tpln = mkplan(unsafe_load(plnr), flags_used_for_planning, prb, Cuint(BLESSING))
        tpln = mkplan(plnr, flags_used_for_planning, prb, Cuint(BLESSING))
#        testplan(reinterpret(Ptr{plan_dft}, tpln))
#        apln = apiplan(tpln, prb, sign)
        papln = mkpapiplan(tpln, prb, sign)
#TMP
        print_with_color(:cyan,"mkapiplan: printing plndesc:\n")
        plndesc = unsafe_wrap(String,ccall((:fftw_sprint_plan,libfftw), Ptr{UInt8}, (Ptr{apiplan},), papln))
        println(plndesc)
#        show(unsafe_load(unsafe_load(papln).pln))

        #p->pln->pcost = pcost
        #pcost offset by 40 bytes from beginning of plan
#        pt = reinterpret(Ptr{Cdouble}, apln.pln + 40)
        pt = reinterpret(Ptr{Cdouble}, unsafe_load(papln).pln + 40)
        unsafe_store!(pt, pcost)
#TMP
        print_with_color(:cyan,"mkapiplan: printing plndesc after pcost change:\n")
        plndesc = unsafe_wrap(String,ccall((:fftw_sprint_plan,libfftw), Ptr{UInt8}, (Ptr{apiplan},), papln))
        println(plndesc)
#        show(unsafe_load(unsafe_load(papln).pln))

        ccall(($(string(fftw,"_plan_awake")),$lib),
                 Void,
#                 (Ptr{plan_dft}, Cint),
                 (Ptr{plan}, Cint),
#                 apln.pln, Cint(AWAKE_SINCOS))
                 unsafe_load(papln).pln, Cint(AWAKE_SINCOS))

        ccall(($(string(fftw,"_plan_destroy_internal")),$lib),
                 Void,
#                 (Ptr{plan_dft},),
                 (Ptr{plan},),
                 pln)
    else
        ccall(($(string(fftw,"_problem_destroy")),$lib),
                 Void,
                 (Ptr{problem},),
                 prb)
    end
#TMP
    print_with_color(:cyan,"mkapiplan: end\n")
    testplan(papln)

    return papln
end
#end #for (fftw,lib)


#=
#planner* X(the_planner) in api/the_planner.c:26
function the_planner()
    if plnr_p == C_NULL
        plnr_p = mkplanner()
        configure_planner(plnr_p)
    end
    return plnr_p
end
=#

function check(plnr::Ptr{planner})::Void
#    print_with_color(23,"check: planner: begin\n")
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
    check(reinterpret(Ptr{hashtab}, plnr + 112))
    check(reinterpret(Ptr{hashtab}, plnr + 160))
#    print_with_color(23,"check: planner: end\n")
    return nothing
end





