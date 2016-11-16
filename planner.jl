export mkplan0, mkplan, mkapiplan
using Base.Libc
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

#macro CHECK_FOR_BOGOSITY in kernel/planner.c:617
macro CHECK_FOR_BOGOSITY()
    mpl = unsafe_load(ego)
    if (mpl.bogosity_hook != C_NULL ?
        (mpl.wisdom_state = mpl.bogosity_hook(mpl.wisdom_state, p))
        : mpl.wisdom_state) == WISDOM_IS_BOGUS
        return :(@goto wisdom_is_bogus)
    end
end

#X(solver_use) in kernel/solver.c:33
function solver_use(ego::Ptr{solver})::Void
    #ego.refcnt += 1
    rc = unsafe_load(ego).refcnt + 1
    #refcnt offset by 8 bytes from beginning of solver
    pt = ego + 8 
    reinterpret(Ptr{Cint}, pt)
    unsafe_store!(pt, rc)
    return nothing
end

#static void sgrow in kernel/planner.c:80
function sgrow(ego::Ptr{planner})::Void
    plnr = unsafe_load(ego)
    osiz = plnr.slvdescsiz
    nsiz = 1 + osiz + div(osiz, 4)
#    ntab = 

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
    end
end

#static plan* mkplan in kernel/planner.c:623
function mkplan(ego::Ptr{planner}, p::Ptr{problem})::Ptr{plan}
    local m = md5()
    local sol::Ptr{solution}

    @assert LEQ(PLNR_L(ego), PLNR_U(ego))
    
    if ESTIMATEP(ego)
        #flags at 216 bytes in planner
        pt = reinterpret(Ptr{flags_t}, ego + 216)
        unsafe_store!(pt, setflag(unsafe_load(pt), :t, 0))
    end

    #timed_out at 248 bytes in planner
    pt = reinterpret(Ptr{Cint}, ego + 248)
    unsafe_store!(pt, 0)

    #nprob at 280 bytes in planner
    pt = reinterpret(Ptr{Cint}, ego + 280)
    unsafe_store!(pt, unsafe_load(pt) + 1)
    md5hash(Ref(m), p, ego)

    plnr = unsafe_load(ego)

    flags_of_solution = plnr.flags

    if plnr.wisdom_state != WISDOM_IGNORE_ALL
        if sol == hlookup(ego, m.s, Ref(flags_of_solution))
            #wisdom is acceptable
            owisdom_state = plnr.wisdom_state

            if plnr.wisdom_ok_hook != C_NULL && plnr.wisdom_ok_hook(p, 
                                                       unsafe_load(sol).flags) == 0
                @goto do_search
            end

            slvndx = SLVNDX(sol)
            if slvndx == INFEASIBLE_SLVNDX
                if plnr.wisdom_state == WISDOM_IGNORE_INFEASIBLE
                    @goto do_search
                else
                    return C_NULL
                end
            end

            flags_of_solution = unsafe_load(sol).flags
            setflag(flags_of_solution, :h, flag(flags_of_solution, :h) | BLISS(ego))

            #wisdom_state at 108 bytes in planner
            pt = reinterpret(Ptr{wisdom_state_t}, ego + 108)
            unsafe_store!(pt, WISDOM_ONLY)

            s = unsafe_load(unsafe_load(ego).slvdescs, slvndx+1).slv
            if unsafe_load(unsafe_load(p).adt).problem_kind != 
                             unsafe_load(unsafe_load(s).adt).problem_kind
                @goto wisdom_is_bogus
            end

            pln = invoke_solver(ego, p, s, Ref(flags_of_solution))

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
            unsafe_load(ego).nowisdom_hook(p)
        end
    end

  @label do_search
    if unsafe_load(ego).wisdom_state == WISDOM_ONLY
        @goto wisdom_is_bogus
    end

    flags_of_solution = unsafe_load(ego).flags
    pln = search(ego, p, Ref(slvndx), Ref(flags_of_solution))
    @CHECK_FOR_BOGOSITY

    if unsafe_load(ego).timed_out != 0
        @assert pln == C_NULL
        if PLNR_TIMELIMIT_IMPATIENCE(ego) != 0
            setflag(flags_of_solution, :h, flag(flags_of_solution, :h) | BLESSING)
        else
            return C_NULL
        end
    else
        setflag(flags_of_solution, :t, 0)
    end

  @label skip_search
    if unsafe_load(ego).wisdom_state == WISDOM_NORMAL || 
              unsafe_load(ego).wisdom_state == WISDOM_ONLY
        if pln != C_NULL
            hinsert(ego, m.s, Ref(flags_of_solution), slvndx)
            invoke_hook(ego, pln, p, 1)
        else
            hinsert(ego, m.s, Ref(flags_of_solution), INFEASIBLE_SLVNDX)
        end
    end
    return pln

  @label wisdom_is_bogus
    plan_destroy_internal(pln)
    #wisdom_state at 108 bytes in planner
    pt = reinterpret(Ptr{wisdom_state_t}, ego + 108)
    unsafe_store!(pt, WISDOM_IS_BOGUS)
    return C_NULL
end

function testplan(ap::Ptr{apiplan})
    X = convert(Array{Complex{Float64}}, [1:5;])
    Y = fill(Complex{Float64}(0), 5)
    print_with_color(99,"testing plan\n")
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
    print_with_color(99,"applying plan\n")
    ccall(apply, Void, 
          (Ptr{plan_dft}, Ptr{Float64}, Ptr{Float64}, Ptr{Float64}, Ptr{Float64}),
          pln_dft, XR, XC, YR, YC)
    println("$X")
    println("$Y")
end

function testplan(p::Ptr{plan_dft})
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

fftw = "fftw"
lib  = FFTWchanges.libfftw
#for (fftw,lib) in (("fftw",FFTWchanges.libfftw),("fftwf",FFTWchanges.libfftwf))

#mkplan0 in api/apiplan.c:31
#@eval function mkplan0(plnr::planner, flags::Cuint, prb::Ptr{problem}, hash_info::Cuint, wisdom_state::wisdom_state_t)::Ptr{plan}
@eval function mkplan0(plnr::Ptr{planner}, flags::Cuint, prb::Ptr{problem_dft}, hash_info::Cuint, wisdom_state::wisdom_state_t)::Ptr{plan_dft}
#TMP
    print_with_color(:magenta,"starting mkplan0\n")
    print_with_color(:green,$(string("library: ",fftw," ",lib,"\n")))
#    print_with_color(:green,"problem at beginning of mkplan0:\n")
#    show(unsafe_load(prb))
#    show(prb)

    ccall(($(string(fftw,"_mapflags")),$lib), Void, (Ptr{planner}, Cuint), plnr, flags)
#TMP
#    print_with_color(:magenta," mapped flags:\n")
    tflags = unsafe_load(plnr).flags
#    show(tflags)

    l = flag(tflags, :l)
    t = flag(tflags, :t)
    u = flag(tflags, :u)
    s = flag(tflags, :s)
#    plnr.flags.hash_info = hash_info
#    plnr.flags = flags_t(l, hash_info, t, u)
#    plnr.wisdom_state = wisdom_state
    pt = reinterpret(Ptr{flags_t}, plnr + 216)
    unsafe_store!(pt, flags_t(l, hash_info, t, u, s))
    pt = reinterpret(Ptr{Cint}, plnr + 108)
    unsafe_store!(pt, Cint(wisdom_state))
#TMP    
#    print_with_color(:green,"problem after storage in mkplan0:\n")
#    show(unsafe_load(prb))
#    show(prb)
   
    adt = unsafe_load(unsafe_load(plnr).adt)
#=    print_with_color(:magenta,"planner in mkplan0:\n")
    show(plnr)
    prbb = unsafe_load(prb)
    print_with_color(:magenta,"problem in mkplan0:\n")
    show(prbb)
    print_with_color(:magenta,"adt in mkplan0:\n")
    show(adt)
    print_with_color(:magenta,"adt.mkplan0\n")=#
    pln = ccall(adt.mkplan,
                 Ptr{plan_dft},
                 (Ptr{planner}, Ptr{problem_dft}),
                 plnr, prb)
#TMP    
#    print_with_color(:green,"plan made in mkplan0:\n")
#    show(unsafe_load(pln))
#    print_with_color(:green,"problem at end of mkplan0:\n")
#    show(unsafe_load(prb))
#    show(prb)
    testplan(pln)

    return pln
end

#mkplan in api/apiplan.c:51
#@eval function mkplan(plnr::planner, flags::Cuint, prb::Ptr{problem}, hash_info::Cuint)::Ptr{plan}
@eval function mkplan(plnr::Ptr{planner}, flags::Cuint, prb::Ptr{problem_dft}, hash_info::Cuint)::Ptr{plan_dft}
#TMP
    print_with_color(90,"starting mkplan\n")
    print_with_color(:green,$(string("library: ",fftw," ",lib,"\n")))

    pln = mkplan0(plnr, flags, prb, hash_info, WISDOM_NORMAL)

    if (unsafe_load(plnr).wisdom_state == WISDOM_NORMAL) && (pln == C_NULL)
        print_with_color(90,"null plan generated, forcing estimate plan\n")
        pln = mkplan0(plnr, force_estimator(flags), prb, hash_info, WISDOM_IGNORE_INFEASIBLE)
    end

    if unsafe_load(plnr).wisdom_state == WISDOM_IS_BOGUS
#TMP
        print_with_color(90," bogus wisdom in mkplan\n")

        adt = unsafe_load(unsafe_load(plnr).adt)
        ccall(adt.forget, Void, (Ptr{planner}, Cint), plnr, Cint(FORGET_EVERYTHING))


        @assert pln == C_NULL
        pln = mkplan0(plnr, flags, prb, hash_info, WISDOM_NORMAL)

        if unsafe_load(plnr).wisdom_state == WISDOM_IS_BOGUS
            adt = unsafe_load(unsafe_load(plnr).adt)
            ccall(adt.forget, Void, (Ptr{planner}, Cint),
                  plnr, Cint(FORGET_EVERYTHING))

            @assert pln == C_NULL
            pln = mkplan0(plnr, force_estimator(flags), prb, 
                          hash_info, WISDOM_IGNORE_ALL)
        end
    end

    return pln
end

#X(mkapiplan) in api/apiplan.c:86
#@eval function mkapiplan(sign::Cint, flags::Cuint, prb::Ptr{problem})::apiplan
@eval function mkapiplan(sign::Cint, flags::Cuint, prb::Ptr{problem_dft})::Ptr{apiplan}

#    print_with_color(:cyan,"starting mkapiplan with problem $prb\n")
#    show(unsafe_load(prb))

    pcost = 0
    local flags_used_for_planning::Cuint
    local pats = [FFTW_ESTIMATE, FFTW_MEASURE, FFTW_PATIENT, FFTW_EXHAUSTIVE]

#X(the_planner) creates and configures planner
#use X(the_planner) XOR X(mkplanner) and X(configure_planner)
#   plnr = ccall(($(string(fftw,"_the_planner")),$lib),
#                 Ptr{planner}, ())
#    println("completed X(the_planner)")

    plnr = ccall(($(string(fftw,"_mkplanner")),$lib), Ptr{planner}, ())

    print_with_color(:cyan,$(string(fftw,"_mkplanner"))," completed\n")
#TMP
#    local jplnr = unsafe_load(plnr)
#    show(jplnr)

    print_with_color(:cyan," configuring planner\n")
    
    ccall(($(string(fftw,"_configure_planner")),$lib), Void, (Ptr{planner},), plnr)

    print_with_color(:cyan,$(string(fftw,"_configure_planner"))," completed\n")
    print_with_color(:green,$(string("library: ",fftw," ",lib,"\n")))
#TMP
#    jplnr = unsafe_load(plnr);
#    jplnr = planner(plnr)
#    show(jplnr)

    if flags & FFTW_WISDOM_ONLY != 0
        #return plan only if wisdom is present
#TMP
        print_with_color(:cyan," using wisdom only\n")

        flags_used_for_planning = flags
#=        pln = ccall(("mkplan0",$lib),
                 PlanPtr,
                 (Ptr{planner}, Cuint, Ptr{problem}, Cuint, wisdom_state_t),
                 plnr, flags, prb, 0, 1) #1 is WISDOM_ONLY=#
#        pln = mkplan0(unsafe_load(plnr), flags, prb, Cuint(0), WISDOM_ONLY)
        pln = mkplan0(plnr, flags, prb, Cuint(0), WISDOM_ONLY)
    else
#TMP        
        print_with_color(:cyan," not using wisdom only\n")

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
        print_with_color(:cyan," got start_time\n")

        pln = C_NULL
        flags_used_for_planning = Cuint(0)
        #plan at increasing patience until running out of time
        for i in pat:pat_max
#TMP
            print_with_color(:cyan,"patience $i\n")
            
            tmpflags = flags | pats[i+1]
            pln1 = mkplan(plnr, tmpflags, prb, Cuint(0))
#TMP
            print_with_color(:cyan,"  made plan with patience $i\n")

            if pln1 == C_NULL
                #abort if planner failed or timed out
                @assert pln == C_NULL || unsafe_load(plnr).timed_out
                break
            end
            ccall(($(string(fftw,"_plan_destroy_internal")),$lib),
                     Void, (Ptr{plan_dft},), pln)
            pln = pln1
            flags_used_for_planning = tmpflags
#            tpln = unsafe_load(unsafe_convert(Ptr{plan}, pln))
#            tpln = unsafe_load(pln)
#            pcost = unsafe_load(pln).pcost
            pcost = unsafe_load(pln).super.pcost
        end
    end

    if pln != C_NULL
        #build apiplan
        #recreate plan from wisdom, add blessing
#        tpln = mkplan(unsafe_load(plnr), flags_used_for_planning, prb, Cuint(BLESSING))
        tpln = mkplan(plnr, flags_used_for_planning, prb, Cuint(BLESSING))
        testplan(tpln)
#        apln = apiplan(tpln, prb, sign)
        papln = mkpapiplan(tpln, prb, sign)
#TMP
        print_with_color(:cyan,"printing plan:\n")
#        plndesc = unsafe_wrap(String,ccall((:fftw_sprint_plan,libfftw), Ptr{UInt8}, (Ptr{apiplan},), Ref(apln)))
        plndesc = unsafe_wrap(String,ccall((:fftw_sprint_plan,libfftw), Ptr{UInt8}, (Ptr{apiplan},), papln))
        println(plndesc)
#        show(unsafe_load(unsafe_load(papln).pln))

#        tpln = unsafe_load(apln.pln)
#        tpln.pcost = pcost
#        apln.pln = unsafe_convert(Ptr{plan}, Ref(tpln))
        #pcost offset by 40 bytes from beginning of plan
#        pt = reinterpret(Ptr{Cdouble}, apln.pln + 40)
        pt = reinterpret(Ptr{Cdouble}, unsafe_load(papln).pln + 40)
        unsafe_store!(pt, pcost)
#TMP
        print_with_color(:cyan,"printing plan after change:\n")
#        plndesc = unsafe_wrap(String,ccall((:fftw_sprint_plan,libfftw), Ptr{UInt8}, (Ptr{apiplan},), Ref(apln)))
        plndesc = unsafe_wrap(String,ccall((:fftw_sprint_plan,libfftw), Ptr{UInt8}, (Ptr{apiplan},), papln))
        println(plndesc)
#        show(unsafe_load(unsafe_load(papln).pln))

        ccall(($(string(fftw,"_plan_awake")),$lib),
                 Void,
                 (Ptr{plan_dft}, Cint),
#                 apln.pln, Cint(AWAKE_SINCOS))
                 unsafe_load(papln).pln, Cint(AWAKE_SINCOS))

        ccall(($(string(fftw,"_plan_destroy_internal")),$lib),
                 Void,
                 (Ptr{plan_dft},),
                 pln)
    else
        ccall(($(string(fftw,"_problem_destroy")),$lib),
                 Void,
                 (Ptr{problem_dft},),
                 prb)
    end
#TMP
    print_with_color(:cyan," finish mkapiplan\n")
    testplan(papln)

    return papln
end
#end #for (fftw,lib)

#X(the_planner) in api/the_planner.c:26
function the_planner()
    

end

#X(dft_conf_standard) in dft/conf.c:40
function dft_conf_standard(plnr::planner)

end

#X(configure_planner) in api/configure.c:26
function configure_planner(plnr::planner)
    dft_conf_standard(plnr)
    rdft_conf_standard(plnr)
    reodft_conf_standard(plnr)
end
