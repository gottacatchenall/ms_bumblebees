## Abstract

Using a data set of [DESCRIBE EACH DATASET IN A NICE WAY], we predict
a spatiotemporally explicit metaweb of interactions between bumblebees
(_Bombus_) and wildflowers (within _find clade_). We integrate this
data with crowdsourced occurrence data and climate data to [best paint
the picture of the Colorado bumblebee-plant metaweb]. Using temporal
climate data, we forecast how the spatiotemporal overlap of
interacting species will change under proposed climate scenarios. We
use this to estimate what interactions between bees and plants need
the most attention to prevent the spatiotemporal decoupling of an
interactions from threatening ecosystem functioning or the persistence
of a species.

# Introduction

Species interactions are important. It is ultimately interactions
between individuals of different species that drive the structure,
dynamics, and persistence of ecosystems, and the abundance and
diversity of the species within them. Plant-pollinator interactions
specifically drive the function and persistence of "architecture of
biodiversity" [@Bascompte2007PlaMut]. However, we are far from a
robust understanding of plant-pollinator networks.
This is because sampling interactions is costly. Interactions vary in
space and time [@Poisot2015SpeWhy]---particularlly relevent in this
system [@CaraDonna2014ShiFlo]. This is why there is interest in using
models to predict interactions from sparse data [@Strydom2021].
In this paper, we combine several datasets, each spanning several
years, to produce spatially and temporally explicit predictions of the
bumblebee (genus _Bombus_) and wildflower pollination network across
the state of Colorado.

We do this in two parts: (1) metaweb prediction and (2) conditioning
our metaweb prediction on co-occurrence probability.
First, we build a model to predict the metaweb---the network of _all_
interactions, aggregated across all times and spatial locations---of
_Bombus_ and wildflower species across Colorado. (Why do this? The
metaweb is more predictable than local interactions.) We do this using
network embedding [@cite]. Network embedding takes each node in the
network (either a bumblebee or a wildflower) and represents it in a
latent $n$ dimensional space. Combination of running models on
Temporal niche (T), Phylogenetic niche (P), Environmental niche (E),
and relative abundance in community (RA).

Second, we then use this metaweb to predict the structure of networks
at specific locations and times of year [@Gravel2019BriElt].
Finally we suggest a map of sampling priority, which
suggests the locations to sample that will best improve our understanding
of the Colorado _Bombus_ pollination metaweb.

Why is this good for science, what does this contribute to our
understanding of plant-pollinator ints, networks, Bombus, predictive
models, etc.,  and how can these results be useful.

# Data

We use three separate field datasets to estimate the Colorado _Bombus_
metaweb.



# Methods

![todo](./figures/concept.png)


# Metaweb Model

## Phylogeny Construction

## Feature Embedding

### Relative Abundance

### Phylogenetic features

### Environmental niche features

### Temporal niche features

## Metaweb Model Fitting and Validation

![todo](./figures/PR_ROC.png)

# Spatiotemporally Explicit Networks

Now that we have a metaweb.....


***Figure 3: Maps over time figure and Prob(Connectance) vs. Month figure***


# Sampling Prioiritization


***Figure 4: Uncertainty and sampling priority map***


# Discussion
