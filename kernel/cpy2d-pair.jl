

#void X(cpy2d_pair) in cpy2d-pair.c:24
function cpy2d_pair(I0::Ptr{R}, I1::Ptr{R}, O0::Ptr{R}, O1::Ptr{R},
                    n0::INT, is0::INT, os0::INT,
                    n1::INT, is1::INT, os1::INT)::Void
    ccall(("fftw_cpy2d_pair", libfftw),
          Void,
          (Ptr{R}, Ptr{R}, Ptr{R}, Ptr{R}, INT, INT, INT, INT, INT, INT),
          I0, I1, O0, O1, n0, is0, os0, n1, is1, os1)
    return nothing
end

#like cpy2d_pair but read input contiguously if possible
#void X(cpy2d_pair_ci) in cpy2d-pair.c:40
function cpy2d_pair_ci(I0::Ptr{R}, I1::Ptr{R}, O0::Ptr{R}, O1::Ptr{R},
                       n0::INT, is0::INT, os0::INT,
                       n1::INT, is1::INT, os1::INT)::Void
    if abs(is0) < abs(is1)
        cpy2d_pair(I0, I1, O0, O1, n0, is0, os0, n1, is1, os1)
    else
        cpy2d_pair(I0, I1, O0, O1, n1, is1, os1, n0, is0, os0)
    end
    return nothing
end

#like cpy2d_pair but write output contiguously if possible
#void X(cpy2d_pair_co) in cpy2d-pair.c:51
function cpy2d_pair_co(I0::Ptr{R}, I1::Ptr{R}, O0::Ptr{R}, O1::Ptr{R},
                       n0::INT, is0::INT, os0::INT,
                       n1::INT, is1::INT, os1::INT)::Void
    if abs(os0) < abs(os1)
        cpy2d_pair(I0, I1, O0, O1, n0, is0, os0, n1, is1, os1)
    else
        cpy2d_pair(I0, I1, O0, O1, n1, is1, os1, n0, is0, os0)
    end
    return nothing
end

