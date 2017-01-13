
#macro in kernel/twiddle.c:27
const HASHSZ = Cint(109)

#hash table of known twiddle factors
#static twid* twilist[HASHSZ] in kernel/twiddle.c:30
twlist = fill(twid(), HASHSZ)

#static INT hash in kernel/twiddle.c:32
function hash(n::INT, r::INT)::INT
    h = n*17 + r
    if h < 0
        h = -h
    end
    return h%HASHSZ
end

#static int equal_instr in kernel/twiddle.c:41
function equal_instr(p::Ptr{tw_instr}, q::Ptr{tw_instr})::Bool
    if p == q
        return true
    end

    pt = p
    qt = q
    while true
        if unsafe_load(pt).op != unsafe_load(qt).op
            return false
        end

        op = unsafe_load(pt)
        pv = unsafe_load(pt).v
        qv = unsafe_load(qt).v

        if op == TW_NEXT
            return pv == qv #ignore p->i
        elseif op == TW_FULL || op == TW_HALF
            if pv != qv
                return false #ignore p->i
            end
        else
            if pv != qv || unsafe_load(pt).i != unsafe_load(qt).i
                return false
            end
        end

        pt += sizeof(tw_instr)
        qt += sizeof(tw_instr)
    end
    @assert false #should never happen
end

#static int ok_twid in kernel/twiddle.c:67
function ok_twid(t::Ptr{twid}, wakefulness::Cint, q::Ptr{tw_instr}, n::INT, r::INT, m::INT)::Bool
    tt = unsafe_load(t)
    return (wakefulness == tt.wakefulness
            && n == tt.n
            && r == tt.r
            && m <= tt.m
            && equal_instr(tt.instr, q))
end

#static twid* lookup in kernel/twiddle.c:78
function lookup(wakefulness::Cint, q::Ptr{tw_instr}, n::INT, r::INT, m::INT)::Ptr{twid}
    while true
        p = twlist[hash(n,r)]
        (p != C_NULL && !ok_twid(p, wakefulness, q, n, r, m)) || break
        p = unsafe_load(p).cdr
    end
    return p
end

#static INT twlen0 in kernel/twiddle.c:90
function twlen0(r::INT, p::Ptr{tw_instr}, vl::Ptr{INT})::INT
    ntwiddle = INT(0)

    #compute length of bytecode program
    @assert r > 0
    
    pt = p
    while true
        op = unsafe_load(pt).op
        op != TW_NEXT || break
        if op == TW_FULL
            ntwiddle += (r - 1)*2
        elseif op == TW_HALF
            ntwiddle += (r - 1)
        elseif op == TW_CEXP
            ntwiddle += 2
        elseif op == TW_COS || op == TW_SIN
            ntwiddle += 1
        end
        pt += sizeof(tw_instr)
    end
    unsafe_store!(INT(unsafe_load(pt).v))
    return ntwiddle
end

function twlen0(r::INT, p::Ptr{tw_instr})
    ntwiddle = INT(0)

    #compute length of bytecode program
    @assert r > 0
    
    pt = p
    while true
        op = unsafe_load(pt).op
        op != TW_NEXT || break
        if op == TW_FULL
            ntwiddle += (r - 1)*2
        elseif op == TW_HALF
            ntwiddle += (r - 1)
        elseif op == TW_CEXP
            ntwiddle += 2
        elseif op == TW_COS || op == TW_SIN
            ntwiddle += 1
        end
        pt += sizeof(tw_instr)
    end
    return ntwiddle, INT(unsafe_load(pt).v)
end

#INT X(twiddle_length) in kernel/twiddle.c:118
function twiddle_length(r::INT, p::Ptr{tw_instr})::INT
#    vl = Ptr{INT}(malloc(sizeof(INT)))
#    rv = twlen0(r, p, vl)
#    free(vl)
#    return rv
    return twlen0(r, p)[1]
end

#static R* compute in kernel/twiddle.c:124
function compute(wakefulness::Cint, instr::Ptr{tw_instr}, n::INT, r::INT, m::INT)::Ptr{R}
    t = mktriggen(wakefulness, n)

    p = instr
    ntwiddle, vl = twlen0(r, p)

    @assert m % vl == 0

    W0 = Ptr{R}(malloc(ntwiddle * m / vl * sizeof(R)))
    W = Ptr{R}(malloc(ntwiddle * m / vl * sizeof(R)))

    for j=0:vl:m-1
        while unsafe_load(p).op != TW_NEXT
            if unsafe_load(p).op == TW_FULL
                for i=1:r-1
                    @assert(j + INT(unsafe_load(p).v)*i < n)
                    @assert(j + INT(unsafe_load(p).v)*i > -n)
                    ccall(unsafe_load(t).cexp, Void, (Ptr{triggen}, INT, Ptr{R}),
                          t, j + INT(unsafe_load(p).v)*i, W)
                    W += 2 * sizeof(R)
                end
            elseif unsafe_load(p).op == TW_HALF
                @assert r % 2 == 1
                i = 1
                while i + i < r
                     ccall(unsafe_load(t).cexp, Void, (Ptr{triggen}, INT, Ptr{R}),
                           t, MULMOD(i, j + INT(unsafe_load(p).v, n), W))
                     W += 2 * sizeof(R)
                     i += 1
                end
            elseif unsafe_load(p).op == TW_COS
                d = zeros(R, 2)
                @assert j + INT(unsafe_load(p).v) * unsafe_load(p).i < n
                @assert j + INT(unsafe_load(p).v) * unsafe_load(p).i > -n
                ccall(unsafe_load(t).cexp, Void, (Ptr{triggen}, INT, Ptr{R}),
                      t, j + INT(unsafe_load(p).v)*INT(unsafe_load(p).i), d)
                unsafe_store!(W, d[0])
                W += 2 * sizeof(R)
            elseif unsafe_load(p).op == TW_SIN
                d = zeros(R, 2)
                @assert j + INT(unsafe_load(p).v) * unsafe_load(p).i < n
                @assert j + INT(unsafe_load(p).v) * unsafe_load(p).i > -n
                ccall(unsafe_load(t).cexp, Void, (Ptr{triggen}, INT, Ptr{R}),
                      t, j + INT(unsafe_load(p).v)*INT(unsafe_load(p).i), d)
                unsafe_store!(W, d[1])
                W += 2 * sizeof(R)
            elseif unsafe_load(p).op == TW_CEXP
                @assert j + INT(unsafe_load(p).v) * unsafe_load(p).i < n
                @assert j + INT(unsafe_load(p).v) * unsafe_load(p).i > -n
                ccall(unsafe_load(t).cexp, Void, (Ptr{triggen}, INT, Ptr{R}),
                      t, j + INT(unsafe_load(p).v)*INT(unsafe_load(p).i), W)
                unsafe_store!(W, d[1])
                W += 2 * sizeof(R)
            end

            p += sizeof(tw_instr)
        end
    end

    triggen_destroy(t)
    return W0
end

#static void mktwiddle in kernel/twiddle.c:197
function mktwiddle(wakefulness::Cint, pp::Ptr{Ptr{twid}}, instr::Ptr{tw_instr}, n::INT, r::INT, m::INT)::Void
    p = lookup(wakefulness, instr, n, r, m)
    if p != C_NULL
        #++p->refcnt
        #int refcnt at 32 bytes in twid
        pt = Ptr{Cint}(p + 32)
        unsafe_store!(pt, unsafe_load(p).refcnt + 1)
    else
        p = Ptr{twid}(malloc(sizeof(twid)))
        #p->n = n
        #INT n at 8 bytes in twid
        pt = Ptr{INT}(p + 8)
        unsafe_store!(pt, n)
        #p->r = r
        #INT r at 16 bytes in twid
        pt = Ptr{INT}(p + 16)
        unsafe_store!(pt, r)
        #p->m = m
        #INT m at 24 bytes in twid
        pt = Ptr{INT}(p + 24)
        unsafe_store!(pt, m)
        #p->instr = instr
        #tw_instr* instr at 40 bytes in twid
        pt = Ptr{Ptr{tw_instr}}(p + 40)
        unsafe_store!(pt, instr)
        #p->refcnt = 1
        #int refcnt at 32 bytes in twid
        pt = Ptr{Cint}(p + 32)
        unsafe_store!(pt, Cint(1))
        #p->wakefulness = wakefulness
        #int wakefulness at 56 bytes in twid
        pt = Ptr{Cint}(p + 56)
        unsafe_store!(pt, wakefulness)
        #p->W = compute(wakefulness, instr, n, r, m)
        #R* W at 0 bytes in twid
        pt = Ptr{Ptr{R}}(p)
        unsafe_store!(pt, compute(wakefulness, instr, n, r, m))
                   
        h = hash(n, r)
        #p->cdr = twlist[h]
        #twid* cdr at 48 bytes in twid
        pt = Ptr{Ptr{twid}}(p + 48)
        unsafe_store!(pt, twlist[h + 1])
        twlist[h + 1] = p
    end

    unsafe_store!(pp, p)
    return nothing
end
#=
#static void twiddle_destroy in kernel/twiddle.c:224
function twiddle_destroy(pp::Ptr{Ptr{twid}})::Void
    p = unsafe_load(pp)

    #int refcnt at 32 bytes in twid
    pt = Ptr{Cint}(p + 32)
    unsafe_store!(pt, unsafe_load(p).refcnt - 1)
    if unsafe_load(p).refcnt == 0
        #remove p from twiddle list
        for 
=#



















        
