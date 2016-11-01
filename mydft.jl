#!/home/qm4/bin/julia

#module myffts



#Slow discrete Fourier transform using the definition.
function mydft(arr)
#function mydft(arr::Array{Number,1})
#function mydft(arr::Array{Complex128,1})
    N = length(arr)
    M = [ exp(-2im*pi*j*k/N) for j=0:N-1, k=0:N-1 ]
    M*arr
end #function mydft

#2-radix Cooley-Tukey algorithm.  Still needs to be optimized.
function myfft(arr)
#function myfft(arr::Array{Number,1})
#function myfft(arr::Array{Complex128,1})
    N = length(arr)
    if N%2 != 0
        return mydft(arr)
    elseif N <= 32
        return mydft(arr)
    else
        evenarr = myfft(arr[1:2:end])
        oddarr  = myfft(arr[2:2:end])
        fact    = [ exp(-2im*pi*j/N) for j=0:N-1 ]
#        [ evenarr .+ fact[1:div(N,2)] .* oddarr; evenarr .+ fact[div(N,2)+1:end] .* oddarr ]
        [ evenarr .+ fact[1:N>>1] .* oddarr; evenarr .+ fact[N>>1+1:end] .* oddarr ]
    end
end #function myfft

function mypfa(arr)
    N = length(arr)
    if isprime(N) return myprimefft end
    facts = myfactors(N)
    length(facts) > 1 || return mypowerfft(arr)
    N1 = facts[1]
    N2 = prod(facts[2:end])
    N1i = invmod(N1,N2)
    N2i = invmod(N2,N1)
    arr=convert(Array{Complex128,1},arr)
    out=zeros(arr)
    temp=zeros(arr)
    for n1=0:N1-1 
        for n2=0:N2-1 
            i = N2*n1+n2+1
            k = (n1*N2*N2i+n2*N1*N1i)%N+1
            temp[i] = arr[k]
#            temp[N2*n1+n2+1] = arr[(n1*N2*N2i+n2*N1*N1i)%N+1]
        end
        ns = N2*n1+1
        ne = N2*(n1+1)
        temp[ns:ne] = myfft(temp[ns:ne])
    end
    for n2=1:N2
        temp[n2:N2:end] = myfft(temp[n2:N2:end])
    end
    for n1=0:N1-1
        for n2=0:N2-1 
            i = N2*n1+n2+1
            n = (n1*N2+n2*N1)%N+1            
            out[n] = temp[i]
        end
    end
    return out
end

#Array of prime power factors of n.
function myfactors(n)
    x = factor(n)
    collect(keys(x)) .^ collect(values(x))
end

#FFT optimized for specific sizes.
function mysmallfft(arr)
    N = length(arr)
    out = zeros(Complex128,N)

    if N == 2
        out[1] = arr[1] + arr[2]
        out[2] = arr[1] - arr[2]
        return out
    elseif N == 3
        u = 2/3*pi
        t1 = arr[2] + arr[3]
        m0 = arr[1] + t1
        m1 = (cos(u) - 1)*t1
        m2 = im*sin(u)*(arr[3]-arr[2])
        s1 = m0 + m1
        out[1] = m0
        out[2] = s1 + m2
        out[3] = s1 - m2
        return out
    elseif N == 4
        t1 = arr[1] + arr[3]
        t2 = arr[2] + arr[4]
        m0 = t1 + t2
        m1 = t1 - t2
        m2 = arr[1] - arr[3]
        m3 = im*(arr[4] - arr[2])
        out[1] = m0
        out[2] = m2 + m3
        out[3] = m1
        out[4] = m2 - m3
        return out
    elseif N == 5
        u = 2/5*pi
        t1 = arr[2] + arr[5]
        t2 = arr[3] + arr[4]
        t3 = arr[2] - arr[5]
        t4 = arr[4] - arr[3]
        t5 = t1 + t2
        m0 = arr[1] + t5
        m1 = (0.5*(cos(u) + cos(2u)) - 1) * t5
        m2 = 0.5*(cos(u) - cos(2u)) * (t1 - t2)
        m3 = -im*sin(u) * (t3 + t4)
        m4 = -im*(sin(u) + sin(2u)) * t4
        m5 = im*(sin(u) - sin(2u)) * t3
        s1 = m0 + m1
        s2 = s1 + m2
        s3 = m3 - m4
        s4 = s1 - m2
        s5 = m3 + m5
        out[1] = m0
        out[2] = s2 + s3
        out[3] = s4 + s5
        out[4] = s4 - s5
        out[5] = s2 - s3
        return out
    elseif N == 7
        u = 2/7*pi
        th = 1/3
        t1 = arr[2] + arr[7]
        t2 = arr[3] + arr[6]
        t3 = arr[4] + arr[5]
        t4 = t1 + t2 + t3
        t5 = arr[2] - arr[7]
        t6 = arr[3] - arr[6]
        t7 = arr[5] - arr[4]
        m0 = arr[1] + t4
        m1 = (th*(cos(u) + cos(2u) + cos(3u)) - 1) * t4
        m2 = th*(2cos(u) - cos(2u) - cos(3u)) * (t1 - t3)
        m3 = th*(cos(u) - 2cos(2u) + cos(3u)) * (t3 - t2)
        m4 = th*(cos(u) + cos(2u) - 2cos(3u)) * (t2 - t1)
        m5 = -im*th*(sin(u) + sin(2u) - sin(3u)) * (t5 + t6 + t7)
        m6 = im*th*(2sin(u) - sin(2u) + sin(3u)) * (t7 - t5)
        m7 = im*th*(sin(u) - 2sin(2u) - sin(3u)) * (t6 - t7)
        m8 = im*th*(sin(u) + sin(2u) + 2sin(3u)) * (t5 - t6)
        s1 = m0 + m1
        s2 = s1 + m2 + m3
        s3 = s1 - m2 - m4
        s4 = s1 - m3 + m4
        s5 = m5 + m6 + m7
        s6 = m5 - m6 - m8
        s7 = m5 - m7 + m8
        out[1] = m0
        out[2] = s2 + s5
        out[3] = s3 + s6
        out[4] = s4 - s7
        out[5] = s4 + s7
        out[6] = s3 - s6
        out[7] = s2 - s5
        return out
    end
end

#FFT for prime sizes.  Not implemented yet.
function myprimefft(arr)
    return mydft(arr)
end

function fft5(arr)
    N = length(arr)
    out = zeros(Complex128,N)
#    out::Array{Complex128,1}
#    out = Complex128[]

#    u = 2/5*pi
    const s25 = 0.9510565162951535
    const s45 = 0.5877852522924732
    const c25 = 0.30901699437494745
    const c45 = -0.8090169943749473
    t1 = arr[2] + arr[5]
    t2 = arr[3] + arr[4]
    t3 = arr[2] - arr[5]
    t4 = arr[4] - arr[3]
    t5 = t1 + t2
    m0 = arr[1] + t5
#    m1 = (0.5*(cos(u) + cos(2u)) - 1) * t5
    m1 = (0.5*(c25 + c45) - 1) * t5
#    m2 = 0.5*(cos(u) - cos(2u)) * (t1 - t2)
    m2 = 0.5*(c25 - c45) * (t1 - t2)
#    m3 = -im*sin(u) * (t3 + t4)
    m3 = -im*s25 * (t3 + t4)
#    m4 = -im*(sin(u) + sin(2u)) * t4
    m4 = -im*(s25 + s45) * t4
#    m5 = im*(sin(u) - sin(2u)) * t3
    m5 = im*(s25 - s45) * t3
    s1 = m0 + m1
    s2 = s1 + m2
    s3 = m3 - m4
    s4 = s1 - m2
    s5 = m3 + m5
#    out = [m0, s2+s3, s4+s5, s4-s5, s2-s3]
    out[1] = m0
    out[2] = s2 + s3
    out[3] = s4 + s5
    out[4] = s4 - s5
    out[5] = s2 - s3
#=    push!(out,m0)
    push!(out,s2+s3)
    push!(out,s4+s5)
    push!(out,s4-s5)
    push!(out,s2-s3)=#
    return out
end


#end #module myffts
