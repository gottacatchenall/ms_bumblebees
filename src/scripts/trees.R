
library(phytools)

setwd("/home/michael/papers/ms_bumblebees/src")

read.tree("cleandata/CONSENSUS.nex")
tr = read.tree("cleandata/ee_consensus.tree")

plot(tr)
nodelabels(tr$edge.length)



setwd("/home/michael/papers/ms_bumblebees/src")

tr = read.nexus("plants_con.tree")
cliptr = read.nexus("clipped_consensus_tree_plants.tree")



plot(tr, use.edge.length=FALSE)

plot(cliptr)
