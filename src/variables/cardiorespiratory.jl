# ── Heart rate ────────────────────────────────────────────────────────────────

"""
    _HEART_RATE_MAMMAL

Resting heart rate for mammals: HR = 241 × M^-0.25 min⁻¹ (M in kg).

Source: Stahl, W. R. (1967). Scaling of respiratory variables in mammals.
*Journal of Applied Physiology* 22:453–460.
See also: Schmidt-Nielsen, K. (1975). Scaling in Biology: The Consequences of Size.
*American Zoologist* 15:295–305.
"""
const _HEART_RATE_MAMMAL = PowerLaw(
    241.0, -0.25;
    input_unit  = u"kg",
    output_unit = u"minute^-1",
    reference   = "Stahl 1967 J. Appl. Physiol. 22:453–460"
)

# ── Lung volume ───────────────────────────────────────────────────────────────

"""
    _LUNG_VOLUME_MAMMAL

Total lung volume for mammals: V_lung = 53.5 × M^1.06 mL (M in kg).

Source: Stahl, W. R. (1967). Scaling of respiratory variables in mammals.
*Journal of Applied Physiology* 22:453–460.
"""
const _LUNG_VOLUME_MAMMAL = PowerLaw(
    53.5, 1.06;
    input_unit  = u"kg",
    output_unit = u"mL",
    reference   = "Stahl 1967 J. Appl. Physiol. 22:453–460"
)

# ── Tidal volume ──────────────────────────────────────────────────────────────

"""
    _TIDAL_VOLUME_MAMMAL

Tidal volume (volume per breath) for mammals: V_t = 7.7 × M^1.04 mL (M in kg).

Source: Stahl, W. R. (1967). Scaling of respiratory variables in mammals.
*Journal of Applied Physiology* 22:453–460.
"""
const _TIDAL_VOLUME_MAMMAL = PowerLaw(
    7.7, 1.04;
    input_unit  = u"kg",
    output_unit = u"mL",
    reference   = "Stahl 1967 J. Appl. Physiol. 22:453–460"
)

# ── allometric dispatch ────────────────────────────────────────────────────────

allometric(::HeartRate,   ::AbstractMammal, mass) = _HEART_RATE_MAMMAL(mass)
allometric(::LungVolume,  ::AbstractMammal, mass) = _LUNG_VOLUME_MAMMAL(mass)
allometric(::TidalVolume, ::AbstractMammal, mass) = _TIDAL_VOLUME_MAMMAL(mass)

# ── power_law accessors ────────────────────────────────────────────────────────

power_law(::HeartRate,   ::AbstractMammal) = _HEART_RATE_MAMMAL
power_law(::LungVolume,  ::AbstractMammal) = _LUNG_VOLUME_MAMMAL
power_law(::TidalVolume, ::AbstractMammal) = _TIDAL_VOLUME_MAMMAL

# ── allometric_inputs ──────────────────────────────────────────────────────────

allometric_inputs(::AbstractCardioRespiratory, ::AbstractTaxon) = (:mass,)

# ── Named convenience wrappers ─────────────────────────────────────────────────

heart_rate(taxon, mass)   = allometric(HeartRate(),   taxon, mass)
lung_volume(taxon, mass)  = allometric(LungVolume(),  taxon, mass)
tidal_volume(taxon, mass) = allometric(TidalVolume(), taxon, mass)
