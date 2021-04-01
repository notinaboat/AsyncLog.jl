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


```
@asynclog "label" expression...
```

Run `@async expression` in a `try/catch` block. Log errors though `@error`. Use `"label"` to identify error logs.

