using Phylo
using Plots

ts = open(parsenewick, "cleandata/bee_consensus.tree")


plot(ts)

savefig("eltree.png")