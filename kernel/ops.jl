


#void X(ops_zero) in kernel/ops.c:24
function ops_zero(dst::Ptr{opcnt})::Void
    pt = reinterpret(Ptr{Cdouble}, dst)
    unsafe_store!(pt, zero(Cdouble))
    pt = reinterpret(Ptr{Cdouble}, dst + 8)
    unsafe_store!(pt, zero(Cdouble))
    pt = reinterpret(Ptr{Cdouble}, dst + 16)
    unsafe_store!(pt, zero(Cdouble))
    pt = reinterpret(Ptr{Cdouble}, dst + 24)
    unsafe_store!(pt, zero(Cdouble))

    return nothing
end
