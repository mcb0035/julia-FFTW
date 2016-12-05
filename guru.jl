export XGURU, MKTENSOR_IODIMS, iodims_kosherp, GURU_KOSHERP, extract_reim
#dft/dft.h:38
#=type problem_dft <: problem
    problem_kind::problems
    sz::tensor
    vecsz::tensor
    ri::Array{Float,1}
    ii::Array{Float,1}
    ro::Array{Float,1}
    io::Array{Float,1}

    #X(mkproblem_dft) in dft/problem.c:77
    function problem_dft(sz::tensor, vecsz::tensor, ri::Float, ii::Float, ro::Float, io::Float)
        if ri == ro || ii == io
            if ri != ro || ii != io || !tensor_inplace_locations(sz, vecsz)
                p = new(PROBLEM_UNSOLVABLE)
                return p
           end
        end

        p = new(PROBLEM_DFT, tensor_compress(sz), tensor_compress_contiguous(vecsz), ri, ii, ro, io)
        return p
    end
end=#

#macros in api/guru64.h
#define XGURU(name) X(plan_guru64_ ## name)
XGURU(name::String) = string("plan_guru64_",name)
#define IODIM X(iodim64)
#define MKTENSOR_IODIMS X(mktensor_iodims64)
#define GURU_KOSHERP X(guru64_kosherp)

#tensor* MKTENSOR_IODIMS in api/mktensor-iodims.h:23
function MKTENSOR_IODIMS(rank::Cint, dims::Ptr{iodim}, is::Cint, os::Cint)::Ptr{tensor}
    x = ccall(("fftw_mktensor_iodims64", libfftw),
              Ptr{tensor},
              (Cint, Ptr{iodim}, Cint, Cint),
              rank, dims, is, os)
    return x
end

function MKTENSOR_IODIMS{T<:Integer}(rank::Integer, dims::Array{T}, is::Integer, os::Integer)::Ptr{tensor}
    x = ccall(("fftw_mktensor_iodims64", libfftw),
              Ptr{tensor},
              (Cint, Ptr{iodim}, Cint, Cint),
              rank, convert(Array{INT}, vec(dims)), is, os)
    return x
end

#=function MKTENSOR_IODIMS(rank::Int, dims::Array{iodim,1}, is::Int, os::Int)
    x = tensor(rank)    
    if FINITE_RNK(rank)
        for i=1:rank
            x.dims[i].n = dims[i].n
            x.dims[i].is = dims[i].is * is
            x.dims[i].os = dims[i].os * os
        end
    end
    return x
end=#

#static int iodims_kosherp in api/mktensor-iodims.h:38
function iodims_kosherp(rank::Cint, dims::Ptr{iodim}, allow_minfty::Cint)::Bool
    if rank < 0
        return false
    end

    if allow_minfty != 0
        if !FINITE_RNK(rank)
            return true
        end
        for i=1:rank
            if unsafe_load(dims, i).n < 0
                return false
            end
        end
    else
        if !FINITE_RNK(rank)
            return false
        end
        for i=1:rank
            if unsafe_load(dims, i).n <= 0
                return false
            end
        end
    end
    return true
end

#int GURU_KOSHERP in api/mktensor-iodims.h:57
#function GURU_KOSHERP(rank::Cint, dims::Ptr{iodim}, howmany_rank::Cint, howmany_dims::Ptr{iodim})::Bool
function GURU_KOSHERP(rank::Cint, dims::Array{INT}, howmany_rank::Cint, howmany_dims::Array{INT})::Bool
    return Bool(ccall(("fftw_guru64_kosherp", libfftw),
                 Cint,
                 (Cint, Ptr{INT}, Cint, Ptr{INT}),
                 rank, dims, howmany_rank, howmany_dims))

#    return iodims_kosherp(rank, dims, 0) && iodims_kosherp(howmany_rank, howmany_dims, 1)
end

#void X(extract_reim) in kernel/extract-reim.c:27
function extract_reim(sign::Cint, c::Ptr{R}, r::Ptr{Ptr{R}}, i::Ptr{Ptr{R}})::Void
   if sign == FFT_SIGN
       unsafe_store!(r, c)
       unsafe_store!(i, c + sizeof(R))
   else
       unsafe_store!(r, c + sizeof(R))
       unsafe_store!(i, c)
   end
   return nothing
end
#=
function extract_reim(sign::Int, c::Array{Complex{Float}}, r::Array{Float}, i::Array{Float})
   if sign == -1 
       r = real(c)
       i = imag(c)
   else
       r = imag(c)
       i = real(c)
   end
   return nothing
end
=#

#XGURU(dft) in api/plan-guru-dft.h:24
function guru64_dft(rank::Int32, dims::Array{iodim,1}, howmany_rank::Int32, howmany_dims::Array{iodim,1}, inp::Array{Complex128,1}, out::Array{Complex128,1}, sign::Int32, flags::UInt32)
    if !GURU_KOSHERP(rank, dims, howmany_rank, howmany_dims)
        return nothing
    end

    extract_reim(sign, inp, ri, ii)
    extract_reim(sign, out, ro, io)

    #taints of ri, ii, ro, io
    return apiplan(sign, flags, problem_dft(tensor_iodims(rank, dims, 2, 2), tensor_iodims(howmany_rank, howmany_dims, 2, 2), ri, ii, ro, io))
end

    

#=function mkproblem_dft(sz::tensor, vecsz::tensor, ri::Float, ii::Float, ro::Float, io::Float)
    #taints

    if ri == ro || ii == io
        if ri != ro || ii != io || !tensor_inplace_locations(sz, vecsz)
            return mkproblem_unsolvable()
        end
    end
    ego = problem_dft(sz, vecsz, ri, ii, ro, io)
    ego.sz = tensor_compress(sz)
    ego.vecsz = tensor_compress_contiguous(vecsz)=#
