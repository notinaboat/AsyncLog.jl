"""
# AsyncLog.jl

`@asynclog` is `@async` with error logging.

Based on: https://github.com/JuliaLang/julia/issues/7626#issuecomment-756395909

e.g.

```
julia> @asynclog "my background loop" while true
           sleep(1)
           @assert false
       end

┌ Error: Error in: "my background loop"
│   exception =
│    AssertionError: false
│    Stacktrace:
│     ...
└ @ Main ~/git/AsyncLog/src/AsyncLog.jl:20
```

"""
module AsyncLog

export @asynclog, @asynclog_loop, @errorlog


"""
    @errorlog "label" expression...

Run `expression` in a `try/catch` block.
Log errors though `@error`.
Use `"label"` to identify error logs.
"""
macro errorlog(label, expr)
    quote
        try
            $(esc(expr))
        catch err
            exception=(err, catch_backtrace())
            label = $(esc(label)) 
            @error "Error in: \"$label\"" exception
            rethrow(err)
        end
    end
end


"""
    @asynclog "label" expression...

Run `@async expression` in a `try/catch` block.
Log errors though `@error`.
Use `"label"` to identify error logs.
"""
macro asynclog(label, expr)
    esc(quote
        @async @errorlog $label $expr
    end)
end


"""
    @asynclog_loop "label" expression...

Run `@async expression` in a `try/catch` block.
Log errors though `@error`.
Use `"label"` to identify error logs.
Restart `expression` after errors.
"""
macro asynclog_loop(label, expr)
    esc(quote
        @async while true
            @errorlog $label $expr
        end
    end)
end


# Documentation.

readme() = join([
    Docs.doc(@__MODULE__),
    Docs.@doc @asynclog
   ], "\n\n")



end # module
