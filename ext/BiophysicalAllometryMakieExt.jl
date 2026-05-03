module BiophysicalAllometryMakieExt

using Makie
using Unitful
using BiophysicalAllometry

import BiophysicalAllometry:
    allometric_scaling, allometric_scaling!,
    structural_constraints, structural_constraints!,
    plot_allometric_scaling, plot_structural_constraints

# ── Helpers ───────────────────────────────────────────────────────────────────

function _ylabel(v::AbstractAllometricVariable)
    v isa BasalMetabolicRate  && return "Basal metabolic rate (W)"
    v isa FieldMetabolicRate  && return "Field metabolic rate (W)"
    v isa SurfaceArea         && return "Surface area (m²)"
    v isa SkinArea            && return "Skin area (cm²)"
    v isa PlumageArea         && return "Plumage area (cm²)"
    v isa SkeletonMass        && return "Skeleton mass (kg)"
    v isa BrainMass           && return "Brain mass (kg)"
    v isa StrideFrequency     && return "Stride frequency (Hz)"
    v isa CostOfTransport     && return "Cost of transport (J kg⁻¹ m⁻¹)"
    v isa HeartRate           && return "Heart rate (min⁻¹)"
    v isa LungVolume          && return "Lung volume (mL)"
    v isa TidalVolume         && return "Tidal volume (mL)"
    v isa Lifespan            && return "Lifespan (yr)"
    v isa GenerationTime      && return "Generation time (yr)"
    return "Value"
end

_linestyle(::ElasticSimilarity)   = :solid
_linestyle(::GeometricSimilarity) = :dash
_linestyle(::DynamicSimilarity)   = :dot

# ── allometric_scaling! ───────────────────────────────────────────────────────
#
# Plots allometric scaling lines (and optional observed data) into an existing
# Axis.  `pairs` is a Vector of `(taxon, label, color)` 3-tuples.
# `data_points` (optional) is a Vector of `(mass, value, label)` 3-tuples;
# the first observed point receives the "Observed" legend label and each point
# gets a text annotation (pass "" to suppress).

function allometric_scaling!(
        ax::Makie.AbstractAxis,
        variable::AbstractAllometricVariable,
        pairs;
        mass_range  = [0.001u"kg", 1000.0u"kg"],
        n_points    = 200,
        data_points = nothing)

    m_lo   = ustrip(u"kg", mass_range[1])
    m_hi   = ustrip(u"kg", mass_range[2])
    masses = 10 .^ range(log10(m_lo), log10(m_hi); length = n_points)

    for (taxon, label, color) in pairs
        pl = power_law(variable, taxon)
        ys = [ustrip(pl(m * u"kg")) for m in masses]
        lines!(ax, masses, ys; color = color, linewidth = 2, label = label)
        mid = n_points ÷ 2
        text!(ax, masses[mid], ys[mid];
              text    = " α = $(round(pl.exponent; digits = 3))",
              fontsize = 9,
              color   = color,
              align   = (:left, :bottom))
    end

    if !isnothing(data_points)
        for (i, (m, v, lbl)) in enumerate(data_points)
            mx = ustrip(u"kg", m)
            vy = ustrip(v)
            # Only the first point gets a legend label; omitting `label` entirely
            # for the rest prevents spurious blank legend entries.
            kw = i == 1 ?
                (; color=:black, markersize=7, strokewidth=0.5, strokecolor=:white, label="Observed") :
                (; color=:black, markersize=7, strokewidth=0.5, strokecolor=:white)
            scatter!(ax, [mx], [vy]; kw...)
            isempty(lbl) || text!(ax, mx, vy;
                                   text    = "  $lbl",
                                   fontsize = 8,
                                   color   = :black,
                                   align   = (:left, :center))
        end
    end

    return ax
end

# Overload for Figure / GridPosition: create an Axis, then delegate.
function allometric_scaling(
        gp::Union{Makie.Figure, Makie.GridPosition, Makie.GridSubposition},
        variable::AbstractAllometricVariable,
        pairs;
        axis = NamedTuple(),
        kwargs...)
    ax = Axis(gp;
              xscale             = log10,
              yscale             = log10,
              xlabel             = "Body mass (kg)",
              ylabel             = _ylabel(variable),
              xminorticksvisible = true,
              yminorticksvisible = true,
              axis...)
    allometric_scaling!(ax, variable, pairs; kwargs...)
    return ax
end

# ── structural_constraints! ───────────────────────────────────────────────────
#
# Plots limb dimension predictions into an existing Axis.
# `pairs` is a Vector of `(similarity, label, color)` 3-tuples.

function structural_constraints!(
        ax::Makie.AbstractAxis,
        pairs;
        mass_range = [0.01u"kg", 10_000.0u"kg"],
        target     = :diameter,
        n_points   = 200)

    m_lo   = ustrip(u"kg", mass_range[1])
    m_hi   = ustrip(u"kg", mass_range[2])
    masses = 10 .^ range(log10(m_lo), log10(m_hi); length = n_points)
    fn     = target === :diameter ? limb_diameter : limb_length

    for (sim, label, color) in pairs
        ys = [ustrip(u"m", fn(sim, m * u"kg")) for m in masses]
        lines!(ax, masses, ys;
               color     = color,
               linewidth  = 2,
               linestyle  = _linestyle(sim),
               label      = label)
    end

    return ax
end

function structural_constraints(
        gp::Union{Makie.Figure, Makie.GridPosition, Makie.GridSubposition},
        pairs;
        target = :diameter,
        axis   = NamedTuple(),
        kwargs...)
    ylabel = target === :diameter ? "Limb diameter (m)" : "Limb length (m)"
    ax = Axis(gp;
              xscale             = log10,
              yscale             = log10,
              xlabel             = "Body mass (kg)",
              ylabel             = ylabel,
              xminorticksvisible = true,
              yminorticksvisible = true,
              axis...)
    structural_constraints!(ax, pairs; target = target, kwargs...)
    return ax
end

# ── Convenience wrappers (create a complete Figure) ───────────────────────────

function plot_allometric_scaling(
        variable,
        pairs;
        mass_range  = [0.001u"kg", 1000.0u"kg"],
        n_points    = 200,
        data_points = nothing)

    fig = Figure(size = (680, 480), backgroundcolor = :white)
    ax  = allometric_scaling(fig[1, 1], variable, pairs;
                              mass_range  = mass_range,
                              n_points    = n_points,
                              data_points = data_points)
    ax.title = "Allometric scaling: $(nameof(typeof(variable)))"
    axislegend(ax; position = :rb, framevisible = false)
    return fig
end

function plot_structural_constraints(
        pairs;
        mass_range = [0.01u"kg", 10_000.0u"kg"],
        target     = :diameter,
        n_points   = 200)

    fig = Figure(size = (680, 480), backgroundcolor = :white)
    ax  = structural_constraints(fig[1, 1], pairs;
                                  mass_range = mass_range,
                                  target     = target,
                                  n_points   = n_points)
    ax.title = "Structural constraint comparison"
    axislegend(ax; position = :rb, framevisible = false)
    return fig
end

end # module BiophysicalAllometryMakieExt
