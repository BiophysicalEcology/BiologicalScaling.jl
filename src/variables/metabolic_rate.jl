# ── Basal metabolic rate power-law constants ──────────────────────────────────

"""
    _BMR_EUTHERIAN

Kleiber's law for eutherian (placental) mammals: BMR = 3.34 × M^0.75 W (M in kg).

Source: Schmidt-Nielsen, K. (1975). Scaling in Biology: The Consequences of Size.
*American Zoologist* 15:295–305, Table 4-2.
See also: McNab, B. K. (2008). An analysis of the factors that influence the level
and scaling of mammalian BMR. *Comparative Biochemistry and Physiology A* 151:5–28.
"""
const _BMR_EUTHERIAN = PowerLaw(
    3.34, 0.75;
    input_unit  = u"kg",
    output_unit = u"W",
    reference   = "Schmidt-Nielsen 1975 Am. Zool. 15:295–305; McNab 2008 Comp. Biochem. Physiol. A 151:5–28"
)

"""
    _BMR_MARSUPIAL

Basal metabolic rate for marsupials: BMR = 2.36 × M^0.737 W (M in kg).

Source: Dawson, T. J., & Hulbert, A. J. (1970). Standard metabolism, body temperature,
and surface areas of Australian marsupials.
*American Journal of Physiology* 218:1233–1238.
"""
const _BMR_MARSUPIAL = PowerLaw(
    2.36, 0.737;
    input_unit  = u"kg",
    output_unit = u"W",
    reference   = "Dawson & Hulbert 1970 Am. J. Physiol. 218:1233–1238"
)

"""
    _BMR_NONPASSERINE

Basal metabolic rate for non-passerine birds: BMR = 10^(−1.461) × M^0.669 W (M in g).

Source: McKechnie, A. E., & Wolf, B. O. (2004). The Allometry of Avian Basal Metabolic
Rate: Good Predictions Need Good Data. *Physiological and Biochemical Zoology* 77:502–521.
"""
const _BMR_NONPASSERINE = PowerLaw(
    10.0^(-1.461), 0.669;
    input_unit  = u"g",
    output_unit = u"W",
    reference   = "McKechnie & Wolf 2004 Physiol. Biochem. Zool. 77:502–521"
)

"""
    _BMR_PASSERINE

Basal metabolic rate for passerine birds: BMR = 6.25 × M^0.724 W (M in kg).

Source: Bennett, P. M., & Harvey, P. H. (1987). Active and resting metabolism in birds:
allometry, phylogeny and ecology. *Journal of Zoology* 213:327–363.
"""
const _BMR_PASSERINE = PowerLaw(
    6.25, 0.724;
    input_unit  = u"kg",
    output_unit = u"W",
    reference   = "Bennett & Harvey 1987 J. Zool. 213:327–363"
)

# ── Standard metabolic rate — ectotherms ──────────────────────────────────────
# Andrews & Pough (1985) Eq. 2 parameters for squamates.
# VO₂ = normalisation × M_g^0.8 × 10^(0.038 × T_°C) × 10^metabolic_state  (mL O₂/hr)
# metabolic_state = 0 → standard (fasted, inactive); 1 → resting (fasted, active).
const _SMR_SQUAMATE_REFERENCE = "Andrews & Pough 1985 Physiol. Zool. 58:214–231, Eq. 2"

# ── Plant dark respiration — Arrhenius ────────────────────────────────────────
# R = mass_normalisation × M_kg × exp(−Ea/(k·T)) / exp(−Ea/(k·T_ref))
# Default params from Reich et al. 2006 and CLM/LPJ parameterisation.
const _PLANT_DARK_RESP_REFERENCE = "Reich et al. 2006 Nature 439:457–461"
const _k_BOLTZMANN_eV = 8.617333e-5  # eV/K

# ── allometric dispatch ────────────────────────────────────────────────────────

"""
    allometric(::BasalMetabolicRate, taxon, mass) → Power (W)

Predict basal metabolic rate from body mass using a taxon-specific power law.

# Examples
```julia
allometric(BasalMetabolicRate(), EutherianMammal(), 1.0u"kg")   # → ~3.34 W
allometric(BasalMetabolicRate(), Marsupial(),       500.0u"g")
allometric(BasalMetabolicRate(), PasserineBird(),   20.0u"g")
```
"""
allometric(::BasalMetabolicRate, ::EutherianMammal,  mass) = _BMR_EUTHERIAN(mass)
allometric(::BasalMetabolicRate, ::Marsupial,        mass) = _BMR_MARSUPIAL(mass)
allometric(::BasalMetabolicRate, ::NonPasserineBird, mass) = _BMR_NONPASSERINE(mass)
allometric(::BasalMetabolicRate, ::PasserineBird,    mass) = _BMR_PASSERINE(mass)
allometric(v::BasalMetabolicRate, ::AbstractMammal,  mass) = allometric(v, EutherianMammal(), mass)
allometric(v::BasalMetabolicRate, ::AbstractBird,    mass) = allometric(v, NonPasserineBird(), mass)

"""
    allometric(::StandardMetabolicRate, ::Squamate, mass, temperature; metabolic_state=0.0) → Power (W)

Predict standard or resting metabolic rate of squamate reptiles from body mass and body
temperature using Andrews & Pough (1985) Eq. 2.

`metabolic_state = 0.0` → standard (fasted, inactive); `1.0` → resting (fasted, active).
Temperature is clamped to 1–50 °C.

# Examples
```julia
allometric(StandardMetabolicRate(), Squamate(), 100.0u"g", 33.0u"°C")
allometric(StandardMetabolicRate(), Squamate(), 100.0u"g", 33.0u"°C"; metabolic_state=1.0)
```
"""
function allometric(::StandardMetabolicRate, ::Squamate, mass, temperature;
                    metabolic_state = 0.0)
    mass_g = ustrip(u"g", mass)
    temp_C = clamp(ustrip(u"°C", temperature), 1.0, 50.0)
    oxygen_ml_hr = 0.013 * mass_g^0.8 * 10.0^(0.038 * temp_C) * 10.0^metabolic_state
    return (oxygen_ml_hr * 20.1 / 3600.0) * u"W"
end

"""
    allometric(::BasalMetabolicRate, ::AbstractPlant, mass, temperature) → Power (W)

Predict plant dark (mitochondrial) respiration from biomass and temperature using an
Arrhenius model (Reich et al. 2006; CLM/LPJ parameterisation).

Rate is normalised to 25 °C: `R = 4.6×10⁻⁴ × M_kg × exp(−0.65/(k·T)) / exp(−0.65/(k·298.15))`.
"""
function allometric(::BasalMetabolicRate, ::AbstractPlant, mass, temperature)
    mass_kg = ustrip(u"kg", mass)
    T       = ustrip(u"K", temperature)
    Ea      = 0.65
    T_ref   = 298.15
    rate    = 4.6e-4 * mass_kg *
              exp(-Ea / (_k_BOLTZMANN_eV * T)) /
              exp(-Ea / (_k_BOLTZMANN_eV * T_ref))
    return rate * u"W"
end

# ── power_law accessors ────────────────────────────────────────────────────────

"""
    power_law(::BasalMetabolicRate, taxon) → PowerLaw

Return the underlying `PowerLaw` for the given taxon.
"""
power_law(::BasalMetabolicRate, ::EutherianMammal)  = _BMR_EUTHERIAN
power_law(::BasalMetabolicRate, ::Marsupial)        = _BMR_MARSUPIAL
power_law(::BasalMetabolicRate, ::NonPasserineBird) = _BMR_NONPASSERINE
power_law(::BasalMetabolicRate, ::PasserineBird)    = _BMR_PASSERINE
power_law(v::BasalMetabolicRate, ::AbstractMammal)  = power_law(v, EutherianMammal())
power_law(v::BasalMetabolicRate, ::AbstractBird)    = power_law(v, NonPasserineBird())

# ── allometric_inputs ──────────────────────────────────────────────────────────

allometric_inputs(::BasalMetabolicRate,    ::AbstractTaxon) = (:mass,)
allometric_inputs(::StandardMetabolicRate, ::AbstractTaxon) = (:mass, :temperature)

# ── Named convenience wrappers ─────────────────────────────────────────────────

basal_metabolic_rate(taxon, mass) = allometric(BasalMetabolicRate(), taxon, mass)
standard_metabolic_rate(taxon, mass, temperature; metabolic_state=0.0) =
    allometric(StandardMetabolicRate(), taxon, mass, temperature; metabolic_state)
