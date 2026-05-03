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

# Makie plotting stubs (implementations in ext/)
export plot_allometric_scaling, plot_structural_constraints

# ── Makie stubs ───────────────────────────────────────────────────────────────

"""
    plot_allometric_scaling(variable, pairs; mass_range, n_points) → Figure

Log-log allometric scaling plot. `pairs` is a vector of `(taxon, label, color)` tuples.
Requires a Makie backend (e.g. `using GLMakie` or `using CairoMakie`).
"""
function plot_allometric_scaling(args...; kwargs...)
    error("plot_allometric_scaling requires a Makie backend — load GLMakie or CairoMakie first.")
end

"""
    plot_structural_constraints(pairs; mass_range, target) → Figure

Compare limb dimension predictions across structural similarity assumptions.
Requires a Makie backend.
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
