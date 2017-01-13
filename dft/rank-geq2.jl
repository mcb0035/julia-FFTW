
#struct S in dft/rank-geq2.c:31
type S_dft_rank_geq2
    super::solver
    spltrnk::Cint
    buddies::Ptr{Cint}
    nbuddies::Cint
end

#struct P in dft/rank-geq2.c:33
type P_dft_rank_geq2
    super::plan_dft
    cld1::Ptr{plan}
    cld2::Ptr{plan}
    solver::Ptr{S_dft_rank_geq2}
end

#static void apply in dft/rank-geq2.c:42
function apply_dft_rank_geq2(ego_::Ptr{plan}, ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R})::Void
    print_with_color(208,"apply_dft_rank_geq2: begin\n")
    ego = unsafe_load(Ptr{P_dft_rank_geq2}(ego_))

    cld1 = Ptr{plan_dft}(ego.cld1)
    ccall(unsafe_load(cld1).apply, Void,
          (Ptr{plan}, Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}),
          ego.cld1, ri, ii, ro, io)

    cld2 = Ptr{plan_dft}(ego.cld2)
    ccall(unsafe_load(cld2).apply, Void,
          (Ptr{plan}, Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}),
          ego.cld2, ri, ii, ro, io)

    print_with_color(208,"apply_dft_rank_geq2: end\n")
    return nothing
end

#static void awake in dft/rank-geq2.c:55
function awake_dft_rank_geq2(ego_::Ptr{plan}, wakefulness::Cint)::Void
#    ego = Ptr{P_dft_rank_geq2}(ego_)
    ego = unsafe_load(Ptr{P_dft_rank_geq2}(ego_))
#    plan_awake(unsafe_load(ego).cld1, wakefulness)
    plan_awake(ego.cld1, wakefulness)
#    plan_awake(unsafe_load(ego).cld2, wakefulness)
    plan_awake(ego.cld2, wakefulness)
    return nothing
end

#static void destroy in dft/rank-geq2.c:62
function destroy_dft_rank_geq2(ego_::Ptr{plan})::Void
#    ego = Ptr{P_dft_rank_geq2}(ego_)
    ego = unsafe_load(Ptr{P_dft_rank_geq2}(ego_))
#    plan_destroy_internal(unsafe_load(ego).cld2)
    plan_destroy_internal(ego.cld2)
#    plan_destroy_internal(unsafe_load(ego).cld1)
    plan_destroy_internal(ego.cld1)
    return nothing
end

#static void print
function print_dft_rank_geq2(ego_::Ptr{plan}, p::Ptr{printer})::Void
    ego = unsafe_load(Ptr{P_dft_rank_geq2}(ego_))
    s = unsafe_load(ego.solver)
    
    str = "(dft-rank>=2/$(INT(s.spltrnk))"
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

    ccall(unsafe_load(unsafe_load(ego.cld1).adt).print, Void,
          (Ptr{plan}, Ptr{printer}),
          ego.cld1, p)
    
#    newline(p)
#TMP
    #int indent at 32 bytes in printer
    indent = unsafe_load(reinterpret(Ptr{Cint}, p + 32))
    str = string('\n', repeat(" ", indent))
    ccall(unsafe_load(p).print, Void,
          (Ptr{printer}, Ptr{Cchar}),
          p, str)

    ccall(unsafe_load(unsafe_load(ego.cld2).adt).print, Void,
          (Ptr{plan}, Ptr{printer}),
          ego.cld2, p)

    indent -= indent_incr
    unsafe_store!(pt, indent)

#=    ccall(unsafe_load(unsafe_load(ego.cld1).adt).print, Void,
          (Ptr{plan}, Ptr{printer}),
          ego.cld1, p)=#

    str = ")"
    ccall(unsafe_load(p).print, Void,
          (Ptr{printer}, Ptr{Cchar}),
          p, str)
    return nothing
end

#static int picksplit in dft/rank-geq2.c:77
function picksplit_dft_rank_geq2(ego::Ptr{S_dft_rank_geq2}, sz::Ptr{tensor}, rp::Ptr{Cint})::Bool
    @assert unsafe_load(sz).rnk > 1
    
    S = unsafe_load(ego)
    if pickdim(S.spltrnk, S.buddies, S.nbuddies, sz, Cint(1), rp) == 0
        return false #cannot split rnk <= 1
    end

    unsafe_store!(rp, unsafe_load(rp) + 1) #convert from index to rank
    if unsafe_load(rp) >= unsafe_load(sz).rnk
        return false #split must reduce rank
    end
    return true
end

#static int applicable0 in dft/rank-geq2.c:88
function applicable0(ego_::Ptr{solver}, p_::Ptr{problem}, rp::Ptr{Cint})::Bool
    p = unsafe_load(Ptr{problem_dft}(p_))
    sz = p.sz
    vecsz = p.vecsz
    ego = Ptr{S_dft_rank_geq2}(ego_)
    return (true
            && FINITE_RNK(unsafe_load(sz).rnk) && FINITE_RNK(unsafe_load(vecsz).rnk)
            && unsafe_load(sz).rnk >= 2
            && picksplit_dft_rank_geq2(ego, sz, rp))
end

#static int applicable in dft/rank-geq2.c:199
function applicable(ego_::Ptr{solver}, p_::Ptr{problem}, plnr::Ptr{planner}, rp::Ptr{Cint})::Bool
    ego = unsafe_load(Ptr{S_dft_rank_geq2}(ego_))
    p = unsafe_load(Ptr{problem_dft}(p_))

    if !applicable0(ego_, p_, rp)
        return false
    end

    if NO_RANK_SPLITSP(plnr) != 0 && ego.spltrnk != unsafe_load(ego.buddies)
        return false
    end

    #if vector stride < transform size then prefer vector loop first with vrank-geq1
    if NO_UGLYP(plnr) != 0
        if (unsafe_load(p.vecsz).rnk > 0 
            && tensor_min_stride(p.vecsz) > tensor_max_index(p.sz))
            return false
        end
    end

    return true
end

#static plan* mkplan in dft/rank-geq2.c:121
function mkplan_dft_rank_geq2(ego_::Ptr{solver}, p_::Ptr{problem}, plnr::Ptr{planner})::Ptr{plan}
    ego = Ptr{S_dft_rank_geq2}(ego_)
    cld1 = Ptr{plan}(C_NULL)
    cld2 = Ptr{plan}(C_NULL)
    
    spltrnk = Ptr{Cint}(malloc(sizeof(Cint)))

    padt = mkplan_adt(dft_solve, awake_dft_rank_geq2, print_dft_rank_geq2, destroy_dft_rank_geq2)

    if !applicable(ego_, p_, plnr, spltrnk)
        return Ptr{plan}(C_NULL)
    end

    p = unsafe_load(Ptr{problem_dft}(p_))
    
    sz1, sz2 = tensor_split(p.sz, unsafe_load(spltrnk))

    vecszi = tensor_copy_inplace(p.vecsz, INPLACE_OS)
    sz2i = tensor_copy_inplace(sz2, INPLACE_OS)

    cld1 = mkplan_d(plnr,
                    mkproblem_dft_d(tensor_copy(sz2),
                                    tensor_append(p.vecsz, sz1),
                                    p.ri, p.ii, p.ro, p.io))
    if cld1 == C_NULL
        @goto nada
    end

    cld2 = mkplan_d(plnr,
                    mkproblem_dft_d(tensor_copy_inplace(sz1, INPLACE_OS),
                                    tensor_append(vecszi, sz2i),
                                    p.ro, p.io, p.ro, p.io))
    if cld2 == C_NULL
        @goto nada
    end

    pln = MKPLAN_DFT(P_dft_rank_geq2, padt, apply_dft_rank_geq2)

    #plan* cld1 at 64 bytes in P
    pt = reinterpret(Ptr{Ptr{plan}}, pln + 64)
    unsafe_store!(pt, cld1)
    #plan* cld2 at 72 bytes in P
    pt = reinterpret(Ptr{Ptr{plan}}, pln + 72)
    unsafe_store!(pt, cld2)
    #S* solver at 80 bytes in P
    pt = reinterpret(Ptr{Ptr{S_dft_rank_geq2}}, pln + 80)
    unsafe_store!(pt, ego)

    #opcnt ops at 8 bytes in plan
    pt = reinterpret(Ptr{opcnt}, pln + 8)
    ops_add(unsafe_load(cld1).ops, unsafe_load(cld2).ops, pt)

    tensor_destroy4(sz1, sz2, vecszi, sz2i)

    free(spltrnk)

    return Ptr{plan}(pln)

  @label nada
    plan_destroy_internal(cld2)
    plan_destroy_internal(cld1)
    tensor_destroy4(sz1, sz2, vecszi, sz2i)
    free(spltrnk)
    return Ptr{plan}(C_NULL)
end

#static solver* mksolver in dft/rank-geq2.c:174
function mksolver_dft_rank_geq2(spltrnk::Cint, buddies::Ptr{Cint}, nbuddies::Cint)::Ptr{solver}
    func = cfunction(mkplan_dft_rank_geq2, Ptr{plan}, (Ptr{solver}, Ptr{problem}, Ptr{planner}))
#    sadt = mksolver_adt(PROBLEM_DFT, mkplan_dft_rank_geq2, C_NULL)
    sadt = mksolver_adt(PROBLEM_DFT, func, C_NULL)
    slv = MKSOLVER(S_dft_rank_geq2, sadt)
    
    #int spltrnk at 16 bytes in S
    pt = reinterpret(Ptr{Cint}, slv + 16)
    unsafe_store!(pt, spltrnk)
    #int* buddies at 24 bytes in S
    pt = reinterpret(Ptr{Ptr{Cint}}, slv + 24)
    unsafe_store!(pt, buddies)
    #int nbuddies at 32 bytes in S
    pt = reinterpret(Ptr{Cint}, slv + 32)
    unsafe_store!(pt, nbuddies)

    return Ptr{solver}(slv)
end

#void X(dft_rank_geq2_register) in dft/rank-geq2.c:184
function dft_rank_geq2_register(p::Ptr{planner})::Void
    buddies = Array{Cint}([1, 0, -2])
#    nbuddies = Cint(div(sizeof(buddies), sizeof(eltype(buddies))))
    nbuddies = Cint(length(buddies))

    for i=1:nbuddies
        solver_register(p, mksolver_dft_rank_geq2(buddies[i], pointer(buddies), nbuddies))
    end
    return nothing
end























