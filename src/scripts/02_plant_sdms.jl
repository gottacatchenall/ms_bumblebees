bounds = (left=-109.6, right=-102.4, top=40.995, bottom=37.01 )

observations = []



function getplantplot(observations, nm)
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
    title!(nm)
end



for pl in gbifplants
    try
        occ= occurrences(
            pl, 
            "hasCoordinate" => "true",
            "country" => "US",
            "decimalLatitude" => (bounds.bottom, bounds.top),
            "decimalLongitude" => (bounds.left, bounds.right),
            "limit" => 300
        )

        push!(observations, occ)
    catch e
        @info "failed on $pl with $e"
    end
end

plantplts = []

for (i,obs) in enumerate(observations)
    push!(plantplts, getplantplot(obs, gbifplants[i].name))
end


plot(plantplts..., size=(5100,5100))

savefig("elplanto.png")
