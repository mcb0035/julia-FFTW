#wrappers for dft scalar codelets


#void X(codelet_n1_2) in dft/scalar/codelets/n1_2.c:92
codelet_n1_2(p::Ptr{planner})::Void = 
    ccall(("fftw_codelet_n1_2", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_n1_3) in dft/scalar/codelets/n1_3.c:122
codelet_n1_3(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_3", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_n1_4) in dft/scalar/codelets/n1_4.c:136
codelet_n1_4(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_4", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_n1_5) in dft/scalar/codelets/n1_5.c:189
codelet_n1_5(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_5", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_n1_6) in dft/scalar/codelets/n1_6.c:210
codelet_n1_6(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_6", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_n1_7) in dft/scalar/codelets/n1_7.c:247
codelet_n1_7(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_7", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_n1_8) in dft/scalar/codelets/n1_8.c:264
codelet_n1_8(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_8", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_n1_9) in dft/scalar/codelets/n1_9.c:358
codelet_n1_9(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_9", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_n1_10) in dft/scalar/codelets/n1_10.c:360
codelet_n1_10(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_10", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_n1_11) in dft/scalar/codelets/n1_11.c:418
codelet_n1_11(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_11", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_n1_12) in dft/scalar/codelets/n1_12.c:397
codelet_n1_12(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_12", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_n1_13) in dft/scalar/codelets/n1_13.c:675
codelet_n1_13(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_13", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_n1_14) in dft/scalar/codelets/n1_14.c:505
codelet_n1_14(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_14", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_n1_15) in dft/scalar/codelets/n1_15.c:576
codelet_n1_15(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_15", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_n1_16) in dft/scalar/codelets/n1_16.c:552
codelet_n1_16(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_16", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_n1_32) in dft/scalar/codelets/n1_32.c:1287
codelet_n1_32(p::Ptr{planner})::Void = 
    ccall(("fftw_codelet_n1_32", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_n1_64) in dft/scalar/codelets/n1_64.c:2977
codelet_n1_64(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_64", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_n1_20) in dft/scalar/codelets/n1_20.c:745
codelet_n1_20(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_20", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_n1_25) in dft/scalar/codelets/n1_25.c:1203
codelet_n1_25(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1_25", libfftw), Void, (Ptr{planner},), p)

#void X(codelet_t1_2) in dft/scalar/codelets/t1_2.c:117
codelet_t1_2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1_2", libfftw), Void, (Ptr{planner},), p)

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


const solvtab_dft_standard = (solvtab(codelet_n1_2),
                              solvtab(codelet_n1_3),
                              solvtab(codelet_n1_4),
                              solvtab(codelet_n1_5),
                              solvtab(codelet_n1_6),
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
                              solvtab(codelet_n1_25),
                              solvtab(codelet_t1_2),
                              solvtab(codelet_t1_3),
                              solvtab(codelet_t1_4),
                              solvtab(codelet_t1_5),
                              solvtab(codelet_t1_6),
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
                              solvtab(codelet_t2_25),
                              solvtab(codelet_q1_2),
                              solvtab(codelet_q1_4),
                              solvtab(codelet_q1_8),
                              solvtab(codelet_q1_3),
                              solvtab(codelet_q1_5),
                              solvtab(codelet_q1_6),
                              SOLVTAB_END)

for elem in solvtab_dft_standard
    finalizer(elem, finalize_solvtab)
end
