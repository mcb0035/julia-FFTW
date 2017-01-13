
#flagmask in api/mapflags.c:29
immutable flagmask
    x::Cuint
    xm::Cuint
end

function Base.show(io::IO, f::flagmask)
    print(io, "($(bits(f.x)[end-length(digits(f.x,2))+1:end]), $(bits(f.xm)[end-length(digits(f.xm,2))+1:end]))")
end

#flagop in api/mapflags.c:34
immutable flagop
    flag::flagmask
    op::flagmask
end

function Base.show(io::IO, f::flagop)
    print_with_color(:yellow," flagop:\n")
#    println(" flag: { {$(bits(f.flag.x)[end-count_ones(f.flag.x)-1:end]), $(bits(f.flag.xm)[end-count_ones(f.flag.xm)-1:end])}, {$(bits(f.op.x)[end-count_ones(f.op.x)-1:end]), $(bits(f.op.xm)[end-count_ones(f.op.xm)-1:end])} }")
    println("{$(f.flag), $(f.op)}")
end

#macros in api/mapflags.c:36
FLAGP(f, msk::flagmask)::Cuint            = (f & msk.x) ⊻ msk.xm
OP(f, msk::flagmask)::Cuint               = (f | msk.x) ⊻ msk.xm
YES(x)::flagmask                          = flagmask(Cuint(x), Cuint(0))
NO(x)::flagmask                           = flagmask(Cuint(x), Cuint(x))
IMPLIES(x::flagmask, y::flagmask)::flagop = flagop(x, y)
EQV(a::Cuint, b::Cuint)  = IMPLIES(YES(a), YES(b)), IMPLIES(NO(a), NO(b))
NEQV(a::Cuint, b::Cuint) = IMPLIES(YES(a), NO(b)), IMPLIES(NO(a), YES(b))

#static void map_flags in api/mapflags.c:45
#return instead of changing oflags*
function map_flags(iflags::Cuint, oflags::Cuint, flagmap::Array{flagop}, nmap::Integer)::Cuint
    of = oflags
    for i=1:nmap
        if FLAGP(iflags, flagmap[i].flag) != 0
#            print_with_color(219,"map_flags: mapping flag $i:\n")
#            show(flagmap[i])
#            print_with_color(219,"new flags: $(bits(OP(of, flagmap[i].op))[end-19:end])\n")
            of = OP(of, flagmap[i].op)
        end
    end
    return of
end

#static unsigned timelimit_to_flags in api/mapflags.c:58
function timelimit_to_flags(timelimit::Cdouble)::Cuint
    tmax   = 365*24*3600
    tstep  = 1.05
    nsteps = 1 << 9 #BITS_FOR_TIMELIMIT = 9
    
    if timelimit < 0 || timelimit >= tmax
        return 0
    end
    if timelimit <= 1.0e-10
        return nsteps - 1
    end

    x = Cint(0.5 + log(tmax/timelimit)/log(tstep))

    if x < 0
        x = 0
    end
    if x >= nsteps
        x = nsteps - 1
    end
    return x
end

#void X(mapflags) in api/mapflags.c:77
function mapflags(plnr::Ptr{planner}, flags::Cuint)::flags_t
#    print_with_color(74,"mapflags: API flags:\n")
#    println(bits(flags)[end-19:end])
#    print_with_color(74,"mapflags: planner flags\n")
#    show(unsafe_load(plnr).flags)
    self_flagmap = [
	  #= in some cases (notably for halfcomplex->real transforms),
	     DESTROY_INPUT is the default, so we need to support
	     an inverse flag to disable it.

	     (PRESERVE, DESTROY)   ->   (PRESERVE, DESTROY)
               (0, 0)                       (1, 0)
               (0, 1)                       (0, 1)
               (1, 0)                       (1, 0)
               (1, 1)                       (1, 0)
	  =#
	  IMPLIES(YES(FFTW_PRESERVE_INPUT), NO(FFTW_DESTROY_INPUT)),
	  IMPLIES(NO(FFTW_DESTROY_INPUT), YES(FFTW_PRESERVE_INPUT)),

	  IMPLIES(YES(FFTW_EXHAUSTIVE), YES(FFTW_PATIENT)),

	  IMPLIES(YES(FFTW_ESTIMATE), NO(FFTW_PATIENT)),
	  IMPLIES(YES(FFTW_ESTIMATE),
		  YES(FFTW_ESTIMATE_PATIENT 
		      | FFTW_NO_INDIRECT_OP
		      | FFTW_ALLOW_PRUNING)),

	  IMPLIES(NO(FFTW_EXHAUSTIVE), 
		  YES(FFTW_NO_SLOW)),

	  # a canonical set of fftw2-like impatience flags
	  IMPLIES(NO(FFTW_PATIENT),
		  YES(FFTW_NO_VRECURSE
		      | FFTW_NO_RANK_SPLITS
		      | FFTW_NO_VRANK_SPLITS
		      | FFTW_NO_NONTHREADED
		      | FFTW_NO_DFT_R2HC
		      | FFTW_NO_FIXED_RADIX_LARGE_N
              | FFTW_BELIEVE_PCOST))]

    l_flagmap = Array{flagop}([
	  EQV(FFTW_PRESERVE_INPUT, NO_DESTROY_INPUT)...,
	  EQV(FFTW_NO_SIMD, NO_SIMD)...,
	  EQV(FFTW_CONSERVE_MEMORY, CONSERVE_MEMORY)...,
	  EQV(FFTW_NO_BUFFERING, NO_BUFFERING)...,
      NEQV(FFTW_ALLOW_LARGE_GENERIC, NO_LARGE_GENERIC)...])

    u_flagmap = Array{flagop}([
	  IMPLIES(YES(FFTW_EXHAUSTIVE), NO(0xFFFFFFFF)),
	  IMPLIES(NO(FFTW_EXHAUSTIVE), YES(NO_UGLY)),

	  #= the following are undocumented, "beyond-guru" flags that
	     require some understanding of FFTW internals =#
	  EQV(FFTW_ESTIMATE_PATIENT, ESTIMATE)...,
	  EQV(FFTW_ALLOW_PRUNING, ALLOW_PRUNING)...,
	  EQV(FFTW_BELIEVE_PCOST, BELIEVE_PCOST)...,
	  EQV(FFTW_NO_DFT_R2HC, NO_DFT_R2HC)...,
	  EQV(FFTW_NO_NONTHREADED, NO_NONTHREADED)...,
	  EQV(FFTW_NO_INDIRECT_OP, NO_INDIRECT_OP)...,
	  EQV(FFTW_NO_RANK_SPLITS, NO_RANK_SPLITS)...,
	  EQV(FFTW_NO_VRANK_SPLITS, NO_VRANK_SPLITS)...,
	  EQV(FFTW_NO_VRECURSE, NO_VRECURSE)...,
	  EQV(FFTW_NO_SLOW, NO_SLOW)...,
      EQV(FFTW_NO_FIXED_RADIX_LARGE_N, NO_FIXED_RADIX_LARGE_N)...])

#    print_with_color(74,"mapflags: self_flagmap\n")
    flags = map_flags(flags, flags, self_flagmap, length(self_flagmap))

    l = Cuint(0)
    u = Cuint(0)
#    print_with_color(74,"mapflags: l_flagmap\n")
    l = map_flags(flags, l, l_flagmap, length(l_flagmap))
#    print_with_color(74,"mapflags: u_flagmap\n")
    u = map_flags(flags, u, u_flagmap, length(u_flagmap))
    
#    print_with_color(103,"mapflags: new l:\n")
#    println(bits(l)[end-19:end])
#    print_with_color(103,"mapflags: new u:\n")
#    println(bits(u)[end-19:end])

    ff = unsafe_load(plnr).flags
    ff = setflag(ff, :l, l)
    ff = setflag(ff, :u, u | l)
    #flags at 216 bytes in planner
    pt = reinterpret(Ptr{flags_t}, plnr + 216)
    unsafe_store!(pt, ff)
#    print_with_color(103,"mapflags: planner flags\n")
#    show(unsafe_load(plnr).flags)
    
    @assert PLNR_L(plnr) == l
    @assert PLNR_U(plnr) == l | u

    t = timelimit_to_flags(unsafe_load(plnr).timelimit)

    ff = setflag(ff, :t, t)
    unsafe_store!(pt, ff)

    @assert PLNR_TIMELIMIT_IMPATIENCE(plnr) == t
    return ff
end




















