```@raw html
---
# https://vitepress.dev/reference/default-theme-home-page
layout: home

hero:
  name: "BiologicalScaling.jl"
  text: "Allometry for biology"
  tagline: "how physiology, morphology, locomotion and life history scale with size, with units and references."
  actions:
    - theme: brand
      text: Get Started
      link: /get_started
    - theme: alt
      text: View on Github
      link: https://github.com/BiophysicalEcology/BiologicalScaling.jl
    - theme: alt
      text: API Reference
      link: /api

features:
  - title: 🔥 Metabolic rate
    details: <a class="highlight-link">Basal metabolic rate</a> of mammals and birds, standard metabolic rate of squamate reptiles with body temperature, and plant respiration.
    link: /manual/metabolic_rate
  - title: 🦎 Morphology
    details: <a class="highlight-link">Surface, skin, plumage and silhouette areas</a>, skeleton and brain mass, and body-part proportions for heat and mass budgets.
    link: /manual/morphology
  - title: 🫀 Physiological time
    details: <a class="highlight-link">Heart rate, lung and tidal volume</a>, stride frequency, cost of transport, lifespan and generation time.
    link: /manual/physiological_time
  - title: 🍃 Leaves
    details: <a class="highlight-link">Leaf area</a> from length and width with the Montgomery model for different plant families, and leaf dry mass from area.
    link: /manual/leaves
  - title: 🦴 Structural constraints
    details: Limb diameter and length under <a class="highlight-link">elastic and geometric similarity</a>, as shape parameters for body geometry.
    link: /manual/structural_constraints
  - title: 📏 Units and references
    details: Every equation takes and returns <a class="highlight-link">Unitful.jl</a> quantities, and carries the literature reference it comes from.
    link: /manual/equations
---
```

## How to install BiologicalScaling.jl?

BiologicalScaling.jl can be installed from the Julia REPL:

```julia
julia> using Pkg
julia> Pkg.add("BiologicalScaling")
# or
julia> ] # ']' should be pressed
pkg> add BiologicalScaling
```

If you want to use the latest unreleased version, you can run the following command:

```julia
julia> using Pkg
julia> Pkg.add(url = "https://github.com/BiophysicalEcology/BiologicalScaling.jl")
```

## Manual

BiologicalScaling.jl is a standalone package of empirical scaling equations for estimating biological
traits from body size. It is also part of the [BiophysicalEcology](https://github.com/BiophysicalEcology) ecosystem for
mechanistic niche modelling, where it provides the sizes, shapes and rates of organisms: metabolic rates for
[ThermalPhysiology.jl](https://github.com/BiophysicalEcology/ThermalPhysiology.jl) to correct for temperature, and body
areas and proportions for the heat budgets of
[HeatExchange.jl](https://github.com/BiophysicalEcology/HeatExchange.jl) and the body shapes of
[BiophysicalGeometry.jl](https://github.com/BiophysicalEcology/BiophysicalGeometry.jl). See the
[Introduction](manual/introduction.md) for the design of the package.
