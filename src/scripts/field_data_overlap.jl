using CSV, DataFrames



"""
    Julians Metaweb
"""
ElkMeadowsInteractions = CSV.read(joinpath("rawdata", "ElkMeadowsBombus.csv"), DataFrame)

names(ElkMeadowsInteractions)
ElkMeadowsInteractions[!, "Ordinal day"]
ElkMeadowsInteractions[!, "Plot"]
ElkMeadowsInteractions[!, "Insect species name"]
ElkMeadowsInteractions[!, "Plant species name"]

# split into species/genus


unique(ElkMeadowsInteractions[!, "Plant species name"])
unique(ElkMeadowsInteractions[!, "Insect species name"])
# convert  Genus species -> genus_species


"""
    RMBL data
"""

RMBL_phenology = CSV.read(joinpath("rawdata", "caradonna_rmbl_flowering_phenology_data_EDI.csv"), DataFrame)
names(RMBL_phenology)

unique(RMBL_phenology[!, "plant"]) # 46

RMBL_interactions = CSV.read(joinpath("rawdata", "caradonna_rmbl_interaction_networks_data_EDI.csv"), DataFrame)
names(RMBL_interactions)




unique(RMBL_interactions[!, "plant"])
unique(RMBL_interactions[!, "pollinator"])


RMBL_interactions[!, "interactions"]
RMBL_interactions[!, "site"]
RMBL_interactions[!, "year"]
RMBL_interactions[!, "day_of_year"]
