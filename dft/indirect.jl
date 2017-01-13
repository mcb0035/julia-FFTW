#dft/indirect.c
#internals for indirect plan

#ndrct_adt in dft/indirect.c:40
immutable ndrct_adt_dft_indirect
    apply::Ptr{Void}
    mkcld::Ptr{Void}
    nam::Ptr{Cchar}

    function ndrct_adt_dft_indirect(ap::Function, mk::Function, nam::String)
        na = new(cfunction(ap, Void, (Ptr{plan}, Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}))
                 cfunction(mk, Ptr{problem}, (Ptr{problem_dft},))
                 cstringize(nam))
        return na
    end
end

#S in dft/indirect.c:45
type S_dft_indirect
    super::solver
    adt::Ptr{ndrct_adt_dft_indirect}
end

#P in dft/indirect.c:51
type P_dft_indirect
    super::plan_dft
    cldcpy::Ptr{plan}
    cld::Ptr{plan}
    slv::Ptr{S_dft_indirect}
end

#rearrange then transform
#static void apply_before in dft/indirect.c:55
function apply_before_dft_indirect(ego::Ptr{plan}, ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R})::Void
    ego = unsafe_load(reinterpret(Ptr{P_dft_indirect}, ego))

    cldcpy = reinterpret(Ptr{plan_dft}, ego.cldcpy)
    ccall(unsafe_load(cldcpy).apply,
          Void,
          (Ptr{plan}, Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}),
          ego.cldcpy, ri, ii, ro, io)

    cld = reinterpret(Ptr{plan_dft}, ego.cld)
    ccall(unsafe_load(cld).apply,
          Void,
          (Ptr{plan}, Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}),
          ego.cld, ri, ii, ro, io)

    return nothing
end

#static problem* mkcld_before in dft/indirect.c:69
function mkcld_before_dft_indirect(p::Ptr{problem_dft})::Ptr{problem}
    P = unsafe_load(p)
    return mkproblem_dft_d(tensor_copy_inplace(P.sz, INPLACE_OS),
                           tensor_copy_inplace(P.vecsz, INPLACE_OS),
                           P.ro, P.io, P.ro, P.io)
end

#static const struct ndrct_adt_dft_indirect adt_before in dft/indirect.c:76
const adt_before_dft_indirect = ndrct_adt_dft_indirect(apply_before_dft_indirect, mkcld_before_dft_indirect, "dft-indirect-before")

#transform then rearrange
#static void apply_after in dft/indirect.c:84
function apply_after_dft_indirect(ego::Ptr{plan}, ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R})::Void
    ego = unsafe_load(reinterpret(Ptr{P_dft_indirect}, ego))

    cld = reinterpret(Ptr{plan_dft}, ego.cld)
    ccall(unsafe_load(cld).apply,
          Void,
          (Ptr{plan}, Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}),
          ego.cld, ri, ii, ro, io)

    cldcpy = reinterpret(Ptr{plan_dft}, ego.cldcpy)
    ccall(cldcpy.apply,
          Void,
          (Ptr{plan}, Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}),
          ego.cldcpy, ri, ii, ro, io)

    return nothing
end

#static problem* mkcld_before in dft/indirect.c:98
function mkcld_after_dft_indirect(p::Ptr{problem_dft})::Ptr{problem}
    P = unsafe_load(p)
    return mkproblem_dft_d(tensor_copy_inplace(P.sz, INPLACE_IS),
                           tensor_copy_inplace(P.vecsz, INPLACE_IS),
                           P.ro, P.io, P.ro, P.io)
end

#static const struct ndrct_adt_dft_indirect adt_after in dft/indirect.c:105
const adt_after_dft_indirect = ndrct_adt_dft_indirect(apply_after_dft_indirect, mkcld_after_dft_indirect, "dft-indirect-after")

#static void destroy in dft/indirect.c:111
function destroy_dft_indirect(ego_::Ptr{plan})::Void
    ego = unsafe_load(Ptr{P_dft_indirect}(ego_))
    plan_destroy_internal(ego.cld)
    plan_destroy_internal(ego.cldcpy)
    return nothing
end
    
#static void awake in dft/indirect.c:118
function awake_dft_indirect(ego_::Ptr{plan}, wakefulness::Cint)::Void
    ego = unsafe_load(Ptr{P_dft_indirect}(ego_))
    plan_awake(ego.cldcpy, wakefulness)
    plan_awake(ego.cld, wakefulness)
    return nothing
end

#static void print in dft/indirect.c:125
function print_dft_indirect(ego_::Ptr{plan}, p::Ptr{printer})
    ego = unsafe_load(Ptr{P_dft_indirect}(ego_))
    s = unsafe_load(Ptr{S_dft_indirect}(ego.slv))
    
    ss = Base.unsafe_wrap(String, unsafe_load(s.adt).nam)
    str = "($ss\n  "

    ccall(unsafe_load(p).print,
          Void,
          (Ptr{printer}, Ptr{Cchar}),
          p, str)
#TODO
end

#static int applicable0 in dft/indirect.c:132
function applicable0_dft_indirect(ego_::Ptr{solver}, p_::Ptr{problem}, plnr::Ptr{planner})::Bool
    ego = unsafe_load(Ptr{S_dft_indirect}(ego_))
    p = unsafe_load(Ptr{problem_dft}(p_))

    return (true
            && FINITE_RNK(unsafe_load(p.vecsz).rnk)
            #nontrivial transform
            && unsafe_load(p.sz).rnk > 0
            && (false
                #problem must be in place and require some rearrangement of data
                #also some strides must decrease to prevent infinite loops
                || (p.ri == p.ro
                    && !tensor_inplace_strides2(p.sz, p.vecsz)
                    && tensor_strides_decrease(p.sz, p.vecsz, 
                         unsafe_load(ego.adt).apply == apply_after_dft_indirect ?
                         INPLACE_IS : INPLACE_OS))
                || (p.ri != p.ro && unsafe_load(ego.adt).apply == apply_after_dft_indirect
                    && NO_DESTROY_INPUTP(plnr) != 0
                    && tensor_min_istride(p.sz) <= 2
                    && tensor_min_ostride(p.sz) > 0)
                || (p.ri != p.ro && unsafe_load(ego.adt).apply == apply_before_dft_indirect
                    && tensor_min_ostride(p.sz) <= 2
                    && tensor_min_istride(p.sz) > 2)
               )
           )
end

#static int applicable in dft/indirect.c:173
function applicable_dft_indirect(ego_::Ptr{solver}, p_::Ptr{problem}, plnr::Ptr{planner})::Bool
    if !applicable0_dft_indirect(ego_, p_, plnr)
        return false
    end
    p = unsafe_load(Ptr{problem_dft}(p_))
    if NO_INDIRECT_OP_P(plnr) != 0 && p.ri != p.ro
        return false
    end
    return true
end

#static int mkplan in dft/indirect.c:184
function mkplan_dft_indirect(ego_::Ptr{solver}, p_::Ptr{problem}, plnr::Ptr{planner})::Ptr{plan}
    p = unsafe_load(Ptr{problem_dft}(p_))
    ego = unsafe_load(Ptr{S_dft_indirect}(ego_))
    cld = cldcpy = Ptr{plan}(C_NULL)

    padt = mkplan_adt(dft_solve, awake_dft_indirect, print_dft_indirect, destroy_dft_indirect)

    if !applicable(ego_, p_, plnr)
        return Ptr{plan}(C_NULL)
    end

    cldcpy = mkplan_d(plnr,
                      mkproblem_dft_d(mktensor_0d(),
                                      tensor_append(p.vecsz, p.sz),
                                      p.ri, p.ii, p.ro, p.io))
    if cldcpy == C_NULL
        @goto nada
    end

    cld = mkplan_f_d(plnr, 
                     ccall(unsafe_load(ego.adt).mkcld,
                           Ptr{problem},
                           (Ptr{problem_dft},),
                           Ptr{problem_dft}(p_)),
                     NO_BUFFERING, Cuint(0), Cuint(0))

    if cld == C_NULL
        @goto nada
    end

    pln = MKPLAN_DFT(P_dft_indirect, padt, unsafe_load(ego.adt).apply)
    
    #pln->cld = cld
    #plan* cld at 72 bytes in P_dft_indirect
    pt = reinterpret(Ptr{Ptr{plan}}, pln + 72)
    unsafe_store!(pt, cld)

    #pln->cldcpy = cldcpy
    #plan* cldcpy at 64 bytes in P_dft_indirect
    pt = reinterpret(Ptr{Ptr{plan}}, pln + 64)
    unsafe_store!(pt, cld)

    #pln->slv = ego
    #S* slv at 80 bytes in P_dft_indirect
    pt = reinterpret(Ptr{Ptr{S_dft_indirect}}, pln + 80)
    unsafe_store!(pt, Ptr{S_dft_indirect}(ego_))

    ops_add(reinterpret(Ptr{opcnt}, cld + 8), 
            reinterpret(Ptr{opcnt}, cldcpy + 8), 
            reinterpret(Ptr{opcnt}, pln + 8))

    return reinterpret(Ptr{plan}, pln) 

@label nada
    plan_destroy_internal(cld)
    plan_destroy_internal(cldcpy)
    return Ptr{plan}(C_NULL)
end

#static solver* mksolver in dft/indirect.c:223
function mksolver_dft_indirect(adt::Ptr{ndrct_adt_dft_indirect})::Ptr{solver}
    slv = MKSOLVER(S_dft_indirect, adt)
    
    #slv->adt = adt
    #ndrct_adt* adt at 16 bytes in S_dft_indirect
























