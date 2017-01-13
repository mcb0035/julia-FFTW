#Constructors using C memory allocation
#this is scaffolding that should be removed at some point
#export mkproblem_adt, mkproblem, problem_destroy, mkplan, plan_destroy_internal, plan_null_destroy, plan_awake

#void* X(malloc_plain) in kernel/alloc.c:263
function malloc_plain(n::Csize_t)::Ptr{Void}
    if n == 0
        n = 1
    end
    p = Libc.malloc(n)
    return p
end
#=
function mkproblem_adt(pk::problems, hash::Ptr{Void}, zero::Ptr{Void}, print::Ptr{Void}, destroy::Ptr{Void})::Ptr{problem_adt}
    padt = Ptr{problem_adt}(malloc(sizeof(problem_adt)))
    #problem_kind at 0 bytes in problem_adt
    pt = reinterpret(Ptr{Cint}, padt)
    unsafe_store!(pt, Cint(pk))
    #hash at 8 bytes in problem_adt
    pt = reinterpret(Ptr{Ptr{Void}}, padt + 8)
    unsafe_store!(pt, hash)
    #zero at 16 bytes in problem_adt
    pt = reinterpret(Ptr{Ptr{Void}}, padt + 16)
    unsafe_store!(pt, zero)
    #print at 24 bytes in problem_adt
    pt = reinterpret(Ptr{Ptr{Void}}, padt + 24)
    unsafe_store!(pt, print)
    #destroy at 32 bytes in problem_adt
    pt = reinterpret(Ptr{Ptr{Void}}, padt + 32)
    unsafe_store!(pt, destroy)

    return padt
end

#problem* X(mkproblem) in kernel/problem.c:25
#function mkproblem(sz::Csize_t, adt::Ptr{problem_adt})::Ptr{problem}
function mkproblem(sz::Integer, adt::Ptr{problem_adt})::Ptr{problem}
    p = Ptr{problem}(malloc(sz))
    pt = reinterpret(Ptr{Ptr{problem_adt}}, p)
    unsafe_store!(pt, adt)
    return p
end

#void X(problem_destroy) in kernel/problem.c:34
function problem_destroy(ego::Ptr{problem})::Void
    if ego != C_NULL
        destroy = unsafe_load(unsafe_load(ego).adt).destroy
        ccall(destroy, Void, (Ptr{problem},), ego)
    end
    return nothing
end

#static void unsolvable_destroy in kernel/problem.c:41
function unsolvable_destroy(ego::Ptr{problem})::Void
    return nothing
end

#static void unsolvable_hash in kernel/problem.c:46
function unsolvable_hash(p::Ptr{problem}, m::Ptr{md5})::Void
    md5puts(m, "unsolvable")
    return nothing
end

#static void unsolvable_print in kernel/problem.c:52
function unsolvable_print(ego::Ptr{problem}, p::Ptr{printer})::Void
    unsafe_load(p).print(p, "unsolvable")
    return nothing
end

#static void unsolvable_zero in kernel/problem.c:58
function unsolvable_zero(ego::Ptr{problem})::Void
    return nothing
end=#
#=
#static const padt in kernel/problem.c:63
const padt = problem_adt(PROBLEM_UNSOLVABLE,
                         unsolvable_hash, unsolvable_zero, unsolvable_print, unsolvable_destroy)

the_unsolvable_problem = problem(=#

#=unsolvable_padt = problem_adt(PROBLEM_UNSOLVABLE,
                         cfunction(unsolvable_hash, Void, (Ptr{problem}, Ptr{md5})),
                         cfunction(unsolvable_zero, Void, (Ptr{problem})),
                         cfunction(unsolvable_print, Void, (Ptr{problem}, 
                                                            Ptr{printer})),
                         cfunction(unsolvable_destroy,Void, (Ptr{problem})))=#

#the_unsolvable_problem = problem(pointer_from_objref(unsolvable_padt))

#problem* X(mkproblem_unsolvable) in kernel/problem.c:75
#function mkproblem_unsolvable() = Ref(the_unsolvable_problem)

function plan_adt(s::Function, a::Function, p::Function, d::Function)
    padt = new(cfunction(s, Void, (Ptr{plan}, Ptr{problem})),
               cfunction(a, Void, (Ptr{plan}, Cint)),
               cfunction(p, Void, (Ptr{plan}, Ptr{printer})),
               cfunction(d, Void, (Ptr{plan},)))
    return padt
end

function mkplan_adt(s::Function, a::Function, p::Function, d::Function)::Ptr{plan_adt}
    padt = Ptr{plan_adt}(malloc(sizeof(plan_adt)))

    pt = reinterpret(Ptr{Ptr{Void}}, padt)
    unsafe_store!(pt, cfunction(s, Void, (Ptr{plan}, Ptr{problem})))
    pt = reinterpret(Ptr{Ptr{Void}}, padt + 8)
    unsafe_store!(pt, cfunction(a, Void, (Ptr{plan}, Cint)))
    pt = reinterpret(Ptr{Ptr{Void}}, padt + 16)
    unsafe_store!(pt, cfunction(p, Void, (Ptr{plan}, Ptr{printer})))
    pt = reinterpret(Ptr{Ptr{Void}}, padt + 24)
    unsafe_store!(pt, cfunction(d, Void, (Ptr{plan},)))

    return padt
end
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
=#
#plan* X(mkplan) in kernel/plan.c:28
function mkplan(size::Csize_t, adt::Ptr{plan_adt})
    p = Ptr{plan}(malloc(size))
    
    @assert unsafe_load(adt).destroy != C_NULL

    #plan_adt* adt at 0 bytes in plan
    pt = reinterpret(Ptr{Ptr{plan_adt}}, p)
    unsafe_store!(pt, adt)

    #opcnt ops at 8 bytes in plan
    pt = reinterpret(Ptr{opcnt}, p + 8)
    ops_zero(pt)

    #double pcost at 40 bytes in plan
    pt = reinterpret(Ptr{Cdouble}, p + 40)
    unsafe_store!(pt, Cdouble(0))

    #enum wakefulness (int) wakefulness at 48 bytes in plan
    pt = reinterpret(Ptr{Cint}, p + 48)
    unsafe_store!(pt, Cint(SLEEPY))

    #int could_prune_now_p at 52 bytes in plan
    pt = reinterpret(Ptr{Cint}, p + 52)
    unsafe_store!(pt, Cint(0))

    return p
end

#plan* X(mkplan_d) in kernel/planner.c:969
function mkplan_d(ego::Ptr{planner}, p::Ptr{problem})::Ptr{plan}
#    pln = unsafe_load(unsafe_load(ego).adt).mkplan(ego, p)
    pln = ccall(unsafe_load(unsafe_load(ego).adt).mkplan,
                Ptr{plan},
                (Ptr{planner}, Ptr{problem}),
                ego, p)
    problem_destroy(p)
    return pln
end

#like mkplan_d but sets/resets flags as well
#plan* X(mkplan_f_d) in kernel/planner.c:976
function mkplan_f_d(ego::Ptr{planner}, p::Ptr{problem}, l_set::Cuint, u_set::Cuint, u_reset::Cuint)::Ptr{plan}
    oflags = unsafe_load(ego).flags

    u = (PLNR_U(ego) & ~u_reset) | u_set | l_set
    l = (PLNR_L(ego) & ~u_reset) | l_set
    ff = setflag(oflags, :u, u)
    ff = setflag(ff, :l, l)
    
    #flags_t flags at 216 bytes in planner
    pt = reinterpret(Ptr{flags_t}, ego + 216)
    unsafe_store!(pt, ff)
    
    pln = mkplan_d(ego, p)
    unsafe_store!(pt, oflags)
    return pln
end


    

#=
#void X(plan_destroy_internal) in kernel/plan.c:45
function plan_destroy_internal(ego::Ptr{plan})
    if ego != C_NULL
        @assert unsafe_load(ego).wakefulness == Cint(SLEEPY)
        destroy = unsafe_load(unsafe_load(ego).adt).destroy
        ccall(destroy, Void, (Ptr{plan},), ego)
        free(ego)
    end
    return nothing
end=#

#void X(plan_null_destroy) in kernel/plan.c:54
plan_null_destroy(ego::Ptr{plan})::Void = nothing

#void X(plan_awake) in kernel/plan.c:61
function plan_awake(ego::Ptr{plan}, wakefulness::Cint)::Void
    if ego != C_NULL
        @assert Cint(wakefulness == Cint(SLEEPY)) ⊻ (unsafe_load(ego).wakefulness == Cint(SLEEPY)) != 0 "wakefulness: $wakefulness, ego.wakefulness: $(unsafe_load(ego).wakefulness)"
        awake = unsafe_load(unsafe_load(ego).adt).awake
        ccall(awake, Void, (Ptr{plan}, Cint), ego, wakefulness)

        #enum wakefulness (int) wakefulness at 48 bytes in plan
        pt = reinterpret(Ptr{Cint}, ego + 48)
        unsafe_store!(pt, wakefulness)
    end
    return nothing
end


#=
#planner* X(mkplanner) in kernel/planner.c:911
function mkplanner()::Ptr{planner}
    #fill planner_adt
    padt = Ptr{planner_adt}(malloc(sizeof(planner_adt)))
    pt = reinterpret(Ptr{Void}, padt)
    unsafe_store!(pt, cfunction(register_solver, Void, (Ptr{planner}, Ptr{solver})))
    unsafe_store!(pt + 8, cfunction(mkplan, Ptr{plan}, (Ptr{planner}, Ptr{problem})))
    unsafe_store!(pt + 16, cfunction(forget, Void, (Ptr{planner}, amnesia)))
    unsafe_store!(pt + 24, C_NULL)
    unsafe_store!(pt + 32, C_NULL)

#=    padt = planner_adt(cfunction(register_solver, Void, (Ptr{planner}, Ptr{solver})),
                       cfunction(mkplan, Ptr{plan}, (Ptr{planner}, Ptr{problem})),
                       cfunction(forget, Void, (Ptr{planner}, amnesia)),
                       C_NULL,
                       C_NULL)=#

    p = Ptr{planner}(malloc(sizeof(planner))) 
    
    #planner_adt* adt at 0 bytes in planner
    pt = reinterpret(Ptr{Ptr{planner_adt}}, p)
    unsafe_store!(pt, padt)

    #func* hook at 8 bytes in planner
    pt = reinterpret(Ptr{Void}, p + 8)
    unsafe_store!(pt, C_NULL)
    #func* cost_hook at 16 bytes in planner
    pt = reinterpret(Ptr{Void}, p + 16)
    unsafe_store!(pt, C_NULL)
    #func* wisdom_ok_hook at 24 bytes in planner
    pt = reinterpret(Ptr{Void}, p + 24)
    unsafe_store!(pt, C_NULL)
    #func* nowisdom_hook at 32 bytes in planner
    pt = reinterpret(Ptr{Void}, p + 32)
    unsafe_store!(pt, C_NULL)
    #func* bogosity_hook at 40 bytes in planner
    pt = reinterpret(Ptr{Void}, p + 40)
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

    return p
end=#
























































