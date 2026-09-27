# Metabolic rate

Metabolic rate is the rate at which an organism uses energy. It scales with body mass to a power less than 1, near
``3/4``, so that small animals use more energy per gram than large ones (Kleiber 1932, White and Kearney 2014). It also depends on body
temperature, which for endotherms is held nearly constant, and for ectotherms and plants follows the environment.

```@setup metabolic
using Main.FigureHelpers
using CairoMakie, BiologicalScaling, Unitful
```

## Basal metabolic rate of endotherms

The basal metabolic rate is the rate of a resting, fasted animal in its thermoneutral zone (White and Kearney 2013). [`basal_metabolic_rate`](@ref)
gives it for mammals and birds:

::: tabs

== Eutherian mammal

Kleiber's law, with an exponent of ``3/4`` (Schmidt-Nielsen 1975):

```@example metabolic
power_law(BasalMetabolicRate(), EutherianMammal())
```

== Marsupial

Marsupials have lower metabolic rates than placental mammals of the same size (Dawson and Hulbert 1970):

```@example metabolic
power_law(BasalMetabolicRate(), Marsupial())
```

== Passerine bird

Passerines have higher metabolic rates than other birds (Bennett and Harvey 1987):

```@example metabolic
power_law(BasalMetabolicRate(), PasserineBird())
```

== Non-passerine bird

With body mass in grams (McKechnie and Wolf 2004):

```@example metabolic
power_law(BasalMetabolicRate(), NonPasserineBird())
```

:::

The coefficients and exponents differ between groups, and the lines diverge over the range of body sizes:

```@example metabolic
masses = exp10.(range(-3, 3; length = 100)) .* u"kg"
fig, ax = figure_axis("Body mass (kg)", "Basal metabolic rate (W)"; xscale = log10, yscale = log10)
for (taxon, label) in ((EutherianMammal(), "Eutherian mammal"), (Marsupial(), "Marsupial"),
                       (PasserineBird(), "Passerine bird"), (NonPasserineBird(), "Non-passerine bird"))
    lines!(ax, ustrip.(u"kg", masses), ustrip.(u"W", basal_metabolic_rate.(Ref(taxon), masses)); linewidth = 2, label)
end
axislegend(ax; position = :lt)
fig
```

Other mammals and birds, [`Primate`](@ref) and [`Human`](@ref), use the equation for eutherian mammals, and an
[`AbstractBird`](@ref) without a group uses the equation for non-passerines.

### Mass-specific metabolic rate

Dividing by body mass gives the metabolic rate per unit mass, which falls with size as ``M^{-1/4}``:

```@example metabolic
fig, ax = figure_axis("Body mass (kg)", "Mass-specific metabolic rate (W/kg)"; xscale = log10, yscale = log10)
lines!(ax, ustrip.(u"kg", masses), ustrip.(u"W/kg", basal_metabolic_rate.(Ref(EutherianMammal()), masses) ./ masses);
       linewidth = 2)
fig
```

By Kleiber's law, a 5 g shrew uses energy per gram about 30 times as fast as a 4 tonne elephant.

### Observed and predicted

Real species scatter around the allometric line. Here are representative basal metabolic rates of some mammals
(after Kleiber 1961 and McNab 2008), compared with Kleiber's law:

```@example metabolic
observed = [
    (0.007u"kg", 0.29u"W", "Shrew"),
    (0.021u"kg", 0.26u"W", "Mouse"),
    (0.262u"kg", 1.45u"W", "Rat"),
    (2.4u"kg", 6.6u"W", "Rabbit"),
    (20.0u"kg", 25.0u"W", "Dog"),
    (70.0u"kg", 83.0u"W", "Human"),
]
[(name, round(uconvert(NoUnits, bmr / basal_metabolic_rate(EutherianMammal(), mass)); digits = 2))
 for (mass, bmr, name) in observed]
```

The ratio of observed to predicted rate is the relative metabolic level; the shrew runs at more than three times the rate
expected for its size.

## Standard metabolic rate of ectotherms

The metabolic rate of ectotherms depends on body temperature. For squamate reptiles, [`standard_metabolic_rate`](@ref)
uses the equation of Andrews and Pough (1985),

```math
\dot{V}_{O_2} = 0.013\, M^{0.8}\, 10^{0.038 T}\, 10^{s} \quad \text{mL O}_2\text{/h}
```

with body mass ``M`` in g and body temperature ``T`` in °C, converted to W with 20.1 J per mL of oxygen. The
metabolic state ``s`` is 0 for standard (fasted and inactive) and 1 for resting (fasted, in the active season)
metabolism:

::: tabs

== Standard

```@example metabolic
standard_metabolic_rate(Squamate(), 50.0u"g", 30.0u"°C")
```

== Resting

```@example metabolic
standard_metabolic_rate(Squamate(), 50.0u"g", 30.0u"°C"; metabolic_state = 1.0)
```

:::

The rate rises by a factor of ``10^{0.38} = 2.4`` for every 10 °C. The temperature is limited to between 1 and 50 °C:

```@example metabolic
temperatures = collect(0.0:0.5:45.0) .* u"°C"
fig, ax = figure_axis("Body temperature (°C)", "Standard metabolic rate (mW)")
for mass in [10.0, 50.0, 200.0] .* u"g"
    lines!(ax, ustrip.(temperatures), ustrip.(u"mW", standard_metabolic_rate.(Ref(Squamate()), mass, temperatures));
           linewidth = 2, label = "$mass")
end
axislegend(ax; position = :lt)
fig
```

[ThermalPhysiology.jl](https://github.com/BiophysicalEcology/ThermalPhysiology.jl) provides other models of the effect
of temperature, including the Arrhenius model and the decline at high temperatures, that can be applied to a rate from
these equations at a reference temperature.

## Plant respiration

The dark (mitochondrial) respiration of C3 plants is proportional to biomass and follows the Arrhenius relation with
an activation energy of 0.65 eV, normalised to 25 °C (Reich et al. 2006):

```@example metabolic
allometric(BasalMetabolicRate(), C3Plant(), 1.0u"kg", 25.0u"°C"), allometric(BasalMetabolicRate(), C3Plant(), 1.0u"kg", 35.0u"°C")
```
