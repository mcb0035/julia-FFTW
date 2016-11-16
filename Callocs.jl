#Constructors using C memory allocation
#this is scaffolding that should be removed at some point

#problem* X(mkproblem) in kernel/problem.c:25
function mkproblem(sz::Csize_t, adt::Ptr{problem_adt})::Ptr{problem}
    p = Ptr{problem}(malloc(sz))
    reinterpret(Ptr{problem_adt}, p)
    unsafe_store!(p, adt)
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
end
#=
#static const padt in kernel/problem.c:63
const padt = problem_adt(PROBLEM_UNSOLVABLE,
                         unsolvable_hash,
                         unsolvable_zero,
                         unsolvable_print,
                         unsolvable_destroy)

the_unsolvable_problem = problem(=#

const padt = problem_adt(PROBLEM_UNSOLVABLE,
                         cfunction(unsolvable_hash, Void, (Ptr{problem}, Ptr{md5})),
                         cfunction(unsolvable_zero, Void, (Ptr{problem})),
                         cfunction(unsolvable_print, Void, (Ptr{problem}, 
                                                            Ptr{printer})),
                         cfunction(unsolvable_destroy,Void, (Ptr{problem})))

the_unsolvable_problem = problem(Ref(padt))

#problem* X(mkproblem_unsolvable) in kernel/problem.c:75
function mkproblem_unsolvable() = Ref(the_unsolvable_problem)

#planner* X(mkplanner) in kernel/planner.c:911
function mkplanner()::Ptr{planner}
    

end




























