using CSV, DataFrames
using SimpleSDMLayers, GBIF, Plots

bounds = (left=-109.6, right=-102.4, top=40.995, bottom=37.01)

beespecies = convert(Vector{String},
    vec(CSV.read(joinpath("cleandata", "beenames.csv"), 
        DataFrame).species)
)

plants = convert(Vector{String},vec(CSV.read(joinpath("cleandata", "plantnames.csv"), DataFrame).species))

planttaxa = GBIF.taxon.(plants, strict=false)
beetaxa = GBIF.taxon.(beespecies)
elev = convert(Float32, geotiff(SimpleSDMPredictor, joinpath("cleandata", "co_elev.tif")))


spname(str) = string(split(str, " ")[1], "_", split(str," ")[2]) 

function write_occurrence_tifs(taxalist, speciesnames, dirname)
    for (i,tx) in enumerate(taxalist)
        try 
            observations = occurrences(
                tx, 
                "hasCoordinate" => "true",
                "country" => "US",
                "decimalLatitude" => (bounds.bottom, bounds.top),
                "decimalLongitude" => (bounds.left, bounds.right),
                "limit" => 10000
            )

            while length(observations) < size(observations)
                occurrences!(observations)
            end

            presences = mask(elev, observations, Int32)

            geotiff("cleandata/$dirname/$(spname(speciesnames[i])).tif", presences)
        catch 
            @info "failed with $tx"
        end
    end 

end

write_occurrence_tifs(planttaxa, plants, "plant_occurrence")



layers = SimpleSDMPredictor(CHELSA, BioClim, 1:19; bounds...);


for (i,envlayer) in enumerate(layers)
    geotiff("cleandata/env_layers/$i.tif", envlayer)
end 