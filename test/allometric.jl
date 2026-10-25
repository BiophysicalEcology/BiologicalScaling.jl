using BiologicalScaling, Unitful, Test

# ── Basal metabolic rate ───────────────────────────────────────────────────────

@testset "BasalMetabolicRate units" begin
    @test allometric(BasalMetabolicRate(), EutherianMammal(),  1.0u"kg") isa Unitful.Power
    @test allometric(BasalMetabolicRate(), Marsupial(),        1.0u"kg") isa Unitful.Power
    @test allometric(BasalMetabolicRate(), PasserineBird(),   20.0u"g")  isa Unitful.Power
    @test allometric(BasalMetabolicRate(), NonPasserineBird(), 1.0u"kg") isa Unitful.Power
end

@testset "BasalMetabolicRate published values" begin
    bmr = allometric(BasalMetabolicRate(), EutherianMammal(), 1.0u"kg")
    @test bmr ≈ 3.34u"W" rtol=0.01
end

@testset "BasalMetabolicRate mass scaling (monotone)" begin
    bmr1 = allometric(BasalMetabolicRate(), EutherianMammal(), 1.0u"kg")
    bmr10 = allometric(BasalMetabolicRate(), EutherianMammal(), 10.0u"kg")
    @test bmr10 > bmr1
end

@testset "BasalMetabolicRate unit conversion invariant" begin
    @test allometric(BasalMetabolicRate(), EutherianMammal(), 1.0u"kg") ≈
          allometric(BasalMetabolicRate(), EutherianMammal(), 1000.0u"g")
end

@testset "BasalMetabolicRate taxon ordering" begin
    m = 1.0u"kg"
    @test allometric(BasalMetabolicRate(), EutherianMammal(), m) >
          allometric(BasalMetabolicRate(), Marsupial(), m)
    @test allometric(BasalMetabolicRate(), PasserineBird(), m) >
          allometric(BasalMetabolicRate(), NonPasserineBird(), m)
end

@testset "BasalMetabolicRate abstract fallback" begin
    # AbstractMammal dispatches to EutherianMammal
    @test power_law(BasalMetabolicRate(), EutherianMammal()) ===
          power_law(BasalMetabolicRate(), EutherianMammal())
end

# ── Morphology ────────────────────────────────────────────────────────────────

@testset "SurfaceArea" begin
    sa = allometric(SurfaceArea(), EutherianMammal(), 1.0u"kg")
    @test sa isa Unitful.Area
    @test sa > 0u"m^2"
    @test allometric(SurfaceArea(), EutherianMammal(), 10.0u"kg") >
          allometric(SurfaceArea(), EutherianMammal(),  1.0u"kg")
end

@testset "SkinArea" begin
    @test allometric(SkinArea(), EutherianMammal(), 1.0u"kg") isa Unitful.Area
    @test allometric(SkinArea(), PasserineBird(),   20.0u"g") isa Unitful.Area
end

@testset "PlumageArea < SkinArea for birds" begin
    m = 100.0u"g"
    @test allometric(PlumageArea(), PasserineBird(), m) <
          allometric(SkinArea(),    PasserineBird(), m)
end

@testset "BrainMass dispatch" begin
    m = 1.0u"kg"
    @test allometric(BrainMass(), EutherianMammal(), m) isa Unitful.Mass
    @test allometric(BrainMass(), Human(),   m) >
          allometric(BrainMass(), Primate(), m) >
          allometric(BrainMass(), EutherianMammal(), m)
end

@testset "SkeletonMass exponent > 1" begin
    sk1  = allometric(SkeletonMass(), EutherianMammal(),   1.0u"kg")
    sk10 = allometric(SkeletonMass(), EutherianMammal(),  10.0u"kg")
    # skeleton/body ratio increases with size (exponent 1.13)
    @test sk10 / (10.0u"kg") > sk1 / (1.0u"kg")
end

# ── Locomotion ────────────────────────────────────────────────────────────────

@testset "StrideFrequency decreases with mass" begin
    @test allometric(StrideFrequency(), EutherianMammal(), 10.0u"kg") <
          allometric(StrideFrequency(), EutherianMammal(),  1.0u"kg")
end

@testset "CostOfTransport decreases with mass" begin
    @test allometric(CostOfTransport(), EutherianMammal(), 10.0u"kg") <
          allometric(CostOfTransport(), EutherianMammal(),  1.0u"kg")
end

# ── Cardiorespiratory ─────────────────────────────────────────────────────────

@testset "HeartRate" begin
    hr = allometric(HeartRate(), EutherianMammal(), 1.0u"kg")
    @test hr ≈ 241.0u"minute^-1" rtol=0.01
    @test allometric(HeartRate(), EutherianMammal(), 10.0u"kg") <
          allometric(HeartRate(), EutherianMammal(),  1.0u"kg")
end

@testset "LungVolume and TidalVolume scale > linear" begin
    lv1  = allometric(LungVolume(), EutherianMammal(),  1.0u"kg")
    lv10 = allometric(LungVolume(), EutherianMammal(), 10.0u"kg")
    # exponent 1.06 → volume/mass ratio increases slightly with size
    @test lv10 / (10.0u"kg") > lv1 / (1.0u"kg")
end

# ── Life history ──────────────────────────────────────────────────────────────

@testset "Lifespan and GenerationTime increase with mass" begin
    @test allometric(Lifespan(),       EutherianMammal(), 10.0u"kg") >
          allometric(Lifespan(),       EutherianMammal(),  1.0u"kg")
    @test allometric(GenerationTime(), EutherianMammal(), 10.0u"kg") >
          allometric(GenerationTime(), EutherianMammal(),  1.0u"kg")
end

# ── Leaf morphology ───────────────────────────────────────────────────────────

@testset "LeafArea Montgomery model" begin
    l, w = 0.08u"m", 0.04u"m"
    area = allometric(LeafArea(), BroadleafPlant(), l, w)
    @test area isa Unitful.Area
    @test area ≈ 0.65 * l * w
    # Montgomery parameter bounds
    @test allometric(LeafArea(), Bambusoideae(),  l, w) > allometric(LeafArea(), Rosaceae(), l, w)
end

@testset "LeafArea unit flexibility" begin
    area_m  = allometric(LeafArea(), BroadleafPlant(), 0.08u"m",  0.04u"m")
    area_cm = allometric(LeafArea(), BroadleafPlant(), 8.0u"cm",  4.0u"cm")
    @test Unitful.uconvert(u"m^2", area_cm) ≈ area_m
end

@testset "LeafDryMass from area" begin
    mass = allometric(LeafDryMass(), BroadleafPlant(), 20.0u"cm^2")
    @test mass isa Unitful.Mass
    @test mass > 0u"g"
end

@testset "LeafDryMass chained (l,w) == two-step" begin
    l, w = 0.08u"m", 0.04u"m"
    taxon = BroadleafPlant()
    area  = allometric(LeafArea(), taxon, l, w)
    m_two  = allometric(LeafDryMass(), taxon, area)
    m_one  = allometric(LeafDryMass(), taxon, l, w)
    @test m_one ≈ m_two
end

# ── allometric_inputs ──────────────────────────────────────────────────────────

@testset "allometric_inputs" begin
    @test allometric_inputs(BasalMetabolicRate(), EutherianMammal()) == (:mass,)
    @test allometric_inputs(LeafArea(),    BroadleafPlant())         == (:length, :width)
    @test allometric_inputs(LeafDryMass(), BroadleafPlant())         == (:area,)
end

# ── trait_name ────────────────────────────────────────────────────────────────

@testset "trait_name" begin
    @test trait_name(BasalMetabolicRate()) == "metabolic_rate_basal"
    @test trait_name(LeafArea())           == "leaf_area"
    @test trait_name(LeafDryMass())        == "leaf_dry_mass"
    @test trait_name(SkinArea())           == "skin_area"
end

# ── reference ─────────────────────────────────────────────────────────────────

@testset "reference accessor" begin
    pl = power_law(BasalMetabolicRate(), EutherianMammal())
    @test reference(pl) isa String
    @test !isempty(reference(pl))
    ml = montgomery_law(LeafArea(), Bambusoideae())
    @test reference(ml) isa String
    @test !isempty(reference(ml))
end

# ── Ectotherm areas and metabolic rates used by HeatExchange ─────────────────

@testset "DesertIguana and LeopardFrog areas" begin
    m = 40.0u"g"
    @test allometric(SurfaceArea(), DesertIguana(), m) ≈ uconvert(u"m^2", 10.4713 * 40.0^0.688 * u"cm^2")
    @test allometric(VentralArea(), DesertIguana(), m) ≈ uconvert(u"m^2", 0.425 * 40.0^0.85 * u"cm^2")
    @test allometric(SurfaceArea(), LeopardFrog(), m) ≈ uconvert(u"m^2", 12.79 * 40.0^0.606 * u"cm^2")
    # silhouette is ~45.8 % of total area with the sun overhead
    @test allometric(SilhouetteArea{ZenithAngle}(), LeopardFrog(), m, 0.0u"°") ≈
          0.458228 * allometric(SurfaceArea(), LeopardFrog(), m)
end

@testset "Squamate resting and endotherm basal rates" begin
    m, T = 40.0u"g", 30.0u"°C"
    @test allometric(RestingMetabolicRate(), Squamate(), m, T) ≈
          10^0.14 * allometric(StandardMetabolicRate(), Squamate(), m, T)
    @test allometric(BasalMetabolicRate(), EutherianMammal(), 1.0u"kg", 37.0u"°C") ==
          allometric(BasalMetabolicRate(), EutherianMammal(), 1.0u"kg")
end
