#!/usr/bin/env bash

DIRECTORY=/Users/pierre-louisstenger/Desktop/GNOMO-master/
FILE=A_digitifera_genomic_elements.txt 


cd $DIRECTORY

grep "gene" A_digitifera_genomic_elements.txt > A_digitifera_genomic_elements.txt_gene.gff3

grep "+" A_digitifera_genomic_elements.txt_gene.gff3 > A_digitifera_genomic_elements.txt_gene_positive.gff3
grep "-" A_digitifera_genomic_elements.txt_gene.gff3 > A_digitifera_genomic_elements.txt_gene_negative.gff3

# For checking:
#grep "+" A_digitifera_genomic_elements.txt_gene_negative.gff3
# Empty = ok
#grep "-" A_digitifera_genomic_elements.txt_gene_positive.gff3
# Empty = ok

########################################################################################################
## Positive

###### Catch only useful informations
awk '{ print $1"\t"$4"\t"$5}' A_digitifera_genomic_elements.txt_gene_positive.gff3 > A_digitifera_genomic_elements.txt_gene_positive_02.gff3
#awk '{ print $9}' A_digitifera_genomic_elements.txt_gene_positive.gff3 > A_digitifera_genomic_elements.txt_gene_positive_02_transcripts.gff3
#awk -F '[;]' '{ print $1}' A_digitifera_genomic_elements.txt_gene_positive_02_transcripts.gff3 > A_digitifera_genomic_elements.txt_gene_positive_02_transcripts_02.gff3
#sed 's/ID=evm.TU.//g' A_digitifera_genomic_elements.txt_gene_positive_02_transcripts_02.gff3 > A_digitifera_genomic_elements.txt_gene_positive_02_transcripts_03.gff3
#sed 's/size/_/g' A_digitifera_genomic_elements.txt_gene_positive_02_transcripts_03.gff3 > A_digitifera_genomic_elements.txt_gene_positive_02_transcripts_04.gff3
#paste A_digitifera_genomic_elements.txt_gene_positive_02.gff3 A_digitifera_genomic_elements.txt_gene_positive_02_transcripts_04.gff3 > A_digitifera_genomic_elements.txt_gene_positive_final.gff3

# Create positive upstream
awk '{ print $1"\t"$2-2000"\t"$2}' A_digitifera_genomic_elements.txt_gene_positive_02.gff3 > A_digitifera_genomic_elements.txt_gene_positive_final_upstream.gff3
awk '{ print $1}' A_digitifera_genomic_elements.txt_gene_positive_final_upstream.gff3 > A_digitifera_genomic_elements.txt_gene_positive_final_upstream_01.gff3
awk '{ print $2}' A_digitifera_genomic_elements.txt_gene_positive_final_upstream.gff3 > A_digitifera_genomic_elements.txt_gene_positive_final_upstream_02.gff3
awk '{ print $3"\t""UPSTREAM"}' A_digitifera_genomic_elements.txt_gene_positive_final_upstream.gff3 > A_digitifera_genomic_elements.txt_gene_positive_final_upstream_03.gff3
# Change negative value for start by 0:
awk '{print($0<0?0:$0)}' A_digitifera_genomic_elements.txt_gene_positive_final_upstream_02.gff3 > A_digitifera_genomic_elements.txt_gene_positive_final_upstream_02_02.gff3
# Concatened the final file:
paste A_digitifera_genomic_elements.txt_gene_positive_final_upstream_01.gff3 A_digitifera_genomic_elements.txt_gene_positive_final_upstream_02_02.gff3 A_digitifera_genomic_elements.txt_gene_positive_final_upstream_03.gff3 > A_digitifera_genomic_elements.txt_gene_positive_final_upstream_final.gff3

# Create positive downstream
awk '{ print $1"\t"$3"\t"$3+2000"\t""DOWNSTREAM"}' A_digitifera_genomic_elements.txt_gene_positive_02.gff3 > A_digitifera_genomic_elements.txt_gene_positive_final_downstream.gff3

########################################################################################################
## Negative 

###### Catch only useful informations
awk '{ print $1"\t"$4"\t"$5}' A_digitifera_genomic_elements.txt_gene_negative.gff3 > A_digitifera_genomic_elements.txt_gene_negative_02.gff3
#awk '{ print $9}' A_digitifera_genomic_elements.txt_gene_negative.gff3 > A_digitifera_genomic_elements.txt_gene_negative_02_transcripts.gff3
#awk -F '[;]' '{ print $1}' A_digitifera_genomic_elements.txt_gene_negative_02_transcripts.gff3 > A_digitifera_genomic_elements.txt_gene_negative_02_transcripts_02.gff3
#sed 's/ID=evm.TU.//g' A_digitifera_genomic_elements.txt_gene_negative_02_transcripts_02.gff3 > A_digitifera_genomic_elements.txt_gene_negative_02_transcripts_03.gff3
#sed 's/size/_/g' A_digitifera_genomic_elements.txt_gene_negative_02_transcripts_03.gff3 > A_digitifera_genomic_elements.txt_gene_negative_02_transcripts_04.gff3
#paste A_digitifera_genomic_elements.txt_gene_negative_02.gff3 A_digitifera_genomic_elements.txt_gene_negative_02_transcripts_04.gff3 > A_digitifera_genomic_elements.txt_gene_negative_final.gff3

# Create negative downstream
awk '{ print $1"\t"$2-2000"\t"$2}' A_digitifera_genomic_elements.txt_gene_negative_02.gff3 > A_digitifera_genomic_elements.txt_gene_negative_final_downstream.gff3
awk '{ print $1}' A_digitifera_genomic_elements.txt_gene_negative_final_downstream.gff3 > A_digitifera_genomic_elements.txt_gene_negative_final_downstream_01.gff3
awk '{ print $2}' A_digitifera_genomic_elements.txt_gene_negative_final_downstream.gff3 > A_digitifera_genomic_elements.txt_gene_negative_final_downstream_02.gff3
awk '{ print $3"\t""DOWNSTREAM"}' A_digitifera_genomic_elements.txt_gene_negative_final_downstream.gff3 > A_digitifera_genomic_elements.txt_gene_negative_final_downstream_03.gff3
# Change negative value for start by 0:
awk '{print($0<0?0:$0)}' A_digitifera_genomic_elements.txt_gene_negative_final_downstream_02.gff3 > A_digitifera_genomic_elements.txt_gene_negative_final_downstream_02_02.gff3
# Concatened the final file:
paste A_digitifera_genomic_elements.txt_gene_negative_final_downstream_01.gff3 A_digitifera_genomic_elements.txt_gene_negative_final_downstream_02_02.gff3 A_digitifera_genomic_elements.txt_gene_negative_final_downstream_03.gff3 > A_digitifera_genomic_elements.txt_gene_negative_final_downstream_final.gff3

# Create negative upstream
awk '{ print $1"\t"$3"\t"$3+2000"\t""UPSTREAM"}' A_digitifera_genomic_elements.txt_gene_negative_02.gff3 > A_digitifera_genomic_elements.txt_gene_negative_final_upstream.gff3


########################################################################################################
## Merge negative & positive files

cat A_digitifera_genomic_elements.txt_gene_negative_final_upstream.gff3 A_digitifera_genomic_elements.txt_gene_positive_final_upstream_final.gff3 > A_digitifera_genomic_elements.txt_gene_upstream.gff3
cat A_digitifera_genomic_elements.txt_gene_negative_final_downstream_final.gff3 A_digitifera_genomic_elements.txt_gene_positive_final_downstream.gff3 > A_digitifera_genomic_elements.txt_gene_downstream.gff3






###### Catch only useful informations
awk '{ print $1"\t"$4"\t"$5"\t""GENE_BODY"}' A_digitifera_genomic_elements.txt_gene.gff3 > A_digitifera_genomic_elements.txt_gene_02.gff3
#awk '{ print $9}' A_digitifera_genomic_elements.txt_gene.gff3 > A_digitifera_genomic_elements.txt_gene_02_transcripts.gff3
#awk -F '[;]' '{ print $1}' A_digitifera_genomic_elements.txt_gene_02_transcripts.gff3 > A_digitifera_genomic_elements.txt_gene_02_transcripts_02.gff3
#sed 's/ID=evm.TU.//g' A_digitifera_genomic_elements.txt_gene_02_transcripts_02.gff3 > A_digitifera_genomic_elements.txt_gene_02_transcripts_03.gff3
#sed 's/size/_/g' A_digitifera_genomic_elements.txt_gene_02_transcripts_03.gff3 > A_digitifera_genomic_elements.txt_gene_02_transcripts_04.gff3
#paste A_digitifera_genomic_elements.txt_gene_02.gff3 A_digitifera_genomic_elements.txt_gene_02_transcripts_04.gff3 > A_digitifera_genomic_elements.txt_gene.gff3
#sed -i 's/size/_/g' A_digitifera_genomic_elements.txt_gene.gff3
#awk '{ print $1"\t"$2"\t"$3"\t"$4"\t""GENE_BODY"}' A_digitifera_genomic_elements.txt_gene.gff3 > A_digitifera_genomic_elements.txt_gene_02.gff3
#mv A_digitifera_genomic_elements.txt_gene_02.gff3 A_digitifera_genomic_elements.txt_gene.gff3



grep "exon" A_digitifera_genomic_elements.txt > A_digitifera_genomic_elements.txt_exon.gff3

###### Catch only useful informations
awk '{ print $1"\t"$4"\t"$5"\t""EXON"}' A_digitifera_genomic_elements.txt_exon.gff3 > A_digitifera_genomic_elements.txt_exon_02.gff3
#awk '{ print $9}' A_digitifera_genomic_elements.txt_exon.gff3 > A_digitifera_genomic_elements.txt_exon_02_transcripts.gff3
#awk -F '[;]' '{ print $2}' A_digitifera_genomic_elements.txt_exon_02_transcripts.gff3 > A_digitifera_genomic_elements.txt_exon_02_transcripts_02.gff3
#sed 's/Parent=evm.model.//g' A_digitifera_genomic_elements.txt_exon_02_transcripts_02.gff3 > A_digitifera_genomic_elements.txt_exon_02_transcripts_03.gff3
#sed 's/size/_/g' A_digitifera_genomic_elements.txt_exon_02_transcripts_03.gff3 > A_digitifera_genomic_elements.txt_exon_02_transcripts_04.gff3
#paste A_digitifera_genomic_elements.txt_exon_02.gff3 A_digitifera_genomic_elements.txt_exon_02_transcripts_04.gff3 > A_digitifera_genomic_elements.txt_exon.gff3
#awk '{ print $1"\t"$2"\t"$3"\t"$4"\t""EXON"}' A_digitifera_genomic_elements.txt_exon.gff3 > A_digitifera_genomic_elements.txt_exon_02.gff3
#mv A_digitifera_genomic_elements.txt_exon_02.gff3 A_digitifera_genomic_elements.txt_exon.gff3
#sed -i 's/size/_/g' A_digitifera_genomic_elements.txt_exon.gff3


mv A_digitifera_genomic_elements.txt_gene_upstream.gff3 A_digitifera_genomic_elements.txt_gene_upstream.gff3
mv A_digitifera_genomic_elements.txt_gene_downstream.gff3 A_digitifera_genomic_elements.txt_gene_downstream.gff3
mv A_digitifera_genomic_elements.txt_gene_02.gff3 A_digitifera_genomic_elements.txt_gene.gff3
mv A_digitifera_genomic_elements.txt_exon_02.gff3 A_digitifera_genomic_elements.txt_exon.gff3
