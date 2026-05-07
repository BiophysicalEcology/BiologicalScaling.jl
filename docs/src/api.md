# API Reference

## Primary interface

```@docs
allometric
allometric_inputs
power_law
montgomery_law
reference
trait_name
```

## Equation types

```@docs
PowerLaw
MontgomeryLaw
```

## Scaling registry

```@docs
ScalingEntry
SCALING_REGISTRY
```

## Variable types

```@docs
AbstractScalingVariable
AbstractMetabolicRate
BasalMetabolicRate
FieldMetabolicRate
StandardMetabolicRate
AbstractMorphology
SurfaceArea
SkinArea
PlumageArea
SkeletonMass
BrainMass
SilhouetteArea
AbstractLocomotion
StrideFrequency
CostOfTransport
AbstractCardioRespiratory
HeartRate
LungVolume
TidalVolume
AbstractLifeHistory
Lifespan
GenerationTime
AbstractLeafMorphology
LeafArea
LeafDryMass
```

## Taxon types

```@docs
AbstractTaxon
AbstractMammal
EutherianMammal
Marsupial
Primate
Human
AbstractBird
PasserineBird
NonPasserineBird
AbstractReptile
Squamate
DesertIguana
AbstractAmphibian
Anuran
LeopardFrog
AbstractPlant
AbstractLeafPlant
C3Plant
BroadleafPlant
Bambusoideae
Liriodendron
Rosaceae
Lauraceae
Oleaceae
```

## Convenience wrappers

```@docs
basal_metabolic_rate
standard_metabolic_rate
surface_area
skin_area
plumage_area
skeleton_mass
brain_mass
silhouette_area
stride_frequency
cost_of_transport
heart_rate
lung_volume
tidal_volume
lifespan
generation_time
leaf_area
leaf_dry_mass
```

## Structural constraints

```@docs
AbstractScalingSimilarity
ElasticSimilarity
GeometricSimilarity
DynamicSimilarity
limb_diameter
limb_length
limb_aspect_ratio
```

## Body-part proportions

```@docs
BodyPartProportions
body_part_proportions
HUMAN_BODY_PROPORTIONS
```

## Visualisation

```@docs
allometric_scaling
structural_constraints
plot_allometric_scaling
plot_structural_constraints
```
