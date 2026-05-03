# ── Montgomery law constants ──────────────────────────────────────────────────
# Leaf area: A = a₁ × L × W  (Montgomery 1911)
# Montgomery parameter a₁ values from Shi et al. 2019, pooled data per family.

"""
    _MONTGOMERY_BROADLEAF

Generic broad-leaved plant Montgomery parameter: a₁ = 0.65.
Midpoint of the empirical range 0.57–0.74 observed across six plant groups.

Source: Shi, P., Liu, M., Ratkowsky, D. A., et al. (2019). Leaf area–length allometry
and its implications in leaf shape evolution. *Trees* 33:1073–1085.
DOI: 10.1007/s00468-019-01843-4.
"""
const _MONTGOMERY_BROADLEAF = MontgomeryLaw(
    0.65;
    reference = "Shi et al. 2019 Trees 33:1073–1085 (pooled range 0.57–0.74)"
)

"""
    _MONTGOMERY_BAMBUSOIDEAE

Bambusoideae (bamboos) Montgomery parameter: a₁ = 0.74.
Significantly higher than most other plant groups.

Source: Shi, P., Liu, M., Ratkowsky, D. A., et al. (2019). Leaf area–length allometry
and its implications in leaf shape evolution. *Trees* 33:1073–1085, Fig. 8.
"""
const _MONTGOMERY_BAMBUSOIDEAE = MontgomeryLaw(
    0.74;
    reference = "Shi et al. 2019 Trees 33:1073–1085, Fig. 8 (Bambusoideae)"
)

"""
    _MONTGOMERY_LIRIODENDRON

Liriodendron (tulip trees) Montgomery parameter: a₁ = 0.73.
Significantly higher than most other plant groups.

Source: Shi, P., Liu, M., Ratkowsky, D. A., et al. (2019). Leaf area–length allometry
and its implications in leaf shape evolution. *Trees* 33:1073–1085, Fig. 8.
"""
const _MONTGOMERY_LIRIODENDRON = MontgomeryLaw(
    0.73;
    reference = "Shi et al. 2019 Trees 33:1073–1085, Fig. 8 (Liriodendron)"
)

"""
    _MONTGOMERY_ROSACEAE

Rosaceae Montgomery parameter: a₁ = 0.62.

Source: Shi, P., Liu, M., Ratkowsky, D. A., et al. (2019). Leaf area–length allometry
and its implications in leaf shape evolution. *Trees* 33:1073–1085, Fig. 8.
"""
const _MONTGOMERY_ROSACEAE = MontgomeryLaw(
    0.62;
    reference = "Shi et al. 2019 Trees 33:1073–1085, Fig. 8 (Rosaceae)"
)

"""
    _MONTGOMERY_LAURACEAE

Lauraceae Montgomery parameter: a₁ = 0.67.

Source: Shi, P., Liu, M., Ratkowsky, D. A., et al. (2019). Leaf area–length allometry
and its implications in leaf shape evolution. *Trees* 33:1073–1085, Fig. 8.
"""
const _MONTGOMERY_LAURACEAE = MontgomeryLaw(
    0.67;
    reference = "Shi et al. 2019 Trees 33:1073–1085, Fig. 8 (Lauraceae)"
)

"""
    _MONTGOMERY_OLEACEAE

Oleaceae Montgomery parameter: a₁ = 0.70.

Source: Shi, P., Liu, M., Ratkowsky, D. A., et al. (2019). Leaf area–length allometry
and its implications in leaf shape evolution. *Trees* 33:1073–1085, Fig. 8.
"""
const _MONTGOMERY_OLEACEAE = MontgomeryLaw(
    0.70;
    reference = "Shi et al. 2019 Trees 33:1073–1085, Fig. 8 (Oleaceae)"
)

# ── Leaf dry mass from area ────────────────────────────────────────────────────

"""
    _LEAF_MASS_BROADLEAF

Leaf dry mass from leaf area: M_leaf = 0.01 × A^1.10 g (A in cm²).
The exponent deviates from the geometric prediction of 1.5, reflecting that leaf
thickness decreases with leaf size.

Source: Milla, R., & Reich, P. B. (2007). The scaling of leaf area and mass: the cost of
light interception increases with leaf size. *Proceedings of the Royal Society B*
274:2403–2410. Mean exponent over >150 species = 1.10 (95% CI: 1.08–1.13).
"""
const _LEAF_MASS_BROADLEAF = PowerLaw(
    0.01, 1.10;
    input_unit  = u"cm^2",
    output_unit = u"g",
    reference   = "Milla & Reich 2007 Proc. R. Soc. B 274:2403–2410 (mean exponent 1.10)"
)

# ── allometric dispatch ────────────────────────────────────────────────────────

"""
    allometric(::LeafArea, taxon, length, width) → Area

Predict leaf lamina area using the Montgomery model: A = a₁ × L × W.

`length` and `width` must be `Unitful` lengths (m, cm, mm, etc.).
The returned area carries the product unit.

# Examples
```julia
allometric(LeafArea(), BroadleafPlant(),  0.08u"m", 0.04u"m")    # → 0.00208 m²
allometric(LeafArea(), Bambusoideae(),    12.0u"cm", 1.5u"cm")   # → 1.332 cm²
allometric(LeafArea(), Liriodendron(),    10.0u"cm", 8.0u"cm")   # → 58.4 cm²
```
"""
allometric(::LeafArea, ::BroadleafPlant,   l, w) = _MONTGOMERY_BROADLEAF(l, w)
allometric(::LeafArea, ::Bambusoideae,     l, w) = _MONTGOMERY_BAMBUSOIDEAE(l, w)
allometric(::LeafArea, ::Liriodendron,     l, w) = _MONTGOMERY_LIRIODENDRON(l, w)
allometric(::LeafArea, ::Rosaceae,         l, w) = _MONTGOMERY_ROSACEAE(l, w)
allometric(::LeafArea, ::Lauraceae,        l, w) = _MONTGOMERY_LAURACEAE(l, w)
allometric(::LeafArea, ::Oleaceae,         l, w) = _MONTGOMERY_OLEACEAE(l, w)
allometric(::LeafArea, ::AbstractLeafPlant, l, w) = _MONTGOMERY_BROADLEAF(l, w)

"""
    allometric(::LeafDryMass, taxon, area) → Mass (g)

Predict leaf dry mass from leaf area using the Milla & Reich (2007) power law.

# Example
```julia
allometric(LeafDryMass(), BroadleafPlant(), 20.0u"cm^2")   # → ~0.14 g
```
"""
allometric(::LeafDryMass, ::AbstractLeafPlant, area::Unitful.Area) = _LEAF_MASS_BROADLEAF(area)

"""
    allometric(::LeafDryMass, taxon, length, width) → Mass (g)

Convenience: predict leaf dry mass from length and width by chaining the Montgomery
model and the Milla & Reich leaf mass–area relationship.
"""
function allometric(v::LeafDryMass, taxon::AbstractLeafPlant,
                    l::Unitful.Length, w::Unitful.Length)
    area = allometric(LeafArea(), taxon, l, w)
    allometric(v, taxon, area)
end

# ── montgomery_law accessors ───────────────────────────────────────────────────

"""
    montgomery_law(::LeafArea, taxon) → MontgomeryLaw

Return the underlying `MontgomeryLaw` for the given taxon.
"""
montgomery_law(::LeafArea, ::BroadleafPlant)    = _MONTGOMERY_BROADLEAF
montgomery_law(::LeafArea, ::Bambusoideae)      = _MONTGOMERY_BAMBUSOIDEAE
montgomery_law(::LeafArea, ::Liriodendron)      = _MONTGOMERY_LIRIODENDRON
montgomery_law(::LeafArea, ::Rosaceae)          = _MONTGOMERY_ROSACEAE
montgomery_law(::LeafArea, ::Lauraceae)         = _MONTGOMERY_LAURACEAE
montgomery_law(::LeafArea, ::Oleaceae)          = _MONTGOMERY_OLEACEAE
montgomery_law(::LeafArea, ::AbstractLeafPlant) = _MONTGOMERY_BROADLEAF

power_law(::LeafDryMass, ::AbstractLeafPlant)   = _LEAF_MASS_BROADLEAF

# ── allometric_inputs ──────────────────────────────────────────────────────────

allometric_inputs(::LeafArea,    ::AbstractLeafPlant) = (:length, :width)
allometric_inputs(::LeafDryMass, ::AbstractLeafPlant) = (:area,)

# ── Named convenience wrappers ─────────────────────────────────────────────────

leaf_area(taxon, length, width)     = allometric(LeafArea(),    taxon, length, width)
leaf_dry_mass(taxon, area)          = allometric(LeafDryMass(), taxon, area)
leaf_dry_mass(taxon, length, width) = allometric(LeafDryMass(), taxon, length, width)
