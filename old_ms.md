
# Introduction

Earth's ecosystems are subject to rapid change  due to both climate
and land-use change [@cite]. These sudden shifts in environment alter
both the spatial and temporal distribution of species.

Ecosystems are composed of interactions between species.


Main idea here: we have interaction information for some subset of the
species pool, and good SDMs for a different subset of the species
pool. There is some overlap in these species pools. How do we combine
this to predict: species interactions, uncertainty in interactions
(which as increases indicates better use of sampling time).

Species interactions and climate change.

Two dimensions: spatial and temporal.

1) Elevation gradients.
- range shifts in latitude context
- apply this to elevation gradients
- dispersal capacity and range shifts

2) Phenological and spatial uncoupling [@Olesen2011MisFor].
- Abundance is a function of time in the year

In this paper we.... combine data from a variety of sources: field
data from several sites, crowd-sourced data (GBIF), and remotely-sensed
data. to produce a _spatially and temporally explict_ metaweb of
bumblebee-flower interactions across Colorado. We then estimate the
change in spatial and temporal overlap over time using the CMIP6
climate consensus forecast [@Karger2017CliHig].


# Methods


![todo](./figures/concept_v2.png){#fig:concept}


## Data

This project involves assembly and integration of data from a variety
of (both structured and unstructured) sources.
This data can be divided into four categories: field data, GBIF data,
remote-sensing data, and phylogenetic data.

### Field data

The field data consists of: (1) a seven year data-set from Rocky
Mountain Biological Laboratory, consisting of season-long interaction
and phenology data six plots along an elevation gradient. (2) a
similar six year data set from Elk Meadows, CO, and (3) a year across
a large elevation gradient at Pikes Peak.

Additional in-situ environmental sensors.

The partitioning of this data into training, test, and validation sets
if described in the _Models_ section.

### GBIF data

The data from Global Biodiversity Information Facility (GBIF) itself
comes in two forms: (1) spatial records of bumblebee and flower
records (2) sparsely available records of the plants a bee was
observed on (TODO details from Julian).

### Remote-sensing data

The remote-sensing data consists of 15-arcsecond elevation
data[@GMTED2020, cite], and daily 1km resolution precipitation and
temperature from CHELSA [@Karger2021GloDai].

### Phylogenic data

The phylogenetic data consists of genomic barcodes available from NCBI
GenBank.


## A spatiotemporally explicit predictive metaweb model

What does it mean for it to be "spatiotemporally explicit?".
Well the formal definition of a metaweb is total species pool and

We denote the predicted probability of two species, $i$ and $j$,
interacting a $p_{ij}$. The outcome is here is to build a model $f$,
or rather a set of candidate models, that take $i$ and $j$ and inputs,
and which potentially combine this with .features

$$p_{ij} = f(i,j)$$


### Candidate models

***True Neutral***: $f(i,j) = \frac{1}{\sum_i \sum_j 1} = 1 / (P\cdot F)$

***Relative-abundance (interaction neutral)***: $f(i,j) = A_i A_j$
where $A_x$ is the relative abundance of species $x$.

***Relative-abundance + environment-embedding***: $f(i,j) = g(i,j, E_i, E_j)$

***Relative-abundance + phylogeny-embedding***: $$

***Relative-abundance + environment-embedding + phylogeny-embedding***

In gravel et al 2017
$$P(X_{iy}, X_{jy}, L_{ijy} | E_y) = P(X_{iy},X_{jy}P(L_{ijy} | X_{iy}, X_{jy}, E_y)$$
Then decompose probability of co-occurence as
$$P(X_{iy}, X_{jy}) = P(X_{iy})P(X_{jy})$$

## Model fitting and validation

Models are implemented and fitted in Julia v1.6, using Turing.jl [cite]

### Training-test-validation split scheme

How do this? Do we remove sites entirely? Years entirely?
Perhaps pikes peak would be best as a validation set as its only one
year anyway and is a larger elevation gradient.


# Results

After comparing different combinations of features/model structures and finding
the ‘best’ performing model on validation data.

## Figure one: spatial species pool and network prediction

Figure that is two panels: a map of total species richness and a map of network
properties across Colorado. This model doesn’t consider time, only other
predictors.

## Figure two: Phenology  

Same as figure one but consists of maps but at different times of the year (e.g.
March, June, August) and uses both an interaction-predictor and
distribution-predictor that incorporate time into predictions

##  Figure three: Climate  

Much as climate change has shifted temperature gradients to get warmer
toward the poles, it has also moved temperature gradients up in
elevation.

We can get a CMIP6 forecast of temperature and precipitation, and then
predict how many observed interactions in the field data will no
longer have their composing species’ distributions overlap. Decompose
temporal component of overlap from spatial component.


# Discussion

This predictive model should not be used as definitive prediction:
instead it reveals gaps in our sampling (where we have little
confidence  in predictions---see uncertainty figure).
Iterative forecasting [@Diteze]: use this model to guide sampling in
the future to validate and update the model, etc.


## Acknowledgements


# References
