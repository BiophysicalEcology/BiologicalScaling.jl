# ── Lifespan ──────────────────────────────────────────────────────────────────

"""
    _LIFESPAN_MAMMAL

Maximum lifespan for mammals: L = 11.8 × M^0.20 yr (M in kg).

Source: Calder, W. A. (1984). *Size, Function, and Life History*.
Harvard University Press, Cambridge MA.
See also: Schmidt-Nielsen, K. (1975). Scaling in Biology: The Consequences of Size.
*American Zoologist* 15:295–305.
"""
const _LIFESPAN_MAMMAL = PowerLaw(
    11.8, 0.20;
    input_unit  = u"kg",
    output_unit = u"yr",
    reference   = "Calder 1984 Size, Function, and Life History. Harvard Univ. Press"
)

# ── Generation time ───────────────────────────────────────────────────────────

"""
    _GENERATION_TIME_MAMMAL

Generation time for mammals: T_gen = 0.83 × M^0.25 yr (M in kg).
Scales as M^1/4, the same exponent as metabolic time scales.

Source: Calder, W. A. (1984). *Size, Function, and Life History*.
Harvard University Press, Cambridge MA.
"""
const _GENERATION_TIME_MAMMAL = PowerLaw(
    0.83, 0.25;
    input_unit  = u"kg",
    output_unit = u"yr",
    reference   = "Calder 1984 Size, Function, and Life History. Harvard Univ. Press"
)

# ── allometric dispatch ────────────────────────────────────────────────────────

allometric(::Lifespan,       ::AbstractMammal, mass) = _LIFESPAN_MAMMAL(mass)
allometric(::GenerationTime, ::AbstractMammal, mass) = _GENERATION_TIME_MAMMAL(mass)

# ── power_law accessors ────────────────────────────────────────────────────────

power_law(::Lifespan,       ::AbstractMammal) = _LIFESPAN_MAMMAL
power_law(::GenerationTime, ::AbstractMammal) = _GENERATION_TIME_MAMMAL

# ── allometric_inputs ──────────────────────────────────────────────────────────

allometric_inputs(::AbstractLifeHistory, ::AbstractTaxon) = (:mass,)

# ── Named convenience wrappers ─────────────────────────────────────────────────

lifespan(taxon, mass)        = allometric(Lifespan(),       taxon, mass)
generation_time(taxon, mass) = allometric(GenerationTime(), taxon, mass)
