# Locomotion, physiology and life history

Many rates and times scale with body mass to powers near ``\pm 1/4``: rates such as heart rate and stride frequency
fall with size, and times such as lifespan and generation time rise. Large animals live more slowly (Calder 1984).

```@setup physiology
using Main.FigureHelpers
using CairoMakie, BiologicalScaling, Unitful
```

## Locomotion

[`stride_frequency`](@ref) is the frequency of strides at the transition from trot to gallop, for mammals (Heglund et
al. 1974):

```@example physiology
stride_frequency(EutherianMammal(), 0.03u"kg"), stride_frequency(EutherianMammal(), 500.0u"kg")
```

[`cost_of_transport`](@ref) is the energy used to move a unit of body mass over a unit of distance. It falls with size,
so large animals travel more cheaply:

::: tabs

== Running mammals

Fedak and Seeherman (1979):

```@example physiology
cost_of_transport(EutherianMammal(), 20.0u"kg")
```

== Flying birds

Tucker (1970):

```@example physiology
cost_of_transport(PasserineBird(), 20.0u"g")
```

:::

The cost of a journey is the cost of transport times body mass and distance:

```@example physiology
uconvert(u"kJ", cost_of_transport(EutherianMammal(), 20.0u"kg") * 20.0u"kg" * 10.0u"km")
```

## Heart and lungs

The heart rate at rest, and the volume of the lungs and of each breath, of mammals (Stahl 1967):

::: tabs

== Heart rate

```@example physiology
heart_rate(EutherianMammal(), 0.02u"kg"), heart_rate(EutherianMammal(), 70.0u"kg")
```

== Lung volume

```@example physiology
lung_volume(EutherianMammal(), 0.02u"kg"), lung_volume(EutherianMammal(), 70.0u"kg")
```

== Tidal volume

```@example physiology
tidal_volume(EutherianMammal(), 0.02u"kg"), tidal_volume(EutherianMammal(), 70.0u"kg")
```

:::

Lung and tidal volumes are nearly proportional to body mass, so the tidal volume is about 14% of lung volume at any
size.

## Life history

Maximum lifespan and generation time of mammals rise with size (Calder 1984):

::: tabs

== Lifespan

```@example physiology
lifespan(EutherianMammal(), 0.02u"kg"), lifespan(EutherianMammal(), 70.0u"kg")
```

== Generation time

```@example physiology
generation_time(EutherianMammal(), 0.02u"kg"), generation_time(EutherianMammal(), 70.0u"kg")
```

:::

## Physiological time

Because heart rate scales as ``M^{-1/4}`` and lifespan nearly as ``M^{1/4}``, the number of heartbeats in a lifetime
changes little with size: small animals live faster, not more.

```@example physiology
heartbeats(mass) = uconvert(NoUnits, heart_rate(EutherianMammal(), mass) * lifespan(EutherianMammal(), mass))
masses = exp10.(range(-2, 3; length = 50)) .* u"kg"
fig, ax = figure_axis("Body mass (kg)", "Heartbeats in a lifetime (billions)"; xscale = log10,
                      limits = (nothing, (0, 3)))
lines!(ax, ustrip.(u"kg", masses), heartbeats.(masses) ./ 1e9; linewidth = 2)
fig
```

A mouse and an elephant each have a lifetime of one to two billion heartbeats.
