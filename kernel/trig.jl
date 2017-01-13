
#macro by2pi in kernel/trig.c:50
by2pi(m, n) = 2π*m/n

#static void real_cexp in kernel/trig.c:57
function real_cexp(m::INT, n::INT, out::Ptr{trigreal})::Void
    octant = Cuint(0)
    quarter_n = n

    nn = n
    nn += 2n
    mm = m
    mm += 2m

    if mm < 0
        mm += nn
    end
    if mm > nn - mm
        mm = nn - mm
        octant |= 4
    end
    if mm - quarter_n > 0
        mm = mm - quarter_n
        octant |= 2
    end
    if mm > quarter_n - mm
        mm = quarter_n - mm
        octant |= 1
    end
    
    theta = by2pi(m, n)
    c = cos(theta)
    s = sin(theta)

    if octant & 1 != 0
        t = c
        c = s
        s = t
    end
    if octant & 2 != 0
        t = c
        c = -s
        s = t
    end
    if octant & 4 != 0
        s = -s
    end

    unsafe_store!(out, trigreal(c))
    unsafe_store!(out + sizeof(trigreal), trigreal(s))
    return nothing
end

#static INT choose_twshft in kernel/trig.c:82
function choose_twshft(n::INT)::INT
    log2r = INT(0)
    while n > 0
        log2r += 1
        n = div(n, 4)

    end
    return log2r
end

#static void cexpl_sqrtn_table in kernel/trig.c:92
function cexpl_sqrtn_table(p::Ptr{triggen}, m::INT, res::Ptr{trigreal})::Void
    mm = m
    pp = unsafe_load(p)
    mm += pp.n * INT(m < 0)

    m0 = mm & pp.twmsk
    m1 = mm >> pp.twshft
    wr0 = trigreal(unsafe_load(pp.W0, 2*m0 + 1))
    wi0 = trigreal(unsafe_load(pp.W0, 2*m0 + 2))
    wr1 = trigreal(unsafe_load(pp.W1, 2*m0 + 1))
    wi1 = trigreal(unsafe_load(pp.W1, 2*m0 + 2))

    unsafe_store!(res, wr1*wr0 - wi1*wi0)
    unsafe_store!(res + sizeof(trigreal), wi1*wr0 + wr1*wi0)
    return nothing
end

#multiply xr, xi by exp(FFT_SIGN * 2πim/n)
#static void rotate_sqrtn_table in kernel/trig.c:110
function rotate_sqrtn_table(p::Ptr{triggen}, m::INT, xr::R, xi::R, res::Ptr{R})::Void
    mm = m
    pp = unsafe_load(p)
    mm += pp.n * INT(m < 0)

    m0 = mm & pp.twmsk
    m1 = mm >> pp.twshft
    wr0 = trigreal(unsafe_load(pp.W0, 2*m0 + 1))
    wi0 = trigreal(unsafe_load(pp.W0, 2*m0 + 2))
    wr1 = trigreal(unsafe_load(pp.W1, 2*m0 + 1))
    wi1 = trigreal(unsafe_load(pp.W1, 2*m0 + 2))
    wr = wr1*wr0 - wi1*wi0
    wi = wi1*wr0 + wr1*wi0

    if FFT_SIGN == -1
        unsafe_store!(res, xr*wr + xi*wi)
        unsafe_store!(res + sizeof(trigreal), xi*wr - xr*wi)
    else
        unsafe_store!(res, xr*wr - xi*wi)
        unsafe_store!(res + sizeof(trigreal), xi*wr + xr*wi)
    end
    return nothing
end

#static void cexpl_sincos in kernel/trig.c:134
function cexpl_sincos(p::Ptr{triggen}, m::INT, res::Ptr{trigreal})::Void
    return real_cexp(m, unsafe_load(p).n, res)
end

#static void cexp_zero in kernel/trig.c:139
function cexp_zero(p::Ptr{triggen}, m::INT, res::Ptr{R})::Void
    unsafe_store!(res, R(0))
    unsafe_store!(res + sizeof(R), R(0))
    return nothing
end

#static void cexpl_zero in kernel/trig.c:146
function cexpl_zero(p::Ptr{triggen}, m::INT, res::Ptr{trigreal})::Void
    unsafe_store!(res, trigreal(0))
    unsafe_store!(res + sizeof(trigreal), trigreal(0))
    return nothing
end

#static void cexp_generic in kernel/trig.c:153
function cexp_generic(p::Ptr{triggen}, m::INT, res::Ptr{R})::Void
    resl = Ptr{trigreal}(malloc(2*sizeof(trigreal)))
    ccall(unsafe_load(p).cexpl, Void, (Ptr{triggen}, INT, Ptr{trigreal}),
          p, m, resl)
    unsafe_store!(res, R(unsafe_load(resl, 1)))
    unsafe_store!(res + sizeof(R), R(unsafe_load(resl, 2)))
    return nothing
end

#static void rotate_generic in kernel/trig.c:161
function rotate_generic(p::Ptr{triggen}, m::INT, xr::R, xi::R, res::Ptr{R})::Void
    w = Ptr{trigreal}(malloc(2*sizeof(trigreal)))
    ccall(unsafe_load(p).cexpl, Void, (Ptr{triggen}, INT, Ptr{trigreal}),
          p, m, resl)
    unsafe_store!(res, R(xr*unsafe_load(w, 1) - xi*FFT_SIGN*unsafe_load(w, 2)))
    unsafe_store!(res, R(xi*unsafe_load(w, 1) + xr*FFT_SIGN*unsafe_load(w, 2)))
    return nothing
end

#triggen* X(mktriggen) in kernel/trig.c:169
function mktriggen(wakefulness::Cint, n::INT)::Ptr{triggen}
    p = Ptr{triggen}(malloc(sizeof(triggen)))

    #p->n = n
    #INT n at 64 bytes in triggen
    pt = Ptr{INT}(p + 64)
    unsafe_store!(pt, n)
    #p->W0 = 0
    #triggen* W0 at 48 bytes in triggen
    pt = Ptr{Ptr{trigreal}}(p + 48)
    unsafe_store!(pt, C_NULL)
    #p->W1 = 0
    #triggen* W1 at 56 bytes in triggen
    pt = Ptr{Ptr{trigreal}}(p + 56)
    unsafe_store!(pt, C_NULL)
    #p->cexp = 0
    #func* cexp at 0 bytes in triggen
    pt = Ptr{Ptr{Void}}(p)
    unsafe_store!(pt, C_NULL)
    #p->rotate = 0
    #func* rotate at 16 bytes in triggen
    pt = Ptr{Ptr{Void}}(p)
    unsafe_store!(pt, C_NULL)

    if wakefulness == SLEEPY
        @assert false #should not happen
    elseif wakefulness == AWAKE_SQRTN_TABLE
        twshft = choose_twshft(n)

        #p->twshft = twshft
        #INT twshft at 24 bytes in triggen
        pt = Ptr{INT}(p + 24)
        unsafe_store!(pt, twshft)
        #p->twradix = ((INT)1) << twshft
        #INT twradix at 32 bytes in triggen
        pt = Ptr{INT}(p + 32)
        n0 = INT(1) << twshft
#        unsafe_store!(pt, INT(1) << twshft)
        unsafe_store!(pt, n0)
        #p-twmsk = p->twradix - 1
        #INT twmsk at 40 bytes in triggen
        pt = Ptr{INT}(p + 40)
#        unsafe_store!(pt, (INT(1) << twshft) -1)
        unsafe_store!(pt, n0 - 1)

        n1 = div(n + n0 - 1, n0)
        
        #trigreal* W0 at 48 bytes in triggen
        pt = Ptr{Ptr{trigreal}}(p + 48)
        unsafe_store!(pt, Ptr{trigreal}(malloc(n0 * 2 * sizeof(trigreal))))
        #trigreal* W1 at 56 bytes in triggen
        pt = Ptr{Ptr{trigreal}}(p + 56)
        unsafe_store!(pt, Ptr{trigreal}(malloc(n1 * 2 * sizeof(trigreal))))

        for i=0:n0-1
            real_cexp(i, n, unsafe_load(p).W0 + 2*i*sizeof(trigreal))
        end
        for i=0:n1-1
            real_cexp(i*unsafe_load(p).twradix, n, unsafe_load(p).W1 + 2*i*sizeof(trigreal))
        end

        #p->cexpl = cexpl_sqrtn_table
        #func* cexpl at 8 bytes in triggen
        pt = Ptr{Ptr{Void}}(p + 8)
        unsafe_store!(pt, cfunction(cexpl_sqrtn_table, Void, (Ptr{triggen}, INT, Ptr{trigreal})))
        #p->rotate = rotate_sqrtn_table
        #func* rotate at 16 bytes in triggen
        pt = Ptr{Ptr{Void}}(p + 16)
        unsafe_store!(pt, cfunction(rotate_sqrtn_table, Void, (Ptr{triggen}, INT, R, R, Ptr{R})))
    elseif wakefulness == AWAKE_SINCOS
        #p->cexpl = cexpl_sincos
        #func* cexpl at 8 bytes in triggen
        pt = Ptr{Ptr{Void}}(p + 8)
        unsafe_store!(pt, cfunction(cexpl_sincos, Void, (Ptr{triggen}, INT, Ptr{trigreal})))
    elseif wakefulness == AWAKE_ZERO
        #p->cexp = cexp_zero
        #func* cexp at 0 bytes in triggen
        pt = Ptr{Ptr{Void}}(p)
        unsafe_store!(pt, cfunction(cexp_zero, Void, (Ptr{triggen}, INT, Ptr{trigreal})))
        #p->cexpl = cexpl_zero
        #func* cexpl at 8 bytes in triggen
        pt = Ptr{Ptr{Void}}(p + 8)
        unsafe_store!(pt, cfunction(cexpl_zero, Void, (Ptr{triggen}, INT, Ptr{trigreal})))
    end

    if unsafe_load(p).cexp == C_NULL
        if sizeof(trigreal) == sizeof(R)
            #func* cexp at 0 bytes in triggen
            pt = Ptr{Ptr{Void}}(p)
            unsafe_store!(pt, unsafe_load(p).cexpl)
        else
            #func* cexp at 0 bytes in triggen
            pt = Ptr{Ptr{Void}}(p)
            unsafe_store!(pt, cfunction(cexp_generic, Void, (Ptr{triggen}, INT, Ptr{R})))
        end
    end
    if unsafe_load(p).rotate == C_NULL
        #p->rotate = rotate_generic
        #func* rotate at 16 bytes in triggen
        pt = Ptr{Ptr{Void}}(p + 16)
        unsafe_store!(pt, cfunction(rotate_generic, Void, (Ptr{triggen}, INT, R, R, Ptr{R})))
    end

    return p
end

#void X(triggen_destroy) in kernel/trig.c:229
function triggen_destroy(p::Ptr{triggen})::Void
    free(unsafe_load(p).W0)
    free(unsafe_load(p).W1)
    free(p)
    return nothing
end

