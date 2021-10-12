using DataFrames
using DataFramesMeta
using CSV
using Shapefile

# each row is a species and columns are range data, and list of counties 
GBIF_bee_occurrence = CSV.read(joinpath("rawdata", "bmbl.bee.csv"), DataFrame)

# each row is an interaction
GBIF_bee_flower_interactions = CSV.read(joinpath("rawdata", "bumblebee_interactions.csv"), DataFrame)
names(GBIF_bee_flower_interactions)



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



# okay 
# pull gbif occurences for each sp.
using SimpleSDMLayers, GBIF, Plots, Measures


speciesstrs =
["Bombus appositus", 
"Bombus auricomus",
"Bombus balteatus",
"Bombus bifarius",
"Bombus californicus",
"Bombus centralis",
"Bombus fernaldae",
"Bombus fervidus",
"Bombus flavifrons",
"Bombus fraternus",
"Bombus frigidus",
"Bombus griseocollis",
"Bombus huntii",
"Bombus insularis",
"Bombus melanopygus",
"Bombus mixtus",
"Bombus morrisoni",
"Bombus nevadensis",
"Bombus occidentalis",
"Bombus pensylvanicus",
"Bombus rufocinctus",
"Bombus suckleyi",
"Bombus sylvicola",
"Bombus variabilis"]

specieslist = GBIF.taxon.(speciesstrs)

function getplot(s)
    bounds = (left=-109.6, right=-102.4, top=40.995, bottom=37.01 )

    observations = occurrences(
        s, 
        "hasCoordinate" => "true",
        "country" => "US",
        "decimalLatitude" => (bounds.bottom, bounds.top),
        "decimalLongitude" => (bounds.left, bounds.right),
        "limit" => 10000
    )

    size(observations) <= 0 && return

    while length(observations) < size(observations)
        occurrences!(observations)
    end

    elev = convert(Float32, SimpleSDMPredictor(WorldClim, Elevation;  bounds...))

    path = joinpath("rawdata", "colorado_counties","Colorado_County_Boundaries.shp")
    table = Shapefile.Table(path)
    geoms = Shapefile.shapes(table)


    plot(frame=:none, tickfont=4, xlim=(-109, -102), ylim=(37,41), size=(300,300))
    plot!(elev, c=:Blues_9, colorbar=:none)
    plot!(geoms, lc=:white, fa=0, lw=1)
    scatter!(
        longitudes(observations),
        latitudes(observations);
        lab="",
        c=:white,
        msc=:orange,
        ms=3,
        alpha=0.5,
    )
    title!(s.name)
end



plts = []

for s in specieslist
    push!(plts, getplot(s))
end


plot(plts..., size=(2000,2000))

savefig("occurrence_and_elevation.png")