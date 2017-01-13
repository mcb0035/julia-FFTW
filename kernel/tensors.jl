#import Base: size, show
#=
#X(tensor_sz) in kernel/tensor.c:62
function Base.size(t::tensor)
    if FINITE_RNK(t.rnk)
        return 0
    end
    n::Cint = 1
    for i=1:t.rnk
#        n *= t.dims[i].n
        d = unsafe_load(t.dims, i)
#        n *= t.dims[i].n
        n *= d.n
    end
    return n
end

#X(tensor_print) in kernel/tensor.c:106
function Base.show(io::IO, t::tensor)
    if FINITE_RNK(t.rnk)
        first = true
        println("rank-$(t.rnk) tensor:")
        print("(");
        for i=1:t.rnk
#            d = t.dims[i]
            d = unsafe_load(t.dims, i)
            print(first ? "" : " ", "($(d.n) $(d.is) $(d.os))")
            first = false
        end
        print(")")
    else
        print("rank-minfty")
    end
end

function Base.convert(::Type{Array{iodim,1}}, arr::Array)
    res = [iodim(arr[:,i]...) for i in 1:size(arr,2)]
    return res
end

#treat rank <= 1 tensor as rank 1 tensor
#X(tensor_tornk1) in kernel/tensor.c:91
function tensor_tornk1(t::tensor, n::Cint, is::Cint, os::Cint)
    @assert t.rnk <= 1
    if t.rnk == 1
        vd = t.dims
        n = vd[1].n
        is = vd[1].is
        os = vd[1].os
    else
        n = 1
        is = os = 0
    end
    return true
end

#X(tensor_max_index) in kernel/tensor4.c:24
function tensor_max_index(sz::tensor)
    @assert FINITE_RNK(sz.rnk)
    ni::Cint = 0
    no::Cint = 0
    for i=1:sz.rnk
        p = sz.dims[i]
        ni += (p.n - 1) * abs(p.is)
        no += (p.n - 1) * abs(p.os)
    end
    return max(ni, no)
end

#X(tensor_min_istride) in kernel/tensor4.c:50
function tensor_min_istride(sz::tensor)
    @assert FINITE_RNK(sz.rnk)
    if sz.rnk == 0
        return nothing
    else
        s = abs(sz.dims[1].is)
        for i=2:sz.rnk
            s = min(s, abs(sz.dims[i].is))
        end
    end
    return s
end

#X(tensor_min_ostride) in kernel/tensor4.c:51
function tensor_min_ostride(sz::tensor)
    @assert FINITE_RNK(sz.rnk)
    if sz.rnk == 0
        return nothing
    else
        s = abs(sz.dims[1].os)
        for i=2:sz.rnk
            s = min(s, abs(sz.dims[i].os))
        end
    end
    return s
end

#X(tensor_min_stride) in kernel/tensor4.c:53
function tensor_min_stride(sz::tensor)
    return min(tensor_min_istride(sz), tensor_min_ostride(sz))
end

#X(tensor_inplace_strides) in kernel/tensor4.c:58
function tensor_inplace_strides(sz::tensor)
    @assert FINITE_RNK(sz.rnk)
    for i=1:sz.rnk
        p = sz.dims[i]
        if p.is != p.os
            return false
        end
    end
    return true
end

#X(tensor_inplace_strides2) in kernel/tensor4.c:70
function tensor_inplace_strides2(a::tensor, b::tensor)
    return tensor_inplace_strides(a) && tensor_inplace_strides(b)
end

#return true iff any strides of sz decrease upon tensor_inplace_copy(sz, k)
#tensor_strides_decrease in kernel/tensor4.c:77
function tensor_strides_decrease(sz::tensor, k::inplace_kind)
    if FINITE_RNK(sz.rnk)
        for i=1:sz.rnk
            if (sz.dims[i].os - sz.dims[i].is) * (k == INPLACE_OS ? 1 : -1) < 0
                return true
            end
        end
    end
    return false
end

#return true iff any strides of sz decrease upon tensor_inplace_copy(k) or if all
#strides are unchanged but any strides of vecsz decrease
#used in indirect.c to determine INPLACE_IS or INPLACE_OS

#= tensor_strides_decrease(sz, vecsz, INPLACE_IS)
   || tensor_strides_decrease(sz, vecsz, INPLACE_IS)
   || tensor_inplace_strides2(p.sz, p.vecsz) =#
#must always be true
#X(tensor_strides_decrease) in kernel/tensor4.c:98
function tensor_strides_decrease(sz::tensor, vecsz::tensor, k::inplace_kind)
    return tensor_strides_decrease(sz, k) || (tensor_inplace_strides(sz) && tensor_strides_decrease(vecsz, k))
end

function Base.copy(dim::iodim)
    return iodim(dim.n, dim.is, dim.os)
end

#X(tensor_copy) in kernel/tensor5.c:32
function Base.copy(sz::tensor)
    x = tensor(sz.rnk)
    for i=1:sz.rnk
        x.dims[i] = copy(sz.dims[i])
    end
    return x
end

#like copy(sz::tensor) but makes strides inplace by setting
#os = is if k == INPLACE_IS or is = os if k == INPLACE_OS
#X(tensor_copy_inplace) in kernel/tensor5.c:41
function tensor_copy_inplace(sz::tensor, k::inplace_kind)
    x = copy(sz)
    if FINITE_RNK(x.rnk)
        if k == INPLACE_OS
            for i=1:x.rnk
                x.dims[i].is = x.dims[i].os
            end
        else
            for i=1:x.rnk
                x.dims[i].os = x.dims[i].is
            end
        end
    end
    return x
end

#like copy(sz::tensor) but copy all dimensions except except_dim
#X(tensor_copy_except) in kernel/tensor5.c:58
function tensor_copy_except(sz::tensor, except_dim::Cint)
    @assert FINITE_RNK(sz.rnk) && sz.rnk >= 1 && except_dim < sz.rnk
    x = tensor(sz.rnk - 1)
    for i=1:except_dim - 1
        x.dims[i] = copy(sz.dims[i])
    end
    for i=except_dim:x.rnk
        x.dims[i] = copy(sz.dims[i+1])
    end
    return x
end

#like copy(sz::tensor) but copy rnk dimensions starting with start_dim
#X(tensor_copy_sub) in kernel/tensor5.c:72
function tensor_copy_sub(sz::tensor, start_dim::Cint, rnk::Cint)
    @assert sz.rnk && start_dim + rnk <= sz.rnk
    x = tensor(rnk)
    for i=1:rnk
        x.dims[i] = copy(sz.dims[start_dim + i - 1])
    end
    return x
end

#X(tensor_append) in kernel/tensor5.c:82
function tensor_append(a::tensor, b::tensor)
    if !FINITE_RNK(a.rnk) || !FINITE_RNK(b.rnk)
        return tensor(0)
    end
    x = tensor(a.rnk + b.rnk)
    for i=1:a.rnk
        x.dims[i] = copy(a.dims[i])
    end
    for i=1:b.rnk
        x.dims[a.rnk + i] = copy(b.dims[i])
    end
    return x
end

#total order on iodims
#X(dimcmp) in kernel/tensor7.c:32
function dimcmp(a::iodim, b::iodim)
#function Base.isless(a::iodim, b::iodim)
    sai = abs(a.is)
    sbi = abs(b.is)
    sao = abs(a.os)
    sbo = abs(b.os)
    sam = min(sai, sao)
    sbm = min(sbi, sbo)

    #descending order of min(istride, ostride)
    if sam != sbm
#        return sign(sbm - sam)
        return sbm - sam < 0 ? true : false
    end
    #tie: descending order of istride
    if sbi != sai
#        return sign(sbi - sai)
        return sbi - sai < 0 ? true : false
    end
    #tie: descending order of ostride
    if sbo != sao
#        return sign(sbo - sao)
        return sbo - sao < 0 ? true : false
    end
    #tie: ascending order of n
#    return sign(a.n - b.n)
    return a.n - b.n < 0 ? true : false
end

#canonicalize in kernel/tensor7.c:54
function canonicalize(x::tensor)
    if x.rnk > 1
        sort!(x.dims, lt=dimcmp)
    end
    return nothing
end

#compare_by_istride in kernel/tensor7.c:62
function compare_by_istride(a::iodim, b::iodim)
    sai = abs(a.is)
    sbi = abs(b.is)
    #descending order of istride
    return sbi - sai < 0 ? true : false
end

#really_compress in kernel/tensor7.c:70
function really_compress(sz::tensor)
    @assert FINITE_RNK(sz.rnk)
    rnk::Cint = 0
    for i=1:sz.rnk
        @assert sz.dims[i].n > 0
        if sz.dims[i].n != 1
            rnk += 1
        end
    end
    x = tensor(rnk)
    rnk = 1
    for i=1:sz.rnk
        if sz.dims[i].n != 1
            x.dims[rnk] = sz.dims[i]
            rnk += 1
        end
    end
    return x
end

#eliminate n == 1 dimensions and sort into decreasing strides
#for better locality
#X(tensor_compress) in kernel/tensor7.c:99
function tensor_compress(sz::tensor)
    x = really_compress(sz)
    canonicalize(x)
    return x
end

#return whether strides of a and b form a contiguous 1d array
#given a.is >= b.is
#strides_contig in kernel/tensor7.c:108
function strides_contig(a::iodim, b::iodim)
    return a.is == b.is * b.n && a.os == b.os * b.n
end

#compress contiguous dimensions with same stride
#X(tensor_compress_contiguous) in kernel/tensor7.c:116
function tensor_compress_contiguous(sz::tensor)
    if size(sz) == 0
        return tensor(0)
    end
    
    sz2 = really_compress(sz)
    @assert FINITE_RNK(sz2.rnk)
    if sz2.rnk <= 1 #nothing to compress
        return sz2
    end

    #sort in descending order of |istride| so compressible dimensions
    #are contiguous
    sort!(sz2.dims, lt=compare_by_istride)

    #compute rank after compression
    rnk::Cint = 2
    for i=2:sz2.rnk
        if !strides_contig(sz2.dims[i-1], sz2.dims[i])
            rnk += 1
        end
    end

    #merge adjacent dimensions where possible
    x = tensor(rnk)
    x.dims[1] = sz2.dims[1]
    rnk = 2
    for i=2:sz2.rnk
        if strides_contig(sz2.dims[i-1], sz2.dims[i])
            x.dims[rnk - 1].n *= sz2.dims[i].n
            x.dims[rnk - 1].is = sz2.dims[i].is
            x.dims[rnk - 1].os = sz2.dims[i].os
        else
            @assert rnk < x.rnk
            x.dims[rnk] = sz2.dims[i]
            rnk += 1
        end
    end
    
    canonicalize(x)
    return x
end

#split tensor sz into tensors a and b wher a.rnk = arnk
#X(tensor_split) in kernel/tensor7.c:171
function tensor_split(sz::tensor, a::tensor, arnk::Cint, b::tensor)
    @assert FINITE_RNK(sz.rnk) && FINITE_RNK(arnk)
    a = tensor_copy_sub(sz, 1, arnk)
    b = tensor_copy_sub(sz, arnk + 1, sz.rnk - arnk)
    return nothing
end

#X(tensor_equal) in kernel/tensor7.c:180
function ==(a::tensor, b::tensor)
    if a.rnk != b.rnk
        return false
    end

    if FINITE_RNK(a.rnk)
        for i=1:a.rnk
            if (0 || a.dims[i].n != b.dims[i].n
                  || a.dims[i].is != b.dims[i].is
                  || a.dims[i].os != b.dims[i].os)
                return false
            end
        end
    end
    return true
end

#X(tensor_inplace_locations) in kernel/tensor7.c:201
function tensor_inplace_locations(sz::tensor, vecsz::tensor)
    t = tensor_append(sz,vecsz)
    ti = tensor_copy_inplace(t, INPLACE_IS)
    to = tensor_copy_inplace(t, INPLACE_OS)
    tic = tensor_compress_contiguous(ti)
    toc = tensor_compress_contiguous(to)
    return tic == toc
end

#X(tensor_kosherp) in kernel/tensor9.c:24
function tensor_kosherp(x::tensor)
    if x.rnk < 0
        return false
    end
    if FINITE_RNK(x.rnk)
        for i=1:x.rnk
            if x.dims[i].n < 0
                return false
            end
        end
    end
    return true
end

#MKTENSOR_IODIMS in api/mktensor-iodims.h:23
function tensor_iodims(rank::Cint, dims::Array{iodim,1}, is::Cint, os::Cint)
    x = tensor(rank)
    if FINITE_RNK(rank)
        for i=1:rank
            x.dims[i].n = dims[i].n
            x.dims[i].is = dims[i].is * is
            x.dims[i].os = dims[i].os * os
        end
    end
    return x
end

=#

#tensor* X(mktensor) in kernel/tensor.c:24
function mktensor(rnk::Cint)::Ptr{tensor}
    x = ccall(("fftw_mktensor", libfftw),
              Ptr{tensor},
              (Cint,),
              rnk)

    return x
end

#void X(tensor_destroy) in kernel/tensor.c:54
function tensor_destroy(sz::Ptr{tensor})::Void
    ccall(("fftw_tensor_destroy", libfftw),
          Void,
          (Ptr{tensor},),
          sz)
    return nothing
end

#void X(tensor_sz) in kernel/tensor.c:62
function tensor_sz(sz::Ptr{tensor})::INT
    n = ccall(("fftw_tensor_sz", libfftw),
              INT,
              (Ptr{tensor},),
              sz)
    return n
end

#void X(tensor_md5) in kernel/tensor.c:75
function tensor_md5(p::Ptr{md5}, t::Ptr{tensor})::Void
    ccall(("fftw_tensor_md5", libfftw),
          Void,
          (Ptr{md5}, Ptr{tensor}),
          p, t)
    return nothing
end

#void X(tensor_tornk1) in kernel/tensor.c:91
function tensor_tornk1(t::Ptr{tensor}, n::Ptr{INT}, is::Ptr{INT}, os::Ptr{INT})::Bool
#=    n = ccall(("fftw_tensor_tornk1", libfftw),
              Cint,
              (Ptr{tensor}, Ptr{INT}, Ptr{INT}, Ptr{Int}),
              t, n, is, os)
    return Bool(n)=#

    @assert unsafe_load(t).rnk <= 1
    if unsafe_load(t).rnk == 1
        #INT t->dims[0].n at 8 bytes in tensor
        pt = reinterpret(Ptr{INT}, t + 8)
#        n = unsafe_load(pt)
        unsafe_store!(n, unsafe_load(pt))
        #INT t->dims[0].is at 16 bytes in tensor
        pt = reinterpret(Ptr{INT}, t + 16)
#        is = unsafe_load(pt)
        unsafe_store!(is, unsafe_load(pt))
        #INT t->dims[0].os at 24 bytes in tensor
        pt = reinterpret(Ptr{INT}, t + 24)
#        is = unsafe_load(pt)
        unsafe_store!(os, unsafe_load(pt))
    else
#        n = 1
#        is = 0
#        os = 0
        unsafe_store!(n, INT(1))
        unsafe_store!(is, INT(0))
        unsafe_store!(os, INT(0))
    end
    return true 
end

#void X(tensor_print) in kernel/tensor.c:91
function tensor_print(x::Ptr{tensor}, p::Ptr{printer})::Void
    ccall(("fftw_tensor_print", libfftw),
          Void,
          (Ptr{tensor}, Ptr{printer}),
          x, p)
    return nothing
end

#tensor* X(mktensor_0d) in kernel/tensor1.c:24
function mktensor_0d()::Ptr{tensor}
    return mktensor(0)
end

#tensor* X(mktensor_1d) in kernel/tensor1.c:29
function mktensor_1d(n::INT, is::INT, os::INT)::Ptr{tensor}
    x = ccall(("fftw_mktensor_1d", libfftw),
              Ptr{tensor},
              (INT, INT, INT),
              n, is, os)
    return x
end

#tensor* X(mktensor_2d) in kernel/tensor2.c:24
function mktensor_2d(n0::INT, is0::INT, os0::INT, 
                     n1::INT, is1::INT, os1::INT)::Ptr{tensor}
    x = ccall(("fftw_mktensor_2d", libfftw),
              Ptr{tensor},
              (INT, INT, INT, INT, INT, INT),
              n0, is0, os0, n1, is1, os1)
    return x
end

#tensor* X(mktensor_3d) in kernel/tensor2.c:38
function mktensor_3d(n0::INT, is0::INT, os0::INT, 
                     n1::INT, is1::INT, os1::INT, 
                     n2::INT, is2::INT, os2::INT)::Ptr{tensor}
    x = ccall(("fftw_mktensor_3d", libfftw),
              Ptr{tensor},
              (INT, INT, INT, INT, INT, INT, INT, INT, INT),
              n0, is0, os0, n1, is1, os1, n2, is2, os2)
    return x
end

#tensor* X(mktensor_4d) in kernel/tensor3.c:28
function mktensor_4d(n0::INT, is0::INT, os0::INT, 
                     n1::INT, is1::INT, os1::INT, 
                     n2::INT, is2::INT, os2::INT,
                     n3::INT, is3::INT, os3::INT)::Ptr{tensor}
    x = ccall(("fftw_mktensor_4d", libfftw),
              Ptr{tensor},
              (INT, INT, INT, INT, INT, INT, INT, INT, INT, INT, INT, INT),
              n0, is0, os0, n1, is1, os1, n2, is2, os2, n3, is3, os3)
    return x
end

#tensor* X(mktensor_5d) in kernel/tensor3.c:49
function mktensor_5d(n0::INT, is0::INT, os0::INT, 
                     n1::INT, is1::INT, os1::INT, 
                     n2::INT, is2::INT, os2::INT,
                     n3::INT, is3::INT, os3::INT,
                     n4::INT, is4::INT, os4::INT)::Ptr{tensor}
    x = ccall(("fftw_mktensor_5d", libfftw),
              Ptr{tensor},
              (INT, INT, INT, INT, INT, INT, INT, INT, INT, INT, INT, INT, INT, INT, INT),
              n0, is0, os0, n1, is1, os1, n2, is2, os2, n3, is3, os3, n4, is4, os4)
    return x
end

#INT X(tensor_max_index) in kernel/tensor4.c:24
function tensor_max_index(sz::Ptr{tensor})::INT
    n = ccall(("fftw_tensor_max_index", libfftw),
              INT,
              (Ptr{tensor},),
              sz)
    return n
end

#INT X(tensor_min_istride) in kernel/tensor4.c:50
function tensor_min_istride(sz::Ptr{tensor})::INT
    n = ccall(("fftw_tensor_min_istride", libfftw),
              INT,
              (Ptr{tensor},),
              sz)
    return n
end

#INT X(tensor_min_ostride) in kernel/tensor4.c:51
function tensor_min_ostride(sz::Ptr{tensor})::INT
     n = ccall(("fftw_tensor_min_ostride", libfftw),
              INT,
              (Ptr{tensor},),
              sz)
    return n
end

#INT X(tensor_min_stride) in kernel/tensor4.c:53
function tensor_min_stride(sz::Ptr{tensor})::INT
    return min(tensor_min_istride(sz), tensor_min_ostride(sz))
end

#int X(tensor_inplace_strides) in kernel/tensor4.c:58
function tensor_inplace_strides(sz::Ptr{tensor})::Bool
    n = ccall(("fftw_tensor_inplace_strides", libfftw),
              Cint,
              (Ptr{tensor},),
              sz)
    return Bool(n)
end

#int X(tensor_inplace_strides2) in kernel/tensor4.c:70
function tensor_inplace_strides2(a::Ptr{tensor}, b::Ptr{tensor})::Bool
    return tensor_inplace_strides(a) && tensor_inplace_strides(b)
end

#int X(tensor_strides_decrease) in kernel/tensor4.c:98
function tensor_strides_decrease(sz::Ptr{tensor}, vecsz::Ptr{tensor}, k::inplace_kind)::Bool
    n = ccall(("fftw_tensor_strides_decrease", libfftw),
              Cint,
              (Ptr{tensor}, Ptr{tensor}, Cint),
              sz, vecsz, Cint(k))
    return Bool(n)
end

#tensor* X(tensor_copy) in kernel/tensor5.c:32
function tensor_copy(sz::Ptr{tensor})::Ptr{tensor}
    x = ccall(("fftw_tensor_copy", libfftw),
              Ptr{tensor},
              (Ptr{tensor},),
              sz)
    return x
end

#tensor* X(tensor_copy_inplace) in kernel/tensor5.c:41
function tensor_copy_inplace(sz::Ptr{tensor}, k::inplace_kind)::Ptr{tensor}
    x = ccall(("fftw_tensor_copy_inplace", libfftw),
              Ptr{tensor},
              (Ptr{tensor}, Cint),
              sz, Cint(k))
    return x
end

#tensor* X(tensor_copy_except) in kernel/tensor5.c:58
function tensor_copy_except(sz::Ptr{tensor}, except_dim::Cint)::Ptr{tensor}
    x = ccall(("fftw_tensor_copy_except", libfftw),
              Ptr{tensor},
              (Ptr{tensor}, Cint),
              sz, except_dim)
    return x
end

#tensor* X(tensor_copy_sub) in kernel/tensor5.c:72
function tensor_copy_sub(sz::Ptr{tensor}, start_dim::Cint, rnk::Cint)::Ptr{tensor}
    x = ccall(("fftw_tensor_copy_sub", libfftw),
              Ptr{tensor},
              (Ptr{tensor}, Cint, Cint),
              sz, start_dim, rnk)
    return x
end

#tensor* X(tensor_append) in kernel/tensor5.c:82
function tensor_append(a::Ptr{tensor}, b::Ptr{tensor})::Ptr{tensor}
    x = ccall(("fftw_tensor_append", libfftw),
              Ptr{tensor},
              (Ptr{tensor}, Ptr{tensor}),
              a, b)
    return x
end

#int X(dimcmp) in kernel/tensor7.c:32
function dimcmp(a::Ptr{iodim}, b::Ptr{iodim})::Cint
    n = ccall(("fftw_dimcmp", libfftw),
              Cint,
              (Ptr{iodim}, Ptr{iodim}),
              a, b)
    return n
end

#copy tensor eliminating dimensions with n == 1 and sort into canonical order of decreasing strides to improve locality
#tensor* X(tensor_compress) in kernel/tensor7.c:99
function tensor_compress(sz::Ptr{tensor})::Ptr{tensor}
    x = ccall(("fftw_tensor_compress", libfftw),
              Ptr{tensor},
              (Ptr{tensor},),
              sz)
    return x
end

#return whether strides of a and b are such that they form and effective contiguous 1d array assuming a.is >= b.is
#static int strides_contig in kernel/tensor7.c:108
function strides_contig(a::Ptr{iodim}, b::Ptr{iodim})::Cint
    aa = unsafe_load(a)
    bb = unsafe_load(b)
    return Cint(aa.is == bb.is && aa.os == bb.os * bb.n)
end

#like tensor_compress but also compress into one dimension any group of dimensions that form a contiguous block of indices with some stride
#tensor* X(tensor_compress_contiguous) in kernel/tensor7.c::116
function tensor_compress_contiguous(sz::Ptr{tensor})::Ptr{tensor}
    x = ccall(("fftw_tensor_compress_contiguous", libfftw),
              Ptr{tensor},
              (Ptr{tensor},),
              sz)
    return x
end

#split sz into tensor a of rank arnk followed by tensor b
#opposite of tensor_append
#void X(tensor_split) in kernel/tensor7.c:171
function tensor_split(sz::Ptr{tensor}, a::Ptr{Ptr{tensor}}, arnk::Cint, b::Ptr{Ptr{tensor}})::Void
    ccall(("fftw_tensor_split", libfftw),
          Void,
          (Ptr{tensor}, Ptr{Ptr{tensor}}, Cint, Ptr{Ptr{tensor}}),
          sz, a, arnk, b)
    return nothing
end

function tensor_split(sz::Ptr{tensor}, arnk::Cint)
    @assert FINITE_RNK(unsafe_load(sz).rnk) && FINITE_RNK(arnk)

    a = tensor_copy_sub(sz, Cint(0), arnk)
    b = tensor_copy_sub(sz, arnk, unsafe_load(sz).rnk - arnk)

    return (a, b)
end


#int X(tensor_equal) in kernel/tensor7.c::180
function tensor_equal(a::Ptr{tensor}, b::Ptr{tensor})::Bool
    n = ccall(("fftw_tensor_equal", libfftw),
              Cint,
              (Ptr{tensor}, Ptr{tensor}),
              a, b)
    return Bool(n)
end

#void X(tensor_destroy2) in kernel/tensor8.c:24
function tensor_destroy2(a::Ptr{tensor}, b::Ptr{tensor})::Void
    tensor_destroy(a)
    tensor_destroy(b)
    return nothing
end

#void X(tensor_destroy4) in kernel/tensor8.c:30
function tensor_destroy4(a::Ptr{tensor}, b::Ptr{tensor}, c::Ptr{tensor}, d::Ptr{tensor})::Void
    tensor_destroy2(a, b)
    tensor_destroy2(c, d)
    return nothing
end

#true if sets of input and output locations described by (append sz vecsz) are the same
#int X(tensor_inplace_locations) in kernel/tensor7.c:201
function tensor_inplace_locations(sz::Ptr{tensor}, vecsz::Ptr{tensor})::Bool
#=    n = ccall(("fftw_tensor_inplace_locations", libfftw),
              Cint,
              (Ptr{tensor}, Ptr{tensor}),
              sz, vecsz)
    return n=#
    t = tensor_append(sz, vecsz)
    ti = tensor_copy_inplace(t, INPLACE_IS)
    to = tensor_copy_inplace(t, INPLACE_OS)
    tic = tensor_compress_contiguous(ti)
    toc = tensor_compress_contiguous(to)

    retval = tensor_equal(tic, toc)

    tensor_destroy(t)
    tensor_destroy4(ti, to, tic, toc)

    return retval
end

#int X(tensor_kosherp) in kernel/tensor9.c:24
function tensor_kosherp(x::Ptr{tensor})::Bool
    n = ccall(("fftw_tensor_kosherp", libfftw),
              Cint,
              (Ptr{tensor},),
              x)
    return Bool(n)
end

#int X(pickdim) in kernel/pickdim.c:63
function pickdim(which_dim::Cint, buddies::Ptr{Cint}, nbuddies::Cint, sz::Ptr{tensor}, oop::Cint, dp::Ptr{Cint})::Cint #changes dp
    n = ccall(("fftw_pickdim", libfftw),
              Cint,
              (Cint, Ptr{Cint}, Cint, Ptr{tensor}, Cint, Ptr{Cint}),
              which_dim, buddies, nbuddies, sz, oop, dp)

    return n
end



































