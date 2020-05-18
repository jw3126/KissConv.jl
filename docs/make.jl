using KissConv
using Documenter

makedocs(;
    modules=[KissConv],
    authors="Jan Weidner <jw3126@gmail.com> and contributors",
    repo="https://github.com/jw3126/KissConv.jl/blob/{commit}{path}#L{line}",
    sitename="KissConv.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://jw3126.github.io/KissConv.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/jw3126/KissConv.jl",
)
