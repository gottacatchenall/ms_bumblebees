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






ElkMeadowsInteractions = CSV.read(joinpath("rawdata", "ElkMeadowsBombus.csv"), DataFrame)

names(ElkMeadowsInteractions)
ElkMeadowsInteractions[!, "Ordinal day"]
ElkMeadowsInteractions[!, "Plot"]
ElkMeadowsInteractions[!, "Insect species name"]
ElkMeadowsInteractions[!, "Plant species name"]


RMBL_phenology = CSV.read(joinpath("rawdata", "caradonna_rmbl_flowering_phenology_data_EDI.csv"), DataFrame)
names(RMBL_phenology)
RMBL_phenology[!, "plant"]


RMBL_interactions = CSV.read(joinpath("rawdata", "caradonna_rmbl_interaction_networks_data_EDI.csv"), DataFrame)
names(RMBL_interactions)
RMBL_interactions[!, "plant"]
RMBL_interactions[!, "pollinator"]
RMBL_interactions[!, "interactions"]
RMBL_interactions[!, "site"]
RMBL_interactions[!, "year"]
RMBL_interactions[!, "day_of_year"]
