# BiologicalScaling.jl

Allometric and structural scaling equations for biology. The package provides empirical power-law relationships between body size and a wide range of biological traits, covering metabolic rate, morphology, locomotion, cardiorespiratory parameters, life history, and leaf morphology.

## What is allometry?

[Allometry](https://en.wikipedia.org/wiki/Allometry) is the study of how biological traits relate to body size. The central tool is the power-law equation:

```
y = a · M^b
```

where `M` is body mass, `a` is the scaling coefficient, and `b` is the scaling exponent. When `b` equals the isometric expectation (e.g. 1 for mass, 2/3 for areas, 1/3 for lengths), proportions are preserved across sizes — this is *isometry*. Allometry in the broad sense covers both cases; the term "allometric equation" is used in this package for any empirical power-law scaling relationship regardless of whether the exponent is isometric.

The distinction matters in this codebase: `allometric(...)` specifically signals an *empirical* calculation derived from comparative data, as opposed to mechanistic equations built from physical principles (as in e.g. `HeatExchange.jl`).

## Package structure

The package is built around three concepts.

### Type dispatch

Every calculation is dispatched on a *variable* type and a *taxon* type:

```julia
allometric(variable, taxon, inputs...) → Quantity
```

Variable types (subtypes of `AbstractScalingVariable`) represent biological quantities:
`BasalMetabolicRate`, `SurfaceArea`, `Lifespan`, `LeafArea`, etc.

Taxon types (subtypes of `AbstractTaxon`) represent the taxonomic group:
`EutherianMammal`, `PasserineBird`, `Squamate`, `BroadleafPlant`, etc.

This design means adding a new taxon–trait combination is a single method definition, and the compiler verifies that every combination you call actually has an implementation.

### Equation objects

Two mathematical forms are used:

- **`PowerLaw`** — univariate power law `y = a · x^b` with units. Used for all mass-scaling relationships.
- **`MontgomeryLaw`** — bivariate model `A = a · L · W` for leaf area from length and width.

Both types are callable and carry full unit information and a literature reference:

```julia
pl = power_law(BasalMetabolicRate(), EutherianMammal())
pl(1u"kg")         # evaluate at 1 kg
pl.exponent        # 0.7526
reference(pl)      # "McNab BK (2008)..."
```

### Unit safety

All inputs and outputs use [Unitful.jl](https://github.com/PainterQubits/Unitful.jl). Unit conversion is handled automatically — pass body mass in grams, kilograms, or pounds and get the same result:

```julia
basal_metabolic_rate(EutherianMammal(), 1000u"g")   # same as 1u"kg"
basal_metabolic_rate(EutherianMammal(), 1u"kg")
```

## The `allometric` interface

The primary function is `allometric(variable, taxon, inputs...)`. Named convenience wrappers are provided for all traits:

```julia
using BiologicalScaling
using Unitful

# Metabolic rate
allometric(BasalMetabolicRate(), EutherianMammal(), 1u"kg")   # ~3.35 W
basal_metabolic_rate(EutherianMammal(), 1u"kg")               # same

# Morphology
surface_area(EutherianMammal(), 70u"kg")    # ~1.87 m²
brain_mass(Primate(), 5u"kg")               # ~97 g
skeleton_mass(EutherianMammal(), 70u"kg")   # ~7.4 kg

# Locomotion
stride_frequency(EutherianMammal(), 1u"kg")  # ~2.55 Hz
cost_of_transport(EutherianMammal(), 1u"kg") # ~4.2 J kg⁻¹ m⁻¹

# Life history
lifespan(EutherianMammal(), 70u"kg")         # ~74 yr
generation_time(EutherianMammal(), 70u"kg")  # ~20 yr

# Leaf morphology (Montgomery model)
leaf_area(BroadleafPlant(), 10u"cm", 5u"cm") # ~32.5 cm²
```

The function `allometric_inputs(variable, taxon)` returns a tuple of named inputs required for any given combination, useful when building generic workflows.

## Structural constraints

Separate from the allometric interface, the package implements three classical structural scaling theories that predict how limb dimensions must scale with body mass to preserve mechanical function:

| Type | Theory | Scaling |
|---|---|---|
| `ElasticSimilarity` | McMahon (1973) — limbs scale to resist Euler buckling | `d ∝ M^(3/8)`, `l ∝ M^(1/4)` |
| `GeometricSimilarity` | Isometric — constant shape across sizes | `d ∝ M^(1/3)`, `l ∝ M^(1/3)` |
| `DynamicSimilarity` | Constant Froude number across sizes | `d ∝ M^(3/8)`, `l ∝ M^(3/8)` |

```julia
# Limb diameter for a 70 kg mammal
limb_diameter(ElasticSimilarity(),  70u"kg")   # ~0.055 m
limb_diameter(GeometricSimilarity(), 70u"kg")  # ~0.050 m

# Limb length
limb_length(ElasticSimilarity(), 70u"kg")      # ~0.44 m
```

## The scaling registry

All allometric equations in the package are registered in `SCALING_REGISTRY`, a `Vector{ScalingEntry}`. Each entry pairs a variable name, taxon name, and the underlying equation object. The `?allometric` help text renders this as a table with equations and references.

```julia
# Browse all available equations
SCALING_REGISTRY

# Retrieve a full citation
reference(power_law(BasalMetabolicRate(), EutherianMammal()))
reference(montgomery_law(LeafArea(), BroadleafPlant()))
```

## Visualisation

Plotting requires a [Makie](https://makie.juliaplots.org) backend loaded before `BiologicalScaling`:

```julia
using CairoMakie          # or GLMakie, WGLMakie
using BiologicalScaling

# Convenience wrapper — returns a complete Figure
fig = plot_allometric_scaling(
    BasalMetabolicRate(),
    [
        (EutherianMammal(),  "Eutherian mammal",  :steelblue),
        (Marsupial(),        "Marsupial",          :tomato),
        (PasserineBird(),    "Passerine bird",     :seagreen),
        (NonPasserineBird(), "Non-passerine bird", :goldenrod),
    ];
    mass_range  = [0.002u"kg", 3000u"kg"],
    data_points = [(70u"kg", 81u"W", "Human")],
)

# Composable recipe — place into an existing Figure
ax = allometric_scaling(fig[1, 2], BasalMetabolicRate(), pairs)
```

Structural constraint plots follow the same pattern:

```julia
fig = plot_structural_constraints(
    [
        (ElasticSimilarity(),  "Elastic",  :blue),
        (GeometricSimilarity(), "Geometric", :red),
    ];
    target = :diameter,
)
```
