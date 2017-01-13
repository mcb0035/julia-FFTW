#dft/dftw-direct.c

#struct S in dft/dftw-direct.c:29
type S_dftw_direct
    super::ct_solver
    desc::Ptr{ct_desc}
    bufferedp::Cint
    k::Ptr{Void} #kdftw
end

#struct P in dft/dftw-direct.c:40
type P_dftw_direct
    super::plan_dftw
    k::Ptr{Void} #kdftw
    r::INT
    rs::fftwstride
    m::INT
    ms::INT
    v::INT
    vs::INT
    mb::INT
    me::INT
    extra_iter::INT
    brs::fftwstride
    rd::Ptr{twid}
    slv::Ptr{S_dftw_direct}
end

#static void apply in dft/dftw-direct.c:46
function apply_dftw_direct(ego_::Ptr{plan}, rio::Ptr{R}, iio::Ptr{R})::Void
    ego = unsafe_load(Ptr{P_dftw_direct}(ego_))
    ASSERT_ALIGNED_DOUBLE()

    for i=0:ego.v-1
        trio = rio + i*ego.vs*sizeof(R)
        tiio = rio + i*ego.vs*sizeof(R)

        mb = ego.mb
        ms = ego.ms

        ccall(ego.k, Void,
              (Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, INT, INT, INT),
              trio + mb*ms*sizeof(R), tiio + mb*ms*sizeof(R), unsafe_load(ego.td).W,
              ego.rs, mb, ego.me, ms)
    end
    return nothing
end

#static void apply_extra_iter in dft/dftw_direct.c:58
function apply_extra_iter_dftw_direct(ego_::Ptr{plan}, rio::Ptr{R}, iio::Ptr{R})::Void
    ego = unsafe_load(Ptr{P_dftw_direct}(ego_))
    v = ego.v
    vs = ego.vs
    mb = ego.mb
    me = ego.me
    mm = me - 1
    ms = ego.ms
    ASSERT_ALIGNED_DOUBLE()

    for i=0:v-1
        trio = rio + i*vs*sizeof(R)
        tiio = iio + i*vs*sizeof(R)

        ccall(ego.k, Void,
              (Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, INT, INT, INT),
              trio + mb*ms*sizeof(R), tiio + mb*ms*sizeof(R), unsafe_load(ego.td).W,
              ego.rs, mb, mm, ms)
        ccall(ego.k, Void,
              (Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, INT, INT, INT),
              trio + mm*ms*sizeof(R), tiio + mm*ms*sizeof(R), unsafe_load(ego.td).W,
              ego.rs, mm, mm + 2, INT(0))
    end
    return nothing
end

#static void dobatch in dft/dftw-direct.c:75
function dobatch_dftw_direct(ego::Ptr{P_dftw_direct}, rA::Ptr{R}, iA::Ptr{R}, mb::INT, me::INT, buf::Ptr{R})::Void
    P = unsafe_load(ego)
    brs = WS(P.brs, 1)
    rs = WS(P.rs, 1)
    ms = P.ms

    cpy2d_pair_ci(rA + mb*ms*sizeof(R), iA + mb*ms*sizeof(R), buf, buf+sizeof(R),
                  P.r, rs, brs, me-mb, ms, 2)
    ccall(P.k, Void,
          (Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, INT, INT, INT),
          buf, buf+sizeof(R), unsafe_load(P.td).W, P.brs, mb, me, 2)
    cpy2d_pair_co(buf, buf+sizeof(R), rA + mb*ms*sizeof(R), iA + mb*ms*sizeof(R),
                  P.r, brs, rs, me-mb, 2, ms)
    return nothing
end

#static INT compute_batchsize in dft/dftw-direct.c:92
function compute_batchsize_dftw_direct(radix::INT)::INT
    n = radix + 3
    n &= -4

    return radix + 2
end

#static void apply_buf in dft/dftw-direct.c:101
function apply_buf_dftw_direct(ego_::Ptr{plan}, rio::Ptr{R}, iio::Ptr{R})::Void
    ego = Ptr{P_dftw_direct}(ego_)
    v = unsafe_load(ego).v
    r = unsafe_load(ego).r
    batchsz = compute_batchsize_dftw_direct(r)
    mb = unsafe_load(ego).mb
    me = unsafe_load(ego).me
    bufsz = r * batchsz * 2 * sizeof(R)

    buf = Ptr{R}(malloc(bufsz))

    for i=1:v
        for j=mb:batchsz:me-batchsz-1
            dobatch(ego, rio, iio, j, j+batchsz, buf)
        end
        dobatch(ego, rio, iio, j, me, buf)
    end
    free(buf)
    return nothing
end
#=
#static void awake in dft/dftw-direct.c:125
function awake_dftw_direct(ego_::Ptr{plan}, wakefulness::Cint)::Void
    ego = unsafe_load(Ptr{P_dftw_direct}(ego_))
=#    
















