using BioSequences
using FASTX

r = open(FASTA.Reader, "./cleandata/UNALIGNED_CLEANED_plant_rbcL.fasta",)

for record in r
    name = string(identifier(record), " ", description(record))
    recstr = sequence(record)
    a = length(recstr) < 650 ? recstr : recstr[begin:650]

    newrec = FASTA.Record(name, a)
    w = FASTA.Writer(open("my-out.fasta", "a"))
    write(w, newrec)
    close(w)
end


close(r)