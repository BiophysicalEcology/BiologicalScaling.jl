# Structural constraints

If animals kept the same shape as they grew, their limbs would become too thin to support them, since weight scales
with volume, ``M``, while the strength of a bone scales with its cross-sectional area, ``M^{2/3}``. Theories of
structural similarity predict how the proportions of limbs must change with size.

```@setup structure
using Main.FigureHelpers
using CairoMakie, BiologicalScaling, Unitful
```

## Similarity

Two theories are implemented:

| Similarity | Assumption | Diameter | Length |
|:-----------|:-----------|:---------|:-------|
| [`GeometricSimilarity`](@ref) | Shape is unchanged (Thompson 1917) | ``M^{1/3}`` | ``M^{1/3}`` |
| [`ElasticSimilarity`](@ref) | Limbs are just thick enough not to buckle under their own weight (McMahon 1973) | ``M^{3/8}`` | ``M^{1/4}`` |

Both are calibrated to a 1 kg mammal, with limbs 1.3 cm in diameter and 17 cm long. [`DynamicSimilarity`](@ref) is
defined, but its limb dimensions are not yet implemented.

[`limb_diameter`](@ref) and [`limb_length`](@ref) give the dimensions for a body mass:

::: tabs

== Elastic

```@example structure
limb_diameter(ElasticSimilarity(), 500.0u"kg"), limb_length(ElasticSimilarity(), 500.0u"kg")
```

== Geometric

```@example structure
limb_diameter(GeometricSimilarity(), 500.0u"kg"), limb_length(GeometricSimilarity(), 500.0u"kg")
```

:::

Under elastic similarity, large animals have shorter, thicker limbs:

```@example structure
masses = exp10.(range(-2, 4; length = 100)) .* u"kg"
fig = Figure(size = (700, 400))
for (column, (dimension, label)) in enumerate(((limb_diameter, "Limb diameter (m)"), (limb_length, "Limb length (m)")))
    ax = Axis(fig[1, column]; xscale = log10, yscale = log10, xlabel = "Body mass (kg)", ylabel = label)
    for (similarity, name) in ((ElasticSimilarity(), "Elastic"), (GeometricSimilarity(), "Geometric"))
        lines!(ax, ustrip.(u"kg", masses), ustrip.(u"m", dimension.(Ref(similarity), masses)); linewidth = 2,
               label = name)
    end
    column == 1 && axislegend(ax; position = :lt)
end
fig
```

## From limb length

The diameter can also be predicted from the length of the limb, as ``d \propto L^{3/2}`` under elastic similarity and
``d \propto L`` under geometric similarity:

::: tabs

== Elastic

```@example structure
limb_diameter(ElasticSimilarity(), 0.5u"m")
```

== Geometric

```@example structure
limb_diameter(GeometricSimilarity(), 0.5u"m")
```

:::

## Aspect ratio

The ratio of length to diameter, [`limb_aspect_ratio`](@ref), describes the shape of a limb. It is constant under
geometric similarity, and falls with size under elastic similarity:

```@example structure
[(mass, limb_aspect_ratio(ElasticSimilarity(), mass), limb_aspect_ratio(GeometricSimilarity(), mass))
 for mass in [0.1, 10.0, 1000.0] .* u"kg"]
```

It is the shape parameter of a cylinder in
[BiophysicalGeometry.jl](https://github.com/BiophysicalEcology/BiophysicalGeometry.jl), so that the limbs of a body
built for a heat budget have realistic proportions for its size.
