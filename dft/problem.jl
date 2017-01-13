#dft/problem.c

function mkproblem_adt(pk::problems, hash::Ptr{Void}, zero::Ptr{Void}, print::Ptr{Void}, destroy::Ptr{Void})::Ptr{problem_adt}
    padt = Ptr{problem_adt}(malloc(sizeof(problem_adt)))
    #problem_kind at 0 bytes in problem_adt
    pt = reinterpret(Ptr{Cint}, padt)
    unsafe_store!(pt, Cint(pk))
    #hash at 8 bytes in problem_adt
    pt = reinterpret(Ptr{Ptr{Void}}, padt + 8)
    unsafe_store!(pt, hash)
    #zero at 16 bytes in problem_adt
    pt = reinterpret(Ptr{Ptr{Void}}, padt + 16)
    unsafe_store!(pt, zero)
    #print at 24 bytes in problem_adt
    pt = reinterpret(Ptr{Ptr{Void}}, padt + 24)
    unsafe_store!(pt, print)
    #destroy at 32 bytes in problem_adt
    pt = reinterpret(Ptr{Ptr{Void}}, padt + 32)
    unsafe_store!(pt, destroy)

    return padt
end

#problem* X(mkproblem) in kernel/problem.c:25
#function mkproblem(sz::Csize_t, adt::Ptr{problem_adt})::Ptr{problem}
function mkproblem(sz::Integer, adt::Ptr{problem_adt})::Ptr{problem}
    p = Ptr{problem}(malloc(sz))
    pt = reinterpret(Ptr{Ptr{problem_adt}}, p)
    unsafe_store!(pt, adt)
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

#static void destroy in dft/problem.c:25
function destroy(ego_::Ptr{problem})::Void
    ego = reinterpret(Ptr{problem_dft}, ego_)
#=    ccall(("fftw_tensor_destroy2", libfftw), 
          Void, 
          (Ptr{tensor}, Ptr{tensor}),
          unsafe_load(ego).sz, unsafe_load(ego).vecsz)=#
    tensor_destroy2(unsafe_load(ego).sz, unsafe_load(ego).vecsz)
    free(ego_)
    return nothing
end

#static void hash in dft/problem.c:32
function hash(p_::Ptr{problem}, m::Ptr{md5})::Void
    p = reinterpret(Ptr{problem_dft}, p_)
    md5puts(m, "dft")
    md5int(m, Cint(unsafe_load(p).ri == unsafe_load(p).ro))
    md5INT(m, INT(unsafe_load(p).ii - unsafe_load(p).ri))
    md5INT(m, INT(unsafe_load(p).io - unsafe_load(p).ro))
    md5int(m, alignment_of(unsafe_load(p).ri))
    md5int(m, alignment_of(unsafe_load(p).ii))
    md5int(m, alignment_of(unsafe_load(p).ro))
    md5int(m, alignment_of(unsafe_load(p).io))
    tensor_md5(m, unsafe_load(p).sz)
    tensor_md5(m, unsafe_load(p).vecsz)

    return nothing
end
    
#static void print in dft/problem.c:47


#static void recur in dft/zero.c:25


#void X(dft_zerotens) in dft/zero.c:47
function dft_zerotens(sz::Ptr{tensor}, ri::Ptr{R}, ii::Ptr{R})::Void
    ccall(("fftw_dft_zerotens", libfftw),
          Void,
          (Ptr{tensor}, Ptr{R}, Ptr{R}),
          sz, ri, ii)
    return nothing
end

#static void zero in dft/problem.c:60
function zero(ego_::Ptr{problem})::Void
    ego = reinterpret(Ptr{problem_dft}, ego_)
    sz = tensor_append(unsafe_load(ego).vecsz, unsafe_load(ego).sz)
    dft_zerotens(sz, UNTAINT(unsafe_load(ego).ri), UNTAINT(unsafe_load(ego).ii))
    tensor_destroy(sz)
    return nothing
end

#static const problem_adt padt in dft/problem.c:68
const padt_dft = mkproblem_adt(PROBLEM_DFT,
                           cfunction(hash, Void, (Ptr{problem}, Ptr{md5})),
                           cfunction(zero, Void, (Ptr{problem}, Ptr{md5})),
                           C_NULL,
                           cfunction(destroy, Void, (Ptr{problem},)))

#problem* X(mkproblem_dft) in dft/problem.c:77
function mkproblem_dft(sz::Ptr{tensor}, vecsz::Ptr{tensor}, ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R})::Ptr{problem}
    if UNTAINT(ri) == UNTAINT(ro)
        ri = ro = JOIN_TAINT(ri, ro)
    end
    if UNTAINT(ii) == UNTAINT(io)
        ii = io = JOIN_TAINT(ii, io)
    end

    @assert TAINTOF(ri) == TAINTOF(ii)
    @assert TAINTOF(ro) == TAINTOF(io)

    @assert tensor_kosherp(sz)
    @assert tensor_kosherp(vecsz)

    if ri == ro || ii == io
        if ri != ro || ii != io || !tensor_inplace_locations(sz, vecsz)
            error("in place failed, unsolvable problem")
#            return mkproblem_unsolvable()
        end
    end

    ego = Ptr{problem_dft}(mkproblem(sizeof(problem_dft), padt_dft))    

    #sz at 8 bytes in problem_dft
    pt = reinterpret(Ptr{Ptr{tensor}}, ego + 8)
    unsafe_store!(pt, tensor_compress(sz))
    #vecsz at 16 bytes in problem_dft
    pt = reinterpret(Ptr{Ptr{tensor}}, ego + 16)
    unsafe_store!(pt, tensor_compress_contiguous(vecsz))
    #ri at 24 bytes in problem_dft
    pt = reinterpret(Ptr{Ptr{R}}, ego + 24)
    unsafe_store!(pt, ri)
    #ii at 32 bytes in problem_dft
    pt = reinterpret(Ptr{Ptr{R}}, ego + 32)
    unsafe_store!(pt, ii)
    #ro at 40 bytes in problem_dft
    pt = reinterpret(Ptr{Ptr{R}}, ego + 40)
    unsafe_store!(pt, ro)
    #io at 48 bytes in problem_dft
    pt = reinterpret(Ptr{Ptr{R}}, ego + 48)
    unsafe_store!(pt, io)

    @assert FINITE_RNK(unsafe_load(unsafe_load(ego).sz).rnk)

    return reinterpret(Ptr{problem}, ego)
end

#problem* X(mkproblem_dft_d) in dft/problem.c:114
function mkproblem_dft_d(sz::Ptr{tensor}, vecsz::Ptr{tensor}, ri::Ptr{R}, ii::Ptr{R}, ro::Ptr{R}, io::Ptr{R})::Ptr{problem}
    p = mkproblem_dft(sz, vecsz, ri, ii, ro, io)
    tensor_destroy2(vecsz, sz)
    return p
end

mkproblem_dft_d(sz::Ptr{tensor}, vecsz::Ptr{tensor}, ri::Array{R}, ii::Array{R}, ro::Array{R}, io::Array{R})::Ptr{problem} =
    mkproblem_dft_d(sz, 
                    vecsz, 
                    unsafe_convert(Ptr{R}, ri),
                    unsafe_convert(Ptr{R}, ii),
                    unsafe_convert(Ptr{R}, ro),
                    unsafe_convert(Ptr{R}, io))































