library(ape)
library(ips)
library(phytools)

setwd("/home/michael/papers/ms_bumblebees/src")

read.tree("cleandata/CONSENSUS.nex")
tr = read.tree("cleandata/ee_consensus.tree")

plot(tr)
nodelabels(tr$edge.length)



setwd("/home/michael/papers/ms_bumblebees/src")

tr = ips::read("inprog_plants.nex")

plot(tr)
nodelabels(tr$edge.length)