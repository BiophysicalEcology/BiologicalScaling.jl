# ── Registry entry ─────────────────────────────────────────────────────────────

"""
    ScalingEntry

An entry in the scaling equation registry, pairing a biological variable and
taxon with the underlying equation object.

## Fields
- `variable` — display name of the predicted quantity (e.g. `"Basal metabolic rate"`)
- `taxon`    — display name of the taxonomic group (e.g. `"Eutherian mammal"`)
- `equation` — a `PowerLaw` or `MontgomeryLaw` constant, or a `NamedTuple`
               `(formula, ref)` for equations not reducible to a standard law
"""
struct ScalingEntry
    variable::String
    taxon::String
    equation  # PowerLaw | MontgomeryLaw | NamedTuple{(:formula,:ref)}
end

# ── Registry ──────────────────────────────────────────────────────────────────

"""
    SCALING_REGISTRY :: Vector{ScalingEntry}

All scaling equations in the package.  Each entry references the underlying
equation constant (a [`PowerLaw`](@ref) or [`MontgomeryLaw`](@ref)), so changes
to any coefficient or citation propagate automatically to `?allometric` and any
other consumer of this registry.

Use `reference(power_law(variable, taxon))` to retrieve the full citation for a
standard power-law entry.
"""
const SCALING_REGISTRY = ScalingEntry[
    # Metabolic rate
    ScalingEntry("Basal metabolic rate",    "Eutherian mammal",   _BMR_EUTHERIAN),
    ScalingEntry("Basal metabolic rate",    "Marsupial",          _BMR_MARSUPIAL),
    ScalingEntry("Basal metabolic rate",    "Non-passerine bird", _BMR_NONPASSERINE),
    ScalingEntry("Basal metabolic rate",    "Passerine bird",     _BMR_PASSERINE),
    ScalingEntry("Standard metabolic rate", "Squamate reptile",
        (formula = "0.013 × Mɡ^0.8 × 10^(0.038·T°C) × 20.1/3600",
         ref     = _SMR_SQUAMATE_REFERENCE)),
    ScalingEntry("Dark respiration",        "Plant",
        (formula = "4.6×10⁻⁴ × Mₖₘ × exp(−Eₐ/kT)  [Arrhenius]",
         ref     = _PLANT_DARK_RESP_REFERENCE)),
    # Morphology
    ScalingEntry("Silhouette area (normal to sun)",   "Desert iguana", _SIL_NORMAL_DESERT_IGUANA),
    ScalingEntry("Silhouette area (parallel to sun)", "Desert iguana", _SIL_PARALLEL_DESERT_IGUANA),
    ScalingEntry("Silhouette area (normal to sun)",   "Leopard frog",  _SIL_NORMAL_LEOPARD_FROG),
    ScalingEntry("Ventral area",                      "Leopard frog",  _SIL_VENTRAL_LEOPARD_FROG),
    ScalingEntry("Surface area",  "Mammal",   _SA_MAMMAL),
    ScalingEntry("Skin area",     "Mammal",   _SKIN_AREA_MAMMAL),
    ScalingEntry("Skin area",     "Bird",     _SKIN_AREA_BIRD),
    ScalingEntry("Plumage area",  "Bird",     _PLUMAGE_AREA_BIRD),
    ScalingEntry("Skeleton mass", "Mammal",   _SKELETON_MAMMAL),
    ScalingEntry("Brain mass",    "Mammal",   _BRAIN_MAMMAL),
    ScalingEntry("Brain mass",    "Primate",  _BRAIN_PRIMATE),
    ScalingEntry("Brain mass",    "Human",    _BRAIN_HUMAN),
    # Locomotion
    ScalingEntry("Stride frequency",  "Mammal", _STRIDE_FREQ_MAMMAL),
    ScalingEntry("Cost of transport", "Mammal", _COT_MAMMAL),
    ScalingEntry("Cost of transport", "Bird",   _COT_BIRD),
    # Cardiorespiratory
    ScalingEntry("Heart rate",   "Mammal", _HEART_RATE_MAMMAL),
    ScalingEntry("Lung volume",  "Mammal", _LUNG_VOLUME_MAMMAL),
    ScalingEntry("Tidal volume", "Mammal", _TIDAL_VOLUME_MAMMAL),
    # Life history
    ScalingEntry("Lifespan",        "Mammal", _LIFESPAN_MAMMAL),
    ScalingEntry("Generation time", "Mammal", _GENERATION_TIME_MAMMAL),
    # Leaf morphology
    ScalingEntry("Leaf area",     "Broadleaf plant",  _MONTGOMERY_BROADLEAF),
    ScalingEntry("Leaf area",     "Bambusoideae",     _MONTGOMERY_BAMBUSOIDEAE),
    ScalingEntry("Leaf area",     "Liriodendron",     _MONTGOMERY_LIRIODENDRON),
    ScalingEntry("Leaf area",     "Rosaceae",         _MONTGOMERY_ROSACEAE),
    ScalingEntry("Leaf area",     "Lauraceae",        _MONTGOMERY_LAURACEAE),
    ScalingEntry("Leaf area",     "Oleaceae",         _MONTGOMERY_OLEACEAE),
    ScalingEntry("Leaf dry mass", "Broadleaf plant",  _LEAF_MASS_BROADLEAF),
]

# ── Table rendering (called once at module load to build docstrings) ───────────

_short_ref(ref::String) = (m = match(r"^(.+?\d{4})", ref); m === nothing ? ref : m[1])

_fmt(x) = string(round(x; sigdigits = 4))

function _equation_str(e::ScalingEntry)
    eq = e.equation
    if eq isa PowerLaw
        "$(_fmt(eq.coefficient)) × M^$(_fmt(eq.exponent))  [$(eq.input_unit) → $(eq.output_unit)]"
    elseif eq isa MontgomeryLaw
        "$(_fmt(eq.coefficient)) × L × W  [length × length → area]"
    else
        eq.formula
    end
end

function _ref_str(e::ScalingEntry)
    eq = e.equation
    _short_ref(eq isa NamedTuple ? eq.ref : reference(eq))
end

function _allometric_table_md()
    header = "| Variable | Taxon | Equation | Reference |"
    sep    = "|---|---|---|---|"
    rows   = ["| $(e.variable) | $(e.taxon) | $(_equation_str(e)) | $(_ref_str(e)) |"
              for e in SCALING_REGISTRY]
    join([header, sep, rows...], "\n")
end

# ── Docstring for the allometric generic function ─────────────────────────────
# Interpolated at module load — the table is derived from SCALING_REGISTRY,
# so it stays in sync automatically when equations are added or updated.

@doc """
    allometric(variable, taxon, inputs...) → Quantity

Predict a biological quantity from body mass, temperature, or morphological
dimensions using a taxon-specific allometric equation.  All inputs and outputs
are `Unitful` quantities; unit conversion is handled automatically.

`variable` and `taxon` are singleton instances of
subtypes of [`AbstractScalingVariable`](@ref) and [`AbstractTaxon`](@ref) (e.g. `BasalMetabolicRate()`, `EutherianMammal()`).

## Available equations

$(_allometric_table_md())

Retrieve the full literature citation for any standard equation with
`reference(power_law(variable, taxon))` or
`reference(montgomery_law(variable, taxon))`.
See [`SCALING_REGISTRY`](@ref) for programmatic access to this table.
""" allometric
