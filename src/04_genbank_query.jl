using CSV, DataFrames


bees = CSV.read(joinpath("cleandata", "beenames.csv"), DataFrame) # bees?

targetfile = "genbank_bee_query.txt"

# format is 
# "Bombus appositus"[Organism] OR "Bombus auricomus"[Organism] OR ... etc.


query = "$(bees.species[begin])[Organism] OR "

for s in bees.species[2:end-1]
    query = string(query, "$s [Organism] OR ")
end

query = string(query, "$(bees.species[end])[Organism]")


