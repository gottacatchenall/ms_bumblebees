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
using SimpleSDMLayers, GBIF, Plots

bounds = (left=-109.6, right=-102.4, top=40.995, bottom=37.01 )

specieslist = ["Bombus appositus", "Bombus auricomus",
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

observations = occurrences(
    GBIF.taxon(specieslist[3]; strict=true),
    "hasCoordinate" => "true",
    "country" => "US",
    "decimalLatitude" => (bounds.bottom, bounds.top),
    "decimalLongitude" => (bounds.left, bounds.right),
    "limit" => 10000,
)

while length(observations) < size(observations)
    occurrences!(observations)
end

temperature, precipitation = SimpleSDMPredictor(CHELSA,BioClim, [1, 12]; bounds...)

presabs = mask(temperature, observations, Float32)


path = joinpath("rawdata", "colorado_counties","Colorado_County_Boundaries.shp")
table = Shapefile.Table(path)
geoms = Shapefile.shapes(table)


plot(frame=:box, tickfont=4, xlim=(-109, -102), ylim=(37,41))
plot!(elev, c=:imola)
plot!(geoms, lc=:white, fa=0, lw=0.8, la=0.8)
scatter!(
    longitudes(observations),
    latitudes(observations);
    lab="",
    c=:white,
    msc=:orange,
    ms=3,
    alpha=0.5,
)


predictors =
    convert.(
        Float32, SimpleSDMPredictor(WorldClim, BioClim, 1:19; resolution=10.0, bounds...)
    );

push!(
    predictors,
    convert(
        Float32, SimpleSDMPredictor(WorldClim, Elevation; resolution=10.0, bounds...)
    ),
);

plot(plot.(predictors, grid=:none, axes=false, frame=:none, leg=false, c=:imola)...)

elev = convert(Float32, SimpleSDMPredictor(WorldClim, Elevation;  bounds...))


