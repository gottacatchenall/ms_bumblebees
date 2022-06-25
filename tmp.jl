using NeutralLandscapes
using Plots

sz = 80, 140
mpd(x) = rand(MidpointDisplacement(x), sz)

heatmap(mpd(0.6), c=:thermal, cbar=:none, aspectratio=1, frame=:none, axis=:none)

savefig("t+1.png")

pwd