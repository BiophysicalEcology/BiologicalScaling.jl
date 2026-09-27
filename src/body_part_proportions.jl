# ── BodyPartProportions ────────────────────────────────────────────────────────

"""
    BodyPartProportions{T}

Proportionality relations decomposing a composite body into named parts.

Each field is a vector aligned with `part_names`. These fractions let you
derive body-part masses, reference surface areas, shape parameters, and
junction overlap areas from a single total-body mass — the same role that
`limb_aspect_ratio` plays for limb geometry, but for all parts of a
composite body.

## Fields
- `part_names`       — ordered `Symbol` names of the body parts
- `mass_fraction`    — fraction of total body mass in each part
- `area_fraction`    — fraction of total external surface area in each part
- `aspect_ratio`     — long-to-short-axis ratio of each part (shape parameter `b` for
                       `Cylinder`, `HalfCylinder`, or `Ellipsoid` constructors in BiophysicalGeometry)
- `junction_overlap` — fraction of each part's surface area that overlaps with
                       adjacent parts (used when assembling a `CompositeBody`)
- `reference`        — literature citation

## Usage

```julia
props = body_part_proportions(Human())
total_mass = 70.0u"kg"
mass_head  = props.mass_fraction[1] * total_mass   # 5.33 kg
# → Ellipsoid(mass_head, 1050u"kg/m^3", props.aspect_ratio[1])
```
"""
struct BodyPartProportions{T}
    part_names::Vector{Symbol}
    mass_fraction::Vector{T}
    area_fraction::Vector{T}
    aspect_ratio::Vector{T}
    junction_overlap::Vector{T}
    reference::String
end

"""
    body_part_proportions(taxon) → BodyPartProportions

Return the canonical body-part proportion relations for `taxon`.

Currently defined for [`Human`](@ref).
"""
function body_part_proportions end

# ── Human ─────────────────────────────────────────────────────────────────────
# Parts: head, trunk, arms (pair), legs (pair).
# Derived from NicheMapR HomoTherm.R and human_silhouette_area.R (Kearney).
# mass_fraction sums to ~0.802 (remaining mass is in hands, feet, neck, etc.).

"""
    HUMAN_BODY_PROPORTIONS :: BodyPartProportions

Body-part proportions of humans (head, trunk, arms and legs), returned by
[`body_part_proportions`](@ref)`(Human())`.
"""
const HUMAN_BODY_PROPORTIONS = BodyPartProportions(
    [:head, :trunk, :arms, :legs],
    [0.07609801, 0.50069348, 0.04932963, 0.16227462],
    [0.08291887, 0.32698460, 0.11025155, 0.18479669],
    [1.6,        1.9,        12.0,        7.0       ],
    [0.02666667, 0.08088128, 0.02000000,  0.03333333],
    "Kearney (NicheMapR HomoTherm.R / human_silhouette_area.R)"
)

body_part_proportions(::Human) = HUMAN_BODY_PROPORTIONS
