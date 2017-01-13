
#struct S in dft/vrank-geq1.c43
type S_dft_vrank_geq1
    super::solver
    vecloop_dim::Cint
    buddies::Ptr{Cint}
    nbuddies::Cint
end

#struct P in dft/vrank-geq1.c52
type P_dft_vrank_geq1
    super::plan_dft
    cld::Ptr{plan}
    vl::INT
    ivs::INT
    ovs::INT
    solver::Ptr{S_dft_vrank_geq1}
end

#static void apply in dft/vrank-geq1.c54
function apply_dft_vrank_geq1(ego_::Ptr{plan}, ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R})::Void
    ego = unsafe_load(Ptr{P_dft_vrank_geq1}(ego_))
    vl = ego.vl
    ivs = ego.ivs * sizeof(R)
    ovs = ego.ovs * sizeof(R)
    cldapply = unsafe_load(Ptr{plan_dft}(ego.cld)).apply

    for i=0:vl-1
        ccall(cldapply, Void, 
              (Ptr{plan}, Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}),
              ri + i*ivs, ii + i*ivs, ro + i*ovs, io + i*ovs)
    end
    return nothing
end

#static void awake in dft/vrank-geq1.c67
function awake_dft_vrank_geq1(ego_::Ptr{plan}, wakefulness::Cint)::Void
    ego = unsafe_load(Ptr{P_dft_vrank_geq1}(ego_))
    plan_awake(ego.cld, wakefulness)
    return nothing
end

#static void destroy in dft/vrank-geq1.c73
function destroy_dft_vrank_geq1(ego_::Ptr{plan})::Void
    ego = unsafe_load(Ptr{P_dft_vrank_geq1}(ego_))
    plan_destroy_internal(ego.cld)
    return nothing
end

#static void print in dft/vrank-geq1.c79
function print_dft_vrank_geq1(ego_::Ptr{plan}, p::Ptr{printer})::Void
    ego = unsafe_load(Ptr{P_dft_vrank_geq1}(ego_))
    s = unsafe_load(ego.solver)

    str = "(dft-vrank>=1-x$(ego.vl)/$(s.vecloop_dim)"
    ccall(unsafe_load(p).print, Void,
          (Ptr{printer}, Ptr{Cchar}),
          p, str)

    #int indent at 32 bytes in printer
    pt = reinterpret(Ptr{Cint}, p + 32)
    indent = unsafe_load(pt)
    #int indent_incr at 36 bytes in printer
    indent_incr = unsafe_load(reinterpret(Ptr{Cint}, p + 36))

    indent += indent_incr
    unsafe_store!(pt, indent)
#    newline(p)
#TMP
    #int indent at 32 bytes in printer
    indent = unsafe_load(reinterpret(Ptr{Cint}, p + 32))
    str = string('\n', repeat(" ", indent))
    ccall(unsafe_load(p).print, Void,
          (Ptr{printer}, Ptr{Cchar}),
          p, str)

    ccall(unsafe_load(unsafe_load(ego.cld).adt).print, Void,
          (Ptr{plan}, Ptr{printer}),
          ego.cld1, p)
    
    indent -= indent_incr
    unsafe_store!(pt, indent)

    str = ")"
    ccall(unsafe_load(p).print, Void,
          (Ptr{printer}, Ptr{Cchar}),
          p, str)
    return nothing
end

#static int pickdim in dft/vrank-geq1.c87
function pickdim_dft_vrank_geq1(ego::Ptr{S_dft_vrank_geq1}, vecsz::Ptr{tensor}, oop::Cint, dp::Ptr{Cint})::Cint
    S = unsafe_load(ego)
    return pickdim(S.vecloop_dim, S.buddies, S.nbuddies, vecsz, oop, dp)
end

#static in applicable0 in dft/vrank-geq1.c93
function applicable0_dft_vrank_geq1(ego_::Ptr{solver}, p_::Ptr{problem}, dp::Ptr{Cint})::Bool
    ego = Ptr{S_dft_vrank_geq1}(ego_)
    p = unsafe_load(Ptr{problem_dft}(p_))

    return (true
            && FINITE_RNK(unsafe_load(p.vecsz).rnk)
            && unsafe_load(p.vecsz).rnk > 0
            #do not loop over rank 0 problems since they are handled by rdft
            && unsafe_load(p.sz).rnk > 0
            && pickdim(ego, unsafe_load(p.vecsz), Cint(p.ri != p.ro), dp))
end

#static int applicable in dft/vrank-geq1.c110
function applicable_dft_vrank_geq1(ego_::Ptr{solver}, p_::Ptr{problem}, plnr::Ptr{planner}, dp::Ptr{Cint})::Bool
    ego = unsafe_load(Ptr{S_dft_vrank_geq1}(ego_))

    if !applicable0_dft_vrank_geq1(ego_, p_, dp)
        return false
    end

    if (NO_VRANK_SPLITSP(plnr) != 0
        && ego.vecloop_dim != unsafe_load(ego.buddies))
        return false
    end

    p = unsafe_load(Ptr{problem_dft}(p_))

    if NO_UGLYP(plnr) != 0
        #if transform is multidimensional and vector stride is less than transform
        #size then use rank>=2 plan first to combine this vector with
        #transform dimension vectors
        
        #iodim dims at 8 bytes in tensor
        #INT is at 8 bytes in iodim
        #INT os at 16 bytes in iodim
        pt = reinterpret(Ptr{INT}, p.vecsz + 8 + unsafe_load(dp)*sizeof(iodim))
        is = unsafe_load(pt + 8)
        os = unsafe_load(pt + 16)
        if (true
            && unsafe_load(p.sz).rnk > 1
            && min(abs(is), abs(os)) < tensor_max_index(p.sz))
            return false
        end
    end

    if NO_NONTHREADEDP(plnr) != 0
        return false
    end

    return true
end

#static plan* mkplan in dft/vrank-geq1.c145
function mkplan_dft_vrank_geq1(ego_::Ptr{solver}, p_::Ptr{problem}, plnr::Ptr{planner})::Ptr{plan}
    ego = Ptr{S_dft_vrank_geq1}(ego_)

    padt = mkplan_adt(dft_solve, awake_dft_vrank_geq1, print_dft_vrank_geq1, destroy_dft_vrank_geq1)

    vdim = Ptr{Cint}(malloc(sizeof(Cint)))

    if !applicable_dft_vrank_geq1(ego_, p_, plnr, vdim)
        return Ptr{plan}(C_NULL)
    end

    p = unsafe_load(Ptr{problem_dft}(p_))

    #iodim dims at 8 bytes in tensor
    #INT n at 0 bytes in iodim
    #INT is at 8 bytes in iodim
    #INT os at 16 bytes in iodim
    pt = reinterpret(Ptr{INT}, p.vecsz + 8 + unsafe_load(vdim)*sizeof(iodim))
    n = unsafe_load(pt)
    is = unsafe_load(pt + 8)
    os = unsafe_load(pt + 16)

    @assert n > 1
    
    cld = mkplan_d(plnr,
                   mkproblem_dft_d(tensor_copy(p.sz),
                                   tensor_copy_except(p.vecsz, unsafe_load(vdim)),
                                   TAINT(p.ri, is), TAINT(p.ii, is),
                                   TAINT(p.ro, os), TAINT(p.io, os)))
    if cld == C_NULL
        free(vdim)
        return Ptr{plan}(C_NULL)
    end

    pln = MKPLAN_DFT(P_dft_vrank_geq1, padt, apply_dft_vrank_geq1)

    #plan* cld at 64 bytes in P
    pt = reinterpret(Ptr{Ptr{plan}}, pln + 64)
    unsafe_store!(pt, cld)
    #INT vl at 72 bytes in P
    pt = reinterpret(Ptr{INT}, pln + 72)
    unsafe_store!(pt, n)
    #INT ivs at 80 bytes in P
    pt = reinterpret(Ptr{INT}, pln + 80)
    unsafe_store!(pt, is)
    #INT ovs at 88 bytes in P
    pt = reinterpret(Ptr{INT}, pln + 88)
    unsafe_store!(pt, os)
    #S* solver at 96 bytes in P
    pt = reinterpret(Ptr{Ptr{S_dft_vrank_geq1}}, pln + 96)
    unsafe_store!(pt, ego)

    #opcnt ops at 8 bytes in plan
    pt = reinterpret(Ptr{opcnt}, pln + 8)
    ops_zero(pt)
    #double other at 24 bytes in opcnt
    pt = reinterpret(Ptr{Cdouble}, pln + 8 + 24)
    unsafe_store!(pt, Cdouble(3.14159)) #magic to prefer codelet loops

#    ops_madd2(n, reinterpret(Ptr{opcnt}, cld + 8), reinterpret(Ptr{opcnt}, pln + 8))
    ops_madd2(n, unsafe_load(cld).ops, reinterpret(Ptr{opcnt}, pln + 8))

    #INT dims[0].n at 8 bytes in tensor
    n = unsafe_load(reinterpret(Ptr{INT}, p.sz + 8))
    if unsafe_load(p.sz).rnk != 1 || n > 64
        #double pcost at 40 bytes in plan
        pt = reinterpret(Ptr{Cdouble}, pln + 40)
        unsafe_store!(pt, unsafe_load(pln).vl * unsafe_load(cld).pcost)
    end
    free(vdim)                  
    return Ptr{plan}(pln)
end

#static solver* mksolver in dft/vrank-geq1.c:191
function mksolver_dft_vrank_geq1(vecloop_dim::Cint, buddies::Ptr{Cint}, nbuddies::Cint)::Ptr{solver}
    func = cfunction(mkplan_dft_vrank_geq1, Ptr{plan}, (Ptr{solver}, Ptr{problem}, Ptr{planner}))
#    sadt = mksolver_adt(PROBLEM_DFT, mkplan_dft_vrank_geq1, C_NULL)
    sadt = mksolver_adt(PROBLEM_DFT, func, C_NULL)
    slv = MKSOLVER(S_dft_vrank_geq1, sadt)
 
    #int vecloop_dim at 16 bytes in S
    pt = reinterpret(Ptr{Cint}, slv + 16)
    unsafe_store!(pt, vecloop_dim)
    #int* buddies at 24 bytes in S
    pt = reinterpret(Ptr{Ptr{Cint}}, slv + 24)
    unsafe_store!(pt, buddies)
    #int nbuddies at 32 bytes in S
    pt = reinterpret(Ptr{Cint}, slv + 32)
    unsafe_store!(pt, nbuddies)

    return Ptr{solver}(slv)
end

#void X(dft_vrank_geq1_register) in dft/vrank-geq1.c:201
function dft_vrank_geq1_register(p::Ptr{planner})::Void
    buddies = Array{Cint}([1, -1])
#    nbuddies = Cint(div(sizeof(buddies), sizeof(eltype(buddies))))
    nbuddies = Cint(length(buddies))

    for i=1:nbuddies
        solver_register(p, mksolver_dft_vrank_geq1(buddies[i], pointer(buddies), nbuddies))
    end
    return nothing
end















