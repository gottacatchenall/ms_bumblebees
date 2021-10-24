
_title ideas_:
Forecasting the spatio-temporal uncoupling of bumblebee-flower interaction
networks

# Introduction

Species interactions and climate change.

Two dimensions: spatial and temporal.

1) Elevation gradients.
- dispersal capacity and range shifts

2) Phenological uncoupling [cite].
- Abundance is a function of time in the year

# Methods

## Data


## Models

We denote the predicted probability of two species, $i$ and $j$,
interacting a $p_{ij}$.
The outcome is here is to build a model $f$, or rather a set of candidate
models, that take $i$ and $j$ and inputs, and which potentially combine
this with .features

$$p_{ij} = f(i,j)$$


### Candidate models

***True Neutral***: $f(i,j) = \frac{1}{\sum_i \sum_j 1} = 1 / (P\cdot F)$

***Relative-abundance (interaction neutral)***: $f(i,j) = A_i A_j$
where $A_x$ is the relative abundance of species $x$.

***Relative-abundance + environment-embedding***: $f(i,j) = g(i,j, E_i, E_j)$

***Relative-abundance + phylogeny-embedding***: $$

***Relative-abundance + environment-embedding + phylogeny-embedding***



![todo](./figures/concept_v2.png){#fig:concept}

In gravel et al 2017
$$P(X_{iy}, X_{jy}, L_{ijy} | E_y) = P(X_{iy},X_{jy}P(L_{ijy} | X_{iy}, X_{jy}, E_y)$$
Then decompose probability of co-occurence as
$$P(X_{iy}, X_{jy}) = P(X_{iy})P(X_{jy})$$

## A predictive model to make spatially explicit network prediction

The goal is two have two predictive models: interaction-predictor model and a
distribution-predictor model (a la Strydom & Catchen et al. 2021, figure 2).

The interaction-predictor model, $f_i(s_i,s_j, \theta_i)$ predicts interaction based on
species-level features $(s_i, s_j)$, and is trained on the field-data.

These features could include Phylogeny (to be determined: how available are
genomes or trees for these species) Environment/Climate Traits (to be
determined: what trait data is available, how annoying is it to clean) Time
(only for the phenology model, see 3.2 and 3.3)

The distribution-predictor model, $f_s(s_i, \vec{x}, t)$ is trained on GBIF data to
predict the occurrence of species with features si at a location in space x, and
time t. Many options here. Here the species level features could be  Climatic
variables derived from remote sensing products. Co-occurence to make a JSDM
Potentially weighted by phenology information from field data.  Time (only for
the phenology model, see 3.2 and 3.3)

## Combining distribution-predictor and interaction-predictor models

Can split this into two based on how the distribution-predictor works. If $f_s$
predicts co-occurrence, then draw the species pool first and predict
interactions between the species in that pool. If $f_s$ is a single-species SDM,
get the occurrence probability for each species p_s and compute the probability
of observing interaction as function of the product of occ. prob.

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

Much as climate change has shifted temperature gradients to get warmer toward
the poles, it has also moved temperature gradients up in elevation.

We can get a CMIP6 forecast of temperature and precipitation, and then predict
how many observed interactions in the field data will no longer have their
composing species’ distributions overlap. Decompose temporal component of
overlap from spatial component.


# Discussion


## Acknowledgements


# References
