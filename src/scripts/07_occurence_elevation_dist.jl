using DataFrames
using DataFramesMeta
using CSV
using Shapefile


using SimpleSDMLayers, GBIF, Plots

bounds = (left=-109.6, right=-102.4, top=40.995, bottom=37.01 )


beespecies = convert(Vector{String},
    vec(CSV.read(joinpath("cleandata", "beenames.csv"), 
        DataFrame).species)
)

beetaxa = GBIF.taxon.(beespecies)

elev = convert(Float32, SimpleSDMPredictor(WorldClim, Elevation;  bounds...))

pollinatorelevlist = []


for tx in beetaxa
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

        presences = mask(elev, observations, Bool)
        thiselevlist  = convert(Vector{Float32}, elev[keys(presences)])

        pollinatorelevlist = vcat(pollinatorelevlist, thiselevlist)
    catch 
        @info "failed with $tx"
    end
end 


pollplt = histogram(pollinatorelevlist, ylim=(0,3000), xlim=(1000, 3500), c=:orange, title="Pollinator GBIF occurrence records", label="GBIF obs", fa=0.3, frame=:box, legend=:outerright)
xlabel!("elevation")
ylabel!("count")

plot!([2500, 3500], [1500, 1500], c=:forestgreen, ribbon=100, label="RMBL")
plot!([2900, 3500], [2000, 2000], c=:dodgerblue, ribbon=100, label="Niwot")
plot!([2600, 3500], [2500, 2500], c=:red, ribbon=100, label="Pikes Peak base to summit")
 

savefig("elevs.png")



# now the plants


plantspecies = convert(Vector{String},
    vec(CSV.read(joinpath("cleandata", "plantnames.csv"), 
        DataFrame).species)
)
planttaxa = GBIF.taxon.(plantspecies, strict=false)


plantelevlist = []


for tx in planttaxa
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

        presences = mask(elev, observations, Bool)
        thiselevlist  = convert(Vector{Float32}, elev[keys(presences)])

        plantelevlist = vcat(plantelevlist, thiselevlist)
    catch 
        @info "failed with $tx"
    end
end 


plantplt = histogram(plantelevlist, title="Plant GBIF occurrence records", xlim=(1000, 3500), c=:purple, label="GBIF obs", fa=0.3, frame=:box, legend=:outerright)
xlabel!("elevation")
ylabel!("count")

plot!([2500, 3500], [7500, 7500], c=:forestgreen, ribbon=300, label="RMBL")
plot!([2900, 3500], [8500, 8500], c=:dodgerblue, ribbon=300, label="Niwot")
plot!([2600, 3500], [9500, 9500], c=:red, ribbon=300, label="Pikes Peak base to summit")
 

using Unitful: mm
plot(plantplt, pollplt, layout=(2,1), padding=50mm, size=(700,500))

savefig("elevation_overlap.png")