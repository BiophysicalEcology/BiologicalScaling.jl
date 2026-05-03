# ── Stride frequency ──────────────────────────────────────────────────────────

"""
    _STRIDE_FREQ_MAMMAL

Mammal stride frequency at the trot–gallop transition: f ≈ 4.0 × M^-0.25 Hz (M in kg).

Source: Heglund, N. C., Taylor, C. R., & McMahon, T. A. (1974). Scaling stride frequency
and gait to animal size: mice to horses. *Science* 186:1112–1113.
See also: Schmidt-Nielsen, K. (1975). Scaling in Biology: The Consequences of Size.
*American Zoologist* 15:295–305.
"""
const _STRIDE_FREQ_MAMMAL = PowerLaw(
    4.0, -0.25;
    input_unit  = u"kg",
    output_unit = u"Hz",
    reference   = "Heglund, Taylor & McMahon 1974 Science 186:1112–1113"
)

# ── Cost of transport ─────────────────────────────────────────────────────────

"""
    _COT_MAMMAL

Mass-specific cost of transport for running mammals: COT = 10.7 × M^-0.316 J kg⁻¹ m⁻¹
(M in kg). Large animals are more efficient movers.

Source: Fedak, M. A., & Seeherman, H. J. (1979). Reappraisal of energetics of locomotion
shows identical cost in bipeds and quadrupeds including ostrich and horse.
*Journal of Experimental Biology* 79:1–25.
"""
const _COT_MAMMAL = PowerLaw(
    10.7, -0.316;
    input_unit  = u"kg",
    output_unit = u"J/kg/m",
    reference   = "Fedak & Seeherman 1979 J. Exp. Biol. 79:1–25"
)

"""
    _COT_BIRD

Mass-specific cost of transport for flying birds: COT = 8.46 × M^-0.21 J kg⁻¹ m⁻¹
(M in kg).

Source: Tucker, V. A. (1970). Energetic cost of locomotion in animals.
*Comparative Biochemistry and Physiology* 34:841–846.
"""
const _COT_BIRD = PowerLaw(
    8.46, -0.21;
    input_unit  = u"kg",
    output_unit = u"J/kg/m",
    reference   = "Tucker 1970 Comp. Biochem. Physiol. 34:841–846"
)

# ── allometric dispatch ────────────────────────────────────────────────────────

allometric(::StrideFrequency, ::AbstractMammal, mass) = _STRIDE_FREQ_MAMMAL(mass)
allometric(::CostOfTransport, ::AbstractMammal, mass) = _COT_MAMMAL(mass)
allometric(::CostOfTransport, ::AbstractBird,   mass) = _COT_BIRD(mass)

# ── power_law accessors ────────────────────────────────────────────────────────

power_law(::StrideFrequency, ::AbstractMammal) = _STRIDE_FREQ_MAMMAL
power_law(::CostOfTransport, ::AbstractMammal) = _COT_MAMMAL
power_law(::CostOfTransport, ::AbstractBird)   = _COT_BIRD

# ── allometric_inputs ──────────────────────────────────────────────────────────

allometric_inputs(::AbstractLocomotion, ::AbstractTaxon) = (:mass,)

# ── Named convenience wrappers ─────────────────────────────────────────────────

stride_frequency(taxon, mass)  = allometric(StrideFrequency(), taxon, mass)
cost_of_transport(taxon, mass) = allometric(CostOfTransport(), taxon, mass)
