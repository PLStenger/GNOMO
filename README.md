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

- **Gene body**. Normaly you have already the gene start and stop information of each genes. However some GFF/GFF3 file from non-model animals can have only exons start and stop information, and the gene start and stop information of each genes is not concatenated. If you are in this last case, please, run the `00_concatenate_exons_into_genes.sh` script, and place the name of your input and output file into this script. This script will take the lower start value for each unique entry (eg. gene or transcript) and take the higher stop value for each unique entry. If you are in the case with a complete GFF/GFF3 file like this:

```
scaffold10000size69197	EVM	gene	15011	27154	.	-	.	ID=evm.TU.scaffold10000size69197.1;Name=EVM%20prediction%20scaffold10000size69197.1
scaffold10000size69197	EVM	mRNA	15011	27154	.	-	.	ID=evm.model.scaffold10000size69197.1;Parent=evm.TU.scaffold10000size69197.1;Name=EVM%20prediction%20scaffold10000size69197.1
scaffold10000size69197	EVM	exon	27101	27154	.	-	.	ID=evm.model.scaffold10000size69197.1.exon1;Parent=evm.model.scaffold10000size69197.1
scaffold10000size69197	EVM	CDS	27101	27154	.	-	0	ID=cds.evm.model.scaffold10000size69197.1;Parent=evm.model.scaffold10000size69197.1
scaffold10000size69197	EVM	exon	26782	26946	.	-	.	ID=evm.model.scaffold10000size69197.1.exon2;Parent=evm.model.scaffold10000size69197.1
scaffold10000size69197	EVM	CDS	26782	26946	.	-	0	ID=cds.evm.model.scaffold10000size69197.1;Parent=evm.model.scaffold10000size69197.1
scaffold10000size69197	EVM	exon	15011	15217	.	-	.	ID=evm.model.scaffold10000size69197.1.exon3;Parent=evm.model.scaffold10000size69197.1
scaffold10000size69197	EVM	CDS	15011	15217	.	-	0	ID=cds.evm.model.scaffold10000size69197.1;Parent=evm.model.scaffold10000size69197.1
```

You are lucky and can go on. The scripts will subset this file by grepping `gene` terms and will work on the start and stop values of each genes. After different step of file cleanning, the `intersect`<sup>4</sup> tool from `Bedtools`<sup>5</sup> will be used against the CpG count files from your WGBS-Seq data (you can obtain the CpG count files with `Bismark`<sup>6</sup> and the `bismark_methylation_extractor` tool or with the MethylKit R package<sup>7</sup>)

- **Exons**. The script will catch the start and stop values for each `exon` from the GFF file. 

<ins>Footnotes</ins>

<sup>1</sup> TSS - Transcription Start Site

<sup>2</sup> TES - Transcription End Site

<sup>3</sup> Wang et al. 2014 : Genome-wide and single-base resolution DNA methylomes of the Pacific oyster Crassostrea gigas provide insight into the evolution of invertebrate CpG methylation. BMC Genomics 2014 15:1119.doi:10.1186/1471-2164-15-1119

<sup>4</sup> https://bedtools.readthedocs.io/en/latest/content/tools/intersect.html

<sup>5</sup> https://bedtools.readthedocs.io/en/latest/index.html

<sup>6</sup> https://www.bioinformatics.babraham.ac.uk/projects/bismark/Bismark_User_Guide.pdf

<sup>7</sup> https://bioconductor.org/packages/devel/bioc/vignettes/methylKit/inst/doc/methylKit.html
