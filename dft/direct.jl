#dft/direct.c

#struct S in dft/direct.c:31
type S_dft_direct
    super::solver
    desc::Ptr{kdft_desc}
    k::Ptr{Void} #kdft
    bufferedp::Cint
end

function Base.show(io::IO, S::S_dft_direct)::Void
    print_with_color(:yellow,"S_dft_direct:\n")
    println(" super:")
#    slv = reinterpret(Ptr{solver}, pointer_from_objref(S))
    show(S.super)
    println(" desc:")
    show(unsafe_load(S.desc))
    println(" k: $(S.k)")
    println(" bufferedp: $(S.bufferedp)")
    return nothing
end

#struct P in dft/direct.c:40
type P_dft_direct
    super::plan_dft
    is::fftwstride
    os::fftwstride
    bufstride::fftwstride
    n::INT
    vl::INT
    ivs::INT
    ovs::INT
    k::Ptr{Void}
    slv::Ptr{S_dft_direct}
end

#static void dobatch in dft/direct.c:42
function dobatch_dft_direct(ego::Ptr{P_dft_direct}, ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R}, buf::Ptr{R}, batchsz::INT)::Void
    P = unsafe_load(ego)
#    cpy2d_pair_ci(ri, ii, buf, buf+sizeof(R), unsafe_load(ego).n, WS(unsafe_load(ego).is, 2), WS(unsafe_load(ego).bufstride, 2), batchsz, unsafe_load(ego).ivs, 2)
    cpy2d_pair_ci(ri, ii, buf, buf+sizeof(R), P.n, WS(P.is, 2), WS(P.bufstride, 2), batchsz, P.ivs, 2)
#    if abs(WS(unsafe_load(ego).os, 2)) < abs(unsafe_load(ego).ovs
    if abs(WS(P.os, 2)) < abs(P.ovs)
        ccall(P.k, Void,
              (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT),
              buf, buf+sizeof(R), ro, io, P.bufstride, P.os, batchsz, 2, P.ovs)
    else
        ccall(P.k, Void,
              (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT),
              buf, buf+sizeof(R), buf, buf+sizeof(R), P.bufstride, P.bufstride, batchsz, 2, 2)
        cpy2d_pair_co(buf, buf+sizeof(R), ro, io, P.n, WS(P.bufstride, 2), WS(P.os, 2), batchsz, 2, P.ovs)
    end
    return nothing
end

#static INT compute_batchsize in dft/direct.c:63
function compute_batchsize(n::INT)::INT
    #round up to multiple of 4
    return ((n + 3) & -4) + 2
end

#static void apply_buf in dft/direct.c:72
function apply_buf_dft_direct(ego_::Ptr{plan}, ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R})::Void
    ego = Ptr{P_dft_direct}(ego_)
    vl = unsafe_load(ego).vl
    n = unsafe_load(ego).n
    batchsz = compute_batchsize(n)
    bufsz = n * batchsz * 2 * sizeof(R)

    #BUF_ALLOC(R *, buf, bufsz)
    buf = Ptr{R}(malloc(bufsz))

    local i = 0
#    for i = 0:batchsz:vl-batchsz-1
    while i < vl - batchsz
        dobatch_dft_direct(ego, ri, ii, ro, io, buf, batchsz)
        ri += batchsz * unsafe_load(ego).ivs * sizeof(R)
        ii += batchsz * unsafe_load(ego).ivs * sizeof(R)
        ro += batchsz * unsafe_load(ego).ovs * sizeof(R)
        io += batchsz * unsafe_load(ego).ovs * sizeof(R)
        i += batchsz
    end
    dobatch_dft_direct(ego, ri, ii, ro, io, buf, vl - i)
    free(buf)
    return nothing
end

#static void apply in dft/direct.c:92
function apply_dft_direct(ego_::Ptr{plan}, ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R})::Void
    print_with_color(214, "apply_dft_direct: begin\n")
    ego = unsafe_load(Ptr{P_dft_direct}(ego_))
    
    ASSERT_ALIGNED_DOUBLE()
    
    ccall(ego.k, Void,
          (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT),
          ri, ii, ro, io, ego.is, ego.os, ego.vl, ego.ivs, ego.ovs)

    print_with_color(214, "apply_dft_direct: end\n")
    return nothing
end

#static void apply_extra_iter in dft/direct.c:99
function apply_extra_iter_dft_direct(ego_::Ptr{plan}, ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R})
    ego = unsafe_load(Ptr{P_dft_direct}(ego_))
    vl = ego.vl

    ASSERT_ALIGNED_DOUBLE()

    #for 4-way SIMD with VL odd iterate over even vector length VL
    #then execute last iteration as 2-vector with vector stride 0
    ccall(ego.k, Void,
          (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT),
          ri, ii, ro, io, ego.is, ego.os, vl - 1, ego.ivs, ego.ovs)

    ccall(ego.k, Void,
          (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT),
          ri + (vl - 1) * ego.ivs * sizeof(R), ii + (vl - 1) * ego.ivs * sizeof(R), 
          ro + (vl - 1) * ego.ovs * sizeof(R), io + (vl - 1) * ego.ovs * sizeof(R), 
          ego.is, ego.os, INT(1), INT(0), INT(0))

    return nothing
end
         

#static void destroy in dft/direct.c:116
function destroy_dft_direct(ego_::Ptr{plan})::Void
    ego = Ptr{P_dft_direct}(ego_)
    P = unsafe_load(ego)
    stride_destroy(P.is)
    stride_destroy(P.os)
    stride_destroy(P.bufstride)
    return nothing
end

#static void print in dft/direct.c:124
function print_dft_direct(ego_::Ptr{plan}, p::Ptr{printer})::Void
    ego = Ptr{P_dft_direct}(ego_)
    P = unsafe_load(ego)
    s = Ptr{S_dft_direct}(P.slv)
    S = unsafe_load(s)
    d = S.desc

    sz = compute_batchsize(unsafe_load(d).sz)
    vl = P.vl > 1 ? "-x$(P.vl)" : ""
    ss = Base.unsafe_wrap(String, unsafe_load(d).nam)

    if S.bufferedp != 0
        str = "(dft-directbuf/$sz-$(unsafe_load(d).sz)$vl \"$ss\")"
        ccall(unsafe_load(p).print,
              Void,
              (Ptr{printer}, Ptr{Cchar}),
              p, str)
    else
        str = "(dft-direct/$(unsafe_load(d).sz)$vl \"$ss\")"
        ccall(unsafe_load(p).print,
              Void,
              (Ptr{printer}, Ptr{Cchar}),
              p, str)
    end
    return nothing
end

#static int applicable_buf in dft/direct.c:137
function applicable_buf_dft_direct(ego_::Ptr{solver}, p_::Ptr{problem}, plnr::Ptr{planner})::Bool
#    print_with_color(:blue,"applicable_buf_dft_direct: begin\n")
    ego = unsafe_load(Ptr{S_dft_direct}(ego_))
#    show(ego)
    p = unsafe_load(Ptr{problem_dft}(p_))
    d = ego.desc
#    show(unsafe_load(d))

    vl = Ptr{INT}(malloc(sizeof(INT)))
    ivs = Ptr{INT}(malloc(sizeof(INT)))
    ovs = Ptr{INT}(malloc(sizeof(INT)))
    batchsz = Ptr{INT}(malloc(sizeof(INT)))

    #INT dims[0].n at 8 bytes in tensor
    szn = unsafe_load(reinterpret(Ptr{INT}, p.sz + 8))
    #INT dims[0].is at 16 bytes in tensor
    szis = unsafe_load(reinterpret(Ptr{INT}, p.sz + 8 + sizeof(INT)))
    #INT dims[0].os at 24 bytes in tensor
    szos = unsafe_load(reinterpret(Ptr{INT}, p.sz + 8 + 2*sizeof(INT)))
    retval = (true
              && unsafe_load(p.sz).rnk == 1
              && unsafe_load(p.vecsz).rnk == 1
#              && unsafe_load(p.sz).dims[0].n == unsafe_load(d).sz
              && szn == unsafe_load(d).sz
              #check strides etc
              && tensor_tornk1(p.vecsz, vl, ivs, ovs)
              #UGLY if IS <= IVS
#              && !(Bool(NO_UGLYP(plnr)) && abs(szis <= abs(unsafe_load(ivs)))))
              && !((NO_UGLYP(plnr) != 0) && abs(szis <= abs(unsafe_load(ivs)))))

    unsafe_store!(batchsz, compute_batchsize(unsafe_load(d).sz))

    retval = (retval
              && unsafe_load(batchsz) != 0
              && Bool(ccall(unsafe_load(unsafe_load(d).genus).okp,
                      Cint,
                      (Ptr{kdft_desc}, Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R},
                       INT, INT, INT, INT, INT, Ptr{planner}),
                      d, Ptr{R}(C_NULL), Ptr{R}(C_NULL) + sizeof(R), p.ro, p.io,
                      2 * unsafe_load(batchsz), szos, 
                      unsafe_load(batchsz), 
                      INT(2), unsafe_load(ovs), plnr))
              && Bool(ccall(unsafe_load(unsafe_load(d).genus).okp,
                      Cint,
                      (Ptr{kdft_desc}, Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R},
                       INT, INT, INT, INT, INT, Ptr{planner}),
                      d, Ptr{R}(C_NULL), Ptr{R}(C_NULL) + sizeof(R), p.ro, p.io,
                      2 * unsafe_load(batchsz), szos, 
                      unsafe_load(vl) % unsafe_load(batchsz), 
                      INT(2), unsafe_load(ovs), plnr)))

    retval = (retval
              && (false
                  #can operate out of place
                  || p.ri != p.ro
                  #can operate in place as long as strides are same
                  || tensor_inplace_strides2(p.sz, p.vecsz)
                  #problem fits in buffer regardless of stride
                  || unsafe_load(vl) <= unsafe_load(batchsz)))

    free(vl)
    free(ivs)
    free(ovs)
    free(batchsz)

#    print_with_color(:blue,"applicable_buf_dft_direct: end\n")
    return retval
end

#static int applicable in dft/direct.c:183
function applicable_dft_direct(ego_::Ptr{solver}, p_::Ptr{problem}, plnr::Ptr{planner}, extra_iterp::Ptr{Cint})::Bool
    print_with_color(99,"applicable_dft_direct: begin\n")
    ego = unsafe_load(Ptr{S_dft_direct}(ego_))
    p = unsafe_load(Ptr{problem_dft}(p_))
    d = ego.desc

    vl = Ptr{INT}(malloc(sizeof(INT)))
    ivs = Ptr{INT}(malloc(sizeof(INT)))
    ovs = Ptr{INT}(malloc(sizeof(INT)))

    #INT dims[0].n at 8 bytes in tensor
    szn = unsafe_load(reinterpret(Ptr{INT}, p.sz + 8))
    #INT dims[0].is at 16 bytes in tensor
    szis = unsafe_load(reinterpret(Ptr{INT}, p.sz + 8 + sizeof(INT)))
    #INT dims[0].os at 24 bytes in tensor
    szos = unsafe_load(reinterpret(Ptr{INT}, p.sz + 8 + 2*sizeof(INT)))

    retval = (true
              && unsafe_load(p.sz).rnk == 1
              && unsafe_load(p.vecsz).rnk <= 1
#              && unsafe_load(p.sz).dims[0].n == unsafe_load(d).sz
              && szn == unsafe_load(d).sz
              && tensor_tornk1(p.vecsz, vl, ivs, ovs))

    if retval
        print_with_color(99, " applicable_dft_direct: size ok\n")
        print_with_color(99, " applicable_dft_direct: vl $(unsafe_load(vl)), ivs $(unsafe_load(ivs)), ovs $(unsafe_load(ovs))\n")
    end

#    print_with_color(99, " applicable_dft_direct: $(unsafe_load(p.sz).rnk == 1)\n")
#    print_with_color(99, " applicable_dft_direct: $(unsafe_load(p.vecsz).rnk <= 1)\n")
#    print_with_color(99, " applicable_dft_direct: $(szn == unsafe_load(d).sz)\n")
#    print_with_color(99, " applicable_dft_direct: $(tensor_tornk1(p.vecsz, vl, ivs, ovs))\n")

    
    unsafe_store!(extra_iterp, Cint(0))
#=    rv = ccall(unsafe_load(unsafe_load(d).genus).okp,
                           Cint,
                           (Ptr{kdft_desc}, Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R},
                            INT, INT, INT, INT, INT, Ptr{planner}),
                           d, p.ri, p.ii, p.ro, p.io, szis, szos,
                           unsafe_load(vl), unsafe_load(ivs), unsafe_load(ovs), 
                           plnr)=#
    rv = okp_n(d, p.ri, p.ii, p.ro, p.io, szis, szos, unsafe_load(vl), unsafe_load(ivs), unsafe_load(ovs), plnr)
    print_with_color(99, " applicable_dft_direct: first rv $rv\n")
    if rv == 0
        unsafe_store!(extra_iterp, Cint(1))
        rv = ccall(unsafe_load(unsafe_load(d).genus).okp,
                               Cint,
                               (Ptr{kdft_desc}, Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R},
                                INT, INT, INT, INT, INT, Ptr{planner}),
                               d, p.ri, p.ii, p.ro, p.io, szis, szos,
                               unsafe_load(vl) - 1, unsafe_load(ivs), unsafe_load(ovs),
                               plnr)
        rv = okp_n(d, p.ri, p.ii, p.ro, p.io, szis, szos, unsafe_load(vl)-1, unsafe_load(ivs), unsafe_load(ovs), plnr)
    end

    print_with_color(99, " applicable_dft_direct: second rv $rv\n")
    if rv == 1
        print_with_color(99, " applicable_dft_direct: strides ok\n")
    end

    retval = (retval 
              && (Bool(rv)
                  && Bool(ccall(unsafe_load(unsafe_load(d).genus).okp,
                                Cint,
                                (Ptr{kdft_desc}, Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R},
                                 INT, INT, INT, INT, INT, Ptr{planner}),
                                d, p.ri, p.ii, p.ro, p.io, szis, szos,
                                INT(2), INT(0), INT(0),
                                plnr)))
              && (false
                  #can operate out of place
                  || p.ri != p.ro
                  #can always compute one transform
                  || unsafe_load(vl) == 1
                  #can operate in place as long as strides are same
                  || tensor_inplace_strides2(p.sz, p.vecsz)))
    print_with_color(99, " applicable_dft_direct: genus $(ccall(unsafe_load(unsafe_load(d).genus).okp,
                                Cint,
                                (Ptr{kdft_desc}, Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R},
                                 INT, INT, INT, INT, INT, Ptr{planner}),
                                d, p.ri, p.ii, p.ro, p.io, szis, szos,
                                INT(2), INT(0), INT(0),
                                plnr))\n")
    print_with_color(99, " applicable_dft_direct: one of the following must be true\n")
    print_with_color(99, " $(p.ri != p.ro)\n")
    print_with_color(99, " $(unsafe_load(vl) == 1)\n")
    print_with_color(99, " $(tensor_inplace_strides2(p.sz, p.vecsz))\n")

    free(vl)
    free(ivs)
    free(ovs)

    print_with_color(99,"applicable_dft_direct: end $retval\n")
    return retval
end

#static plan* mkplan in dft/direct.c:229
function mkplan_dft_direct(ego_::Ptr{solver}, p_::Ptr{problem}, plnr::Ptr{planner})
    print_with_color(152, "mkplan_dft_direct: begin\n")
    ego = Ptr{S_dft_direct}(ego_)
#    print_with_color(152, "mkplan_dft_direct: S:\n")
#    show(unsafe_load(ego))
    
    eg = unsafe_load(ego).desc

    padt = mkplan_adt(dft_solve, null_awake, print_dft_direct, destroy_dft_direct)

    if unsafe_load(ego).bufferedp != 0
        if !applicable_buf_dft_direct(ego_, p_, plnr)
            print_with_color(152, "   mkplan_dft_direct: direct buffered plan not applicable, returning null plan\n")
            return Ptr{plan}(C_NULL)
        end
        pln = MKPLAN_DFT(P_dft_direct, padt, apply_buf_dft_direct)

    else
        extra_iterp = Ptr{Cint}(malloc(sizeof(Cint)))
        if !applicable_dft_direct(ego_, p_, plnr, extra_iterp)
            print_with_color(152, "   mkplan_dft_direct: direct plan not applicable, returning null plan\n")
            return Ptr{plan}(C_NULL)
        end
        pln = MKPLAN_DFT(P_dft_direct, padt, unsafe_load(extra_iterp) != 0 ? 
                         apply_extra_iter_dft_direct : apply_dft_direct)
    end

    p = unsafe_load(Ptr{problem_dft}(p_))
    #INT dims[0].n at 8 bytes in tensor
    dn = unsafe_load(reinterpret(Ptr{INT}, p.sz + 8))
    #INT dims[0].is at 16 bytes in tensor
    dis = unsafe_load(reinterpret(Ptr{INT}, p.sz + 8 + sizeof(INT)))
    #INT dims[0].os at 24 bytes in tensor
    dos = unsafe_load(reinterpret(Ptr{INT}, p.sz + 8 + 2*sizeof(INT)))

    #pln->k = ego->k
    #kdft k at 120 bytes in P
    pt = reinterpret(Ptr{Ptr{Void}}, pln + 120)
    unsafe_store!(pt, unsafe_load(ego).k)
    #pln->n = d[0].n
    #INT n at 88 bytes in P
    pt = reinterpret(Ptr{INT}, pln + 88)
    unsafe_store!(pt, dn)
    #pln->is = X(mkstride)(pln->n, d[0].is)
    #stride is at 64 bytes in P
    pt = reinterpret(Ptr{fftwstride}, pln + 64)
    unsafe_store!(pt, mkstride(dn, dis))
    #pln->os = X(mkstride)(pln->n, d[0].os)
    #stride os at 72 bytes in P
    pt = reinterpret(Ptr{fftwstride}, pln + 72)
    unsafe_store!(pt, mkstride(dn, dos))
    #pln->bufstride = X(mkstride)(pln->n, 2*compute_batchsize(pln->n))
    #stride bufstride at 80 bytes in P
    pt = reinterpret(Ptr{fftwstride}, pln + 80)
    unsafe_store!(pt, mkstride(dn, 2 * compute_batchsize(dn)))

    #INT vl, ivs, ovs at 96, 104, 112 bytes in P
    tensor_tornk1(p.vecsz, 
                  Ptr{INT}(pln + 96), Ptr{INT}(pln + 104), Ptr{INT}(pln + 112))

    #pln->slv = ego
    #S* slv at 128 bytes in P
    pt = reinterpret(Ptr{Ptr{S_dft_direct}}, pln + 128)
    unsafe_store!(pt, ego)

    #opcnt ops at 8 bytes in P
    ops_zero(reinterpret(Ptr{opcnt}, pln + 8))

    #opcnt ops at 16 bytes in kdft_desc
    ops_madd2(div(unsafe_load(pln).vl, unsafe_load(unsafe_load(eg).genus).vl),
              reinterpret(Ptr{opcnt}, eg + 16),
              reinterpret(Ptr{opcnt}, pln + 8))

    if unsafe_load(ego).bufferedp != 0
        pt = reinterpret(Ptr{opcnt}, pln + 8)
        val = unsafe_load(pt).other + 4 * dn * unsafe_load(pln).vl
        #double other at 24 bytes in opcnt, 32 bytes in P
        pt = reinterpret(Ptr{Cdouble}, pln + 32)
        unsafe_store!(pt, Cdouble(val))
    end

    #int could_prune_now_p at 52 bytes in P
    pt = reinterpret(Ptr{Cint}, pln + 52)
    unsafe_store!(pt, Cint(unsafe_load(ego).bufferedp == 0))

    print_with_color(154, "mkplan_dft_direct: end\n")
    return Ptr{plan}(pln)
end

#static solver* mksolver in dft/direct.c:275
function mksolver_dft_direct(k::Ptr{Void}, desc::Ptr{kdft_desc}, bufferedp::Cint)::Ptr{solver}
    func = cfunction(mkplan_dft_direct, Ptr{plan}, (Ptr{solver}, Ptr{problem}, Ptr{planner}))
#    sadt = mksolver_adt(PROBLEM_DFT, mkplan_dft_direct, C_NULL)
    sadt = mksolver_adt(PROBLEM_DFT, func, C_NULL)
#    print_with_color(154,"mksolver_dft_direct: solver_adt:\n")
#    show(unsafe_load(sadt))
    slv = MKSOLVER(S_dft_direct, sadt)
#    print_with_color(154,"mksolver_dft_direct: solver:\n")
#    show(unsafe_load(reinterpret(Ptr{solver}, slv)))

    #kdft k at 24 bytes in S
    pt = reinterpret(Ptr{Ptr{Void}}, slv + 24)
    unsafe_store!(pt, k)
    #kdft_desc at 16 bytes in S
    pt = reinterpret(Ptr{Ptr{kdft_desc}}, slv + 16)
    unsafe_store!(pt, desc)
    #int bufferedp at 32 bytes in S
    pt = reinterpret(Ptr{Cint}, slv + 32)
    unsafe_store!(pt, bufferedp)

    return Ptr{solver}(slv)
end

#solver* X(mksolver_dft_direct) in dft/direct.c:285
function mksolver_dft_direct(k::Ptr{Void}, desc::Ptr{kdft_desc})::Ptr{solver}
    return mksolver_dft_direct(k, desc, Cint(0))
end

#solver* X(mksolver_dft_directbuf) in dft/direct.c:290
function mksolver_dft_directbuf(k::Ptr{Void}, desc::Ptr{kdft_desc})::Ptr{solver}
    return mksolver_dft_direct(k, desc, Cint(1))
end













