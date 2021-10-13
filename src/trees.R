library(ape)
library(ips)
library(phytools)

setwd("/home/michael/papers/ms_bumblebees/src")


tr = read.tree("cleandata/bee_consensus.tree")

plot(tr)
nodelabels(tr)

