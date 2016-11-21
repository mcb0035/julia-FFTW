#MD5 hashing stuff
import Base.show, Base.Libc.malloc
export md5sig, md5, md5begin, md5putc, md5end

#kernel/ifftw.h:381
if sizeof(Cuint) >= 4
    typealias md5uint Cuint
else
    typealias md5uint Culong
end

#kernel/ifftw.h:400
typealias md5sig NTuple{4,md5uint}

#kernel/ifftw.h:409
type md5
    s::md5sig
    c::NTuple{64,Cuchar}
    l::Cuint
    function md5()
        m = new((zeros(md5uint, 4)...), (zeros(Cuchar, 64)...), Cuint(0))
        return m
    end
end

function newmd5()::Ptr{md5}
    m = Ptr{md5}(malloc(sizeof(md5)))
    return m
end

function Base.show(io::IO, m::md5)
    print_with_color(:yellow,"md5:\n")
    println(" s: $(m.s)")
    println(" c: $(m.c)")
    println(" l: $(m.l)")
end

#static const sintab in kernel/md5.c:32
#const sintab::NTuple{64, md5uint} = (
const sintab = (
     0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
     0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
     0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
     0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
     0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
     0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
     0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
     0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
     0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
     0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
     0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
     0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
     0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
     0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
     0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
     0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391)

#roundtab in kernel/md5.c:52
immutable rt
    k::Cchar
    s::Cchar
end

#static const roundtab[64] in kernel/md5.c:55
#const roundtab::NTuple{64, roundtab} = (
const roundtab = (
     rt(  0,  7), rt(  1, 12), rt(  2, 17), rt(  3, 22),
     rt(  4,  7), rt(  5, 12), rt(  6, 17), rt(  7, 22),
     rt(  8,  7), rt(  9, 12), rt( 10, 17), rt( 11, 22),
     rt( 12,  7), rt( 13, 12), rt( 14, 17), rt( 15, 22),
     rt(  1,  5), rt(  6,  9), rt( 11, 14), rt(  0, 20),
     rt(  5,  5), rt( 10,  9), rt( 15, 14), rt(  4, 20),
     rt(  9,  5), rt( 14,  9), rt(  3, 14), rt(  8, 20),
     rt( 13,  5), rt(  2,  9), rt(  7, 14), rt( 12, 20),
     rt(  5,  4), rt(  8, 11), rt( 11, 16), rt( 14, 23),
     rt(  1,  4), rt(  4, 11), rt(  7, 16), rt( 10, 23),
     rt( 13,  4), rt(  0, 11), rt(  3, 16), rt(  6, 23),
     rt(  9,  4), rt( 12, 11), rt( 15, 16), rt(  2, 23),
     rt(  0,  6), rt(  7, 10), rt( 14, 15), rt(  5, 21),
     rt( 12,  6), rt(  3, 10), rt( 10, 15), rt(  1, 21),
     rt(  8,  6), rt( 15, 10), rt(  6, 15), rt( 13, 21),
     rt(  4,  6), rt( 11, 10), rt(  2, 15), rt(  9, 21))

#macro rol in kernel/md5.c:74
rol(a, s) = ((a << Cint(s)) | (a >> (32 - Cint(s))))

#static void doblock in kernel/md5.c:76
function doblock(state::md5sig, data::Ptr{Cuchar})::Void
    local x::NTuple{16, md5uint}
    msk = md5uint(Culong(0xffffffff))

    for i=1:16
        p = unsafe_wrap(Array, data + 4*(i-1), 4)
        x[i] = p[1] | (p[2] << 8) | (p[3] << 16) | (p[4] << 24)
    end

    (a,b,c,d) = state

    for i=1:64
        p = roundtab[i]
        ii = Cuint(i-1) >> 4
        if ii == 0
            a += (b & c) | (~b & d)
        elseif ii == 1
            a += (b & d) | (c & ~d)
        elseif ii == 2
            a += b ⊻ c ⊻ d
        elseif ii == 3
            a += c ⊻ (b | ~d)
        end

        a += sintab[i]
        a += x[Cint(p.k)]
        a &= msk
        t = b + rol(a, p.s)
        a = d; d = c; c = b; b = t
    end

    state[1] = (state[1] + a) & msk
    state[2] = (state[2] + b) & msk
    state[3] = (state[3] + c) & msk
    state[4] = (state[4] + d) & msk
    return nothing
end

#void X(md5begin) in kernel/md5.c:110
function md5begin(p::Ptr{md5})::Void
    pt = reinterpret(Ptr{md5uint}, p)
    s = sizeof(md5uint)

    unsafe_store!(pt,      0x67452301)
    unsafe_store!(pt + s,  0xefcdab89)
    unsafe_store!(pt + 2s, 0x98badcfe)
    unsafe_store!(pt + 3s, 0x10325476)

    pt = reinterpret(Ptr{Cuint}, p + 4*s + 64*sizeof(Cuchar))

    unsafe_store!(pt, Cuint(0))
    return nothing
end

#void X(md5putc) in kernel/md5.c:119
function md5putc(p::Ptr{md5}, c::Cuchar)::Void
    m = unsafe_load(p)
    i = m.l % 64
    
    pt = reinterpret(Ptr{Cuchar}, p + 4*sizeof(md5uint) + i*sizeof(Cuchar))
    unsafe_store!(pt, c)

    m.l += 1
    if (m.l) % 64 == 0
        doblock(m.s, Ref(m.c))
    end
    pt = reinterpret(Ptr{md5sig}, p)
    unsafe_store!(pt, m.s)
    return nothing
end

#void X(md5end) in kernel/md5.c:125
function md5end(p::Ptr{md5})
    m = unsafe_load(p)
    l = 8 * m.l
    
    md5putc(p, 0x80)
    while unsafe_load(p).l % 64 != 56
        md5putc(p, 0x00)
    end

    for i=1:8
        md5putc(p, l & 0xFF)
        l = l >> 8
    end
    return nothing
end

#void X(md5putb) in md5-1.c:24
function md5putb(p::Ptr{md5}, d_::Ptr{Void}, len::Csize_t)::Void
    d = reinterpret(Ptr{Cuchar}, d_)
    for i=1:len
        md5putc(p, unsafe_load(d, i))
    end
    return nothing
end

#void X(md5puts) in md5-1.c:32
function md5puts(p::Ptr{md5}, s::Ptr{Cchar})::Void
#=    md5putc(p, unsafe_load(s))
    while unsafe_load(s) != 0
        s += sizeof(Cchar)
        md5putc(p, unsafe_load(s))
    end
    s += sizeof(Cchar)=#

    #do {
    #  X(md5putc)(p, *s);
    #} while(*s++);

    while true
        md5putc(p, unsafe_load(s))
        unsafe_load(s) == 0 && break
        s += sizeof(Cchar)
    end
    s += sizeof(Cchar)

    return nothing
end

#void X(md5int) in md5-1.c:40
#function md5int(p::Ptr{md5}, i::Cint)::Void
    







































