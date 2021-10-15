using DataFrames
using DataFramesMeta
using CSV
using Shapefile


using SimpleSDMLayers, GBIF, Plots

# each row is a species and columns are range data, and list of counties 
GBIF_bee_occurrence = CSV.read(joinpath("rawdata", "bmbl.bee.csv"), DataFrame)

# each row is an interaction
GBIF_bee_flower_interactions = CSV.read(joinpath("rawdata", "bumblebee_interactions.csv"), DataFrame)
names(GBIF_bee_flower_interactions)

df_to_write = DataFrame(bee=[], plant=[])

for row in 1:nrow(GBIF_bee_flower_interactions)
   thisrow = GBIF_bee_flower_interactions[row, :]
   bee, plant = thisrow["bumblebee"], thisrow["genus.plant"]

   push!(df_to_write.bee, bee)
   push!(df_to_write.plant, plant)
end

CSV.write( "tmpmetaweb.csv",df_to_write)

"""
    Get the names of plant species from GBIF metaweb and write them 
    to 'plantnames.csv'.

"""
plant_full_species_names = convert(Vector{String},unique(GBIF_bee_flower_interactions[!, "plant.ackerfield"]))
gbifplants = GBIF.taxon.(plant_full_species_names, strict=false)
filter!(!isnothing, gbifplants)
plantnames = DataFrame(species=[p.name for p in gbifplants])
CSV.write(joinpath("cleandata", "plantnames.csv"), plantnames)



"""
    Get the names of bee species from GBIF metaweb and write them 
    to 'beenames.csv'.

"""
bee_species_names = convert(Vector{String},unique(GBIF_bee_flower_interactions[!, "bumblebee"]))
gbifbees = GBIF.taxon.(bee_species_names)
filter!(!isnothing, gbifbees)
beenames = DataFrame(species=[p.name for p in gbifbees])
CSV.write(joinpath("cleandata", "beenames.csv"), beenames)
