
#printer* X(mkprinter) in kernel/print.c:225
function mkprinter(siz::Integer, putchr::Ptr{Void}, cleanup::Ptr{Void})::Ptr{printer}
    p = ccall(("fftw_mkprinter", libfftw),
              Ptr{printer},
              (Csize_t, Ptr{Void}, Ptr{Void}),
              siz, putchr, cleanup)
    return p
end
#=
#struct P_cnt in api/mkprinter-str.c:26
type P_cnt
    super::printer
    cnt::Ptr{Cint}
end

#static void putchr_cnt in api/mkprinter-str.c:28
function putchr_cnt(p_::Ptr{printer}, c::Cchar)::Void
    p = Ptr{P_cnt}(p_)
    
    #++*p->cnt
    #int* cnt at 40 bytes in P_cnt
    pt = reinterpret(Ptr{Ptr{Cint}}, p + 40)
    cnt = unsafe_load(unsafe_load(p).cnt) + 1
    unsafe_store!(pt, pointer_from_objref(cnt))
    return nothing
end

#printer* X(mkprinter_cnt) in api/mkprinter-str.c
function mkprinter_cnt(cnt::Ptr{Cint})::Ptr{printer}
    p = Ptr{P_cnt}(mkprinter(sizeof(P_cnt)))

    #p->cnt = cnt
    #int* cnt at 40 bytes in P_cnt
    pt = reinterpret(Ptr{Ptr{Cint}}, p + 40)
    unsafe_store!(pt, cnt)

    #*cnt = 0
    unsafe_store!(cnt, Cint(0))

    return unsafe_load(p).super
end
=#

#printer* X(mkprinter_cnt) in api/mkprinter-str.c:35
function mkprinter_cnt(cnt::Ptr{Cint})
    p = ccall(("fftw_mkprinter_cnt", libfftw),
              Ptr{printer},
              (Ptr{Cint},),
              s)
    return p
end

#=
type P_str
    super::printer
    s::Ptr{Cchar}
end

#static void putchr_str in api/mkprinter-str.c:48
function putchr_str(p_::Ptr{printer}, c::Cchar)::Void
    p = Ptr{P_str}(p_)

    #*p->s++ = c
    #char* s at 40 bytes in P_str
    pt = reinterpret(Ptr{Ptr{Cchar}}, p + 40)
    s = unsafe_load(p).s
    unsafe_store!(pt, pointer_from_objref(c))
    s += sizeof(Cchar)

=#

#printer* X(mkprinter_str) in api/mkprinter-str.c:55
function mkprinter_str(s::Ptr{Cchar})
    p = ccall(("fftw_mkprinter_str", libfftw),
              Ptr{printer},
              (Ptr{Cchar},),
              s)
    return p
end

#void X(printer_destroy) in kernel/print.c:239
function printer_destroy(p::Ptr{printer})::Void
    if unsafe_load(p).cleanup != C_NULL
        ccall(unsafe_load(p).cleanup,
              Void,
              (Ptr{printer},),
              p)
    end
    free(p)
end

#printer* X(mkprinter_file in api/mkprinter-file.c:53
function mkprinter_file(f::Ptr{Void})
    p = ccall(("fftw_mkprinter_file", libfftw),
              Ptr{printer},
              (Ptr{Void},),
              f)
    return p
end

#void putchr in printer
function putchr(p::Ptr{printer}, c::Cchar)::Void
    #func* putchr at 16 bytes in printer
    pt = reinterpret(Ptr{Void}, p + 16)
    ccall(pt, Void, (Ptr{printer}, Cchar), p, c)
    return nothing
end

function putchr(p::Ptr{printer}, c::Char)::Void
    #func* putchr at 16 bytes in printer
    pt = reinterpret(Ptr{Void}, p + 16)
    ccall(pt, Void, (Ptr{printer}, Cchar), p, Cchar(c))
    return nothing
end
#static void myputs in kernel/print.c:29
function myputs(p::Ptr{printer}, s::Ptr{Cchar})::Void
    ss = s
    c = unsafe_load(ss)
    while c != 0
        putchr(p, c)
        ss += sizeof(Cchar)
        c = unsafe_load(ss)
    end
    return nothing
end

#static void newline in kernel/print.c:36
function newline(p::Ptr{printer})::Void
    putchr(p, '\n')

    #int indent at 32 bytes in printer
    indent = unsafe_load(reinterpret(Ptr{Cint}, p + 32))
    
    for i=1:indent
        putchr(p, ' ')
    end
    return nothing
end


















    
