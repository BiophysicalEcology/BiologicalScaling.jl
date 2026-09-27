# Leaves

The area of a leaf determines how much light it intercepts and how it exchanges heat and water. Leaf area is tedious
to measure, but can be estimated from the length and width of the lamina.

```@setup leaves
using Main.FigureHelpers
using CairoMakie, BiologicalScaling, Unitful
```

## Leaf area

The Montgomery model (Montgomery 1911) takes leaf area to be a fixed fraction of the rectangle that bounds the leaf,

```math
A = a_1 L W
```

where ``L`` is the length and ``W`` the width of the lamina. The Montgomery parameter ``a_1`` is 0.5 for a triangular
leaf and ``\pi/4 \approx 0.785`` for an elliptical one, and is between 0.57 and 0.74 for most broad-leaved plants
(Shi et al. 2019). [`leaf_area`](@ref) uses a value for each plant group:

::: tabs

== Broadleaf

The generic value of 0.65, used for any [`AbstractLeafPlant`](@ref) without its own value:

```@example leaves
leaf_area(BroadleafPlant(), 10.0u"cm", 5.0u"cm")
```

== Bamboos

```@example leaves
leaf_area(Bambusoideae(), 10.0u"cm", 5.0u"cm")
```

== Tulip trees

```@example leaves
leaf_area(Liriodendron(), 10.0u"cm", 5.0u"cm")
```

== Rosaceae

```@example leaves
leaf_area(Rosaceae(), 10.0u"cm", 5.0u"cm")
```

== Lauraceae

```@example leaves
leaf_area(Lauraceae(), 10.0u"cm", 5.0u"cm")
```

== Oleaceae

```@example leaves
leaf_area(Oleaceae(), 10.0u"cm", 5.0u"cm")
```

:::

The area has the units of the product of the length and width:

```@example leaves
leaf_area(BroadleafPlant(), 0.1u"m", 50.0u"mm")
```

The parameter itself is the `coefficient` of the [`MontgomeryLaw`](@ref):

```@example leaves
[(nameof(typeof(taxon)), montgomery_law(LeafArea(), taxon).coefficient)
 for taxon in (BroadleafPlant(), Bambusoideae(), Liriodendron(), Rosaceae(), Lauraceae(), Oleaceae())]
```

## Leaf dry mass

Leaf dry mass scales with leaf area to the power 1.10, less than the 1.5 expected if leaves kept their shape, because
larger leaves are relatively thinner (Milla and Reich 2007). [`leaf_dry_mass`](@ref) takes either the area, or the
length and width:

::: tabs

== From area

```@example leaves
leaf_dry_mass(BroadleafPlant(), 20.0u"cm^2")
```

== From length and width

```@example leaves
leaf_dry_mass(BroadleafPlant(), 10.0u"cm", 5.0u"cm")
```

:::

The leaf mass per area, a key trait of the leaf economics spectrum, therefore rises slowly with leaf size:

```@example leaves
areas = exp10.(range(0, 3; length = 50)) .* u"cm^2"
fig, ax = figure_axis("Leaf area (cm²)", "Leaf mass per area (g/m²)"; xscale = log10)
lines!(ax, ustrip.(u"cm^2", areas), ustrip.(u"g/m^2", leaf_dry_mass.(Ref(BroadleafPlant()), areas) ./ areas);
       linewidth = 2)
fig
```
