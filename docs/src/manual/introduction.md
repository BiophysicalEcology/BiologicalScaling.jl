# Introduction

BiologicalScaling.jl provides empirical equations relating biological traits to body size: metabolic rate, morphology,
locomotion, cardiorespiratory physiology, life history and leaf dimensions, and classical theories of how the
proportions of limbs must change with size.

```@setup intro
using BiologicalScaling, Unitful
```

## Allometry

[Allometry](https://en.wikipedia.org/wiki/Allometry) is the study of how traits change with body size. Most allometric
relationships are power laws,

```math
y = a M^b
```

where ``M`` is body mass, ``a`` the coefficient and ``b`` the exponent. On logarithmic axes a power law is a straight
line with slope ``b``. When ``b`` is the value expected if shape is unchanged, 1 for masses and volumes, ``2/3`` for
areas and ``1/3`` for lengths, the scaling is *isometric*; otherwise it is *allometric* in the narrow sense.
Metabolic rate, for example, scales with an exponent near ``3/4`` rather than 1, so larger animals use less energy per
unit mass (Kleiber 1932):

```@example intro
[basal_metabolic_rate(EutherianMammal(), M) / M for M in [0.02, 2.0, 200.0] .* u"kg"]
```

In this package, `allometric` means an *empirical* equation fitted to comparative data, as opposed to a mechanistic
equation derived from physical principles, such as the heat budgets of
[HeatExchange.jl](https://github.com/BiophysicalEcology/HeatExchange.jl).

## Traits and taxa

Every prediction dispatches on the trait, a subtype of [`AbstractScalingVariable`](@ref), and the taxon, a subtype of
[`AbstractTaxon`](@ref):

```julia
allometric(variable, taxon, inputs...)
```

The traits and taxa are singleton types, such as `BasalMetabolicRate()` and `EutherianMammal()`. The taxa form a
hierarchy, so an equation for [`AbstractMammal`](@ref) applies to all mammals, and one for a particular group,
such as [`Primate`](@ref), overrides it:

::: tabs

== Mammal

```@example intro
brain_mass(EutherianMammal(), 5.0u"kg")
```

== Primate

```@example intro
brain_mass(Primate(), 5.0u"kg")
```

== Human

```@example intro
brain_mass(Human(), 5.0u"kg")
```

:::

A combination of trait and taxon with no equation is a `MethodError`, rather than a silent extrapolation from another
group. [`allometric_inputs`](@ref) gives the inputs each combination needs:

```@example intro
allometric_inputs(BasalMetabolicRate(), EutherianMammal()), allometric_inputs(StandardMetabolicRate(), Squamate()),
allometric_inputs(LeafArea(), BroadleafPlant())
```

Each trait also has a named function, such as [`basal_metabolic_rate`](@ref) or [`leaf_area`](@ref), that calls
[`allometric`](@ref), and [`trait_name`](@ref) gives the standard name of a trait in
[traits.build](https://traitecoevo.github.io/traits.build/) databases:

```@example intro
trait_name(BasalMetabolicRate())
```

## Equations as objects

The equations are held as objects that carry their units and the reference they come from. A [`PowerLaw`](@ref) is a
univariate power law, and a [`MontgomeryLaw`](@ref) gives leaf area from leaf length and width:

::: tabs

== PowerLaw

```@example intro
kleiber = power_law(BasalMetabolicRate(), EutherianMammal())
```

== MontgomeryLaw

```@example intro
montgomery = montgomery_law(LeafArea(), BroadleafPlant())
```

:::

Both are callable, and [`reference`](@ref) gives the citation:

```@example intro
kleiber(70.0u"kg"), montgomery(10.0u"cm", 5.0u"cm"), reference(kleiber)
```

New equations can be built in the same way, here with made-up values:

```@example intro
amphibian_smr = PowerLaw(0.0033, 0.84; input_unit = u"g", output_unit = u"W",
                         reference = "Illustrative values only")
amphibian_smr(10.0u"g")
```

## Units

All inputs and outputs are [Unitful.jl](https://github.com/PainterQubits/Unitful.jl) quantities. Each equation is
defined in the units of its source, grams for some and kilograms for others, and converts whatever is passed:

```@example intro
skin_area(PasserineBird(), 0.02u"kg"), skin_area(PasserineBird(), 20.0u"g")
```

## BiologicalScaling.jl in the BiophysicalEcology ecosystem

BiologicalScaling.jl can be used on its own, and is also part of the
[BiophysicalEcology](https://github.com/BiophysicalEcology) packages for mechanistic niche modelling, to be brought
together in [NicheMapper.jl](https://github.com/BiophysicalEcology/NicheMapper.jl) (in development). There it provides
the sizes, shapes and rates of organisms that other packages need:

| Package | What BiologicalScaling.jl can provide |
|:--------|:-----|
| [ThermalPhysiology.jl](https://github.com/BiophysicalEcology/ThermalPhysiology.jl) | Metabolic rates at a reference temperature, corrected for body temperature with Arrhenius and thermal performance models |
| [HeatExchange.jl](https://github.com/BiophysicalEcology/HeatExchange.jl) | Surface, skin, plumage and silhouette areas for the exchange of heat by radiation, convection and evaporation |
| [BiophysicalGeometry.jl](https://github.com/BiophysicalEcology/BiophysicalGeometry.jl) | Limb aspect ratios and body-part proportions for the shapes of composite bodies |
| AnimalMapper.jl (in development) | Energy and water budgets of animals over time and space |

The [ThermalPhysiology.jl tutorial on metabolic rate](https://biophysicalecology.github.io/ThermalPhysiology.jl/dev/tutorials/metabolic_rate)
combines the two packages.
