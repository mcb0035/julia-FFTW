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

#=
#XGURU(dft) in api/plan-guru-dft.h:24
function guru64_dft(rank::Cint32, dims::Array{iodim,1}, howmany_rank::Cint32, howmany_dims::Array{iodim,1}, inp::Array{Complex128,1}, out::Array{Complex128,1}, sign::Cint32, flags::Cuint32)
    if !GURU_KOSHERP(rank, dims, howmany_rank, howmany_dims)
        return nothing
    end

    extract_reim(sign, inp, ri, ii)
    extract_reim(sign, out, ro, io)

    #taints of ri, ii, ro, io
    #plan = apiplan(sign, flags, problem_dft(tensor_iodims(rank, dims, 2, 2), tensor_iodims(howmany_rank, howmany_dims, 2, 2), ri, ii, ro, io))
    plan = ccall(("fftw_mkapiplan", libfftw), PlanPtr,
    return plan
end=#

    

#=function mkproblem_dft(sz::tensor, vecsz::tensor, ri::Float, ii::Float, ro::Float, io::Float)
    #taints

    if ri == ro || ii == io
        if ri != ro || ii != io || !tensor_inplace_locations(sz, vecsz)
            return mkproblem_unsolvable()
        end
    end
    ego = problem_dft(sz, vecsz, ri, ii, ro, io)
    ego.sz = tensor_compress(sz)
    ego.vecsz = tensor_compress_contiguous(vecsz)=#

#mkplan0 in api/apiplan.c:31
for (fftw,lib) in (("fftw",FFTWchanges.libfftw),("fftwf",libfftwf))
@eval function mkplan0(plnr::planner, flags::Cuint, prb::ProbPtr, hash_info::Cuint, wisdom_state::wisdom_state_t)::PlanPtr
    println("starting mkplan0")
    ccall(($(string(fftw,"_mapflags")),$lib),
          Void,
          (Ptr{planner}, Cuint),
          Ref(plnr), flags)
    println(" mapped flags:")
    show(plnr.flags)
    l = flag(plnr.flags, :l)
    t = flag(plnr.flags, :t)
    u = flag(plnr.flags, :u)
#    plnr.flags.hash_info = hash_info
    plnr.flags = flags_t(l, hash_info, t, u)
    plnr.wisdom_state = wisdom_state
    
#    return plnr.adt.mkplan(plnr, prb)
    adt = unsafe_load(plnr.adt)
    println("planner in mkplan0:")
    show(plnr)
    println("problem: $prb")
    return ccall(adt.mkplan,
                 PlanPtr,
                 (Ptr{planner}, ProbPtr),
                 Ref(plnr), prb)
end
end #for (fftw,lib)

#force_estimator in api/apiplan.c:45
function force_estimator(flags::Cuint)::Cuint
    flags &= ~(FFTW_MEASURE | FFTW_PATIENT | FFTW_EXHAUSTIVE)
    return flags | FFTW_ESTIMATE
end

#mkplan in api/apiplan.c:51
for (fftw,lib) in (("fftw",FFTWchanges.libfftw),("fftwf",libfftwf))
@eval function mkplan(plnr::planner, flags::Cuint, prb::ProbPtr, hash_info::Cuint)::PlanPtr
    println("starting mkplan")
    pln = mkplan0(plnr, flags, prb, hash_info, WISDOM_NORMAL)

    if (plnr.wisdom_state == WISDOM_NORMAL) && (pln == C_NULL)
        pln = mkplan0(plnr, force_estimator(flags), prb, hash_info, WISDOM_IGNORE_INFEASIBLE)
    end

    if plnr.wisdom_state == WISDOM_IS_BOGUS
#        plnr.adt.forget(plnr, FORGET_EVERYTHING)
        println(" bogus wisdom in mkplan")
        ccall(plnr.adt.forget,
              Void,
              (Ptr{planner}, Cint),
              Ref(plnr), Cint(FORGET_EVERYTHING))


        @assert pln == C_NULL
        pln = mkplan0(plnr, flags, prb, hash_info, WISDOM_NORMAL)

        if plnr.wisdom_state == WISDOM_IS_BOGUS
#            plnr.adt.forget(plnr, FORGET_EVERYTHING)
            ccall(plnr.adt.forget,
                  Void,
                  (Ptr{planner}, Cint),
                  Ref(plnr), Cint(FORGET_EVERYTHING))

            @assert pln == C_NULL
            pln = mkplan0(plnr, force_estimator(flags), prb, hash_info, WISDOM_IGNORE_ALL)
        end
    end

    return pln
end
end #for (fftw,lib)


#X(mkapiplan) in api/apiplan.c:86
for (fftw,lib) in (("fftw",FFTWchanges.libfftw),("fftwf",libfftwf))
@eval function mkapiplan(sign::Cint, flags::Cuint, prb::ProbPtr)::PlanPtr
    println("starting mkapiplan with problem $prb")

    pcost = 0
    local flags_used_for_planning::Cuint
    local pats::Array{Cuint,1} = [FFTW_ESTIMATE, FFTW_MEASURE, FFTW_PATIENT, FFTW_EXHAUSTIVE]

#=   plnr = ccall(($(string(fftw,"_the_planner")),$lib),
#                 PlannerPtr,
                 Ptr{planner},
                 (Cint, Cuint, ProbPtr),
                 sign, flags, prb)=#
#    println("completed X(the_planner)")

#=   plnr = ccall(($(string(fftw,"_the_planner")),$lib),
                 Ptr{planner},
                 (),
                 )=#
    plnr = ccall(($(string(fftw,"_mkplanner")),$lib),
                 Ptr{planner},
                 (),
                 )
    println("X(mkplanner) completed")
#    local jplnr::planner = unsafe_load(plnr)
#    show(jplnr)
    println(" configuring planner")
    ccall(($(string(fftw,"_configure_planner")),$lib),
                 Void,
                 (Ptr{planner},),
                 plnr)
    println(" X(configure_planner) completed")
#    jplnr = unsafe_load(plnr)
    jplnr = planner(plnr)
    show(jplnr)

    if flags & FFTW_WISDOM_ONLY != 0
        println(" using wisdom only")
        flags_used_for_planning = flags
        pln = ccall(("mkplan0",$lib),
                 PlanPtr,
                 (PlannerPtr, Cuint, ProbPtr, Cuint, wisdom_state_t),
                 plnr, flags, prb, 0, 1) #1 is WISDOM_ONLY
    else
        println(" not using wisdom only")
        pat_max = flags & FFTW_ESTIMATE != 0 ? 0 :
            (flags & FFTW_EXHAUSTIVE != 0 ? 3 :
             (flags & FFTW_PATIENT != 0 ? 2 : 1))
        pat = jplnr.timelimit >= 0 ? 0 : pat_max

        flags &= ~(FFTW_ESTIMATE | FFTW_MEASURE | FFTW_PATIENT | FFTW_EXHAUSTIVE)
        jplnr.start_time = ccall(($(string(fftw,"_get_crude_time")),$lib),
                                 crude_time,
                                 ()
                                 )
        println(" got start_time")
        pln = C_NULL
        flags_used_for_planning = Cuint(0)
        for _ in pat:pat_max
            println("patience $pat")
            tmpflags = flags | pats[pat+1]
#=            pln1 = ccall(("mkplan",$lib),
                 PlanPtr,
#                 (PlannerPtr, Cuint, ProbPtr, Cuint),
                 (Ptr{planner}, Cuint, ProbPtr, Cuint),
#                 plnr, tmpflags, prb, 0)
                 Ref(jplnr), tmpflags, prb, 0)=#
            pln1 = mkplan(jplnr, tmpflags, prb, Cuint(0))
            println("  made plan with patience $pat")
            if pln1 == C_NULL
                @assert pln == C_NULL || jplnr.timed_out
                break
            end
            ccall(($(string(fftw,"_plan_destroy_internal")),$lib),
                     Void,
                     (PlanPtr,),
                     pln)
            pln = pln1
            flags_used_for_planning = tmpflags
            pln_s::plan_s = unsafe_load(unsafe_convert(Ptr{plan_s}, pln))
            pcost = pln_s.pcost
        end
    end

    if pln != C_NULL
#=        local tpln = ccall(("mkplan",$lib),
             PlanPtr,
             (PlannerPtr, Cuint, ProbPtr, Cuint),
             plnr, flags_used_for_planning, prb, BLESSING)=#
        local tpln = mkplan(jplnr, flags_used_for_planning, prb, Cuint(BLESSING))
        p = apiplan(tpln, prb, sign)
        pln_s = unsafe_load(unsafe_convert(Ptr{plan_s}, p.pln))
        pln_s.pcost = pcost
        p.pln = unsafe_convert(PlanPtr, pointer_from_objref(pln_s))

        ccall(($(string(fftw,"_plan_awake")),$lib),
                 Void,
                 (PlanPtr, Cint),
                 p.pln, Cint(AWAKE_SINCOS))

        ccall(($(string(fftw,"_plan_destroy_internal")),$lib),
                 Void,
                 (PlanPtr,),
                 pln)
    else
        ccall(($(string(fftw,"_problem_destroy")),$lib),
                 Void,
                 (ProbPtr,),
                 prb)
    end
    println(" finish mkapiplan")
    return unsafe_convert(PlanPtr, pointer_from_objref(p))
end
end #for (fftw,lib)

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
