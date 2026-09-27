# Plotting

With a [Makie](https://docs.makie.org) backend loaded, such as CairoMakie or GLMakie, BiologicalScaling.jl can plot
scaling relationships directly. The plotting functions are in a package extension, loaded when Makie is.

```@example plotting
using BiologicalScaling, CairoMakie, Unitful
```

## Allometric scaling

[`plot_allometric_scaling`](@ref) plots a trait against body mass on logarithmic axes, for a list of
`(taxon, label, color)`, with the exponent of each line in the legend. It works for any trait that is a power law of body
mass:

::: tabs

== Metabolic rate

```@example plotting
plot_allometric_scaling(BasalMetabolicRate(),
    [(EutherianMammal(), "Eutherian mammal", :steelblue),
     (Marsupial(), "Marsupial", :tomato),
     (PasserineBird(), "Passerine bird", :seagreen),
     (NonPasserineBird(), "Non-passerine bird", :goldenrod)];
    mass_range = [0.002u"kg", 3000.0u"kg"])
```

== Brain mass

```@example plotting
plot_allometric_scaling(BrainMass(),
    [(EutherianMammal(), "Mammal", :steelblue),
     (Primate(), "Primate", :tomato)];
    mass_range = [0.01u"kg", 1000.0u"kg"])
```

== Cost of transport

```@example plotting
plot_allometric_scaling(CostOfTransport(),
    [(EutherianMammal(), "Running mammals", :steelblue),
     (PasserineBird(), "Flying birds", :seagreen)];
    mass_range = [0.01u"kg", 1000.0u"kg"])
```

:::

Observed values can be added as `(mass, value, label)`:

```@example plotting
observed = [(0.021u"kg", 0.26u"W", "Mouse"), (2.4u"kg", 6.6u"W", "Rabbit"), (70.0u"kg", 83.0u"W", "Human")]
plot_allometric_scaling(BasalMetabolicRate(), [(EutherianMammal(), "Eutherian mammal", :steelblue)];
    mass_range = [0.005u"kg", 200.0u"kg"], data_points = observed)
```

## Composing figures

[`allometric_scaling`](@ref) plots into a position of an existing figure, and `allometric_scaling!` into an existing
axis, so that several panels can be combined:

```@example plotting
fig = Figure(size = (900, 400))
allometric_scaling(fig[1, 1], HeartRate(), [(EutherianMammal(), "Mammal", :firebrick)];
                   axis = (; title = "Heart rate"))
allometric_scaling(fig[1, 2], Lifespan(), [(EutherianMammal(), "Mammal", :steelblue)];
                   axis = (; title = "Lifespan"))
fig
```

## Structural constraints

[`plot_structural_constraints`](@ref) and [`structural_constraints`](@ref) plot limb diameter or length, chosen with
`target`, for a list of `(similarity, label, color)`:

::: tabs

== Diameter

```@example plotting
plot_structural_constraints([(ElasticSimilarity(), "Elastic", :blue), (GeometricSimilarity(), "Geometric", :red)];
                            target = :diameter)
```

== Length

```@example plotting
plot_structural_constraints([(ElasticSimilarity(), "Elastic", :blue), (GeometricSimilarity(), "Geometric", :red)];
                            target = :length)
```

:::
