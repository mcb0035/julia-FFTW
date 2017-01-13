#wrappers for dft scalar codelets

#void n1_2 in dft/scalar/codelets/n1_2.c:72
function n1_2(ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R}, is::fftwstride, os::fftwstride, v::INT, ivs::INT, ovs::INT)::Void
    ccall(("n1_2", libcodelet), Void,
           (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT),
           ri, ii, ro, io, is, os, v, ivs, ovs)
    return nothing
end

#= #void X(codelet_n1_2) in dft/scalar/codelets/n1_2.c:92
codelet_n1_2(p::Ptr{planner})::Void = 
    ccall(("fftw_codelet_n1_2", libfftw), Void, (Ptr{planner},), p)=#

#void X(codelet_n1_2) in dft/scalar/codelets/n1_2.c:92
function codelet_n1_2(p::Ptr{planner})::Void
    desc = kdft_desc(INT(2), cstringize("n1_2"), opcnt(R(4), R(0), R(0), R(0)), pointer_from_objref(GENUS_N), 0, 0, 0, 0)
#    pt = Ptr{kdft_desc}(malloc(sizeof(kdft_desc)))
#    unsafe_copy!(pt, pointer_from_objref(desc), sizeof(kdft_desc))
    func = cfunction(n1_2, Void, (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT))
    kdft_register(p, func, Ptr{kdft_desc}(pointer_from_objref(desc)))
#    kdft_register(p, func, pt)
    return nothing
end

#-----------------------------------------------------

#void n1_3 in dft/scalar/codelets/n1_3.c:87
function n1_3(ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R}, is::fftwstride, os::fftwstride, v::INT, ivs::INT, ovs::INT)::Void
    ccall(("n1_3", libcodelet), Void,
           (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT),
           ri, ii, ro, io, is, os, v, ivs, ovs)
    return nothing
end

#= #void X(codelet_n1_3) in dft/scalar/codelets/n1_3.c:122
codelet_n1_3(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_3", libfftw), Void, (Ptr{planner},), p)=#

#void X(codelet_n1_3) in dft/scalar/codelets/n1_3.c:122
function codelet_n1_3(p::Ptr{planner})::Void
    desc = kdft_desc(INT(3), cstringize("n1_3"), opcnt(R(10), R(2), R(2), R(0)), pointer_from_objref(GENUS_N), 0, 0, 0, 0)
#    pt = Ptr{kdft_desc}(malloc(sizeof(kdft_desc)))
#    unsafe_copy!(pt, pointer_from_objref(desc), sizeof(kdft_desc))
    func = cfunction(n1_3, Void, (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT))
    kdft_register(p, func, Ptr{kdft_desc}(pointer_from_objref(desc)))
#    kdft_register(p, func, pt)
    return nothing
end

#-----------------------------------------------------

#void n1_4 in dft/scalar/codelets/n1_4.c:94
function n1_4(ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R}, is::fftwstride, os::fftwstride, v::INT, ivs::INT, ovs::INT)::Void
    ccall(("n1_4", libcodelet), Void,
           (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT),
           ri, ii, ro, io, is, os, v, ivs, ovs)
    return nothing
end

#= #void X(codelet_n1_4) in dft/scalar/codelets/n1_4.c:136
codelet_n1_4(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_4", libfftw), Void, (Ptr{planner},), p)=#

#void X(codelet_n1_4) in dft/scalar/codelets/n1_4.c:136
function codelet_n1_4(p::Ptr{planner})::Void
    desc = kdft_desc(INT(4), cstringize("n1_4"), opcnt(R(16), R(0), R(0), R(0)), pointer_from_objref(GENUS_N), 0, 0, 0, 0)
#    pt = Ptr{kdft_desc}(malloc(sizeof(kdft_desc)))
#    unsafe_copy!(pt, pointer_from_objref(desc), sizeof(kdft_desc))
    func = cfunction(n1_4, Void, (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT))
    kdft_register(p, func, Ptr{kdft_desc}(pointer_from_objref(desc)))
#    kdft_register(p, func, pt)
    return nothing
end

#-----------------------------------------------------

#void n1_5 in dft/scalar/codelets/n1_5.c:119
function n1_5(ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R}, is::fftwstride, os::fftwstride, v::INT, ivs::INT, ovs::INT)::Void
    ccall(("n1_5", libcodelet), Void,
           (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT),
           ri, ii, ro, io, is, os, v, ivs, ovs)
    return nothing
end

#= #void X(codelet_n1_5) in dft/scalar/codelets/n1_5.c:189
codelet_n1_5(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_5", libfftw), Void, (Ptr{planner},), p)=#

#void X(codelet_n1_5) in dft/scalar/codelets/n1_5.c:189
function codelet_n1_5(p::Ptr{planner})::Void
    desc = kdft_desc(INT(5), cstringize("n1_5"), opcnt(R(26), R(6), R(6), R(0)), pointer_from_objref(GENUS_N), 0, 0, 0, 0)
#    pt = Ptr{kdft_desc}(malloc(sizeof(kdft_desc)))
#    unsafe_copy!(pt, pointer_from_objref(desc), sizeof(kdft_desc))
    func = cfunction(n1_5, Void, (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT))
    kdft_register(p, func, Ptr{kdft_desc}(pointer_from_objref(desc)))
#    kdft_register(p, func, pt)
    return nothing
end

#-----------------------------------------------------

#void n1_6 in dft/scalar/codelets/n1_6.c:132
function n1_6(ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R}, is::fftwstride, os::fftwstride, v::INT, ivs::INT, ovs::INT)::Void
    ccall(("n1_6", libcodelet), Void,
           (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT),
           ri, ii, ro, io, is, os, v, ivs, ovs)
    return nothing
end

#= #void X(codelet_n1_6) in dft/scalar/codelets/n1_6.c:210
codelet_n1_6(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_6", libfftw), Void, (Ptr{planner},), p)=#

#void X(codelet_n1_6) in dft/scalar/codelets/n1_6.c:210
function codelet_n1_6(p::Ptr{planner})::Void
    desc = kdft_desc(INT(6), cstringize("n1_6"), opcnt(R(32), R(4), R(4), R(0)), pointer_from_objref(GENUS_N), 0, 0, 0, 0)
#    pt = Ptr{kdft_desc}(malloc(sizeof(kdft_desc)))
#    unsafe_copy!(pt, pointer_from_objref(desc), sizeof(kdft_desc))
    func = cfunction(n1_6, Void, (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT))
    kdft_register(p, func, Ptr{kdft_desc}(pointer_from_objref(desc)))
#    kdft_register(p, func, pt)
    return nothing
end

#-----------------------------------------------------

#void n1_7 in dft/scalar/codelets/n1_7.c:159
function n1_7(ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R}, is::fftwstride, os::fftwstride, v::INT, ivs::INT, ovs::INT)::Void
    ccall(("n1_7", libcodelet), Void,
           (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT),
           ri, ii, ro, io, is, os, v, ivs, ovs)
    return nothing
end

#= #void X(codelet_n1_7) in dft/scalar/codelets/n1_7.c:247
codelet_n1_7(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_7", libfftw), Void, (Ptr{planner},), p)=#

#void X(codelet_n1_7) in dft/scalar/codelets/n1_7.c:247
function codelet_n1_7(p::Ptr{planner})::Void
    desc = kdft_desc(INT(7), cstringize("n1_7"), opcnt(R(36), R(12), R(24), R(0)), pointer_from_objref(GENUS_N), 0, 0, 0, 0)
#    pt = Ptr{kdft_desc}(malloc(sizeof(kdft_desc)))
#    unsafe_copy!(pt, pointer_from_objref(desc), sizeof(kdft_desc))
    func = cfunction(n1_7, Void, (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT))
    kdft_register(p, func, Ptr{kdft_desc}(pointer_from_objref(desc)))
#    kdft_register(p, func, pt)
    return nothing
end

#-----------------------------------------------------

#void n1_8 in dft/scalar/codelets/n1_8.c:158
function n1_8(ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R}, is::fftwstride, os::fftwstride, v::INT, ivs::INT, ovs::INT)::Void
    ccall(("n1_8", libcodelet), Void,
           (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT),
           ri, ii, ro, io, is, os, v, ivs, ovs)
    return nothing
end

#= #void X(codelet_n1_8) in dft/scalar/codelets/n1_8.c:264
codelet_n1_8(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_8", libfftw), Void, (Ptr{planner},), p)=#

#void X(codelet_n1_8) in dft/scalar/codelets/n1_8.c:264
function codelet_n1_8(p::Ptr{planner})::Void
    desc = kdft_desc(INT(8), cstringize("n1_8"), opcnt(R(52), R(4), R(0), R(0)), pointer_from_objref(GENUS_N), 0, 0, 0, 0)
#    pt = Ptr{kdft_desc}(malloc(sizeof(kdft_desc)))
#    unsafe_copy!(pt, pointer_from_objref(desc), sizeof(kdft_desc))
    func = cfunction(n1_8, Void, (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT))
    kdft_register(p, func, Ptr{kdft_desc}(pointer_from_objref(desc)))
#    kdft_register(p, func, pt)
    return nothing
end

#-----------------------------------------------------

#void n1_9 in dft/scalar/codelets/n1_9.c:206
function n1_9(ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R}, is::fftwstride, os::fftwstride, v::INT, ivs::INT, ovs::INT)::Void
    ccall(("n1_9", libcodelet), Void,
           (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT),
           ri, ii, ro, io, is, os, v, ivs, ovs)
    return nothing
end

#= #void X(codelet_n1_9) in dft/scalar/codelets/n1_9.c:358
codelet_n1_9(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_9", libfftw), Void, (Ptr{planner},), p)=#

#void X(codelet_n1_9) in dft/scalar/codelets/n1_9.c:358
function codelet_n1_9(p::Ptr{planner})::Void
    desc = kdft_desc(INT(9), cstringize("n1_9"), opcnt(R(60), R(20), R(20), R(0)), pointer_from_objref(GENUS_N), 0, 0, 0, 0)
#    pt = Ptr{kdft_desc}(malloc(sizeof(kdft_desc)))
#    unsafe_copy!(pt, pointer_from_objref(desc), sizeof(kdft_desc))
    func = cfunction(n1_9, Void, (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT))
    kdft_register(p, func, Ptr{kdft_desc}(pointer_from_objref(desc)))
#    kdft_register(p, func, pt)
    return nothing
end

#-----------------------------------------------------

#void n1_10 in dft/scalar/codelets/n1_10.c:206
function n1_10(ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R}, is::fftwstride, os::fftwstride, v::INT, ivs::INT, ovs::INT)::Void
    ccall(("n1_10", libcodelet), Void,
           (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT),
           ri, ii, ro, io, is, os, v, ivs, ovs)
    return nothing
end

#= #void X(codelet_n1_10) in dft/scalar/codelets/n1_10.c:360
codelet_n1_10(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_10", libfftw), Void, (Ptr{planner},), p)=#

#void X(codelet_n1_10) in dft/scalar/codelets/n1_10.c:360
function codelet_n1_10(p::Ptr{planner})::Void
    desc = kdft_desc(INT(10), cstringize("n1_10"), opcnt(R(72), R(12), R(12), R(0)), pointer_from_objref(GENUS_N), 0, 0, 0, 0)
#    pt = Ptr{kdft_desc}(malloc(sizeof(kdft_desc)))
#    unsafe_copy!(pt, pointer_from_objref(desc), sizeof(kdft_desc))
    func = cfunction(n1_10, Void, (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT))
    kdft_register(p, func, Ptr{kdft_desc}(pointer_from_objref(desc)))
#    kdft_register(p, func, pt)
    return nothing
end

#-----------------------------------------------------

#void n1_11 in dft/scalar/codelets/n1_11.c:281
function n1_11(ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R}, is::fftwstride, os::fftwstride, v::INT, ivs::INT, ovs::INT)::Void
    ccall(("n1_11", libcodelet), Void,
           (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT),
           ri, ii, ro, io, is, os, v, ivs, ovs)
    return nothing
end

#= #void X(codelet_n1_11) in dft/scalar/codelets/n1_11.c:418
codelet_n1_11(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_11", libfftw), Void, (Ptr{planner},), p)=#

#void X(codelet_n1_11) in dft/scalar/codelets/n1_11.c:418
function codelet_n1_11(p::Ptr{planner})::Void
    desc = kdft_desc(INT(11), cstringize("n1_11"), opcnt(R(60), R(20), R(80), R(0)), pointer_from_objref(GENUS_N), 0, 0, 0, 0)
#    pt = Ptr{kdft_desc}(malloc(sizeof(kdft_desc)))
#    unsafe_copy!(pt, pointer_from_objref(desc), sizeof(kdft_desc))
    func = cfunction(n1_11, Void, (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT))
    kdft_register(p, func, Ptr{kdft_desc}(pointer_from_objref(desc)))
#    kdft_register(p, func, pt)
    return nothing
end

#-----------------------------------------------------

#void n1_12 in dft/scalar/codelets/n1_12.c:214
function n1_12(ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R}, is::fftwstride, os::fftwstride, v::INT, ivs::INT, ovs::INT)::Void
    ccall(("n1_12", libcodelet), Void,
           (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT),
           ri, ii, ro, io, is, os, v, ivs, ovs)
    return nothing
end

#= #void X(codelet_n1_12) in dft/scalar/codelets/n1_12.c:397
codelet_n1_12(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_12", libfftw), Void, (Ptr{planner},), p)=#

#void X(codelet_n1_12) in dft/scalar/codelets/n1_12.c:397
function codelet_n1_12(p::Ptr{planner})::Void
    desc = kdft_desc(INT(12), cstringize("n1_12"), opcnt(R(88), R(8), R(8), R(0)), pointer_from_objref(GENUS_N), 0, 0, 0, 0)
#    pt = Ptr{kdft_desc}(malloc(sizeof(kdft_desc)))
#    unsafe_copy!(pt, pointer_from_objref(desc), sizeof(kdft_desc))
    func = cfunction(n1_12, Void, (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT))
    kdft_register(p, func, Ptr{kdft_desc}(pointer_from_objref(desc)))
#    kdft_register(p, func, pt)
    return nothing
end

#-----------------------------------------------------

#void n1_13 in dft/scalar/codelets/n1_13.c:364
function n1_13(ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R}, is::fftwstride, os::fftwstride, v::INT, ivs::INT, ovs::INT)::Void
    ccall(("n1_13", libcodelet), Void,
           (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT),
           ri, ii, ro, io, is, os, v, ivs, ovs)
    return nothing
end

#= #void X(codelet_n1_13) in dft/scalar/codelets/n1_13.c:675
codelet_n1_13(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_13", libfftw), Void, (Ptr{planner},), p)=#

#void X(codelet_n1_13) in dft/scalar/codelets/n1_13.c:675
function codelet_n1_13(p::Ptr{planner})::Void
    desc = kdft_desc(INT(13), cstringize("n1_13"), opcnt(R(138), R(30), R(38), R(0)), pointer_from_objref(GENUS_N), 0, 0, 0, 0)
#    pt = Ptr{kdft_desc}(malloc(sizeof(kdft_desc)))
#    unsafe_copy!(pt, pointer_from_objref(desc), sizeof(kdft_desc))
    func = cfunction(n1_13, Void, (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT))
    kdft_register(p, func, Ptr{kdft_desc}(pointer_from_objref(desc)))
#    kdft_register(p, func, pt)
    return nothing
end

#-----------------------------------------------------

#void n1_14 in dft/scalar/codelets/n1_14.c:297
function n1_14(ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R}, is::fftwstride, os::fftwstride, v::INT, ivs::INT, ovs::INT)::Void
    ccall(("n1_14", libcodelet), Void,
           (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT),
           ri, ii, ro, io, is, os, v, ivs, ovs)
    return nothing
end

#= #void X(codelet_n1_14) in dft/scalar/codelets/n1_14.c:505
codelet_n1_14(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_14", libfftw), Void, (Ptr{planner},), p)=#

#void X(codelet_n1_14) in dft/scalar/codelets/n1_14.c:505
function codelet_n1_14(p::Ptr{planner})::Void
    desc = kdft_desc(INT(14), cstringize("n1_14"), opcnt(R(100), R(24), R(48), R(0)), pointer_from_objref(GENUS_N), 0, 0, 0, 0)
#    pt = Ptr{kdft_desc}(malloc(sizeof(kdft_desc)))
#    unsafe_copy!(pt, pointer_from_objref(desc), sizeof(kdft_desc))
    func = cfunction(n1_14, Void, (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT))
    kdft_register(p, func, Ptr{kdft_desc}(pointer_from_objref(desc)))
#    kdft_register(p, func, pt)
    return nothing
end

#-----------------------------------------------------

#void n1_15 in dft/scalar/codelets/n1_15.c:326
function n1_15(ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R}, is::fftwstride, os::fftwstride, v::INT, ivs::INT, ovs::INT)::Void
    ccall(("n1_15", libcodelet), Void,
           (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT),
           ri, ii, ro, io, is, os, v, ivs, ovs)
    return nothing
end

#= #void X(codelet_n1_15) in dft/scalar/codelets/n1_15.c:576
codelet_n1_15(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_15", libfftw), Void, (Ptr{planner},), p)=#

#void X(codelet_n1_15) in dft/scalar/codelets/n1_15.c:576
function codelet_n1_15(p::Ptr{planner})::Void
    desc = kdft_desc(INT(15), cstringize("n1_15"), opcnt(R(128), R(28), R(28), R(0)), pointer_from_objref(GENUS_N), 0, 0, 0, 0)
#    pt = Ptr{kdft_desc}(malloc(sizeof(kdft_desc)))
#    unsafe_copy!(pt, pointer_from_objref(desc), sizeof(kdft_desc))
    func = cfunction(n1_15, Void, (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT))
    kdft_register(p, func, Ptr{kdft_desc}(pointer_from_objref(desc)))
#    kdft_register(p, func, pt)
    return nothing
end

#-----------------------------------------------------

#void n1_16 in dft/scalar/codelets/n1_16.c:299
function n1_16(ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R}, is::fftwstride, os::fftwstride, v::INT, ivs::INT, ovs::INT)::Void
    ccall(("n1_16", libcodelet), Void,
           (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT),
           ri, ii, ro, io, is, os, v, ivs, ovs)
    return nothing
end

#= #void X(codelet_n1_16) in dft/scalar/codelets/n1_16.c:552
codelet_n1_16(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_16", libfftw), Void, (Ptr{planner},), p)=#

#void X(codelet_n1_16) in dft/scalar/codelets/n1_16.c:552
function codelet_n1_16(p::Ptr{planner})::Void
    desc = kdft_desc(INT(16), cstringize("n1_16"), opcnt(R(136), R(16), R(8), R(0)), pointer_from_objref(GENUS_N), 0, 0, 0, 0)
#    pt = Ptr{kdft_desc}(malloc(sizeof(kdft_desc)))
#    unsafe_copy!(pt, pointer_from_objref(desc), sizeof(kdft_desc))
    func = cfunction(n1_16, Void, (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT))
    kdft_register(p, func, Ptr{kdft_desc}(pointer_from_objref(desc)))
#    kdft_register(p, func, pt)
    return nothing
end

#-----------------------------------------------------

#void n1_32 in dft/scalar/codelets/n1_32.c:655
function n1_32(ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R}, is::fftwstride, os::fftwstride, v::INT, ivs::INT, ovs::INT)::Void
    ccall(("n1_32", libcodelet), Void,
           (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT),
           ri, ii, ro, io, is, os, v, ivs, ovs)
    return nothing
end

#= #void X(codelet_n1_32) in dft/scalar/codelets/n1_32.c:1287
codelet_n1_32(p::Ptr{planner})::Void = 
    ccall(("fftw_codelet_n1_32", libfftw), Void, (Ptr{planner},), p)=#

#void X(codelet_n1_32) in dft/scalar/codelets/n1_32.c:1287
function codelet_n1_32(p::Ptr{planner})::Void
    desc = kdft_desc(INT(32), cstringize("n1_32"), opcnt(R(340), R(52), R(32), R(0)), pointer_from_objref(GENUS_N), 0, 0, 0, 0)
#    pt = Ptr{kdft_desc}(malloc(sizeof(kdft_desc)))
#    unsafe_copy!(pt, pointer_from_objref(desc), sizeof(kdft_desc))
    func = cfunction(n1_32, Void, (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT))
    kdft_register(p, func, Ptr{kdft_desc}(pointer_from_objref(desc)))
#    kdft_register(p, func, pt)
    return nothing
end

#-----------------------------------------------------

#void n1_64 in dft/scalar/codelets/n1_64.c:1461
function n1_64(ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R}, is::fftwstride, os::fftwstride, v::INT, ivs::INT, ovs::INT)::Void
    ccall(("n1_64", libcodelet), Void,
           (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT),
           ri, ii, ro, io, is, os, v, ivs, ovs)
    return nothing
end

#= #void X(codelet_n1_64) in dft/scalar/codelets/n1_64.c:2977
codelet_n1_64(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_64", libfftw), Void, (Ptr{planner},), p)=#

#void X(codelet_n1_64) in dft/scalar/codelets/n1_64.c:2977
function codelet_n1_64(p::Ptr{planner})::Void
    desc = kdft_desc(INT(64), cstringize("n1_64"), opcnt(R(808), R(144), R(104), R(0)), pointer_from_objref(GENUS_N), 0, 0, 0, 0)
#    pt = Ptr{kdft_desc}(malloc(sizeof(kdft_desc)))
#    unsafe_copy!(pt, pointer_from_objref(desc), sizeof(kdft_desc))
    func = cfunction(n1_64, Void, (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT))
    kdft_register(p, func, Ptr{kdft_desc}(pointer_from_objref(desc)))
#    kdft_register(p, func, pt)
    return nothing
end

#-----------------------------------------------------

#void n1_20 in dft/scalar/codelets/n1_20.c:413
function n1_20(ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R}, is::fftwstride, os::fftwstride, v::INT, ivs::INT, ovs::INT)::Void
    ccall(("n1_20", libcodelet), Void,
           (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT),
           ri, ii, ro, io, is, os, v, ivs, ovs)
    return nothing
end

#= #void X(codelet_n1_20) in dft/scalar/codelets/n1_20.c:745
codelet_n1_20(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_20", libfftw), Void, (Ptr{planner},), p)=#

#void X(codelet_n1_20) in dft/scalar/codelets/n1_20.c:745
function codelet_n1_20(p::Ptr{planner})::Void
    desc = kdft_desc(INT(20), cstringize("n1_20"), opcnt(R(184), R(24), R(24), R(0)), pointer_from_objref(GENUS_N), 0, 0, 0, 0)
#    pt = Ptr{kdft_desc}(malloc(sizeof(kdft_desc)))
#    unsafe_copy!(pt, pointer_from_objref(desc), sizeof(kdft_desc))
    func = cfunction(n1_20, Void, (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT))
    kdft_register(p, func, Ptr{kdft_desc}(pointer_from_objref(desc)))
#    kdft_register(p, func, pt)
    return nothing
end

#-----------------------------------------------------

#void n1_25 in dft/scalar/codelets/n1_25.c:632
function n1_25(ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R}, is::fftwstride, os::fftwstride, v::INT, ivs::INT, ovs::INT)::Void
    ccall(("n1_25", libcodelet), Void,
           (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT),
           ri, ii, ro, io, is, os, v, ivs, ovs)
    return nothing
end

#= #void X(codelet_n1_25) in dft/scalar/codelets/n1_25.c:1203
codelet_n1_25(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_25", libfftw), Void, (Ptr{planner},), p)=#

#void X(codelet_n1_25) in dft/scalar/codelets/n1_25.c:1203
function codelet_n1_25(p::Ptr{planner})::Void
    desc = kdft_desc(INT(25), cstringize("n1_25"), opcnt(R(260), R(92), R(92), R(0)), pointer_from_objref(GENUS_N), 0, 0, 0, 0)
#    pt = Ptr{kdft_desc}(malloc(sizeof(kdft_desc)))
#    unsafe_copy!(pt, pointer_from_objref(desc), sizeof(kdft_desc))
    func = cfunction(n1_25, Void, (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, fftwstride, INT, INT, INT))
    kdft_register(p, func, Ptr{kdft_desc}(pointer_from_objref(desc)))
#    kdft_register(p, func, pt)
    return nothing
end

#-----------------------------------------------------

#void t1_2 in dft/scalar/codelets/t1_2.c:85
function t1_2(ri::Ptr{R}, ii::Ptr{R}, W::Ptr{R}, rs::fftwstride, mb::INT, me::INT, ms::INT)::Void
    ccall(("t1_2", libcodelet), Void,
          (Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, INT, INT, INT),
          ri, ii, W, rs, mb, me, ms)
    return nothing
end

#void X(codelet_t1_2) in dft/scalar/codelets/t1_2.c:117
codelet_t1_2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1_2", libfftw), Void, (Ptr{planner},), p)
#=
#void X(codelet_t1_2) in dft/scalar/codelets/t1_2.c:117
function codelet_t1_2(p::Ptr{planner})::Void
    twinstr = [tw_instr(Cuchar(TW_FULL), Cchar(0), Cshort(2)),
               tw_instr(Cuchar(TW_NEXT), Cchar(1), Cshort(0))]
    desc = ct_desc(INT(2), cstringize("t1_2"), pointer(twinstr), pointer_from_objref(GENUS_T), opcnt(R(4), R(2), R(2), R(0)), INT(0), INT(0), INT(0))
    func = cfunction(t1_2, Void, (Ptr{R}, Ptr{R}, Ptr{R}, fftwstride, INT, INT, INT))
    kdft_dit_register(p, func, Ptr{ct_desc}(pointer_from_objref(desc)))
    return nothing
end=#


#void X(codelet_t1_3) in dft/scalar/codelets/t1_3.c:160
codelet_t1_3(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1_3", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_t1_4) in dft/scalar/codelets/t1_4.c:190
codelet_t1_4(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1_4", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_t1_5) in dft/scalar/codelets/t1_5.c:256
codelet_t1_5(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1_5", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_t1_6) in dft/scalar/codelets/t1_6.c:287
codelet_t1_6(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1_6", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_t1_7) in dft/scalar/codelets/t1_7.c:352
codelet_t1_7(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1_7", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_t1_8) in dft/scalar/codelets/t1_8.c:367
codelet_t1_8(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1_8", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_t1_9) in dft/scalar/codelets/t1_9.c:478
codelet_t1_9(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1_9", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_t1_10) in dft/scalar/codelets/t1_10.c:498
codelet_t1_10(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1_10", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_t1_12) in dft/scalar/codelets/t1_12.c:563
codelet_t1_12(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1_12", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_t1_15) in dft/scalar/codelets/t1_15.c:798
codelet_t1_15(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1_15", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_t1_16) in dft/scalar/codelets/t1_16.c:782
codelet_t1_16(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1_16", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_t1_32) in dft/scalar/codelets/t1_32.c:1768
codelet_t1_32(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1_32", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_t1_64) in dft/scalar/codelets/t1_64.c:3972
codelet_t1_64(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1_64", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_t1_20) in dft/scalar/codelets/t1_20.c:1026
codelet_t1_20(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1_20", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_t1_25) in dft/scalar/codelets/t1_25.c:1558
codelet_t1_25(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1_25", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_t2_4) in dft/scalar/codelets/t2_4.c:194
codelet_t2_4(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2_4", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_t2_8) in dft/scalar/codelets/t2_8.c:388
codelet_t2_8(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2_8", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_t2_16) in dft/scalar/codelets/t2_16.c:824
codelet_t2_16(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2_16", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_t2_32) in dft/scalar/codelets/t2_32.c:1841
codelet_t2_32(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2_32", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_t2_64) in dft/scalar/codelets/t2_64.c:4093
codelet_t2_64(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2_64", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_t2_5) in dft/scalar/codelets/t2_5.c:268
codelet_t2_5(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2_5", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_t2_10) in dft/scalar/codelets/t2_10.c:506
codelet_t2_10(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2_10", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_t2_20) in dft/scalar/codelets/t2_20.c:1061
codelet_t2_20(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2_20", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_t2_25) in dft/scalar/codelets/t2_25.c:1616
codelet_t2_25(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2_25", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_q1_2) in dft/scalar/codelets/q1_2.c:146
codelet_q1_2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_q1_2", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_q1_4) in dft/scalar/codelets/q1_4.c:515
codelet_q1_4(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_q1_4", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_q1_8) in dft/scalar/codelets/q1_8.c:2393
codelet_q1_8(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_q1_8", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_q1_3) in dft/scalar/codelets/q1_3.c:313
codelet_q1_3(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_q1_3", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_q1_5) in dft/scalar/codelets/q1_5.c:980
codelet_q1_5(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_q1_5", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_q1_6) in dft/scalar/codelets/q1_6.c:1310
codelet_q1_6(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_q1_6", libfftw), Void, (Ptr{planner},), p)


const solvtab_dft_standard = (
                              solvtab(codelet_n1_2),
#=                              solvtab(codelet_n1_3),
                              solvtab(codelet_n1_4),=#
                              solvtab(codelet_n1_5),
#=                              solvtab(codelet_n1_6),
                              solvtab(codelet_n1_7),
                              solvtab(codelet_n1_8),
                              solvtab(codelet_n1_9),
                              solvtab(codelet_n1_10),
                              solvtab(codelet_n1_11),
                              solvtab(codelet_n1_12),
                              solvtab(codelet_n1_13),
                              solvtab(codelet_n1_14),
                              solvtab(codelet_n1_15),
                              solvtab(codelet_n1_16),
                              solvtab(codelet_n1_32),
                              solvtab(codelet_n1_64),
                              solvtab(codelet_n1_20),
                              solvtab(codelet_n1_25),=#
                              solvtab(codelet_t1_2),
#=                              solvtab(codelet_t1_3),
                              solvtab(codelet_t1_4),=#
                              solvtab(codelet_t1_5),
#=                              solvtab(codelet_t1_6),
                              solvtab(codelet_t1_7),
                              solvtab(codelet_t1_8),
                              solvtab(codelet_t1_9),
                              solvtab(codelet_t1_10),
                              solvtab(codelet_t1_12),
                              solvtab(codelet_t1_15),
                              solvtab(codelet_t1_16),
                              solvtab(codelet_t1_32),
                              solvtab(codelet_t1_64),
                              solvtab(codelet_t1_20),
                              solvtab(codelet_t1_25),
                              solvtab(codelet_t2_4),
                              solvtab(codelet_t2_8),
                              solvtab(codelet_t2_16),
                              solvtab(codelet_t2_32),
                              solvtab(codelet_t2_64),
                              solvtab(codelet_t2_5),
                              solvtab(codelet_t2_10),
                              solvtab(codelet_t2_20),
                              solvtab(codelet_t2_25),=#
                              solvtab(codelet_q1_2),
#=                              solvtab(codelet_q1_4),
                              solvtab(codelet_q1_8),
                              solvtab(codelet_q1_3),
                              solvtab(codelet_q1_5),
                              solvtab(codelet_q1_6),=#
                              SOLVTAB_END)

#=for elem in solvtab_dft_standard
    finalizer(elem, finalize_solvtab)
end=#
