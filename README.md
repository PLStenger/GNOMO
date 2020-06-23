# GNOMO
***GNOMO is a Gencode for NOn Model Organism***

GNOMO allow to count the number of CpG from WGBS-Seq data into the different genomic part, as in :

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

You are lucky and can go on. The scripts will subset this file by grepping `gene` terms and will work on the start and stop values of each genes. After different step of file cleanning, the `intersect`<sup>1</sup> tool from `Bedtools`<sup>2</sup> will be used against the CpG count files from your WGBS-Seq data (you can obtain the CpG count files with `Bismark`<sup>3</sup> and the `bismark_methylation_extractor` tool or with the MethylKit R package<sup>4</sup>)

- **Exons**. The script will catch the start and stop values for each `exon` from the GFF file and the exact same way than above will be used.

- **Introns**. Will be obtain only at the end of the **Gene body** and **Exons** steps. For each CpG count files from your WGBS-Seq data, the number of CpG in **Gene body** will be subtract to the number of CpG in **Exons**.

- **Upstream** and **Downstream** (2kb before/after the TSS<sup>5</sup> and TES<sup>6</sup>).
2Kb is used here like in Wang et al. 2014 (doi:10.1186/1471-2164-15-1119)<sup>7</sup>. When considering double-stranded DNA, upstream is toward the 5' end of the coding strand for the gene in question and downstream is toward the 3' end. Due to the anti-parallel nature of DNA, this means the 3' end of the template strand is upstream of the gene and the 5' end is downstream. GNOMO take this fact in account, so you must have the transcription direction information in your GFF/GFF3 file. Example:


```
If "+" (positive or 5 '→ 3')
Upstream = 5'UTR = 5' end
Downstream = 3'UTR = 3' end

If "-" (negative or 3 '→ 5')
Upstream = 3'UTR = 3' end
Downstream = 5'UTR = 5' end
```

- So, how it's works for **Upstream** and **Downstream**? First, all genes with ***positive*** strand and with ***negative*** strand are split into two different files. For ***positive*** strand files, in *upstream*, 2000 pb (=2kb) is substracted to the start of each **Gene body** and will be used as a strat for the *upstream* part; and the start of each **Gene body** will be used as stop for *upstream* part. For ***negative*** strand files, the stop of each **Gene body** will be used as start for *upstream* part, and this value will be store and added by +2000bp in order to obtainning the stop value for the *upstream* part in the negative strand. This is the exactly opposite for *downstream* parts : For ***negative*** strand files, in *downstream*, 2000 pb (=2kb) is substracted to the start of each **Gene body** and will be used as a strat for the *downstream* part; and the start of each **Gene body** will be used as stop for *downstream* part. For ***positive*** strand files, the stop of each **Gene body** will be used as start for *downstream* part, and this value will be store and added by +2000bp in order to obtainning the stop value for the *downstream* part in the positive strand. Another important thing here is, a CpG can be on **upstream** on a gene 1, but a second gene (2) could be really very close to the gene 1 and also be considered both in **upstream** AND **Gene body**. So, GNOMO will deleted the **upstream** value to keep only the **Gene body** value for this CpG.

## How to run ? What's it's doing ?

1. If you have only exon values in your GFF/GFF3 file, please run before the `00_concatenate_exons_into_genes.sh` as explained before. Then, merge your new file with your old file in order to kept **Exon** and **Gene body** informations. Then, go to step 2.
2. If you have a GFF/GFF3 file like in the example above, please run these different step in this order:

- `01_layout.sh`. You need to change in the header or this script the path of your working directory (in DIRECTORY=) and the name of your GFF/GFF3 file (in FILE=). Run the script. It will created for subsetted files: `${FILE##*/}_gene_upstream.gff3`, `${FILE##*/}_gene_downstream.gff3`, `${FILE##*/}_gene.gff3` and `${FILE##*/}_exon.gff3`. In this four files, there is the limit (start and stop) of each category.

- `02_intersect_WGBS_files.sh`. You need to change in the header or this script.  the path of your working directory (in DATADIRECTORY) and the output direcectory (DATAOUTPUT), precise the location of your `Bedtools`<sup>2</sup> (in BEDTOOLS_ENV=), and wrote the similar name pattern for your WGBS-Seq CpG count file in WGBS_FILE= (for example, if all your CpG count files are finish by `*_cpg_count.txt`, wrote this: `WGBS_FILE=_cpg_count.txt`). Run the script. For each WGBS-Seq CpG count file you will obtain four files, for: **Gene body** CpG, **Exon** CpG, **Upstream** CpG and **Downstream** CpG.

- `03_clean_steps.sh`. You also need to change in the header or this script. This script will clean the files, but more important, it attributes and unique name of each CpG, and this will serve when comparing **Gene body** CpG files with **Upstream** and **Downstream** CpG files for deleted duplicates.

- `04_vlookup.shh`. You also need to change in the header or this script. This script will search duplicates CpG by comparing **Gene body** CpG files with **Upstream** and **Downstream** CpG files. All duplicates will be put in `*_gene_MATCH_w_upstream.txt` and `*_gene_MATCH_w_downstream.txt` files. So, into this files, there are CpG position that are both in **Gene body** region for one gene and in **Upstream** or **Downstream** region for another gene with is closer to the first one. 

- The last step for obtainning the number of CpG in each genomic part is only command line:

1. `wc -l ${WGBS_FILE##*/}` (`${WGBS_FILE##*/}` correspond to your similar name pattern for your WGBS-Seq CpG count file). This will give you the total number of your CpG in all of your WGBS-Seq CpG count files.
2. `wc -l *_gene_02.gff`. Will give you the number of CpG only in the gene body (so, exons + introns) for all of your WGBS-Seq CpG count files.
3. `wc -l *_exon_02.gff`. Will give you the number of CpG only in exons for all of your WGBS-Seq CpG count files.
4. For obtainning the number of CpG only in **introns**, please subtract the number of CpG only in the gene body (step 2) with the number of CpG only in exons (step 3) for each of your WGBS-Seq CpG count files.
5. `wc -l *combined_gene_MATCH_w_upstream.txt` and `wc -l *combined_gene_MATCH_w_downstream.txt` will give you respectively the number of duplicates CpG.
6. `wc -l *_gene_upstream_02.gff` and `wc -l *_gene_downstream_02.gff` will give you the total number of CpG in **up** and **downstream**.
7. So, for obtainning the real number of **up** and **downstream** CpG, please substract the number of CpG in **up** and **downstream** (step 6) by the number of duplicates (step 5) for each of your WGBS-Seq CpG count files.
 


## Footnotes

<sup>1</sup> https://bedtools.readthedocs.io/en/latest/content/tools/intersect.html

<sup>2</sup> https://bedtools.readthedocs.io/en/latest/index.html

<sup>3</sup> https://www.bioinformatics.babraham.ac.uk/projects/bismark/Bismark_User_Guide.pdf

<sup>4</sup> https://bioconductor.org/packages/devel/bioc/vignettes/methylKit/inst/doc/methylKit.html

<sup>5</sup> TSS - Transcription Start Site

<sup>6</sup> TES - Transcription End Site

<sup>7</sup> Wang et al. 2014 : Genome-wide and single-base resolution DNA methylomes of the Pacific oyster Crassostrea gigas provide insight into the evolution of invertebrate CpG methylation. BMC Genomics 2014 15:1119.doi:10.1186/1471-2164-15-1119
