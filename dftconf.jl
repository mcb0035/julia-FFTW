#turn string to Cstring
function cstringize(s::String)::Ptr{Cchar}
    n = length(s)
    if n == 0
        return Ptr{Cchar}(C_NULL)
    end

    cstr = Ptr{Cchar}(malloc(n+1))
    for i=1:n
        unsafe_store!(cstr, s[i], i)
    end
    unsafe_store!(cstr, 0, n+1)
    return cstr
end

cstringize(f::Function) = cstringize(string(f))

type solvtab
    reg::Ptr{Void}
    reg_nam::Ptr{Cchar}

    function solvtab(f::Function)
        st = new(cfunction(f, Void, (Ptr{planner},)), cstringize(f))
        return st
    end

    function solvtab()
        return new(C_NULL, C_NULL)
    end
end

function finalize_solvtab(s::solvtab)
    Libc.free(s.reg_nam)
end

#const SOLVTAB_END = solvtab(Ptr{Void}(C_NULL), Ptr{Cchar}(C_NULL))
const SOLVTAB_END = solvtab()

function dft_indirect_register(p::Ptr{planner})::Void
    
end

function dft_indirect_transpose_register(p::Ptr{planner})::Void

end

function dft_rank_geq2_register(p::Ptr{planner})::Void

end

function dft_vrank_geq1_register(p::Ptr{planner})::Void

end

function dft_buffered_register(p::Ptr{planner})::Void

end

function dft_generic_register(p::Ptr{planner})::Void

end

function dft_rader_register(p::Ptr{planner})::Void

end

function dft_bluestein_register(p::Ptr{planner})::Void

end

function dft_nop_register(p::Ptr{planner})::Void

end

function ct_generic_register(p::Ptr{planner})::Void

end

function ct_genericbuf_register(p::Ptr{planner})::Void

end

const s = (solvtab(dft_indirect_register),
           solvtab(dft_indirect_transpose_register),
           solvtab(dft_rank_geq2_register),
           solvtab(dft_vrank_geq1_register),
           solvtab(dft_buffered_register),
           solvtab(dft_generic_register),
           solvtab(dft_rader_register),
           solvtab(dft_bluestein_register),
           solvtab(dft_nop_register),
           solvtab(ct_generic_register),
           solvtab(ct_genericbuf_register),
           SOLVTAB_END)
include("dft/codelets.jl")

for elem in s
    finalizer(elem, finalize_solvtab)
end

#void X(solvtab_exec) in kernel/solvtab.c:24
function solvtab_exec(tbl, p::Ptr{planner})::Void
    for elem in tbl
        elem != SOLVTAB_END || break
        #p->cur_reg_nam = tbl->reg_nam
        #cur_reg_nam at 64 bytes in planner
        pt = reinterpret(Ptr{Ptr{Cchar}}, p + 64)
        unsafe_store!(pt, elem.reg_nam)

        #p->cur_reg_id = 0
        #cur_reg_id at 72 bytes in planner
        pt = reinterpret(Ptr{Cint}, p + 72)
        unsafe_store!(pt, Cint(0))

        #tbl->reg(p)
        ccall(elem.reg, Void, (Ptr{planner},), p)
    end
    #p->cur_reg_nam = 0
    #cur_reg_nam at 64 bytes in planner
    pt = reinterpret(Ptr{Ptr{Cchar}}, p + 64)
    unsafe_store!(pt, C_NULL)

    return nothing
end

#void X(solvtab_exec) in kernel/solvtab.c:24
function solvtab_exec(s::solvtab, p::Ptr{planner})::Void
    if s != SOLVTAB_END
        #p->cur_reg_nam = tbl->reg_nam
        #cur_reg_nam at 64 bytes in planner
        pt = reinterpret(Ptr{Ptr{Cchar}}, p + 64)
        unsafe_store!(pt, s.reg_nam)

        #p->cur_reg_id = 0
        #cur_reg_id at 72 bytes in planner
        pt = reinterpret(Ptr{Cint}, p + 72)
        unsafe_store!(pt, Cint(0))

        #tbl->reg(p)
        ccall(s.reg, Void, (Ptr{planner},), p)
    end
        
    #p->cur_reg_nam = 0
    #cur_reg_nam at 64 bytes in planner
    pt = reinterpret(Ptr{Ptr{Cchar}}, p + 64)
    unsafe_store!(pt, C_NULL)

    return nothing
end

#void X(dft_conf_standard) in dft/conf.c:40
function dft_conf_standard(p::Ptr{planner})::Void
    solvtab_exec(s, p)
    solvtab_exec(solvtab_dft_standard, p)

    #add SSE2, AVX, ALTIVEC, NEON

    return nothing 
end
























