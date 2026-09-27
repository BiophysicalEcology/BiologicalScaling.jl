# Equations

Every equation in the package is listed in [`SCALING_REGISTRY`](@ref), with the trait, the taxon, the equation and its
source. This table is generated from the registry, so it always matches the code:

```@eval
using BiologicalScaling, Markdown
Markdown.parse(BiologicalScaling._allometric_table_md())
```

The units in brackets are those of the input and the output. Equations whose source uses grams take masses in grams,
but any unit of mass can be passed, since the inputs are converted.

## Using the registry

The registry is a vector of [`ScalingEntry`](@ref), which can be searched like any other vector:

```@example equations
using BiologicalScaling, Unitful

[entry.taxon for entry in SCALING_REGISTRY if entry.variable == "Basal metabolic rate"]
```

The full citation of an equation is given by [`reference`](@ref):

::: tabs

== Power law

```@example equations
reference(power_law(BasalMetabolicRate(), Marsupial()))
```

== Montgomery law

```@example equations
reference(montgomery_law(LeafArea(), Bambusoideae()))
```

:::

The table is also part of the help for [`allometric`](@ref), shown with `?allometric` in the REPL.
