# GNOMO
GNOMO is a Gencode for NOn Model Organism

GNOMO allow to count the number of CpG from WGBS-Seq data into the different genomic part, as in :

- **Upstream** and **Downstream** (2kb before/after the TSS<sup>1</sup> and TES<sup>2</sup>).
2Kb is used here like in Wang et al. 2014 (doi:10.1186/1471-2164-15-1119)<sup>3</sup>. When considering double-stranded DNA, upstream is toward the 5' end of the coding strand for the gene in question and downstream is toward the 3' end. Due to the anti-parallel nature of DNA, this means the 3' end of the template strand is upstream of the gene and the 5' end is downstream. GNOMO take this fact in account, so you must have the transcription direction information in your GFF/GFF3 file. Example:

```
If "+" (positive or 5 '→ 3')
Upstream = 5'UTR = 5' end
Downstream = 3'UTR = 3' end

If "-" (negative or 3 '→ 5')
Upstream = 3'UTR = 3' end
Downstream = 5'UTR = 5' end
```

<ins>Footnotes</ins>

<sup>1</sup> TSS - Transcription Start Site

<sup>2</sup> TES - Transcription End Site

<sup>3</sup> Wang et al. 2014 : Genome-wide and single-base resolution DNA methylomes of the Pacific oyster Crassostrea gigas provide insight into the evolution of invertebrate CpG methylation. BMC Genomics 2014 15:1119.doi:10.1186/1471-2164-15-1119


