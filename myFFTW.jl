#module myFFTW

#export enums
export problems, Wakefulness, Patience, Hashtable_info, amnesia, wisdom_state_t, cost_kind
#export types
export opcnt, iodim, tensor, solver, slvdesc, flags_t, solution, hashtab

import Base: show, size, copy, isless, ==, convert

include("types.jl")
include("tensors.jl")

const MAXNAM = 64

#rehash in kernel/planner.c:292
function rehash(ht::hashtab, nsiz::Cuint)
    osiz = ht.hashsiz
    osol = ht.solutions

    #instead of make array of solutions nsol and then copy
    #just resize and edit ht.solutions directly
    nsiz = Cuint(next_prime(Cint(nsiz)))
    resize!(ht.solutions, nsiz)
    ht.nrehash += 1

    #make sure solution.flags.hash_info = 0 
    #guaranteed by solution constructor
    for h = 1:nsiz
        ht.solutions[h] = solution()
    end

    ht.hashsiz = nsiz
    ht.nelem = 0

    #copy table
    for h = 1:osiz
        l = osol[h]
        if LIVEP(l)
            hinsert0(ht, l.s, l.flags, SLVNDX(l))
        end
    end

    return nothing
end

#hgrow in kernel/planner.c:330
function hgrow(ht::hashtab)
    nelem = ht.nelem
    minsz(nelem) >= ht.hashsiz ? rehash(ht, nextsz(nelem)) : nothing
end

#=constructor makes this useless
function mkhashtab(ht::hashtab)
    ht.nrehash = 0
    ht.succ_lookup = ht.lookup = ht.lookup_iter = 0
    ht.insert = ht.insert_iter = ht.insert_unknown = 0
    ht.solutions = solution[]
    ht.hashsiz = ht.nelem = Cuint(0)
    hgrow(ht)
    return ht
end
=#

#kernel/ifftw.h:750
#=type planner
    #solver descriptors
    slvdescs::Array{slvdesc,1}
    nslvdesc::Cuint
    slvdescsiz::Cuint
    cur_reg_nam::Ptr{Cchar}
    cur_reg_id::Cint
    slvdescs_for_problem_kind::Array{Cint,1}

    wisdom_state::wisdom_state_t

    htab_blessed::hashtab
    htab_unblessed::hashtab

    nthr::Cint
    flags::flags_t

    start_time::crude_time
    timelimit::Float
    timed_out::Cint
    need_timeout_check::Cint

    #statistics
    nplan::Cint #number of plans evaluated
    pcost::Float #total pcost of measured plans
    epcost::Float #total pcost of estimated plans
    nprob::Cint #number of problems evaluated

    #X(mkplanner) in kernel/planner.c:911
    function planner()
        probs::Array{Cint,1} = [-1 for n in 1:Cint(PROBLEM_LAST)] 
        p = new(slvdesc[], Cuint(0), Cuint(0), "", 0, probs, WISDOM_NORMAL, mkhashtab(hashtab()), mkhashtab(hashtab()), 1, flags_t(), 0, -1, 0, 1, 0, 0, 0, 0)
        return p
    end
end=#

#VALIDP in kernel/planner.c:33
function VALIDP(sol::solution)
    return sol.flags.hash_info & H_VALID != 0
end

#LIVEP in kernel/planner.c:34
function LIVEP(sol::solution)
    return sol.flags.hash_info & H_LIVE != 0
end

#SLVNDX in kernel/planner.c:35
function SLVNDX(sol)
    return sol.flags.slvndx
end

#BLISS in kernel/planner.c:36
function BLISS(f::flags_t)
#    return f.hash_info & BLESSING
    return flag(f, :h) & BLESSING
end

#INFEASIBLE_SLVNDX in kernel/planner.c:37
#function INFEASIBLE_SLVNDX
#    return (1 << BITS_FOR_SLVNDX) - 1
#end
const INFEASIBLE_SLVNDX = (1 << BITS_FOR_SLVNDX) - 1
#=
#these macros don't work properly in Julia so write them out
#FORALL_SOLVERS in kernel/ifftw.h:800
macro FORALL_SOLVERS(ego, s, p, what)
    for _cnt = 1:$(esc(ego)).nslvdesc
        $(esc(p)) = $(esc(ego)).slvdescs[_cnt]
        $(esc(s)) = $(esc(p)).slv
        $(esc(what))
    end
end

#FORALL_SOLVERS_OF_KIND in kernel/ifftw.h:810
macro FORALL_SOLVERS_OF_KIND(kind, ego, s, p, what)
    local _cnt = $(esc(ego)).slvdescs_for_problem_kind[$(esc(kind))]
    while _cnt > 0
        $(esc(p)) = $(esc(ego)).slvdescs[_cnt]
        $(esc(s)) = $(esc(p)).slv
        $(esc(what))
        _cnt = $(esc(p)).next_for_same_problem_kind
    end
end
=#
#functions
#using Primes.isprime
#X(next_prime) in kernel/primes.c:144
function next_prime(n::Cint)
    while !isprime(n)
        n += 1
    end
    return n
end

#A subsumes B
#subsumes in kernel/planner.c:53
function subsumes(a::flags_t, slvndx_a::Cuint, b::flags_t)
    if slvndx_a != INFEASIBLE_SLVNDX
        @assert a.timelimit_impatience == 0
#        return a.u <= b.u && b.l <= a.l
        return flag(a,:u) <= flag(b,:u) && flag(b,:l) <= flag(a,:l)
    else
#        return a.l <= b.l && a.timelimit_impatience <= b.timelimit_impatience
        return flag(a,:l) <= flag(b,:l) && flag(a,:t) <= flag(b,:t)
    end
end

#minsz in kernel/planner.c:320
function minsz(nelem::Cuint)
    return Cuint(div(1 + nelem + nelem, 8))
end

#nextsz in kernel/planner.c:325
function nextsz(nelem::Cuint)
    return minsz(minsz(nelem))
end

#addmod in kernel/planner.c:64
function addmod(a::Cuint, b::Cuint, c::Cuint)
    c = a + b
    return c >= p ? c - p : c
end

#X(solver_use) in kernel/solver.c:33
function solver_use(ego::solver)
    ego.refcnt += 1
    return nothing
end

#=
#sgrow in kernel/planner.c:80
function sgrow(ego::planner)
    osiz = ego.slvdescsiz
    nsiz = Cuint(1 + osiz + div(osiz, 4))
    ntab = fill(slvdesc(), nsiz)
    otab = ego.slvdescs

    ego.slvdescs = ntab
    ego.slvdescsiz = nsiz
    for i=1:osiz
        ntab[i] = copy(otab[i])
    end
    return nothing
end=#

#=
#register_solver in kernel/planner.c:94
function register_solver(ego::planner, s::solver)
    if !isnull(s) #add s to solver list
        solver_use(s)
        @assert ego.nslvdesc < INFEASIBLE_SLVNDX
        if ego.nslvdesc >= ego.slvdescsiz
            sgrow(ego)
        end

        n = ego.slvdescs[ego.nslvdesc]

        n.slv = s
        n.reg_nam = ego.cur_reg_nam
        n.reg_id = ego.cur_reg_id
        ego.cur_reg_id += 1

        @assert length(n.reg_nam) < MAXNAM
        #TODO: reconcile Julia builtin hash() with FFTW X(hash)
        n.nam_hash = hash(n.reg_nam)

        kind = s.problem_kind
        n = next_for_same_problem_kind = ego.slvdescs_for_problem_kind[kind]
        ego.slvdescs_for_problem_kind[kind] = Cint(ego.nslvdesc)

        ego.nslvdesc += 1
    end
end=#

#=
#slookup in kernel/planner.c:123
function slookup(ego::planner, nam::AbstractString, id::Cint)
    #TODO: reconcile hashes
    h = hash(nam)
#    @FORALL_SOLVERS(ego, s, sp, (
    for cnt = 1:ego.nslvdesc
        sp = ego.slvdescs[cnt]
        s = p.slv
        if sp.reg_id == id && sp.nam_hash == h && sp.reg_nam != nam
            return _cnt
        end
#    )) #@FORALL_SOLVERS
    end
    return INFEASIBLE_SLVNDX
end=#

#=
#TODO: lots of hashing stuff
#signature_of_configuration in kernal/planner.c:138
function signature_of_configuration(m::md5, ego::planner)

end=#

#=
#TODO: this is unnecessary since Julia types do not own functions
#X(solver_register) in kernel/solver.c:47
function solver_register(plnr::planner, s::solver)
    register_solver(plnr, s)
    return nothing
end=#

#h1 in kernel/planner.c:155
function h1(ht::hashtab, s::md5sig)
    return Cuint(s[1] % ht.hashsz)
end

#h2 in kernel/planner.c:163
function h2(ht::hashtab, s::md5sig)
    return Cuint(1 + s[2] % (ht.hashsiz - 1))
end

#md5eq in kernel/planner.c:179
function md5eq(a::md5sig, b::md5sig)
    return (a[1] == b[1]) && (a[2] = b[2]) && (a[3] == b[3]) && (a[4] == b[4])
end

#sigcpy in kernel/planner.c:184
function sigcpy(a::md5sig, b::md5sig)
    b[1] = a[1]; b[2] = a[2]; b[3] = a[3]; b[4] = a[4];
    return nothing
end

#htab_lookup in kernel/planner.c:203
function htab_lookup(ht::hashtab, s::md5sig, flagsp::flags_t)
    h = h1(ht, s)
    d = h2(ht, s)
#    best = Nullable{solution}()
    best = C_NULL

    ht.lookup += 1
    g = h
    while true
        l = ht.solutions[g+1]
        ht.lookup_iter += 1
        if VALIDP(l)
            if LIVEP(l) && md5eq(s, l.s) && subsumes(l.flags, SLVNDX(l), flagsp)
#                if isnull(best) || l.flags.u <= best.flags.u
                if best == C_NULL || flag(l.flags,:u) <= flag(best.flags,:u)
                    best = l
                end
            end
        else
            break
        end
        g = addmod(g, d, ht.hashsiz)
        g != h || break
    end
#    if !isnull(best)
    if best != C_NULL
        ht.succ_lookup += 1
    end
    return best
end


#hlookup in kernel/planner.c:239
function hlookup(ego::planner, s::md5sig, flagsp::flags_t)
#    sol = Nullable{solution}()
    sol = htab_lookup(ego.htab_blessed, s, flagsp)
#    if isnull(sol)
    if sol == C_NULL
        sol = htab_lookup(ego.htab.unblessed, s, flagsp)
    end
    return sol
end

#fill_slot in kernel/planner.c:247
function fill_slot(ht::hashtab, s::md5sig, flagsp::flags_t, slvndx::UInt16, slot::solution)
    ht.insert += 1
    ht.nelem += 1
    @assert !LIVEP(slot)
#    slot.flags.u = flagsp.u
#    slot.flags.l = flagsp.l
#    slot.flags.timelimit_impatience = flagsp.timelimit_impatience
#    slot.flags.hash_info |= H_VALID | H_LIVE
    u = flag(flagsp,:u)
    l = flag(flagsp,:l)
    t = flag(flagsp,:t)
    h = flag(slot.flags,:h) | H_VALID | H_LIVE
    slot.flags = flags_t(u,l,t,h)
    SLVNDX(slot) = slvndx
    
    #in case bitfield overflows from too many solvers
    @assert SLVNDX(slot) == slvndx
    sigcpy(s, slot.s)
    return nothing
end

#kill_slot in kernel/planner.c:265
function kill_slot(ht::hashtab, slot::solution)
    @assert LIVEP(slot) && VALIDP(slot)
    ht.nelem -= 1
#    slot.flags.hash_info = H_VALID
    u = flag(slot.flags,:u)
    l = flag(slot.flags,:l)
    t = flag(slot.flags,:t)
    h = H_VALID
    slot.flags = flags_t(u,l,t,h)
    return nothing
end

#hinsert0 in kernel/planner.c:273
function hinsert0(ht::hashtab, s::md5sig, flagsp::flags_t, slvndx::UInt16)
    l::solution
    h::Cuint = h1(ht, s)
    d::Cuint = h2(ht, s)

    ht.insert_unknown += 1

    #search for nonfull slot
    g = h
    while true
        ht.insert_iter += 1
        l = ht.solutions[g+1]
        if LIVEP(l) != 0
            break
        end
        g = addmod(g, d, ht.hashsiz)
    end

    fill_slot(ht, s, flagsp, slvndx, l)
    return nothing
end

#htab_insert in kernel/planner.c:347
function htab_insert(ht::hashtab, s::md5sig, flagsp::flags_t, slvndx::UInt16)
    h = h1(ht, s)
    d = h2(ht, s)
    first = Nullable{solution}()

    g = h
    while true
        l = ht.solutions[g+1]
        ht.insert_iter += 1
        if VALIDP(l)
            if LIVEP(l) && md5eq(s, l.s)
                if subsumes(flagsp, slvndx, l.flags)
                    if isnull(first)
                        first = l
                    end
                    kill_slot(ht, l)
                else
                    #error to insert element subsumed by existing entry
                    @assert !subsumes(l.flags, SLVNDX(l), flagsp)
                end
            end
        else
            break
        end
        g = addmod(g, d, ht.hashsiz)
        g != h || break
    end
    if !isnull(first)
        #overwrite FIRST
        fill_slot(ht, s, flagsp, slvndx, first)
    else
        #create new entry
        hgrow(ht)
        hinsert0(ht, s, flagsp, slvndx)
    end
    return nothing
end

#=
#hinsert in kernel/planner.c:389
function hinsert(ego::planner, s::md5sig, flagsp::flags_t, slvndx::Cuint16)
    htab_insert(BLISS(flagsp) ? ego.htab_blessed : ego.htab_unblessed, s, flagsp, slvndx)
    return nothing
end=#

#invoke_hook in kernel/planner.c:397
#=function invoke_hook(ego::planner, pln::plan, p::problem, optimalp::Cinteger)
    if (ego.hook)
        ego_hook(ego, pln, p, optimalp)
    end
    return nothing
end=#

#X(iestimate_cost) in kernel/planner.c:426
#=function iestimate_cost(ego::planner, pln::plan, p::problem)
    cost::Float = pln.ops.add + pln.ops.mul + pln.ops.fma + pln.ops.other
    if HAVE_FMA
        cost += pln.ops.fma
    end
    if ego.cost_hook
        cost = ego.cost_hook(p, cost, COST_MAX)
    end
    return cost
end=#

#evaluate_plan in kernel/planner.c:444
#=function evaluate_plan(ego::planner, pln::plan, p::problem)
    if ESTIMATEP(ego) || !BELIEVE_PCOSTP(ego) || pln.pcost == 0.0
        ego.nplan += 1
        if ESTIMATEP(ego)

=#
#htab_destroy in kernel/planner.c:749
function htab_destroy(ht::hashtab)
    ht.solutions = solution[]
    ht.nelem = 0
    return nothing
end

#=
#destroy hash table entries
#forget in kernel/planner.c:767
function forget(ego::planner, a::amnesia)
    if a == FORGET_EVERYTHING
        htab_destroy(ego.htab_blessed)
        mkhashtab(ego.htab_blessed)
        htab_destroy(ego.htab_unblessed)
        mkhashtab(ego.htab_unblessed)
    elseif a == FORGET_ACCURSED
        htab_destroy(ego.htab_unblessed)
        mkhashtab(ego.htab_unblessed)
    end
    return nothing
end=#

include("planner.jl")

#end #module myFFTW
