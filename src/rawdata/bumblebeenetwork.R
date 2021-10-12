# Bumblebee network project
# J. Resasco
setwd("/Users/julianresasco 1/Documents/Data/Bumblebee networks")

library(reshape2)
library(bipartite)
library(igraph)
library(vegan)

intr <- read.csv("bumblebee_interactions.csv")
plnt <- read.csv("plants.csv")
bmbe <- read.csv("bmbl.bee.csv")
elkb <- read.csv("ElkMeadowsBombus.csv")

head(intr)
head(plnt)
head(bmbe)
head(elkb)

# check data for slight variations of variable names
sort(unique(intr$plant.ackerfield))
sort(unique(intr$species.plant))
sort(unique(intr$bumblebee))

# remove species
intr <- subset(intr, intr$plant.ackerfield != "UNKNOWN SP UNKNOWN SP")
intr <- subset(intr, intr$plant.ackerfield != "NA NA")
intr <- subset(intr, intr$species.plant != "sp.")
dim(intr)
occ = rep(1, dim(intr)[1])
intr <- cbind(intr, occ)

# a useful function to make quantitative matrices binary
quant2bin<-function(matr)
{
    ij<-which(matr!=0,arr.ind=T)
    matrb<-matrix(0,dim(matr)[1],dim(matr)[2])
    matrb[ij]<-1
    return(matrb)
}

# build Colorado metaweb
# make long data into plant x pollinator matrix
comw <- acast(intr, plant.ackerfield~bumblebee, 
                value.var="occ", fun.aggregate = sum)

# plotweb visualization  
plotweb(comw, method="normal",arrow="both",bor.col.interaction="grey", y.width.low=0.02, y.width.high=0.02, col.high="tomato", col.low="yellow green", high.lablength=20, low.lablength=20, text.rot = 90)


# build subweb from a focal time and/or site 

# select focal county
county = "Boulder"

# select focal elevation for Elk Meadow
elevat.min = 9500
elevat.max = 10000

# select focal season
#season.min = 
#season.max = 

# subset plants to focal site and elevation
plant.sub <- subset(plnt, plnt$Boulder == 1)
plant.sub <- subset(plant.sub, plant.sub$high.limit.elev >= elevat.min)
plant.sub <- subset(plant.sub, plant.sub$low.limit.elev  <= elevat.max)
dim(plant.sub)

# subset bmbees to focal site and elevation
bmbee.sub <- subset(bmbe, bmbe$Boulder == 1)
bmbee.sub <- subset(bmbe, bmbee.sub$elevation.max.ft >= elevat.min)
bmbee.sub <- subset(bmbe, bmbee.sub$elevation.min.ft <= elevat.max)
dim(bmbee.sub)

rows = which(rownames(comw) %in% plant.sub$Ack.names)
cols = which(colnames(comw) %in% bmbee.sub$bmbl.bee)

subnet = comw[rows,cols]
dim(subnet)

# Plot web visualization  
plotweb(subnet, method="normal",arrow="both",bor.col.interaction="grey", 
        y.width.low=0.02, y.width.high=0.02, col.high="tomato", 
        col.low="yellow green", high.lablength=20, 
        low.lablength=20, text.rot = 90)

# empirical web for comparison
elkweb <- acast(elkb, Plant.species.name~Insect.species.name, 
              value.var="PA", fun.aggregate = sum)
plotweb(elkweb, method="normal",arrow="both",bor.col.interaction="grey", 
        y.width.low=0.02, y.width.high=0.02, col.high="tomato", 
        col.low="yellow green", high.lablength=20, 
        low.lablength=20, text.rot = 90)
colnames(elkweb)
colnames(subnet)

nestednodf(subnet)
nestednodf(elkweb)

networklevel(subnet, index = c("connectance", "NODF"))
networklevel(elkweb, index = c("connectance", "NODF"))

# how well sampled is the empirical web
# bumble bees
bbmat <- reshape2::acast(elkb, Sample~Insect.species.name, 
                         value.var="PA", fun.aggregate = sum)
total_rich_est <- specpool(bbmat)
as.numeric(total_rich_est[1]/total_rich_est[2]*100)

N <- colSums(bbmat) # total samples

# subsamples for rarefaction
subs <- c(seq(0,dim(bbmat)[1],by=10),sum(N))

# rarefaction (can be a bit slow)
rar <- rarefy(N,sample=subs,se=T,MARG=2)

# three panels for bumblebees, plant, and interactions
par(mfrow = c(1,3))
par(mar = c(2,5,2,2))
par(oma = c(2,4,2,2))
# Plot accumoutaion curve +/- 95% CIs 
plot(subs,rar[1,],ylab= "Bombus richness",
     xlab="Collected samples",type="l",ylim=c(0,20),xlim=c(0,300), 
     lwd = 3, las = 1, cex.axis = 1, cex.lab =1.5)
points(subs,(rar[1,]+2*rar[2,]),type="l")
points(subs,(rar[1,]-2*rar[2,]),type="l")

# bumble bees
plmat <- reshape2::acast(elkb, Sample~Plant.species.name, 
                         value.var="PA", fun.aggregate = sum)
total_rich_est <- specpool(plmat)
as.numeric(total_rich_est[1]/total_rich_est[2]*100)

N <- colSums(plmat) # total samples

# subsamples for rarefaction
subs <- c(seq(0,dim(plmat)[1],by=10),sum(N))

# rarefaction (can be a bit slow)
rar <- rarefy(N,sample=subs,se=T,MARG=2)

plot(subs,rar[1,],ylab= "Plant richness",
     xlab="Collected samples",type="l",ylim=c(0,40),xlim=c(0,300), 
     lwd = 3, las = 1, cex.axis = 1, cex.lab =1.5)
points(subs,(rar[1,]+2*rar[2,]),type="l")
points(subs,(rar[1,]-2*rar[2,]),type="l")


# interactions
inmat <- reshape2::acast(elkb, Sample~Interaction, 
                         value.var="PA", fun.aggregate = sum)
total_rich_est <- specpool(inmat)
as.numeric(total_rich_est[1]/total_rich_est[2]*100)

N <- colSums(inmat) # total samples

# subsamples for rarefaction
subs <- c(seq(0,dim(plmat)[1],by=10),sum(N))

# rarefaction (can be a bit slow)
rar <- rarefy(N,sample=subs,se=T,MARG=2)

plot(subs,rar[1,],ylab= "Interaction richness",
     xlab="Collected samples",type="l",ylim=c(0,70),xlim=c(0,300), 
     lwd = 3, las = 1, cex.axis = 1, cex.lab =1.5)
points(subs,(rar[1,]+2*rar[2,]),type="l")
points(subs,(rar[1,]-2*rar[2,]),type="l")

# bumblebee species data frame
bbeesp = c(colnames(elkweb), colnames(subnet))
pres = c(rep(1, dim(elkweb)[2]), 
         rep(1, dim(subnet)[2]))
site = c(rep("obs", dim(elkweb)[2]), 
                rep("pred", dim(subnet)[2]))
bbspdf <- data.frame(bbeesp,pres,site)

bbspmat <- reshape2::acast(bbspdf, site~bbeesp, 
                             value.var="pres", fun.aggregate = sum)

#species dissimilarity between database and observed in field
obsbbdis <- vegdist(bbspmat, method = "bray")

# confusion matrix
a = length(which(bbspmat[2,] == 1 & bbspmat[1,]== 1))
b = length(which(bbspmat[2,] == 1 & bbspmat[1,]== 0))
c = length(which(bbspmat[2,] == 0 & bbspmat[1,]== 1))
d = length(which(bbspmat[2,] == 0 & bbspmat[1,]== 0))
N = a+b+c+d

# False positive rate (errors of commission) b/(b + d)
fpr = b/(b + d)

# False negative rate (errors of omission) c/(a + c)
fnr = c/(a + c)

# Sensitivity (True positive rate) a/(a + c)
snr = a/(a + c)

# Specificity (True negative rate) d/(b + d)
tnr = d/(b + d)

# Correct classification rate
ccr = (a + d)/N


# plant species data frame
pltesp = c(rownames(elkweb), rownames(subnet))
pres = c(rep(1, dim(elkweb)[1]), 
         rep(1, dim(subnet)[1]))
op = c(rep("obs", dim(elkweb)[1]), 
         rep("pred", dim(subnet)[1]))
plspdf <- data.frame(pltesp,pres,op)

plspmat <- reshape2::acast(plspdf, op~pltesp, 
                           value.var="pres", fun.aggregate = sum)

#species dissimilarity between database and observed in field
obspldis <- vegdist(plspmat, method = "bray")

# confusion matrix
a = length(which(plspmat[2,] == 1 & plspmat[1,]== 1))
b = length(which(plspmat[2,] == 1 & plspmat[1,]== 0))
c = length(which(plspmat[2,] == 0 & plspmat[1,]== 1))
d = length(which(plspmat[2,] == 0 & plspmat[1,]== 0))
N = a+b+c+d

# False positive rate (errors of commission) b/(b + d)
fpr = b/(b + d)

# False negative rate (errors of omission) c/(a + c)
fnr = c/(a + c)

# Sensitivity (True positive rate) a/(a + c)
snr = a/(a + c)

# Specificity (True negative rate) d/(b + d)
tnr = d/(b + d)

# Correct classification rate
ccr = (a + d)/N



# FIX OBJECT NAMES
# interaction data frame
# Make subnet long
indf = as.data.frame(melt(subnet))
colnames(indf) = c("plant","bbee","num")
ixn = paste(indf$bbee,indf$plant,sep="-")


pltesp = c(unique(elkb$Interaction), unique(ixn))
pres = c(rep(1, length(unique(elkb$Interaction))), 
         rep(1, length(unique(ixn))))
op = c(rep("obs", length(unique(elkb$Interaction))), 
       rep("pred", length(unique(ixn))))
plspdf <- data.frame(pltesp,pres,op)

plspmat <- reshape2::acast(plspdf, op~pltesp, 
                           value.var="pres", fun.aggregate = sum)

#species dissimilarity between database and observed in field
obspldis <- vegdist(plspmat, method = "bray")

# confusion matrix
a = length(which(plspmat[2,] == 1 & plspmat[1,]== 1))
b = length(which(plspmat[2,] == 1 & plspmat[1,]== 0))
c = length(which(plspmat[2,] == 0 & plspmat[1,]== 1))
d = length(which(plspmat[2,] == 0 & plspmat[1,]== 0))
N = a+b+c+d

# False positive rate (errors of commission) b/(b + d)
fpr = b/(b + d)

# False negative rate (errors of omission) c/(a + c)
fnr = c/(a + c)

# Sensitivity (True positive rate) a/(a + c)
snr = a/(a + c)

# Specificity (True negative rate) d/(b + d)
tnr = d/(b + d)

# Correct classification rate
ccr = (a + d)/N

