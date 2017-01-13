#=
function mksolver_adt(p::problems, mkp::Function, des::Function)::Ptr{solver_adt}
    sadt = Ptr{solver_adt}(malloc(sizeof(solver_adt)))
    #problems (int) p at 0 bytes in solver_adt
    pt = reinterpret(Ptr{Cint}, sadt)
    unsafe_store!(pt, Cint(p))
    #void* mkplan at 8 bytes in solver_adt
    pt = reinterpret(Ptr{Ptr{Void}}, sadt + 8)
    unsafe_store!(pt, cfunction(mkp, Ptr{plan}, (Ptr{solver}, Ptr{problem}, Ptr{planner})))
    #void* destroy at 16 bytes in solver_adt
    pt = reinterpret(Ptr{Ptr{Void}}, sadt + 16)
    unsafe_store!(pt, cfunction(des, Void, (Ptr{solver},)))

    return sadt
end

function mksolver_adt(p::problems, mkp::Function, des::Ptr{Void})::Ptr{solver_adt}
    sadt = Ptr{solver_adt}(malloc(sizeof(solver_adt)))
    #problems (int) p at 0 bytes in solver_adt
    pt = reinterpret(Ptr{Cint}, sadt)
    unsafe_store!(pt, Cint(p))
    #void* mkplan at 8 bytes in solver_adt
    pt = reinterpret(Ptr{Ptr{Void}}, sadt + 8)
    unsafe_store!(pt, cfunction(mkp, Ptr{plan}, (Ptr{solver}, Ptr{problem}, Ptr{planner})))
    #void* destroy at 16 bytes in solver_adt
    pt = reinterpret(Ptr{Ptr{Void}}, sadt + 16)
    unsafe_store!(pt, des)

#    print_with_color(:blue, "mksolver_adt: solver_adt:\n")
#    show(unsafe_load(sadt))
    return sadt
end
=#
function mksolver_adt(p::problems, mkp::Ptr{Void}, des::Ptr{Void})::Ptr{solver_adt}
    sadt = Ptr{solver_adt}(malloc(sizeof(solver_adt)))
    #problems (int) p at 0 bytes in solver_adt
    pt = reinterpret(Ptr{Cint}, sadt)
    unsafe_store!(pt, Cint(p))
    #void* mkplan at 8 bytes in solver_adt
    pt = reinterpret(Ptr{Ptr{Void}}, sadt + 8)
    unsafe_store!(pt, mkp)
    #void* destroy at 16 bytes in solver_adt
    pt = reinterpret(Ptr{Ptr{Void}}, sadt + 16)
    unsafe_store!(pt, des)

#    print_with_color(:blue, "mksolver_adt: solver_adt:\n")
#    show(unsafe_load(sadt))
    return sadt
end

#solver* X(mksolver) in kernel/solver.c:24
function mksolver(siz::Integer, adt::Ptr{solver_adt})::Ptr{solver}
    s = Ptr{solver}(malloc(siz))

    #s->adt = adt
    #solver_adt* at 0 bytes in solver
    pt = reinterpret(Ptr{Ptr{solver_adt}}, s)
    unsafe_store!(pt, adt)

    #s->refcnt = 0
    #int refcnt at 8 bytes in solver
    pt = reinterpret(Ptr{Cint}, s + 8)
    unsafe_store!(pt, Cint(0))

    return s
end

#macro in kernel/ifftw.h:612
function MKSOLVER(t, adt::Ptr{solver_adt})::Ptr{t}
    return Ptr{t}(mksolver(sizeof(t), adt))
end

#void X(solver_use) in kernel/solver.c:33
function solver_use(ego::Ptr{solver})::Void
    #ego.refcnt += 1
    rc = unsafe_load(ego).refcnt + 1
    #int refcnt at 8 bytes in solver
    pt = reinterpret(Ptr{Cint}, ego + 8)
    unsafe_store!(pt, rc)
    return nothing
end

#void X(solver_destroy) in kernel/solver.c:38
function solver_destroy(ego::Ptr{solver})::Void
    if unsafe_load(ego).refcnt == 1
        if unsafe_load(unsafe_load(ego).adt).destroy != C_NULL
            ccall(unsafe_load(unsafe_load(ego).adt).destroy,
                  Void,
                  (Ptr{solver},),
                  ego)
        end
        free(ego)
    end
    return nothing
end

#void X(solver_register) in kernel/solver.c:47
function solver_register(plnr::Ptr{planner}, s::Ptr{solver})::Void
    ccall(unsafe_load(unsafe_load(plnr).adt).register_solver,
          Void,
          (Ptr{planner}, Ptr{solver}),
          plnr, s)
    return nothing
end
