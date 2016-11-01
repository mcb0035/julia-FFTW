#dft/dft.h:38
type problem_dft <: problem
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
end

#MKTENSOR_IODIMS in api/mktensor-iodims.h:23
function MKTENSOR_IODIMS(rank::Int, dims::Array{iodim,1}, is::Int, os::Int)
    x = tensor(rank)    
    if rank != intmax
        for i=1:rank
            x.dims[i].n = dims[i].n
            x.dims[i].is = dims[i].is * is
            x.dims[i].os = dims[i].os * os
        end
    end
    return x
end

#iodims_kosherp in api/mktensor-iodims.h:38
function iodims_kosherp(rank::Int, dims::iodim, allow_minfty::Int)
    if rank < 0
        return false
    end
    if allow_minfty != 0
#        if rank == typemax(typeof(rank))
        if rank == intmax
            return true
        end
        for i=1:rank
            if dims[i].n < 0
                return false
            end
        end
    else
#        if rank == typemax(typeof(rank))
        if rank == intmax
            return false
        end
        for i=1:rank
            if dims[i].n <= 0
                return false
            end
        end
    end
    return true
end

#X(extract_reim) in kernel/extract-reim.c:27
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

#GURU_KOSHERP in api/mktensor-iodims.h:57
function GURU_KOSHERP(rank::Int, dims::Array{iodim,1}, howmany_rank::Int, howmany_dims::Array{iodim,1})
    return iodims_kosherp(rank, dims, 0) && iodims_kosherp(howmany_rank, howmany_dims, 1)
end

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
