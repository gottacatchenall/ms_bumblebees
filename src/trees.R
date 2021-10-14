
library(phytools)

setwd("/home/michael/papers/ms_bumblebees/src/")

df = read.csv("rawdata/bumblebee_interactions.csv")
names(df)

beetree = read.nexus("bee_consensus.tree")
planttree = read.nexus("clipped_consensus.tree")


df =read.csv("tmpmetaweb.csv")

df = df[!is.na(df$plant),]




dev.new(width = 15, height=12)


co = cophylo(planttree,beetree, rotate=FALSE)
plot(co)

