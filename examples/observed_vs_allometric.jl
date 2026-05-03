# observed_vs_allometric.jl
#
# Plots observed BMR measurements for individual species on top of the
# predicted eutherian allometric scaling line, illustrating where real animals
# sit relative to the allometric expectation.
#
# Demonstrates two usage patterns:
#   1. Recipe directly inside a manually-built Figure (full layout control)
#   2. Convenience wrapper plot_allometric_scaling() for a quick one-liner
#
# Run from the BiophysicalAllometry.jl root:
#   julia --project examples/observed_vs_allometric.jl
#
# Output: observed_vs_allometric.png

using BiophysicalAllometry
using CairoMakie
using Unitful

# ── Observed BMR data ──────────────────────────────────────────────────────────
#
# Species-level BMR measurements assembled from:
#   McNab, B. K. (2008). An analysis of the factors that influence the level and
#   scaling of mammalian BMR. Comp. Biochem. Physiol. A 151:5–28.
#   Kleiber, M. (1961). The Fire of Life. Wiley, New York.
#
# Values are representative means; the full McNab (2008) dataset contains >600
# species.  Masses and rates in SI units.

observed_bmr = [
    #  mass             BMR         label
    (0.007u"kg",   0.29u"W",  "Sorex araneus (shrew)"),
    (0.021u"kg",   0.26u"W",  "Mus musculus (mouse)"),
    (0.262u"kg",   1.45u"W",  "Rattus norvegicus (rat)"),
    (2.4u"kg",     6.6u"W",   "Oryctolagus cuniculus (rabbit)"),
    (20.0u"kg",    25.0u"W",  "Canis lupus familiaris (dog)"),
    (70.0u"kg",    83.0u"W",  "Homo sapiens (human)"),
]

# ── Pattern 1: recipe inside a manually-built Figure ──────────────────────────
#
# allometric_scaling! places the plot into the given Axis, leaving the rest of
# the Figure free for additional panels, colorbars, or custom legend placement.

fig = Figure(size = (720, 500), backgroundcolor = :white)

ax = Axis(fig[1, 1];
          xscale             = log10,
          yscale             = log10,
          xlabel             = "Body mass (kg)",
          ylabel             = "Basal metabolic rate (W)",
          title              = "Observed BMR vs. allometric prediction (Kleiber's law)",
          xminorticksvisible = true,
          yminorticksvisible = true)

allometric_scaling!(ax,
    BasalMetabolicRate(),
    [(EutherianMammal(), "Eutherian mammal (Kleiber)", :royalblue),
     (Marsupial(),       "Marsupial",                  :tomato)];
    mass_range  = [0.005u"kg", 100.0u"kg"],
    data_points = observed_bmr)

axislegend(ax; position = :rb, framevisible = false)

save("observed_vs_allometric.png", fig)
println("Saved observed_vs_allometric.png")

# ── Pattern 2: convenience wrapper for a quick standalone figure ───────────────

fig2 = plot_allometric_scaling(
    BasalMetabolicRate(),
    [(EutherianMammal(), "Eutherian mammal (Kleiber)", :royalblue),
     (Marsupial(),       "Marsupial",                  :tomato)];
    mass_range  = [0.005u"kg", 100.0u"kg"],
    data_points = observed_bmr)

save("observed_vs_allometric2.png", fig2)
println("Saved observed_vs_allometric2.png")

# ── Residuals: how far each species deviates from the prediction ───────────────

println()
println("Residuals from Kleiber's law (observed / predicted):")
println()
println("  $(rpad("Species", 36))  $(rpad("Mass", 10))  $(rpad("Observed", 10))  $(rpad("Predicted", 10))  Ratio")
println("  " * "─"^80)

for (mass, bmr, label) in observed_bmr
    predicted = basal_metabolic_rate(EutherianMammal(), mass)
    ratio     = ustrip(u"W", bmr) / ustrip(u"W", predicted)
    println("  $(rpad(label, 36))  $(rpad(string(mass), 10))  " *
            "$(rpad(string(round(u"W", bmr; digits=2)), 10))  " *
            "$(rpad(string(round(u"W", predicted; digits=2)), 10))  " *
            "$(round(ratio; digits=2))×")
end
