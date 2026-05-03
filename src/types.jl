# ── Taxon hierarchy ───────────────────────────────────────────────────────────
# Zero-field singleton structs. The type IS the taxonomic group.

"""
    AbstractTaxon

Root abstract type for taxonomic groups used to dispatch allometric equations.
"""
abstract type AbstractTaxon end

abstract type AbstractMammal    <: AbstractTaxon end
abstract type AbstractBird      <: AbstractTaxon end
abstract type AbstractReptile   <: AbstractTaxon end
abstract type AbstractAmphibian <: AbstractTaxon end
abstract type AbstractPlant     <: AbstractTaxon end

# Mammals
"Eutherian (placental) mammals."
struct EutherianMammal <: AbstractMammal end
"Marsupial mammals."
struct Marsupial       <: AbstractMammal end
"Non-human primates."
struct Primate         <: AbstractMammal end
"Humans."
struct Human           <: AbstractMammal end

# Birds
"Passerine (perching) birds."
struct PasserineBird    <: AbstractBird end
"Non-passerine birds."
struct NonPasserineBird <: AbstractBird end

# Reptiles
"Squamate reptiles (lizards and snakes)."
struct Squamate <: AbstractReptile end

# Amphibians
"Frogs and toads."
struct Anuran <: AbstractAmphibian end

# Plants
"C3 photosynthesis plants."
struct C3Plant <: AbstractPlant end

abstract type AbstractLeafPlant <: AbstractPlant end

"Generic broad-leaved plant (default Montgomery parameter)."
struct BroadleafPlant <: AbstractLeafPlant end
"Bamboos (Bambusoideae). Higher Montgomery parameter than most groups."
struct Bambusoideae   <: AbstractLeafPlant end
"Tulip trees (Liriodendron). Higher Montgomery parameter than most groups."
struct Liriodendron   <: AbstractLeafPlant end
"Rosaceae family."
struct Rosaceae       <: AbstractLeafPlant end
"Lauraceae family."
struct Lauraceae      <: AbstractLeafPlant end
"Oleaceae family."
struct Oleaceae       <: AbstractLeafPlant end

# ── Allometric variable hierarchy ─────────────────────────────────────────────
# Zero-field singleton structs. The type IS the biological quantity.

"""
    AbstractAllometricVariable

Root abstract type for biological quantities predictable via allometry.
"""
abstract type AbstractAllometricVariable end

abstract type AbstractMetabolicRate      <: AbstractAllometricVariable end
abstract type AbstractMorphology         <: AbstractAllometricVariable end
abstract type AbstractLocomotion         <: AbstractAllometricVariable end
abstract type AbstractCardioRespiratory  <: AbstractAllometricVariable end
abstract type AbstractLifeHistory        <: AbstractAllometricVariable end
abstract type AbstractLeafMorphology     <: AbstractAllometricVariable end

# Metabolic rate
"Basal (resting, fasted, thermoneutral) metabolic rate."
struct BasalMetabolicRate    <: AbstractMetabolicRate end
"Field (free-living) metabolic rate."
struct FieldMetabolicRate    <: AbstractMetabolicRate end
"Standard (fasted, inactive) metabolic rate — temperature-dependent; used for ectotherms."
struct StandardMetabolicRate <: AbstractMetabolicRate end

# Morphology
"Total external body surface area."
struct SurfaceArea  <: AbstractMorphology end
"Bare skin surface area (no insulation)."
struct SkinArea     <: AbstractMorphology end
"Outer plumage surface area (birds)."
struct PlumageArea  <: AbstractMorphology end
"Skeleton dry mass."
struct SkeletonMass <: AbstractMorphology end
"Brain mass."
struct BrainMass    <: AbstractMorphology end

# Locomotion
"Stride frequency at trot–gallop transition."
struct StrideFrequency <: AbstractLocomotion end
"Mass-specific energetic cost of transport."
struct CostOfTransport <: AbstractLocomotion end

# Cardiorespiratory
"Resting heart rate."
struct HeartRate   <: AbstractCardioRespiratory end
"Total lung volume."
struct LungVolume  <: AbstractCardioRespiratory end
"Tidal volume (volume per breath)."
struct TidalVolume <: AbstractCardioRespiratory end

# Life history
"Maximum lifespan."
struct Lifespan        <: AbstractLifeHistory end
"Generation time."
struct GenerationTime  <: AbstractLifeHistory end

# Leaf morphology
"Leaf lamina area, predicted via the Montgomery model: A = a₁ × L × W."
struct LeafArea    <: AbstractLeafMorphology end
"Leaf dry mass."
struct LeafDryMass <: AbstractLeafMorphology end

# ── trait_name: traits.build standardised names ───────────────────────────────

"""
    trait_name(variable::AbstractAllometricVariable) → String

Return the standardised trait name for use with traits.build databases.
"""
trait_name(::BasalMetabolicRate)    = "metabolic_rate_basal"
trait_name(::FieldMetabolicRate)    = "metabolic_rate_field"
trait_name(::StandardMetabolicRate) = "metabolic_rate_standard"
trait_name(::SurfaceArea)        = "body_surface_area"
trait_name(::SkinArea)           = "skin_area"
trait_name(::PlumageArea)        = "plumage_area"
trait_name(::SkeletonMass)       = "skeleton_mass"
trait_name(::BrainMass)          = "brain_mass"
trait_name(::StrideFrequency)    = "stride_frequency"
trait_name(::CostOfTransport)    = "cost_of_transport"
trait_name(::HeartRate)          = "heart_rate"
trait_name(::LungVolume)         = "lung_volume"
trait_name(::TidalVolume)        = "tidal_volume"
trait_name(::Lifespan)           = "lifespan_max"
trait_name(::GenerationTime)     = "generation_time"
trait_name(::LeafArea)           = "leaf_area"
trait_name(::LeafDryMass)        = "leaf_dry_mass"
