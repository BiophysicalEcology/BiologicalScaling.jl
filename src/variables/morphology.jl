# ── Surface area ──────────────────────────────────────────────────────────────

"""
    _SA_MAMMAL

Generic mammal total surface area (isometric baseline): SA = 0.1 × M^0.667 m² (M in kg).

Source: Schmidt-Nielsen, K. (1975). Scaling in Biology: The Consequences of Size.
*American Zoologist* 15:295–305. Derived from geometric similarity (SA ∝ M^2/3).
"""
const _SA_MAMMAL = PowerLaw(
    0.1, 0.667;
    input_unit  = u"kg",
    output_unit = u"m^2",
    reference   = "Schmidt-Nielsen 1975 Am. Zool. 15:295–305 (isometric baseline)"
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
*American Zoologist* 15:295–305.
"""
const _SKELETON_MAMMAL = PowerLaw(
    0.061, 1.13;
    input_unit  = u"kg",
    output_unit = u"kg",
    reference   = "Schmidt-Nielsen 1975 Am. Zool. 15:295–305"
)

# ── Brain mass ────────────────────────────────────────────────────────────────

"""
    _BRAIN_MAMMAL

Generic mammal brain mass: M_brain = 0.01 × M^0.7 kg (M in kg).

Source: Schmidt-Nielsen, K. (1975). Scaling in Biology: The Consequences of Size.
*American Zoologist* 15:295–305.
"""
const _BRAIN_MAMMAL = PowerLaw(
    0.01, 0.7;
    input_unit  = u"kg",
    output_unit = u"kg",
    reference   = "Schmidt-Nielsen 1975 Am. Zool. 15:295–305"
)

"""
    _BRAIN_PRIMATE

Non-human primate brain mass: M_brain = 0.025 × M^0.66 kg (M in kg).

Source: Schmidt-Nielsen, K. (1975). Scaling in Biology: The Consequences of Size.
*American Zoologist* 15:295–305 (midpoint of 0.02–0.03 range).
"""
const _BRAIN_PRIMATE = PowerLaw(
    0.025, 0.66;
    input_unit  = u"kg",
    output_unit = u"kg",
    reference   = "Schmidt-Nielsen 1975 Am. Zool. 15:295–305 (primates)"
)

"""
    _BRAIN_HUMAN

Human brain mass: M_brain = 0.08 × M^0.66 kg (M in kg).

Source: Schmidt-Nielsen, K. (1975). Scaling in Biology: The Consequences of Size.
*American Zoologist* 15:295–305.
"""
const _BRAIN_HUMAN = PowerLaw(
    0.08, 0.66;
    input_unit  = u"kg",
    output_unit = u"kg",
    reference   = "Schmidt-Nielsen 1975 Am. Zool. 15:295–305 (humans)"
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

surface_area(taxon, mass)  = allometric(SurfaceArea(),  taxon, mass)
skin_area(taxon, mass)     = allometric(SkinArea(),     taxon, mass)
plumage_area(taxon, mass)  = allometric(PlumageArea(),  taxon, mass)
skeleton_mass(taxon, mass) = allometric(SkeletonMass(), taxon, mass)
brain_mass(taxon, mass)    = allometric(BrainMass(),    taxon, mass)
