"""
    PowerLaw{C,E,IU,OU}

Callable struct encoding a univariate power-law allometric relationship:
`y = coefficient × x^exponent`.

Unit handling is built in: call `(pl::PowerLaw)(x)` with any `Unitful` quantity
whose dimensions match `input_unit`, and receive a `Unitful` quantity in `output_unit`.

# Fields
- `coefficient` — multiplicative constant (plain number; units implicit in `output_unit`)
- `exponent`    — scaling exponent (dimensionless)
- `input_unit`  — `Unitful` unit expected for the independent variable (e.g. `u"kg"`)
- `output_unit` — `Unitful` unit of the returned quantity (e.g. `u"W"`)
- `reference`   — full citation string — **mandatory for all equation constants**

# Example
```julia
pl = PowerLaw(3.34, 0.75; input_unit=u"kg", output_unit=u"W",
              reference="Schmidt-Nielsen 1975 J. Exp. Zool. 194:287–307")
pl(1.0u"kg")     # → 3.34 W
pl(500.0u"g")    # → unit-converted automatically
```
"""
struct PowerLaw{C,E,IU,OU}
    coefficient::C
    exponent::E
    input_unit::IU
    output_unit::OU
    reference::String
end

function PowerLaw(coefficient, exponent;
                  input_unit   = u"kg",
                  output_unit  = u"W",
                  reference    = "")
    PowerLaw(coefficient, exponent, input_unit, output_unit, reference)
end

"""
    (pl::PowerLaw)(x) → Unitful quantity

Evaluate the power law at `x`, stripping and reattaching units automatically.
"""
(pl::PowerLaw)(x) = (pl.coefficient * ustrip(pl.input_unit, x)^pl.exponent) * pl.output_unit

"""
    reference(pl::PowerLaw) → String

Return the literature citation for this power-law equation.
"""
reference(pl::PowerLaw) = pl.reference
