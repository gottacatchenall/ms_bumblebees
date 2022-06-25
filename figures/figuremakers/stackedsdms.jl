using GeoJSON
using Downloads
using SimpleSDMLayers
using Shapefile
using Plots

counties = Downloads.download("https://raw.githubusercontent.com/earthlab/earthpy/main/earthpy/example-data/colorado-counties.geojson")
geo = GeoJSON.read(read(counties, String))

p0 = colorant"#e8e8e8"
bv_pal_1 = (p0=p0, p1=colorant"#64acbe", p2=colorant"#c85a5a")
bv_pal_2 = (p0=p0, p1=colorant"#73ae80", p2=colorant"#6c83b5")
bv_pal_3 = (p0=p0, p1=colorant"#9972af", p2=colorant"#c8b35a")
bv_pal_4 = (p0=p0, p1=colorant"#be64ac", p2=colorant"#5ac8c8")

beerichness = geotiff(SimpleSDMPredictor, joinpath("..", "data", "beerichness.tif"))
beeuncert = geotiff(SimpleSDMPredictor, joinpath("..", "data", "beeuncertainty.tif"))
plantrichness = geotiff(SimpleSDMPredictor, joinpath("..", "data", "plantrichness.tif"))
plantuncert = geotiff(SimpleSDMPredictor, joinpath("..", "data", "plantuncertainty.tif"))


beemax = max(beerichness.grid...)

co_shp = Shapefile.shapes(Shapefile.Table(joinpath("co/co.shp")))

beeplt = plot(beerichness; title="Bombus", leg=false, fc=:darkgrey, frame=:grid, xlab="Longitude", ylab="Latitude", xlim=(-109, -102), grid=false)
bivariate!(beerichness, beeuncert, classes=4, quantiles=false; bv_pal_1...)
p2 = bivariatelegend!(
    beerichness, beeuncert;
    bv_pal_1...,
    classes=4,
    inset=(1, bbox(0.0, 0.0, 0.27, 0.27, :center, :right)),
    subplot=2,
    xlab="Richness",
    ylab="Uncertainty",
    guidefontsize=10,
)

beeplt

plantplt = plot(plantrichness; title="Flowers", leg=false, c=:darkgrey, frame=:grid, xlab="Longitude", ylab="Latitude", grid=false)
plot!()
bivariate!(plantrichness, plantuncert, classes=4, quantiles=false; bv_pal_4...)
p2 = bivariatelegend!(
    plantrichness, plantuncert;
    bv_pal_4...,
    classes=4,
    inset=(1, bbox(0.0, 0.0, 0.27, 0.27, :center, :right)),
    subplot=2,
    xlab="Richness",
    ylab="Uncertainty",
    guidefontsize=10,
)

using Plots.PlotMeasures



plot(beeplt, plantplt, margin=5mm, dpi=300, size=(750, 1000), layout=(2,1))
savefig("../ssdms.png")