using DataFrames
using DataFramesMeta
using CSV
using Shapefile


using SimpleSDMLayers, GBIF, Plots


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


    plot(frame=:none, tickfont=4, xlim=(-109, -102), ylim=(37,41), size=(500,500))
    plot!(elev, c=:Greens_9, colorbar=:none)
    plot!(geoms, lc=:white, fa=0, lw=1)
    scatter!(
        longitudes(observations),
        latitudes(observations);
        lab="",
        c=:white,
        msc=:dodgerblue,
        ms=3,
        alpha=0.5,
    )
    title!(s.name)
end


bounds = (left=-109.6, right=-102.4, top=40.995, bottom=37.01 )

plts = []

for s in specieslist
    push!(plts, getplot(s))
end


getplot(specieslist[1])

plot(plts..., size=(2000,2000))

savefig("singleocc.png")