#wrappers for dft sse2 codelets

#void XSIMD(codelet_n1fv_2) in dft/simd/common/n1fv_2.c:94
codelet_n1fv_2_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1fv_2_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1fv_3) in dft/simd/common/n1fv_3.c:108
codelet_n1fv_3_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1fv_3_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1fv_4) in dft/simd/common/n1fv_4.c:116
codelet_n1fv_4_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1fv_4_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1fv_5) in dft/simd/common/n1fv_5.c:148
codelet_n1fv_5_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1fv_5_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1fv_6) in dft/simd/common/n1fv_6.c:150
codelet_n1fv_6_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1fv_6_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1fv_7) in dft/simd/common/n1fv_7.c:177
codelet_n1fv_7_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1fv_7_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1fv_8) in dft/simd/common/n1fv_8.c:177
codelet_n1fv_8_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1fv_8_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1fv_9) in dft/simd/common/n1fv_9.c:249
codelet_n1fv_9_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1fv_9_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1fv_10) in dft/simd/common/n1fv_10.c:228
codelet_n1fv_10_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1fv_10_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1fv_11) in dft/simd/common/n1fv_11.c:265
codelet_n1fv_11_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1fv_11_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1fv_12) in dft/simd/common/n1fv_12.c:249
codelet_n1fv_12_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1fv_12_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1fv_13) in dft/simd/common/n1fv_13.c:402
codelet_n1fv_13_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1fv_13_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1fv_14) in dft/simd/common/n1fv_14.c:304
codelet_n1fv_14_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1fv_14_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1fv_15) in dft/simd/common/n1fv_15.c:341
codelet_n1fv_15_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1fv_15_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1fv_16) in dft/simd/common/n1fv_16.c:336
codelet_n1fv_16_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1fv_16_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1fv_32) in dft/simd/common/n1fv_32.c:692
codelet_n1fv_32_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1fv_32_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1fv_64) in dft/simd/common/n1fv_64.c:1564
codelet_n1fv_64_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1fv_64_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1fv_128) in dft/simd/common/n1fv_128.c:3523
codelet_n1fv_128_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1fv_128_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1fv_20) in dft/simd/common/n1fv_20.c:412
codelet_n1fv_20_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1fv_20_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1fv_25) in dft/simd/common/n1fv_25.c:789
codelet_n1fv_25_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1fv_25_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1bv_2) in dft/simd/common/n1bv_2.c:94
codelet_n1bv_2_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1bv_2_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1bv_3) in dft/simd/common/n1bv_3.c:108
codelet_n1bv_3_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1bv_3_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1bv_4) in dft/simd/common/n1bv_4.c:116
codelet_n1bv_4_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1bv_4_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1bv_5) in dft/simd/common/n1bv_5.c:148
codelet_n1bv_5_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1bv_5_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1bv_6) in dft/simd/common/n1bv_6.c:150
codelet_n1bv_6_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1bv_6_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1bv_7) in dft/simd/common/n1bv_7.c:177
codelet_n1bv_7_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1bv_7_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1bv_8) in dft/simd/common/n1bv_8.c:177
codelet_n1bv_8_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1bv_8_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1bv_9) in dft/simd/common/n1bv_9.c:249
codelet_n1bv_9_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1bv_9_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1bv_10) in dft/simd/common/n1bv_10.c:228
codelet_n1bv_10_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1bv_10_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1bv_11) in dft/simd/common/n1bv_11.c:265
codelet_n1bv_11_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1bv_11_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1bv_12) in dft/simd/common/n1bv_12.c:249
codelet_n1bv_12_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1bv_12_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1bv_13) in dft/simd/common/n1bv_13.c:402
codelet_n1bv_13_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1bv_13_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1bv_14) in dft/simd/common/n1bv_14.c:304
codelet_n1bv_14_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1bv_14_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1bv_15) in dft/simd/common/n1bv_15.c:341
codelet_n1bv_15_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1bv_15_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1bv_16) in dft/simd/common/n1bv_16.c:336
codelet_n1bv_16_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1bv_16_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1bv_32) in dft/simd/common/n1bv_32.c:692
codelet_n1bv_32_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1bv_32_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1bv_64) in dft/simd/common/n1bv_64.c:1564
codelet_n1bv_64_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1bv_64_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1bv_128) in dft/simd/common/n1bv_128.c:3523
codelet_n1bv_128_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1bv_128_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1bv_20) in dft/simd/common/n1bv_20.c:412
codelet_n1bv_20_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1bv_20_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n1bv_25) in dft/simd/common/n1bv_25.c:789
codelet_n1bv_25_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n1bv_25_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2fv_2) in dft/simd/common/n2fv_2.c:100
codelet_n2fv_2_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2fv_2_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2fv_4) in dft/simd/common/n2fv_4.c:134
codelet_n2fv_4_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2fv_4_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2fv_6) in dft/simd/common/n2fv_6.c:177
codelet_n2fv_6_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2fv_6_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2fv_8) in dft/simd/common/n2fv_8.c:207
codelet_n2fv_8_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2fv_8_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2fv_10) in dft/simd/common/n2fv_10.c:273
codelet_n2fv_10_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2fv_10_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2fv_12) in dft/simd/common/n2fv_12.c:300
codelet_n2fv_12_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2fv_12_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2fv_14) in dft/simd/common/n2fv_14.c:365
codelet_n2fv_14_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2fv_14_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2fv_16) in dft/simd/common/n2fv_16.c:408
codelet_n2fv_16_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2fv_16_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2fv_32) in dft/simd/common/n2fv_32.c:819
codelet_n2fv_32_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2fv_32_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2fv_64) in dft/simd/common/n2fv_64.c:1811
codelet_n2fv_64_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2fv_64_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2fv_20) in dft/simd/common/n2fv_20.c:491
codelet_n2fv_20_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2fv_20_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2bv_2) in dft/simd/common/n2bv_2.c:100
codelet_n2bv_2_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2bv_2_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2bv_4) in dft/simd/common/n2bv_4.c:134
codelet_n2bv_4_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2bv_4_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2bv_6) in dft/simd/common/n2bv_6.c:177
codelet_n2bv_6_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2bv_6_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2bv_8) in dft/simd/common/n2bv_8.c:207
codelet_n2bv_8_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2bv_8_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2bv_10) in dft/simd/common/n2bv_10.c:273
codelet_n2bv_10_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2bv_10_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2bv_12) in dft/simd/common/n2bv_12.c:300
codelet_n2bv_12_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2bv_12_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2bv_14) in dft/simd/common/n2bv_14.c:365
codelet_n2bv_14_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2bv_14_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2bv_16) in dft/simd/common/n2bv_16.c:408
codelet_n2bv_16_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2bv_16_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2bv_32) in dft/simd/common/n2bv_32.c:819
codelet_n2bv_32_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2bv_32_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2bv_64) in dft/simd/common/n2bv_64.c:1811
codelet_n2bv_64_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2bv_64_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2bv_20) in dft/simd/common/n2bv_20.c:491
codelet_n2bv_20_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2bv_20_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2sv_4) in dft/simd/common/n2sv_4.c:167
codelet_n2sv_4_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2sv_4_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2sv_8) in dft/simd/common/n2sv_8.c:307
codelet_n2sv_8_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2sv_8_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2sv_16) in dft/simd/common/n2sv_16.c:649
codelet_n2sv_16_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2sv_16_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2sv_32) in dft/simd/common/n2sv_32.c:1449
codelet_n2sv_32_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2sv_32_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_n2sv_64) in dft/simd/common/n2sv_64.c:3299
codelet_n2sv_64_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_n2sv_64_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fuv_2) in dft/simd/common/t1fuv_2.c:101
codelet_t1fuv_2_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fuv_2_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fuv_3) in dft/simd/common/t1fuv_3.c:122
codelet_t1fuv_3_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fuv_3_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fuv_4) in dft/simd/common/t1fuv_4.c:131
codelet_t1fuv_4_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fuv_4_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fuv_5) in dft/simd/common/t1fuv_5.c:173
codelet_t1fuv_5_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fuv_5_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fuv_6) in dft/simd/common/t1fuv_6.c:179
codelet_t1fuv_6_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fuv_6_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fuv_7) in dft/simd/common/t1fuv_7.c:210
codelet_t1fuv_7_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fuv_7_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fuv_8) in dft/simd/common/t1fuv_8.c:214
codelet_t1fuv_8_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fuv_8_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fuv_9) in dft/simd/common/t1fuv_9.c:293
codelet_t1fuv_9_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fuv_9_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fuv_10) in dft/simd/common/t1fuv_10.c:277
codelet_t1fuv_10_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fuv_10_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fv_2) in dft/simd/common/t1fv_2.c:101
codelet_t1fv_2_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fv_2_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fv_3) in dft/simd/common/t1fv_3.c:122
codelet_t1fv_3_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fv_3_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fv_4) in dft/simd/common/t1fv_4.c:131
codelet_t1fv_4_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fv_4_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fv_5) in dft/simd/common/t1fv_5.c:173
codelet_t1fv_5_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fv_5_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fv_6) in dft/simd/common/t1fv_6.c:179
codelet_t1fv_6_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fv_6_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fv_7) in dft/simd/common/t1fv_7.c:210
codelet_t1fv_7_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fv_7_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fv_8) in dft/simd/common/t1fv_8.c:214
codelet_t1fv_8_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fv_8_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fv_9) in dft/simd/common/t1fv_9.c:293
codelet_t1fv_9_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fv_9_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fv_10) in dft/simd/common/t1fv_10.c:277
codelet_t1fv_10_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fv_10_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fv_12) in dft/simd/common/t1fv_12.c:312
codelet_t1fv_12_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fv_12_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fv_15) in dft/simd/common/t1fv_15.c:419
codelet_t1fv_15_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fv_15_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fv_16) in dft/simd/common/t1fv_16.c:415
codelet_t1fv_16_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fv_16_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fv_32) in dft/simd/common/t1fv_32.c:860
codelet_t1fv_32_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fv_32_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fv_64) in dft/simd/common/t1fv_64.c:1874
codelet_t1fv_64_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fv_64_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fv_20) in dft/simd/common/t1fv_20.c:516
codelet_t1fv_20_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fv_20_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1fv_25) in dft/simd/common/t1fv_25.c:929
codelet_t1fv_25_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1fv_25_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t2fv_2) in dft/simd/common/t2fv_2.c:101
codelet_t2fv_2_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2fv_2_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t2fv_4) in dft/simd/common/t2fv_4.c:131
codelet_t2fv_4_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2fv_4_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t2fv_8) in dft/simd/common/t2fv_8.c:214
codelet_t2fv_8_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2fv_8_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t2fv_16) in dft/simd/common/t2fv_16.c:415
codelet_t2fv_16_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2fv_16_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t2fv_32) in dft/simd/common/t2fv_32.c:860
codelet_t2fv_32_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2fv_32_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t2fv_64) in dft/simd/common/t2fv_64.c:1874
codelet_t2fv_64_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2fv_64_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t2fv_5) in dft/simd/common/t2fv_5.c:173
codelet_t2fv_5_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2fv_5_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t2fv_10) in dft/simd/common/t2fv_10.c:277
codelet_t2fv_10_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2fv_10_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t2fv_20) in dft/simd/common/t2fv_20.c:516
codelet_t2fv_20_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2fv_20_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t2fv_25) in dft/simd/common/t2fv_25.c:929
codelet_t2fv_25_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2fv_25_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t3fv_4) in dft/simd/common/t3fv_4.c:141
codelet_t3fv_4_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t3fv_4_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t3fv_8) in dft/simd/common/t3fv_8.c:226
codelet_t3fv_8_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t3fv_8_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t3fv_16) in dft/simd/common/t3fv_16.c:432
codelet_t3fv_16_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t3fv_16_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t3fv_32) in dft/simd/common/t3fv_32.c:878
codelet_t3fv_32_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t3fv_32_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t3fv_5) in dft/simd/common/t3fv_5.c:180
codelet_t3fv_5_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t3fv_5_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t3fv_10) in dft/simd/common/t3fv_10.c:284
codelet_t3fv_10_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t3fv_10_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t3fv_20) in dft/simd/common/t3fv_20.c:530
codelet_t3fv_20_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t3fv_20_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t3fv_25) in dft/simd/common/t3fv_25.c:945
codelet_t3fv_25_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t3fv_25_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1buv_2) in dft/simd/common/t1buv_2.c:101
codelet_t1buv_2_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1buv_2_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1buv_3) in dft/simd/common/t1buv_3.c:122
codelet_t1buv_3_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1buv_3_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1buv_4) in dft/simd/common/t1buv_4.c:131
codelet_t1buv_4_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1buv_4_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1buv_5) in dft/simd/common/t1buv_5.c:173
codelet_t1buv_5_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1buv_5_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1buv_6) in dft/simd/common/t1buv_6.c:179
codelet_t1buv_6_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1buv_6_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1buv_7) in dft/simd/common/t1buv_7.c:210
codelet_t1buv_7_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1buv_7_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1buv_8) in dft/simd/common/t1buv_8.c:214
codelet_t1buv_8_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1buv_8_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1buv_9) in dft/simd/common/t1buv_9.c:293
codelet_t1buv_9_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1buv_9_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1buv_10) in dft/simd/common/t1buv_10.c:277
codelet_t1buv_10_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1buv_10_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1bv_2) in dft/simd/common/t1bv_2.c:101
codelet_t1bv_2_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1bv_2_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1bv_3) in dft/simd/common/t1bv_3.c:122
codelet_t1bv_3_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1bv_3_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1bv_4) in dft/simd/common/t1bv_4.c:131
codelet_t1bv_4_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1bv_4_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1bv_5) in dft/simd/common/t1bv_5.c:173
codelet_t1bv_5_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1bv_5_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1bv_6) in dft/simd/common/t1bv_6.c:179
codelet_t1bv_6_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1bv_6_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1bv_7) in dft/simd/common/t1bv_7.c:210
codelet_t1bv_7_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1bv_7_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1bv_8) in dft/simd/common/t1bv_8.c:214
codelet_t1bv_8_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1bv_8_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1bv_9) in dft/simd/common/t1bv_9.c:293
codelet_t1bv_9_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1bv_9_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1bv_10) in dft/simd/common/t1bv_10.c:277
codelet_t1bv_10_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1bv_10_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1bv_12) in dft/simd/common/t1bv_12.c:312
codelet_t1bv_12_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1bv_12_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1bv_15) in dft/simd/common/t1bv_15.c:419
codelet_t1bv_15_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1bv_15_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1bv_16) in dft/simd/common/t1bv_16.c:415
codelet_t1bv_16_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1bv_16_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1bv_32) in dft/simd/common/t1bv_32.c:860
codelet_t1bv_32_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1bv_32_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1bv_64) in dft/simd/common/t1bv_64.c:1874
codelet_t1bv_64_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1bv_64_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1bv_20) in dft/simd/common/t1bv_20.c:516
codelet_t1bv_20_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1bv_20_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1bv_25) in dft/simd/common/t1bv_25.c:929
codelet_t1bv_25_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1bv_25_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t2bv_2) in dft/simd/common/t2bv_2.c:101
codelet_t2bv_2_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2bv_2_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t2bv_4) in dft/simd/common/t2bv_4.c:131
codelet_t2bv_4_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2bv_4_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t2bv_8) in dft/simd/common/t2bv_8.c:214
codelet_t2bv_8_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2bv_8_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t2bv_16) in dft/simd/common/t2bv_16.c:415
codelet_t2bv_16_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2bv_16_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t2bv_32) in dft/simd/common/t2bv_32.c:860
codelet_t2bv_32_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2bv_32_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t2bv_64) in dft/simd/common/t2bv_64.c:1874
codelet_t2bv_64_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2bv_64_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t2bv_5) in dft/simd/common/t2bv_5.c:173
codelet_t2bv_5_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2bv_5_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t2bv_10) in dft/simd/common/t2bv_10.c:277
codelet_t2bv_10_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2bv_10_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t2bv_20) in dft/simd/common/t2bv_20.c:516
codelet_t2bv_20_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2bv_20_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t2bv_25) in dft/simd/common/t2bv_25.c:929
codelet_t2bv_25_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2bv_25_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t3bv_4) in dft/simd/common/t3bv_4.c:141
codelet_t3bv_4_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t3bv_4_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t3bv_8) in dft/simd/common/t3bv_8.c:226
codelet_t3bv_8_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t3bv_8_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t3bv_16) in dft/simd/common/t3bv_16.c:432
codelet_t3bv_16_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t3bv_16_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t3bv_32) in dft/simd/common/t3bv_32.c:878
codelet_t3bv_32_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t3bv_32_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t3bv_5) in dft/simd/common/t3bv_5.c:180
codelet_t3bv_5_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t3bv_5_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t3bv_10) in dft/simd/common/t3bv_10.c:284
codelet_t3bv_10_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t3bv_10_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t3bv_20) in dft/simd/common/t3bv_20.c:530
codelet_t3bv_20_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t3bv_20_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t3bv_25) in dft/simd/common/t3bv_25.c:945
codelet_t3bv_25_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t3bv_25_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1sv_2) in dft/simd/common/t1sv_2.c:119
codelet_t1sv_2_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1sv_2_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1sv_4) in dft/simd/common/t1sv_4.c:194
codelet_t1sv_4_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1sv_4_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1sv_8) in dft/simd/common/t1sv_8.c:376
codelet_t1sv_8_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1sv_8_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1sv_16) in dft/simd/common/t1sv_16.c:806
codelet_t1sv_16_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1sv_16_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t1sv_32) in dft/simd/common/t1sv_32.c:1781
codelet_t1sv_32_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t1sv_32_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t2sv_4) in dft/simd/common/t2sv_4.c:193
codelet_t2sv_4_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2sv_4_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t2sv_8) in dft/simd/common/t2sv_8.c:386
codelet_t2sv_8_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2sv_8_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t2sv_16) in dft/simd/common/t2sv_16.c:821
codelet_t2sv_16_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2sv_16_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_t2sv_32) in dft/simd/common/t2sv_32.c:1797
codelet_t2sv_32_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_t2sv_32_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_q1fv_2) in dft/simd/common/q1fv_2.c:111
codelet_q1fv_2_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_q1fv_2_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_q1fv_4) in dft/simd/common/q1fv_4.c:250
codelet_q1fv_4_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_q1fv_4_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_q1fv_5) in dft/simd/common/q1fv_5.c:436
codelet_q1fv_5_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_q1fv_5_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_q1fv_8) in dft/simd/common/q1fv_8.c:988
codelet_q1fv_8_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_q1fv_8_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_q1bv_2) in dft/simd/common/q1bv_2.c:111
codelet_q1bv_2_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_q1bv_2_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_q1bv_4) in dft/simd/common/q1bv_4.c:250
codelet_q1bv_4_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_q1bv_4_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_q1bv_5) in dft/simd/common/q1bv_5.c:436
codelet_q1bv_5_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_q1bv_5_sse2", libfftw), Void, (Ptr{planner},), p)

#void XSIMD(codelet_q1bv_8) in dft/simd/common/q1bv_8.c:988
codelet_q1bv_8_sse2(p::Ptr{planner})::Void =
    ccall(("fftw_codelet_q1bv_8_sse2", libfftw), Void, (Ptr{planner},), p)

const solvtab_dft_sse2 = (
                          solvtab(codelet_n1fv_2_sse2),
                          solvtab(codelet_n1fv_3_sse2),
                          solvtab(codelet_n1fv_4_sse2),
                          solvtab(codelet_n1fv_5_sse2),
                          solvtab(codelet_n1fv_6_sse2),
                          solvtab(codelet_n1fv_7_sse2),
                          solvtab(codelet_n1fv_8_sse2),
                          solvtab(codelet_n1fv_9_sse2),
                          solvtab(codelet_n1fv_10_sse2),
                          solvtab(codelet_n1fv_11_sse2),
                          solvtab(codelet_n1fv_12_sse2),
                          solvtab(codelet_n1fv_13_sse2),
                          solvtab(codelet_n1fv_14_sse2),
                          solvtab(codelet_n1fv_15_sse2),
                          solvtab(codelet_n1fv_16_sse2),
                          solvtab(codelet_n1fv_32_sse2),
                          solvtab(codelet_n1fv_64_sse2),
                          solvtab(codelet_n1fv_128_sse2),
                          solvtab(codelet_n1fv_20_sse2),
                          solvtab(codelet_n1fv_25_sse2),
                          solvtab(codelet_n1bv_2_sse2),
                          solvtab(codelet_n1bv_3_sse2),
                          solvtab(codelet_n1bv_4_sse2),
                          solvtab(codelet_n1bv_5_sse2),
                          solvtab(codelet_n1bv_6_sse2),
                          solvtab(codelet_n1bv_7_sse2),
                          solvtab(codelet_n1bv_8_sse2),
                          solvtab(codelet_n1bv_9_sse2),
                          solvtab(codelet_n1bv_10_sse2),
                          solvtab(codelet_n1bv_11_sse2),
                          solvtab(codelet_n1bv_12_sse2),
                          solvtab(codelet_n1bv_13_sse2),
                          solvtab(codelet_n1bv_14_sse2),
                          solvtab(codelet_n1bv_15_sse2),
                          solvtab(codelet_n1bv_16_sse2),
                          solvtab(codelet_n1bv_32_sse2),
                          solvtab(codelet_n1bv_64_sse2),
                          solvtab(codelet_n1bv_128_sse2),
                          solvtab(codelet_n1bv_20_sse2),
                          solvtab(codelet_n1bv_25_sse2),
                          solvtab(codelet_n2fv_2_sse2),
                          solvtab(codelet_n2fv_4_sse2),
                          solvtab(codelet_n2fv_6_sse2),
                          solvtab(codelet_n2fv_8_sse2),
                          solvtab(codelet_n2fv_10_sse2),
                          solvtab(codelet_n2fv_12_sse2),
                          solvtab(codelet_n2fv_14_sse2),
                          solvtab(codelet_n2fv_16_sse2),
                          solvtab(codelet_n2fv_32_sse2),
                          solvtab(codelet_n2fv_64_sse2),
                          solvtab(codelet_n2fv_20_sse2),
                          solvtab(codelet_n2bv_2_sse2),
                          solvtab(codelet_n2bv_4_sse2),
                          solvtab(codelet_n2bv_6_sse2),
                          solvtab(codelet_n2bv_8_sse2),
                          solvtab(codelet_n2bv_10_sse2),
                          solvtab(codelet_n2bv_12_sse2),
                          solvtab(codelet_n2bv_14_sse2),
                          solvtab(codelet_n2bv_16_sse2),
                          solvtab(codelet_n2bv_32_sse2),
                          solvtab(codelet_n2bv_64_sse2),
                          solvtab(codelet_n2bv_20_sse2),
                          solvtab(codelet_n2sv_4_sse2),
                          solvtab(codelet_n2sv_8_sse2),
                          solvtab(codelet_n2sv_16_sse2),
                          solvtab(codelet_n2sv_32_sse2),
                          solvtab(codelet_n2sv_64_sse2),
                          solvtab(codelet_t1fuv_2_sse2),
                          solvtab(codelet_t1fuv_3_sse2),
                          solvtab(codelet_t1fuv_4_sse2),
                          solvtab(codelet_t1fuv_5_sse2),
                          solvtab(codelet_t1fuv_6_sse2),
                          solvtab(codelet_t1fuv_7_sse2),
                          solvtab(codelet_t1fuv_8_sse2),
                          solvtab(codelet_t1fuv_9_sse2),
                          solvtab(codelet_t1fuv_10_sse2),
                          solvtab(codelet_t1fv_2_sse2),
                          solvtab(codelet_t1fv_3_sse2),
                          solvtab(codelet_t1fv_4_sse2),
                          solvtab(codelet_t1fv_5_sse2),
                          solvtab(codelet_t1fv_6_sse2),
                          solvtab(codelet_t1fv_7_sse2),
                          solvtab(codelet_t1fv_8_sse2),
                          solvtab(codelet_t1fv_9_sse2),
                          solvtab(codelet_t1fv_10_sse2),
                          solvtab(codelet_t1fv_12_sse2),
                          solvtab(codelet_t1fv_15_sse2),
                          solvtab(codelet_t1fv_16_sse2),
                          solvtab(codelet_t1fv_32_sse2),
                          solvtab(codelet_t1fv_64_sse2),
                          solvtab(codelet_t1fv_20_sse2),
                          solvtab(codelet_t1fv_25_sse2),
                          solvtab(codelet_t2fv_2_sse2),
                          solvtab(codelet_t2fv_4_sse2),
                          solvtab(codelet_t2fv_8_sse2),
                          solvtab(codelet_t2fv_16_sse2),
                          solvtab(codelet_t2fv_32_sse2),
                          solvtab(codelet_t2fv_64_sse2),
                          solvtab(codelet_t2fv_5_sse2),
                          solvtab(codelet_t2fv_10_sse2),
                          solvtab(codelet_t2fv_20_sse2),
                          solvtab(codelet_t2fv_25_sse2),
                          solvtab(codelet_t3fv_4_sse2),
                          solvtab(codelet_t3fv_8_sse2),
                          solvtab(codelet_t3fv_16_sse2),
                          solvtab(codelet_t3fv_32_sse2),
                          solvtab(codelet_t3fv_5_sse2),
                          solvtab(codelet_t3fv_10_sse2),
                          solvtab(codelet_t3fv_20_sse2),
                          solvtab(codelet_t3fv_25_sse2),
                          solvtab(codelet_t1buv_2_sse2),
                          solvtab(codelet_t1buv_3_sse2),
                          solvtab(codelet_t1buv_4_sse2),
                          solvtab(codelet_t1buv_5_sse2),
                          solvtab(codelet_t1buv_6_sse2),
                          solvtab(codelet_t1buv_7_sse2),
                          solvtab(codelet_t1buv_8_sse2),
                          solvtab(codelet_t1buv_9_sse2),
                          solvtab(codelet_t1buv_10_sse2),
                          solvtab(codelet_t1bv_2_sse2),
                          solvtab(codelet_t1bv_3_sse2),
                          solvtab(codelet_t1bv_4_sse2),
                          solvtab(codelet_t1bv_5_sse2),
                          solvtab(codelet_t1bv_6_sse2),
                          solvtab(codelet_t1bv_7_sse2),
                          solvtab(codelet_t1bv_8_sse2),
                          solvtab(codelet_t1bv_9_sse2),
                          solvtab(codelet_t1bv_10_sse2),
                          solvtab(codelet_t1bv_12_sse2),
                          solvtab(codelet_t1bv_15_sse2),
                          solvtab(codelet_t1bv_16_sse2),
                          solvtab(codelet_t1bv_32_sse2),
                          solvtab(codelet_t1bv_64_sse2),
                          solvtab(codelet_t1bv_20_sse2),
                          solvtab(codelet_t1bv_25_sse2),
                          solvtab(codelet_t2bv_2_sse2),
                          solvtab(codelet_t2bv_4_sse2),
                          solvtab(codelet_t2bv_8_sse2),
                          solvtab(codelet_t2bv_16_sse2),
                          solvtab(codelet_t2bv_32_sse2),
                          solvtab(codelet_t2bv_64_sse2),
                          solvtab(codelet_t2bv_5_sse2),
                          solvtab(codelet_t2bv_10_sse2),
                          solvtab(codelet_t2bv_20_sse2),
                          solvtab(codelet_t2bv_25_sse2),
                          solvtab(codelet_t3bv_4_sse2),
                          solvtab(codelet_t3bv_8_sse2),
                          solvtab(codelet_t3bv_16_sse2),
                          solvtab(codelet_t3bv_32_sse2),
                          solvtab(codelet_t3bv_5_sse2),
                          solvtab(codelet_t3bv_10_sse2),
                          solvtab(codelet_t3bv_20_sse2),
                          solvtab(codelet_t3bv_25_sse2),
                          solvtab(codelet_t1sv_2_sse2),
                          solvtab(codelet_t1sv_4_sse2),
                          solvtab(codelet_t1sv_8_sse2),
                          solvtab(codelet_t1sv_16_sse2),
                          solvtab(codelet_t1sv_32_sse2),
                          solvtab(codelet_t2sv_4_sse2),
                          solvtab(codelet_t2sv_8_sse2),
                          solvtab(codelet_t2sv_16_sse2),
                          solvtab(codelet_t2sv_32_sse2),
                          solvtab(codelet_q1fv_2_sse2),
                          solvtab(codelet_q1fv_4_sse2),
                          solvtab(codelet_q1fv_5_sse2),
                          solvtab(codelet_q1fv_8_sse2),
                          solvtab(codelet_q1bv_2_sse2),
                          solvtab(codelet_q1bv_4_sse2),
                          solvtab(codelet_q1bv_5_sse2),
                          solvtab(codelet_q1bv_8_sse2),
                          SOLVTAB_END)

