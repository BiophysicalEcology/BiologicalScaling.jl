# BiologicalScaling.jl

[![CI](https://github.com/BiophysicalEcology/BiologicalScaling.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/BiophysicalEcology/BiologicalScaling.jl/actions/workflows/CI.yml)
[![codecov](https://codecov.io/gh/BiophysicalEcology/BiologicalScaling.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/BiophysicalEcology/BiologicalScaling.jl)
[![Docs](https://img.shields.io/badge/docs-dev-blue.svg)](https://BiophysicalEcology.github.io/BiologicalScaling.jl/dev)

Allometric and structural scaling equations for biology. Predict metabolic rates, morphology, locomotion, cardiorespiratory parameters, life-history traits, and leaf dimensions from body mass and taxon — with full unit safety via [Unitful.jl](https://github.com/PainterQubits/Unitful.jl).

## Installation

```julia
] add BiologicalScaling
```

## Quick start

```julia
using BiologicalScaling
using Unitful

# Predict basal metabolic rate for a 70 kg eutherian mammal
allometric(BasalMetabolicRate(), EutherianMammal(), 70u"kg")  # ~83 W

# Named convenience wrappers
basal_metabolic_rate(EutherianMammal(), 70u"kg")  # ~83 W
surface_area(EutherianMammal(), 70u"kg")          # ~1.87 m²
lifespan(EutherianMammal(), 70u"kg")              # ~74 yr

# Inspect the underlying power law
pl = power_law(BasalMetabolicRate(), EutherianMammal())
pl.exponent    # 0.7526  (Kleiber's law)
reference(pl)  # "McNab BK (2008)..."

# Leaf area from length × width (Montgomery model)
leaf_area(BroadleafPlant(), 10u"cm", 5u"cm")      # ~32.5 cm²

# Structural constraints: limb diameter under different similarity assumptions
limb_diameter(ElasticSimilarity(), 70u"kg")        # ~0.055 m
limb_diameter(GeometricSimilarity(), 70u"kg")      # ~0.050 m
```

## Available traits

| Category | Traits | Taxa |
|---|---|---|
| Metabolic rate | Basal, standard, field | Eutherian mammals, marsupials, passerine and non-passerine birds, squamate reptiles, plants |
| Morphology | Surface area, skin area, plumage area, silhouette area, skeleton mass, brain mass | Mammals, birds, lizards, frogs |
| Locomotion | Stride frequency, cost of transport | Mammals, birds |
| Cardiorespiratory | Heart rate, lung volume, tidal volume | Mammals |
| Life history | Lifespan, generation time | Mammals |
| Leaf morphology | Leaf area (Montgomery model), leaf dry mass | Broadleaf plants, bamboos, Rosaceae, Lauraceae, Oleaceae, Liriodendron |

The full list of equations with citations is in `?allometric` and programmatically in `SCALING_REGISTRY`.

## Visualisation

Requires a [Makie](https://makie.juliaplots.org) backend:

```julia
using CairoMakie
using BiologicalScaling

fig = plot_allometric_scaling(
    BasalMetabolicRate(),
    [
        (EutherianMammal(),  "Eutherian mammal",  :steelblue),
        (Marsupial(),        "Marsupial",          :tomato),
        (PasserineBird(),    "Passerine bird",     :seagreen),
        (NonPasserineBird(), "Non-passerine bird", :goldenrod),
    ]
)
```

## References

All equations are sourced from the primary literature. Retrieve any citation with:

```julia
reference(power_law(BasalMetabolicRate(), EutherianMammal()))
reference(montgomery_law(LeafArea(), BroadleafPlant()))
```
