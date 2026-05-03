module BiophysicalAllometry

using Unitful

# ── Exports ───────────────────────────────────────────────────────────────────

# Taxon types
export AbstractTaxon,
    AbstractMammal, AbstractBird, AbstractReptile, AbstractAmphibian, AbstractPlant,
    AbstractLeafPlant,
    EutherianMammal, Marsupial, Primate, Human,
    PasserineBird, NonPasserineBird,
    Squamate,
    Anuran,
    C3Plant, BroadleafPlant, Bambusoideae, Liriodendron, Rosaceae, Lauraceae, Oleaceae

# Variable types
export AbstractAllometricVariable,
    AbstractMetabolicRate, AbstractMorphology, AbstractLocomotion,
    AbstractCardioRespiratory, AbstractLifeHistory, AbstractLeafMorphology,
    BasalMetabolicRate, FieldMetabolicRate, StandardMetabolicRate,
    SurfaceArea, SkinArea, PlumageArea, SkeletonMass, BrainMass,
    StrideFrequency, CostOfTransport,
    HeartRate, LungVolume, TidalVolume,
    Lifespan, GenerationTime,
    LeafArea, LeafDryMass

# Core equation types
export PowerLaw, MontgomeryLaw, reference

# Primary interface
export allometric, power_law, montgomery_law, allometric_inputs, trait_name

# Named convenience functions
export basal_metabolic_rate, standard_metabolic_rate,
    surface_area, skin_area, plumage_area, skeleton_mass, brain_mass,
    stride_frequency, cost_of_transport,
    heart_rate, lung_volume, tidal_volume,
    lifespan, generation_time,
    leaf_area, leaf_dry_mass

# Allometric registry
export AllometricEntry, ALLOMETRIC_REGISTRY

# Structural constraints
export AbstractScalingSimilarity, ElasticSimilarity, GeometricSimilarity, DynamicSimilarity
export limb_diameter, limb_length, limb_aspect_ratio

# Makie plotting — recipe functions and convenience wrappers (implementations in ext/)
export allometric_scaling, allometric_scaling!
export structural_constraints, structural_constraints!
export plot_allometric_scaling, plot_structural_constraints

# ── Makie stubs ───────────────────────────────────────────────────────────────
# Pre-declared so the names live in BiophysicalAllometry's namespace.
# @recipe in the extension adds methods; the convenience wrappers override the
# error-throwing bodies below once a Makie backend is loaded.

"""
    allometric_scaling([fig_or_ax], variable, pairs; mass_range, n_points, data_points)

Makie recipe for a log-log allometric scaling plot.  `pairs` is a vector of
`(taxon, label, color)` 3-tuples.  `data_points` (optional) overlays observed
data as `(mass, value, label)` 3-tuples.

Works composably inside any `Figure` position or `Axis` via `allometric_scaling!`.
Requires a Makie backend (`using GLMakie` or `using CairoMakie`).
"""
function allometric_scaling(args...; kwargs...)
    error("allometric_scaling requires a Makie backend — load GLMakie or CairoMakie first.")
end
function allometric_scaling!(args...; kwargs...)
    error("allometric_scaling! requires a Makie backend — load GLMakie or CairoMakie first.")
end

"""
    structural_constraints([fig_or_ax], pairs; mass_range, target, n_points)

Makie recipe for comparing limb dimensions across structural similarity assumptions.
`pairs` is a vector of `(similarity, label, color)` 3-tuples.
`target` is `:diameter` (default) or `:length`.

Requires a Makie backend (`using GLMakie` or `using CairoMakie`).
"""
function structural_constraints(args...; kwargs...)
    error("structural_constraints requires a Makie backend — load GLMakie or CairoMakie first.")
end
function structural_constraints!(args...; kwargs...)
    error("structural_constraints! requires a Makie backend — load GLMakie or CairoMakie first.")
end

"""
    plot_allometric_scaling(variable, pairs; mass_range, n_points, data_points) → Figure

Convenience wrapper: creates a complete `Figure` with log-log axes, calls
`allometric_scaling!`, and adds a legend.  For composable use, call the recipe
directly via `allometric_scaling(fig[r,c], ...)` or `allometric_scaling!(ax, ...)`.

Requires a Makie backend (`using GLMakie` or `using CairoMakie`).
"""
function plot_allometric_scaling(args...; kwargs...)
    error("plot_allometric_scaling requires a Makie backend — load GLMakie or CairoMakie first.")
end

"""
    plot_structural_constraints(pairs; mass_range, target, n_points) → Figure

Convenience wrapper: creates a complete `Figure` for structural constraint
comparison.  For composable use, call `structural_constraints(fig[r,c], ...)`.

Requires a Makie backend (`using GLMakie` or `using CairoMakie`).
"""
function plot_structural_constraints(args...; kwargs...)
    error("plot_structural_constraints requires a Makie backend — load GLMakie or CairoMakie first.")
end

# ── Includes ──────────────────────────────────────────────────────────────────

include("types.jl")
include("power_law.jl")
include("montgomery_law.jl")
include("variables/metabolic_rate.jl")
include("variables/morphology.jl")
include("variables/locomotion.jl")
include("variables/cardiorespiratory.jl")
include("variables/life_history.jl")
include("variables/leaf_morphology.jl")
include("structural_constraints.jl")
include("allometric_registry.jl")

end
