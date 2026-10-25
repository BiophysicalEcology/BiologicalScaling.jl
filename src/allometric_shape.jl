"""
    AllometricShape(taxon, mass, density)

A BiophysicalGeometry shape whose surface and silhouette areas are allometries for `taxon`
(e.g. `DesertIguana()`, `LeopardFrog()`). Lengths for convection and conduction are those
of a cylinder with length L = 2D = 4R, so R = (V/4π)^(1/3).
"""
struct AllometricShape{T<:AbstractTaxon,M,D} <: AbstractShape
    taxon::T
    mass::M
    density::D
end

function BiophysicalGeometry.geometry(shape::AllometricShape, ::Naked)
    (; taxon, mass) = shape
    volume = BiophysicalGeometry.body_volume(shape)
    r_skin = cbrt(volume / 4π)
    total = allometric(SurfaceArea(), taxon, mass)
    return BiophysicalGeometry.Geometry(volume, (; r_skin), SurfaceAreas(; total, ventral = ventral_area(taxon, mass)))
end

ventral_area(taxon::DesertIguana, mass) = allometric(VentralArea(), taxon, mass)
ventral_area(::AbstractTaxon, mass) = nothing

silhouette_area(shape::AllometricShape, ::Naked, ::AbstractBody) =
    (; normal = silhouette_area(shape, NormalToSun()), parallel = silhouette_area(shape, ParallelToSun()))
silhouette_area(shape::AllometricShape{<:LeopardFrog}, ::Naked, ::AbstractBody, zenith_angle) =
    allometric(SilhouetteArea{ZenithAngleVarying}(), shape.taxon, shape.mass, zenith_angle)

silhouette_area(shape::AllometricShape, o::Union{NormalToSun,ParallelToSun}) =
    allometric(SilhouetteArea{typeof(o)}(), shape.taxon, shape.mass)
silhouette_area(shape::AllometricShape, ::Intermediate) =
    (silhouette_area(shape, NormalToSun()) + silhouette_area(shape, ParallelToSun())) / 2

BiophysicalGeometry._skin_radius(::AllometricShape, length) = length.r_skin
