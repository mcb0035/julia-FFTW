const libcodelet = "/home/qm4/tests/dft/scalar/codelets/libcdl.so"

#struct kdft_genus in dft/codelet-dft.h:46
immutable kdft_genus
    #int (*okp)(const kdft_desc *desc, const R *ri, const R *ii, const R *ro, const R *io, INT is, INT os, INT vl, INT ivs, INT ovs, const planner *plnr)
    okp::Ptr{Void}
    vl::INT
end

function Base.show(io::IO, kg::kdft_genus)::Void
    print_with_color(:yellow, "kdft_genus:\n")
    println(" okp: $(kg.okp)")
    println(" vl: $(kg.vl)")
    return nothing
end

#struct kdft_desc_s in dft/codelet-dft.h:48
immutable kdft_desc
    sz::INT
    nam::Ptr{Cchar}
    ops::opcnt
    genus::Ptr{kdft_genus}
    is::INT
    os::INT
    ivs::INT
    ovs::INT
end

function kdft_desc(sz::INT, nam::Ptr{Cchar}, ops::opcnt, genus::Ptr{kdft_genus}, is::INT, os::INT, ivs::INT, ovs::INT)::kdft_desc
    return kdft_desc(sz, nam, ops, genus, is, os, ivs, ovs)
end

function kdft_genus(f::Function, vl::INT)::kdft_genus
    return kdft_genus(cfunction(f, Bool, (Ptr{kdft_desc}, Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R},
                                       INT, INT, INT, INT, INT, Ptr{planner})), vl)
end

function Base.show(io::IO, kd::kdft_desc)::Void
    print_with_color(:yellow,"kdft_desc:\n")
    println(" sz: $(kd.sz)")
    println(" nam: $(unsafe_wrap(String, kd.nam))")
    show(kd.ops)
    show(unsafe_load(kd.genus))
    println(" is: $(kd.is)")
    println(" so: $(kd.os)")
    println(" ivs: $(kd.ivs)")
    println(" ovs: $(kd.ovs)")
    return nothing
end

#static int okp in dft/scalar/n.c:24
function okp_n(d::Ptr{kdft_desc}, ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R},
               is::INT, os::INT, vl::INT, ivs::INT, ovs::INT, plnr::Ptr{planner})::Bool
    D = unsafe_load(d)
    return (true
            && (D.is == 0 || D.is == is)
            && (D.os == 0 || D.os == os)
            && (D.ivs == 0 || D.ivs == ivs)
            && (D.ovs == 0 || D.ovs == ovs))
end

#GENUS in dft/scalar/n.c:39
const GENUS_N = kdft_genus(okp_n, INT(1))

#struct ct_genus in dft/codelet-dft.h:73
immutable ct_genus
    #int (*okp)(const struct ct_desc_s *desc, const R *rio, const R *iio, INT rs, INT vs, INT m, INT mb, INT me, INT ms, const planner *plnr)
    okp::Ptr{Void}
    vl::INT
end

#struct ct_desc_s in dft/codelet-dft.h:75
immutable ct_desc
    radix::INT
    nam::Ptr{Cchar}
    tw::Ptr{tw_instr}
    genus::Ptr{ct_genus}
    ops::opcnt
    rs::INT
    vs::INT
    ms::INT
end

function ct_genus(f::Function, vl::INT)::ct_genus
    return ct_genus(cfunction(f, Bool, (Ptr{ct_desc}, Ptr{R}, Ptr{R}, INT, INT, 
                                       INT, INT, INT, INT, Ptr{planner})), vl)
end

#static int okp in dft/scalar/t.c:24
function okp_t(d::Ptr{ct_desc}, rio::Ptr{R}, iio::Ptr{R}, rs::INT, vs::INT, 
               m::INT, mb::INT, me::INT, ms::INT, plnr::Ptr{planner})::Bool
    D = unsafe_load(d)
    return (true
            && (D.rs == C_NULL || D.rs == rs)
            && (D.vs == C_NULL || D.vs == vs)
            && (D.ms == C_NULL || D.ms == ms))
end

#GENUS in dft/scalar/t.c:37
const GENUS_T = ct_genus(okp_t, INT(1))

#=
#plan* X(mkplan_dft) in dft/plan.c:24
function mkplan_dft(siz::Integer, adt::Ptr{plan_adt}, apply::Function)::Ptr{plan}
    ego = Ptr{plan_dft}(mkplan(siz, adt))
    #ego->apply = apply
    #apply at 56 bytes in plan_dft
    pt = reinterpret(Ptr{Ptr{Void}}, ego + 56)
    unsafe_store!(pt, cfunction(apply, Void, (Ptr{plan}, Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R})))
    return reinterpret(Ptr{plan}, ego)
end
=#
#plan* X(mkplan_dft) in dft/plan.c:24
function mkplan_dft(siz::Integer, adt::Ptr{plan_adt}, apply::Ptr{Void})::Ptr{plan}
    ego = Ptr{plan_dft}(mkplan(Csize_t(siz), adt))
    #ego->apply = apply
    #apply at 56 bytes in plan_dft
    pt = reinterpret(Ptr{Ptr{Void}}, ego + 56)
    unsafe_store!(pt, apply)
    return reinterpret(Ptr{plan}, ego)
end

#macro in dft/dft.h:59
function MKPLAN_DFT(t::DataType, adt::Ptr{plan_adt}, apply::Ptr{Void})::Ptr{t}
    return reinterpret(Ptr{t}, mkplan_dft(sizeof(t), adt, apply))
end

#macro in dft/dft.h:59
function MKPLAN_DFT(t::DataType, adt::Ptr{plan_adt}, apply::Function)::Ptr{t}
    ap = cfunction(apply, Void, (Ptr{plan}, Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}))

    return reinterpret(Ptr{t}, mkplan_dft(sizeof(t), adt, ap))
end

#struct plan_dftw in dft/ct.h:37
immutable plan_dftw
    super::plan
    apply::Ptr{Void} #dftwapply
end

#plan* X(mkplan_dftw) in dft/ct.c:247
function mkplan_dftw(siz::Integer, adt::Ptr{plan_adt}, apply::Ptr{Void})::Ptr{plan}
    ego = Ptr{plan_dftw}(mkplan(Csize_t(siz), adt))
    #ego->apply = apply
    #apply at 56 bytes in plan_dftw
    pt = reinterpret(Ptr{Ptr{Void}}, ego + 56)
    unsafe_store!(pt, apply)
    return reinterpret(Ptr{plan}, ego)
end

#macro in dft/ct.h:41
function MKPLAN_DFTW(t::DataType, adt::Ptr{plan_adt}, apply::Function)::Ptr{t}
    ap = cfunction(apply, Void, (Ptr{plan}, Ptr{R}, Ptr{R}))

    return reinterpret(Ptr{t}, mkplan_dftw(sizeof(t), adt, ap))
end

const DECDIF = Cint(0)
const DECDIT = Cint(1)
const TRANSPOSE = Cint(2)

#struct ct_solver_s in dft/ct.h:44
immutable ct_solver
    super::solver
    r::INT
    dec::Cint
    mkcldw::Ptr{Void} #ct_mkinferior
    force_vrecursionp::Ptr{Void} #ct_force_vrecursion
end



























