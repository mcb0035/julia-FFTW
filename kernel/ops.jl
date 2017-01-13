


#void X(ops_zero) in kernel/ops.c:24
function ops_zero(dst::Ptr{opcnt})::Void
    pt = reinterpret(Ptr{Cdouble}, dst)
    unsafe_store!(pt, Cdouble(0))
    pt = reinterpret(Ptr{Cdouble}, dst + 8)
    unsafe_store!(pt, Cdouble(0))
    pt = reinterpret(Ptr{Cdouble}, dst + 16)
    unsafe_store!(pt, Cdouble(0))
    pt = reinterpret(Ptr{Cdouble}, dst + 24)
    unsafe_store!(pt, Cdouble(0))

    return nothing
end

#void X(ops_cpy) in kernel/ops.c:29
function ops_cpy(src::Ptr{opcnt}, dst::Ptr{opcnt})
    pt = reinterpret(Ptr{Cdouble}, dst)
    unsafe_store!(pt, unsafe_load(src).add)
    pt = reinterpret(Ptr{Cdouble}, dst + 8)
    unsafe_store!(pt, unsafe_load(src).mul)
    pt = reinterpret(Ptr{Cdouble}, dst + 16)
    unsafe_store!(pt, unsafe_load(src).fma)
    pt = reinterpret(Ptr{Cdouble}, dst + 24)
    unsafe_store!(pt, unsafe_load(src).other)

    return nothing
end

function ops_cpy(src::opcnt, dst::Ptr{opcnt})
    pt = reinterpret(Ptr{Cdouble}, dst)
    unsafe_store!(pt, src.add)
    pt = reinterpret(Ptr{Cdouble}, dst + 8)
    unsafe_store!(pt, src.mul)
    pt = reinterpret(Ptr{Cdouble}, dst + 16)
    unsafe_store!(pt, src.fma)
    pt = reinterpret(Ptr{Cdouble}, dst + 24)
    unsafe_store!(pt, src.other)

    return nothing
end


#void X(ops_other) in kernel/ops.c:34
function ops_other(o::INT, dst::Ptr{opcnt})::Void
    ops_zero(dst)
    pt = reinterpret(Ptr{Cdouble}, dst + 24)
    unsafe_store!(pt, Cdouble(o))
    
    return nothing
end

#void X(ops_madd) in kernel/ops.c:40
function ops_madd(m::INT, a::Ptr{opcnt}, b::Ptr{opcnt}, dst::Ptr{opcnt})::Void
    A = unsafe_load(a)
    B = unsafe_load(b)
    pt = reinterpret(Ptr{Cdouble}, dst)
    unsafe_store!(pt, Cdouble(m * A.add + B.add))
    pt = reinterpret(Ptr{Cdouble}, dst + 8)
    unsafe_store!(pt, Cdouble(m * A.mul + B.mul))
    pt = reinterpret(Ptr{Cdouble}, dst + 16)
    unsafe_store!(pt, Cdouble(m * A.fma + B.fma))
    pt = reinterpret(Ptr{Cdouble}, dst + 24)
    unsafe_store!(pt, Cdouble(m * A.other + B.other))

    return nothing
end

function ops_madd(m::INT, a::opcnt, b::opcnt, dst::Ptr{opcnt})::Void
    pt = reinterpret(Ptr{Cdouble}, dst)
    unsafe_store!(pt, Cdouble(m * a.add + b.add))
    pt = reinterpret(Ptr{Cdouble}, dst + 8)
    unsafe_store!(pt, Cdouble(m * a.mul + b.mul))
    pt = reinterpret(Ptr{Cdouble}, dst + 16)
    unsafe_store!(pt, Cdouble(m * a.fma + b.fma))
    pt = reinterpret(Ptr{Cdouble}, dst + 24)
    unsafe_store!(pt, Cdouble(m * a.other + b.other))

    return nothing
end

#void X(ops_add) in kernel/ops.c:48
function ops_add(a::Ptr{opcnt}, b::Ptr{opcnt}, dst::Ptr{opcnt})::Void
    ops_madd(INT(1), a, b, dst)
    return nothing
end

function ops_add(a::opcnt, b::opcnt, dst::Ptr{opcnt})::Void
    ops_madd(INT(1), a, b, dst)
    return nothing
end

#void X(ops_add2) in kernel/ops.c:53
function ops_add2(a::Ptr{opcnt}, dst::Ptr{opcnt})::Void
    ops_add(a, dst, dst)
    return nothing
end

function ops_add2(a::opcnt, dst::Ptr{opcnt})::Void
    ops_add(a, unsafe_load(dst), dst)
    return nothing
end

#void X(ops_madd2) in kernel/ops.c:58
function ops_madd2(m::INT, a::Ptr{opcnt}, dst::Ptr{opcnt})::Void
    ops_madd(m, a, dst, dst)
    return nothing
end

function ops_madd2(m::INT, a::opcnt, dst::Ptr{opcnt})::Void
    ops_madd(m, a, unsafe_load(dst), dst)
    return nothing
end


































