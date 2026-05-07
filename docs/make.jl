using Documenter
using BiologicalScaling

makedocs(
    sitename = "BiologicalScaling.jl",
    modules  = [BiologicalScaling],
    format   = Documenter.HTML(
        prettyurls       = get(ENV, "CI", nothing) == "true",
        canonical        = "https://BiophysicalEcology.github.io/BiologicalScaling.jl",
        edit_link        = "main",
        assets           = String[],
    ),
    pages = [
        "Overview"      => "index.md",
        "API Reference" => "api.md",
    ],
    checkdocs = :exports,
    warnonly  = true,
)

deploydocs(
    repo      = "github.com/BiophysicalEcology/BiologicalScaling.jl",
    devbranch = "main",
    push_preview = true,
)
