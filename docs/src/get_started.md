# Get started

BiologicalScaling.jl predicts biological traits from body size with empirical scaling equations. Inputs and outputs are
[Unitful.jl](https://github.com/PainterQubits/Unitful.jl) quantities; the empirical nature of the functions means
that units must be stripped for the respective equations and then reattached, which happens inside the functions.

```julia
using Pkg
Pkg.add("BiologicalScaling")
```

## Predicting a trait

Every prediction names a trait, a taxon, and the inputs, usually body mass. Each trait also has a named function:

::: tabs

== Named function

```@example get_started
using BiologicalScaling, Unitful

basal_metabolic_rate(EutherianMammal(), 70.0u"kg")
```

== allometric

```@example get_started
allometric(BasalMetabolicRate(), EutherianMammal(), 70.0u"kg")
```

:::

The same trait can be predicted for different taxa:

::: tabs

== Eutherian mammal

```@example get_started
basal_metabolic_rate(EutherianMammal(), 1.0u"kg")
```

== Marsupial

```@example get_started
basal_metabolic_rate(Marsupial(), 1.0u"kg")
```

== Passerine bird

```@example get_started
basal_metabolic_rate(PasserineBird(), 1.0u"kg")
```

== Non-passerine bird

```@example get_started
basal_metabolic_rate(NonPasserineBird(), 1.0u"kg")
```

:::

## Units

Any unit of mass can be used, and the result can be converted to any compatible unit:

```@example get_started
basal_metabolic_rate(EutherianMammal(), 1000.0u"g") == basal_metabolic_rate(EutherianMammal(), 1.0u"kg")
```

```@example get_started
uconvert(u"kJ/d", basal_metabolic_rate(EutherianMammal(), 70.0u"kg"))
```

## The equations

Most traits are power laws of body mass, ``y = a M^b``, held in a [`PowerLaw`](@ref) with its units and reference:

```@example get_started
kleiber = power_law(BasalMetabolicRate(), EutherianMammal())
kleiber.coefficient, kleiber.exponent, reference(kleiber)
```

A `PowerLaw` can be called directly:

```@example get_started
kleiber(70.0u"kg")
```

All equations are listed in [Equations](manual/equations.md).

## Other traits

::: tabs

== Morphology

```@example get_started
surface_area(EutherianMammal(), 70.0u"kg"), brain_mass(Human(), 70.0u"kg")
```

== Physiology

```@example get_started
heart_rate(EutherianMammal(), 70.0u"kg"), lung_volume(EutherianMammal(), 70.0u"kg")
```

== Life history

```@example get_started
lifespan(EutherianMammal(), 70.0u"kg"), generation_time(EutherianMammal(), 70.0u"kg")
```

== Leaves

```@example get_started
leaf_area(BroadleafPlant(), 10.0u"cm", 5.0u"cm")
```

== Limbs

```@example get_started
limb_diameter(ElasticSimilarity(), 70.0u"kg"), limb_length(ElasticSimilarity(), 70.0u"kg")
```

:::

## Broadcasting

Taxa and traits are singleton types; wrap them in `Ref` to broadcast over body masses:

```@example get_started
masses = [0.02, 2.0, 200.0] .* u"kg"
basal_metabolic_rate.(Ref(EutherianMammal()), masses)
```

## Plotting

With a Makie backend loaded, scaling relationships can be plotted directly, see [Plotting](manual/plotting.md):

```@example get_started
using CairoMakie

plot_allometric_scaling(BasalMetabolicRate(),
    [(EutherianMammal(), "Eutherian mammal", :steelblue),
     (PasserineBird(), "Passerine bird", :seagreen)];
    mass_range = [0.005u"kg", 1000.0u"kg"])
```
