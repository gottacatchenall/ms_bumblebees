using CSV, DataFrames


bees = CSV.read(joinpath("cleandata", "beenames.csv"), DataFrame) # bees?

plants = CSV.read(joinpath("cleandata", "plantnames.csv"), DataFrame)
# format is 
# "Bombus appositus"[Organism] OR "Bombus auricomus"[Organism] OR ... etc.

function makequery(species)
    query = "$(species[begin])[Organism] OR "

    for s in species[2:end-1]
        query = string(query, "$s [Organism] OR ")
    end

    query = string(query, "$(species[end])[Organism]")
end



makequery(plants.species)