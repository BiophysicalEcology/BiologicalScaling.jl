# ── Registry entry ─────────────────────────────────────────────────────────────

"""
    AllometricEntry

An entry in the allometric equation registry, pairing a biological variable and
taxon with the underlying equation object.

## Fields
- `variable` — display name of the predicted quantity (e.g. `"Basal metabolic rate"`)
- `taxon`    — display name of the taxonomic group (e.g. `"Eutherian mammal"`)
- `equation` — a `PowerLaw` or `MontgomeryLaw` constant, or a `NamedTuple`
               `(formula, ref)` for equations not reducible to a standard law
"""
struct AllometricEntry
    variable::String
    taxon::String
    equation  # PowerLaw | MontgomeryLaw | NamedTuple{(:formula,:ref)}
end

# ── Registry ──────────────────────────────────────────────────────────────────

"""
    ALLOMETRIC_REGISTRY :: Vector{AllometricEntry}

All allometric equations in the package.  Each entry references the underlying
equation constant (a [`PowerLaw`](@ref) or [`MontgomeryLaw`](@ref)), so changes
to any coefficient or citation propagate automatically to `?allometric` and any
other consumer of this registry.

Use `reference(power_law(variable, taxon))` to retrieve the full citation for a
standard power-law entry.
"""
const ALLOMETRIC_REGISTRY = AllometricEntry[
    # Metabolic rate
    AllometricEntry("Basal metabolic rate",    "Eutherian mammal",   _BMR_EUTHERIAN),
    AllometricEntry("Basal metabolic rate",    "Marsupial",          _BMR_MARSUPIAL),
    AllometricEntry("Basal metabolic rate",    "Non-passerine bird", _BMR_NONPASSERINE),
    AllometricEntry("Basal metabolic rate",    "Passerine bird",     _BMR_PASSERINE),
    AllometricEntry("Standard metabolic rate", "Squamate reptile",
        (formula = "0.013 × Mɡ^0.8 × 10^(0.038·T°C) × 20.1/3600",
         ref     = _SMR_SQUAMATE_REFERENCE)),
    AllometricEntry("Dark respiration",        "Plant",
        (formula = "4.6×10⁻⁴ × Mₖₘ × exp(−Eₐ/kT)  [Arrhenius]",
         ref     = _PLANT_DARK_RESP_REFERENCE)),
    # Morphology
    AllometricEntry("Surface area",  "Mammal",   _SA_MAMMAL),
    AllometricEntry("Skin area",     "Mammal",   _SKIN_AREA_MAMMAL),
    AllometricEntry("Skin area",     "Bird",     _SKIN_AREA_BIRD),
    AllometricEntry("Plumage area",  "Bird",     _PLUMAGE_AREA_BIRD),
    AllometricEntry("Skeleton mass", "Mammal",   _SKELETON_MAMMAL),
    AllometricEntry("Brain mass",    "Mammal",   _BRAIN_MAMMAL),
    AllometricEntry("Brain mass",    "Primate",  _BRAIN_PRIMATE),
    AllometricEntry("Brain mass",    "Human",    _BRAIN_HUMAN),
    # Locomotion
    AllometricEntry("Stride frequency",  "Mammal", _STRIDE_FREQ_MAMMAL),
    AllometricEntry("Cost of transport", "Mammal", _COT_MAMMAL),
    AllometricEntry("Cost of transport", "Bird",   _COT_BIRD),
    # Cardiorespiratory
    AllometricEntry("Heart rate",   "Mammal", _HEART_RATE_MAMMAL),
    AllometricEntry("Lung volume",  "Mammal", _LUNG_VOLUME_MAMMAL),
    AllometricEntry("Tidal volume", "Mammal", _TIDAL_VOLUME_MAMMAL),
    # Life history
    AllometricEntry("Lifespan",        "Mammal", _LIFESPAN_MAMMAL),
    AllometricEntry("Generation time", "Mammal", _GENERATION_TIME_MAMMAL),
    # Leaf morphology
    AllometricEntry("Leaf area",     "Broadleaf plant",  _MONTGOMERY_BROADLEAF),
    AllometricEntry("Leaf area",     "Bambusoideae",     _MONTGOMERY_BAMBUSOIDEAE),
    AllometricEntry("Leaf area",     "Liriodendron",     _MONTGOMERY_LIRIODENDRON),
    AllometricEntry("Leaf area",     "Rosaceae",         _MONTGOMERY_ROSACEAE),
    AllometricEntry("Leaf area",     "Lauraceae",        _MONTGOMERY_LAURACEAE),
    AllometricEntry("Leaf area",     "Oleaceae",         _MONTGOMERY_OLEACEAE),
    AllometricEntry("Leaf dry mass", "Broadleaf plant",  _LEAF_MASS_BROADLEAF),
]

# ── Table rendering (called once at module load to build docstrings) ───────────

_short_ref(ref::String) = (m = match(r"^(.+?\d{4})", ref); m === nothing ? ref : m[1])

_fmt(x) = string(round(x; sigdigits = 4))

function _equation_str(e::AllometricEntry)
    eq = e.equation
    if eq isa PowerLaw
        "$(_fmt(eq.coefficient)) × M^$(_fmt(eq.exponent))  [$(eq.input_unit) → $(eq.output_unit)]"
    elseif eq isa MontgomeryLaw
        "$(_fmt(eq.coefficient)) × L × W  [length × length → area]"
    else
        eq.formula
    end
end

function _ref_str(e::AllometricEntry)
    eq = e.equation
    _short_ref(eq isa NamedTuple ? eq.ref : reference(eq))
end

function _allometric_table_md()
    header = "| Variable | Taxon | Equation | Reference |"
    sep    = "|---|---|---|---|"
    rows   = ["| $(e.variable) | $(e.taxon) | $(_equation_str(e)) | $(_ref_str(e)) |"
              for e in ALLOMETRIC_REGISTRY]
    join([header, sep, rows...], "\n")
end

# ── Docstring for the allometric generic function ─────────────────────────────
# Interpolated at module load — the table is derived from ALLOMETRIC_REGISTRY,
# so it stays in sync automatically when equations are added or updated.

@doc """
    allometric(variable, taxon, inputs...) → Quantity

Predict a biological quantity from body mass, temperature, or morphological
dimensions using a taxon-specific allometric equation.  All inputs and outputs
are `Unitful` quantities; unit conversion is handled automatically.

`variable` and `taxon` are singleton instances of the types defined in
[`types.jl`](@ref) (e.g. `BasalMetabolicRate()`, `EutherianMammal()`).

## Available equations

$(_allometric_table_md())

Retrieve the full literature citation for any standard equation with
`reference(power_law(variable, taxon))` or
`reference(montgomery_law(variable, taxon))`.
See [`ALLOMETRIC_REGISTRY`](@ref) for programmatic access to this table.
""" allometric
