#char* X(sprint_plan) in api/print-plan.c:23
function sprint_plan(p::Ptr{apiplan})::Ptr{Cchar}
    pln = unsafe_load(p).pln
    cnt = Ptr{Cint}(malloc(sizeof(Cint)))

    pr = mkprinter_cnt(cnt)
    free(cnt)

    ccall(unsafe_load(unsafe_load(pln).adt).print,
          Void,
          (Ptr{plan}, Ptr{printer}),
          pln, pr)
    printer_destroy(pr)

    s = Ptr{Cchar}(malloc(sizeof(Cchar) * (unsafe_load(cnt) + 1)))
    if s != C_NULL
        pr = mkprinter_str(s)
        ccall(unsafe_load(unsafe_load(pln).adt).print,
              Void,
              (Ptr{plan}, Ptr{printer}),
              pln, pr)
        printer_destroy(pr)
    end
    return s
end

#void X(fprint_plan) in api/print-plan.c:42
function fprint_plan(p::Ptr{apiplan}, output_file::Ptr{Void})::Void
    pr = mkprinter_file(output_file)
    pln = unsafe_load(p).pln

    ccall(unsafe_load(unsafe_load(pln).adt).print,
          Void,
          (Ptr{plan}, Ptr{printer}),
          pln, pr)
    printer_destroy(pr)
    return nothing
end

#void X(print_plan) in api/print_plan.c:50
function print_plan(p::Ptr{apiplan})
    fprint_plan(p, STDOUT.handle)
    return nothing
end


