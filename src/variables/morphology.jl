# ── Surface area ──────────────────────────────────────────────────────────────

"""
    _SA_MAMMAL

Generic mammal total surface area (isometric baseline): SA = 0.1 × M^0.667 m² (M in kg).

Source: Schmidt-Nielsen, K. (1975). Scaling in Biology: The Consequences of Size.
*Journal of Experimental Zoology* 194:287–307. Derived from geometric similarity (SA ∝ M^2/3).
"""
const _SA_MAMMAL = PowerLaw(
    0.1, 0.667;
    input_unit  = u"kg",
    output_unit = u"m^2",
    reference   = "Schmidt-Nielsen 1975 J. Exp. Zool. 194:287–307 (isometric baseline)"
)

"""
    _SKIN_AREA_MAMMAL

Mammal skin surface area: SA_skin = 1110 × M^0.65 cm² (M in kg).
Note: skin area does not include fur.

Source: Walsberg, G. E., & King, J. R. (1978). The relationship of the external surface
area of birds to skin surface area and body mass.
*Journal of Experimental Biology* 76:185–189.
"""
const _SKIN_AREA_MAMMAL = PowerLaw(
    1110.0, 0.65;
    input_unit  = u"kg",
    output_unit = u"cm^2",
    reference   = "Walsberg & King 1978 J. Exp. Biol. 76:185–189"
)

"""
    _SKIN_AREA_BIRD

Bird skin surface area: SA_skin = 10.0 × M^0.667 cm² (M in g).
Note: skin area is greater than plumage area.

Source: Walsberg, G. E., & King, J. R. (1978). The relationship of the external surface
area of birds to skin surface area and body mass.
*Journal of Experimental Biology* 76:185–189.
"""
const _SKIN_AREA_BIRD = PowerLaw(
    10.0, 0.667;
    input_unit  = u"g",
    output_unit = u"cm^2",
    reference   = "Walsberg & King 1978 J. Exp. Biol. 76:185–189"
)

"""
    _PLUMAGE_AREA_BIRD

Bird plumage (feather) surface area: SA_plumage = 8.11 × M^0.667 cm² (M in g).
Note: plumage area is less than skin area.

Source: Walsberg, G. E., & King, J. R. (1978). The relationship of the external surface
area of birds to skin surface area and body mass.
*Journal of Experimental Biology* 76:185–189.
"""
const _PLUMAGE_AREA_BIRD = PowerLaw(
    8.11, 0.667;
    input_unit  = u"g",
    output_unit = u"cm^2",
    reference   = "Walsberg & King 1978 J. Exp. Biol. 76:185–189"
)

# ── Skeleton mass ─────────────────────────────────────────────────────────────

"""
    _SKELETON_MAMMAL

Mammal skeleton dry mass: M_sk = 0.061 × M^1.13 kg (M in kg).
Larger animals require disproportionately heavier skeletons.

Source: Schmidt-Nielsen, K. (1975). Scaling in Biology: The Consequences of Size.
*Journal of Experimental Zoology* 194:287–307.
"""
const _SKELETON_MAMMAL = PowerLaw(
    0.061, 1.13;
    input_unit  = u"kg",
    output_unit = u"kg",
    reference   = "Schmidt-Nielsen 1975 J. Exp. Zool. 194:287–307"
)

# ── Brain mass ────────────────────────────────────────────────────────────────

"""
    _BRAIN_MAMMAL

Generic mammal brain mass: M_brain = 0.01 × M^0.7 kg (M in kg).

Source: Schmidt-Nielsen, K. (1975). Scaling in Biology: The Consequences of Size.
*Journal of Experimental Zoology* 194:287–307.
"""
const _BRAIN_MAMMAL = PowerLaw(
    0.01, 0.7;
    input_unit  = u"kg",
    output_unit = u"kg",
    reference   = "Schmidt-Nielsen 1975 J. Exp. Zool. 194:287–307"
)

"""
    _BRAIN_PRIMATE

Non-human primate brain mass: M_brain = 0.025 × M^0.66 kg (M in kg).

Source: Schmidt-Nielsen, K. (1975). Scaling in Biology: The Consequences of Size.
*Journal of Experimental Zoology* 194:287–307 (midpoint of 0.02–0.03 range).
"""
const _BRAIN_PRIMATE = PowerLaw(
    0.025, 0.66;
    input_unit  = u"kg",
    output_unit = u"kg",
    reference   = "Schmidt-Nielsen 1975 J. Exp. Zool. 194:287–307 (primates)"
)

"""
    _BRAIN_HUMAN

Human brain mass: M_brain = 0.08 × M^0.66 kg (M in kg).

Source: Schmidt-Nielsen, K. (1975). Scaling in Biology: The Consequences of Size.
*Journal of Experimental Zoology* 194:287–307.
"""
const _BRAIN_HUMAN = PowerLaw(
    0.08, 0.66;
    input_unit  = u"kg",
    output_unit = u"kg",
    reference   = "Schmidt-Nielsen 1975 J. Exp. Zool. 194:287–307 (humans)"
)

# ── Silhouette area ────────────────────────────────────────────────────────────

"""
    _SIL_NORMAL_DESERT_IGUANA

Desert iguana (*Dipsosaurus dorsalis*) silhouette area normal to the solar beam:
ASIL = 3.798×10⁻⁴ × Mɡ^0.683 m² (Mɡ in g).

Source: Porter, W. P., & Tracy, C. R. (1983). Biophysical analyses of energetics, time-space
utilization, and distributional limits. In R. B. Huey, E. R. Pianka, & T. W. Schoener (Eds.),
*Lizard Ecology: Studies of a Model Organism* (pp. 55–83). Harvard University Press.
Original data from Porter et al. (1973) *Oecologia* 13:1–54.
"""
const _SIL_NORMAL_DESERT_IGUANA = PowerLaw(
    3.798e-4, 0.683;
    input_unit  = u"g",
    output_unit = u"m^2",
    reference   = "Porter et al. 1973 Oecologia 13:1–54; Porter & Tracy 1983 in Lizard Ecology (Harvard)"
)

"""
    _SIL_PARALLEL_DESERT_IGUANA

Desert iguana (*Dipsosaurus dorsalis*) silhouette area parallel to the solar beam:
ASIL = 6.94×10⁻⁵ × Mɡ^0.743 m² (Mɡ in g).

Source: Porter, W. P., & Tracy, C. R. (1983). Biophysical analyses of energetics, time-space
utilization, and distributional limits. In R. B. Huey, E. R. Pianka, & T. W. Schoener (Eds.),
*Lizard Ecology: Studies of a Model Organism* (pp. 55–83). Harvard University Press.
"""
const _SIL_PARALLEL_DESERT_IGUANA = PowerLaw(
    6.94e-5, 0.743;
    input_unit  = u"g",
    output_unit = u"m^2",
    reference   = "Porter et al. 1973 Oecologia 13:1–54; Porter & Tracy 1983 in Lizard Ecology (Harvard)"
)

"""
    _SIL_NORMAL_LEOPARD_FROG

Leopard frog (*Rana pipiens*) total surface area allometry:
ATOT = 1.279×10⁻³ × Mɡ^0.606 m² (Mɡ in g).
Used as a proxy for the normal-to-sun silhouette for this taxon.

Source: Tracy, C. R. (1976). A model of the dynamic exchanges of water and energy
between a terrestrial amphibian and its environment. *Ecological Monographs* 46:293–326.
"""
const _SIL_NORMAL_LEOPARD_FROG = PowerLaw(
    1.279e-3, 0.606;
    input_unit  = u"g",
    output_unit = u"m^2",
    reference   = "Tracy 1976 Ecol. Monogr. 46:293–326"
)

"""
    _SIL_VENTRAL_LEOPARD_FROG

Leopard frog (*Rana pipiens*) ventral surface area:
AVEN = 4.25×10⁻⁵ × Mɡ^0.85 m² (Mɡ in g).

Source: Tracy, C. R. (1976). A model of the dynamic exchanges of water and energy
between a terrestrial amphibian and its environment. *Ecological Monographs* 46:293–326.
"""
const _SIL_VENTRAL_LEOPARD_FROG = PowerLaw(
    4.25e-5, 0.85;
    input_unit  = u"g",
    output_unit = u"m^2",
    reference   = "Tracy 1976 Ecol. Monogr. 46:293–326"
)

# ── allometric dispatch ────────────────────────────────────────────────────────

allometric(::SurfaceArea,  ::AbstractMammal, mass) = _SA_MAMMAL(mass)

allometric(::SkinArea, ::AbstractMammal, mass) = _SKIN_AREA_MAMMAL(mass)
allometric(::SkinArea, ::AbstractBird,   mass) = _SKIN_AREA_BIRD(mass)

allometric(::PlumageArea, ::AbstractBird, mass) = _PLUMAGE_AREA_BIRD(mass)

allometric(::SkeletonMass, ::AbstractMammal, mass) = _SKELETON_MAMMAL(mass)

allometric(::BrainMass, ::AbstractMammal, mass) = _BRAIN_MAMMAL(mass)
allometric(::BrainMass, ::Primate,        mass) = _BRAIN_PRIMATE(mass)
allometric(::BrainMass, ::Human,          mass) = _BRAIN_HUMAN(mass)

# ── power_law accessors ────────────────────────────────────────────────────────

power_law(::SurfaceArea,  ::AbstractMammal) = _SA_MAMMAL
power_law(::SkinArea,     ::AbstractMammal) = _SKIN_AREA_MAMMAL
power_law(::SkinArea,     ::AbstractBird)   = _SKIN_AREA_BIRD
power_law(::PlumageArea,  ::AbstractBird)   = _PLUMAGE_AREA_BIRD
power_law(::SkeletonMass, ::AbstractMammal) = _SKELETON_MAMMAL
power_law(::BrainMass,    ::AbstractMammal) = _BRAIN_MAMMAL
power_law(::BrainMass,    ::Primate)        = _BRAIN_PRIMATE
power_law(::BrainMass,    ::Human)          = _BRAIN_HUMAN

# ── allometric_inputs ──────────────────────────────────────────────────────────

allometric_inputs(::AbstractMorphology, ::AbstractTaxon) = (:mass,)

# ── Named convenience wrappers ─────────────────────────────────────────────────

allometric(::SilhouetteArea{NormalToSun},   ::DesertIguana, mass) = _SIL_NORMAL_DESERT_IGUANA(mass)
allometric(::SilhouetteArea{ParallelToSun}, ::DesertIguana, mass) = _SIL_PARALLEL_DESERT_IGUANA(mass)
allometric(::SilhouetteArea{NormalToSun},   ::LeopardFrog,  mass) = _SIL_NORMAL_LEOPARD_FROG(mass)
allometric(::SilhouetteArea{ParallelToSun}, ::LeopardFrog,  mass) = _SIL_VENTRAL_LEOPARD_FROG(mass)

power_law(::SilhouetteArea{NormalToSun},   ::DesertIguana) = _SIL_NORMAL_DESERT_IGUANA
power_law(::SilhouetteArea{ParallelToSun}, ::DesertIguana) = _SIL_PARALLEL_DESERT_IGUANA
power_law(::SilhouetteArea{NormalToSun},   ::LeopardFrog)  = _SIL_NORMAL_LEOPARD_FROG
power_law(::SilhouetteArea{ParallelToSun}, ::LeopardFrog)  = _SIL_VENTRAL_LEOPARD_FROG

# ── Named convenience wrappers ─────────────────────────────────────────────────

"""
    surface_area(taxon, mass)

Shorthand for `allometric(SurfaceArea(), taxon, mass)`. Example:

    surface_area(EutherianMammal(), 70.0u"kg")
"""
surface_area(taxon, mass)     = allometric(SurfaceArea(),  taxon, mass)
"""
    skin_area(taxon, mass)

Shorthand for `allometric(SkinArea(), taxon, mass)`. Example:

    skin_area(PasserineBird(), 20.0u"g")
"""
skin_area(taxon, mass)        = allometric(SkinArea(),     taxon, mass)
"""
    plumage_area(taxon, mass)

Shorthand for `allometric(PlumageArea(), taxon, mass)`. Example:

    plumage_area(PasserineBird(), 20.0u"g")
"""
plumage_area(taxon, mass)     = allometric(PlumageArea(),  taxon, mass)
"""
    skeleton_mass(taxon, mass)

Shorthand for `allometric(SkeletonMass(), taxon, mass)`. Example:

    skeleton_mass(EutherianMammal(), 70.0u"kg")
"""
skeleton_mass(taxon, mass)    = allometric(SkeletonMass(), taxon, mass)
"""
    brain_mass(taxon, mass)

Shorthand for `allometric(BrainMass(), taxon, mass)`. Example:

    brain_mass(Primate(), 5.0u"kg")
"""
brain_mass(taxon, mass)       = allometric(BrainMass(),    taxon, mass)
"""
    silhouette_area(orientation, taxon, mass)

Shorthand for `allometric(SilhouetteArea{typeof(orientation)}(), taxon, mass)`, with `orientation`
[`NormalToSun`](@ref)`()` or [`ParallelToSun`](@ref)`()`. Example:

    silhouette_area(NormalToSun(), DesertIguana(), 50.0u"g")
"""
silhouette_area(orientation, taxon, mass) = allometric(SilhouetteArea{typeof(orientation)}(), taxon, mass)
