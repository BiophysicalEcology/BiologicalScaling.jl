# Morphology

The sizes of body surfaces and organs determine how organisms exchange heat and water with their environment, and how
their bodies are built.

```@setup morphology
using Main.FigureHelpers
using CairoMakie, BiologicalScaling, Unitful
```

## Surface areas

Heat and water are exchanged across the body surface. If shape does not change with size, surface area scales with
mass to the power ``2/3``, so that small animals have more surface per unit mass. [`surface_area`](@ref) gives this
isometric baseline for mammals (Schmidt-Nielsen 1975):

```@example morphology
surface_area(EutherianMammal(), 70.0u"kg")
```

For insulated animals, the area of the skin and the area of the outer surface of the fur or feathers differ.
[`skin_area`](@ref) and [`plumage_area`](@ref) give them for birds and mammals (Walsberg and King 1978):

::: tabs

== Bird skin

```@example morphology
skin_area(PasserineBird(), 20.0u"g")
```

== Bird plumage

```@example morphology
plumage_area(PasserineBird(), 20.0u"g")
```

== Mammal skin

```@example morphology
skin_area(EutherianMammal(), 20.0u"g")
```

:::

### Silhouette areas

The radiation an animal absorbs from the sun depends on its silhouette area, the area of its shadow on a plane
perpendicular to the sun's rays. This depends on the orientation of the animal to the sun: the silhouette is largest
when the body is side-on (normal) to the sun's rays, and smallest when it points along them (parallel).
[`silhouette_area`](@ref) gives both, for reference species of lizard and frog:

::: tabs

== Desert iguana, normal

The desert iguana, *Dipsosaurus dorsalis* (Porter et al. 1973, Porter and Tracy 1983):

```@example morphology
silhouette_area(NormalToSun(), DesertIguana(), 50.0u"g")
```

== Desert iguana, parallel

```@example morphology
silhouette_area(ParallelToSun(), DesertIguana(), 50.0u"g")
```

== Leopard frog, normal

The leopard frog, *Rana pipiens*, whose total surface area stands in for its silhouette normal to the sun (Tracy
1976):

```@example morphology
silhouette_area(NormalToSun(), LeopardFrog(), 50.0u"g")
```

== Leopard frog, parallel

For the frog, the ventral area stands in for the silhouette parallel to the sun:

```@example morphology
silhouette_area(ParallelToSun(), LeopardFrog(), 50.0u"g")
```

:::

By turning side-on to the sun or facing it, a lizard can change the radiation it absorbs about four-fold:

```@example morphology
masses = exp10.(range(0, 3; length = 50)) .* u"g"
fig, ax = figure_axis("Body mass (g)", "Silhouette area (cm²)"; xscale = log10, yscale = log10)
for (orientation, label) in ((NormalToSun(), "Normal to the sun"), (ParallelToSun(), "Parallel to the sun"))
    areas = silhouette_area.(Ref(orientation), Ref(DesertIguana()), masses)
    lines!(ax, ustrip.(u"g", masses), ustrip.(u"cm^2", areas); linewidth = 2, label)
end
axislegend(ax; position = :lt)
fig
```

## Skeleton and brain

A larger animal needs a proportionally heavier skeleton to support its weight, so skeleton mass scales with an
exponent above 1, 1.13 for mammals (Schmidt-Nielsen 1975). As a percentage of body mass:

```@example morphology
[(mass, round(100 * uconvert(NoUnits, skeleton_mass(EutherianMammal(), mass) / mass); digits = 1))
 for mass in [0.02, 2.0, 200.0, 2000.0] .* u"kg"]
```

Brain mass scales with an exponent below 1, and differs between mammals, primates and humans:

::: tabs

== Mammal

```@example morphology
brain_mass(EutherianMammal(), 70.0u"kg")
```

== Primate

```@example morphology
brain_mass(Primate(), 70.0u"kg")
```

== Human

```@example morphology
brain_mass(Human(), 70.0u"kg")
```

:::

## Body-part proportions

Composite bodies, such as a human made of a head, trunk, arms and legs, are described by the fraction of mass and
surface area in each part, each part's shape, and the fraction of its surface that joins other parts.
[`body_part_proportions`](@ref) gives these for humans, from NicheMapR:

```@example morphology
proportions = body_part_proportions(Human())
proportions.part_names, proportions.mass_fraction
```

The mass of each part of a 70 kg person is then:

```@example morphology
proportions.part_names .=> proportions.mass_fraction .* 70.0u"kg"
```

The `aspect_ratio` of each part is the shape parameter of the cylinders and ellipsoids of
[BiophysicalGeometry.jl](https://github.com/BiophysicalEcology/BiophysicalGeometry.jl), which builds the composite body
for heat budgets.
