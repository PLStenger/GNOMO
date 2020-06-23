#!/usr/bin/env bash

$DIRECTORY= #Set your working directory
$FILE= #your GFF or your GFF3 file


cd $DIRECTORY

grep "gene" ${FILE##*/} > ${FILE##*/}_gene.gff3

grep "+" ${FILE##*/}_gene.gff3 > ${FILE##*/}_gene_positive.gff3
grep "-" ${FILE##*/}_gene.gff3 > ${FILE##*/}_gene_negative.gff3

# For checking:
#grep "+" ${FILE##*/}_gene_negative.gff3
# Empty = ok
#grep "-" ${FILE##*/}_gene_positive.gff3
# Empty = ok

########################################################################################################
## Positive

###### Catch only useful informations
awk '{ print $1"\t"$4"\t"$5}' ${FILE##*/}_gene_positive.gff3 > ${FILE##*/}_gene_positive_02.gff3
awk '{ print $9}' ${FILE##*/}_gene_positive.gff3 > ${FILE##*/}_gene_positive_02_transcripts.gff3
awk -F '[;]' '{ print $1}' ${FILE##*/}_gene_positive_02_transcripts.gff3 > ${FILE##*/}_gene_positive_02_transcripts_02.gff3
sed 's/ID=evm.TU.//g' ${FILE##*/}_gene_positive_02_transcripts_02.gff3 > ${FILE##*/}_gene_positive_02_transcripts_03.gff3
sed 's/size/_/g' ${FILE##*/}_gene_positive_02_transcripts_03.gff3 > ${FILE##*/}_gene_positive_02_transcripts_04.gff3
paste ${FILE##*/}_gene_positive_02.gff3 ${FILE##*/}_gene_positive_02_transcripts_04.gff3 > ${FILE##*/}_gene_positive_final.gff3

# Create positive upstream
awk '{ print $1"\t"$2-2000"\t"$2"\t"$4}' ${FILE##*/}_gene_positive_final.gff3 > ${FILE##*/}_gene_positive_final_upstream.gff3
awk '{ print $1}' ${FILE##*/}_gene_positive_final_upstream.gff3 > ${FILE##*/}_gene_positive_final_upstream_01.gff3
awk '{ print $2}' ${FILE##*/}_gene_positive_final_upstream.gff3 > ${FILE##*/}_gene_positive_final_upstream_02.gff3
awk '{ print $3"\t"$4"\t""UPSTREAM"}' ${FILE##*/}_gene_positive_final_upstream.gff3 > ${FILE##*/}_gene_positive_final_upstream_03.gff3
# Change negative value for start by 0:
awk '{print($0<0?0:$0)}' ${FILE##*/}_gene_positive_final_upstream_02.gff3 > ${FILE##*/}_gene_positive_final_upstream_02_02.gff3
# Concatened the final file:
paste ${FILE##*/}_gene_positive_final_upstream_01.gff3 ${FILE##*/}_gene_positive_final_upstream_02_02.gff3 ${FILE##*/}_gene_positive_final_upstream_03.gff3 > ${FILE##*/}_gene_positive_final_upstream_final.gff3

# Create positive downstream
awk '{ print $1"\t"$3"\t"$3+2000"\t"$4"\t""DOWNSTREAM"}' ${FILE##*/}_gene_positive_final.gff3 > ${FILE##*/}_gene_positive_final_downstream.gff3

########################################################################################################
## Negative 

###### Catch only useful informations
awk '{ print $1"\t"$4"\t"$5}' ${FILE##*/}_gene_negative.gff3 > ${FILE##*/}_gene_negative_02.gff3
awk '{ print $9}' ${FILE##*/}_gene_negative.gff3 > ${FILE##*/}_gene_negative_02_transcripts.gff3
awk -F '[;]' '{ print $1}' ${FILE##*/}_gene_negative_02_transcripts.gff3 > ${FILE##*/}_gene_negative_02_transcripts_02.gff3
sed 's/ID=evm.TU.//g' ${FILE##*/}_gene_negative_02_transcripts_02.gff3 > ${FILE##*/}_gene_negative_02_transcripts_03.gff3
sed 's/size/_/g' ${FILE##*/}_gene_negative_02_transcripts_03.gff3 > ${FILE##*/}_gene_negative_02_transcripts_04.gff3
paste ${FILE##*/}_gene_negative_02.gff3 ${FILE##*/}_gene_negative_02_transcripts_04.gff3 > ${FILE##*/}_gene_negative_final.gff3

# Create negative downstream
awk '{ print $1"\t"$2-2000"\t"$2"\t"$4}' ${FILE##*/}_gene_negative_final.gff3 > ${FILE##*/}_gene_negative_final_downstream.gff3
awk '{ print $1}' ${FILE##*/}_gene_negative_final_downstream.gff3 > ${FILE##*/}_gene_negative_final_downstream_01.gff3
awk '{ print $2}' ${FILE##*/}_gene_negative_final_downstream.gff3 > ${FILE##*/}_gene_negative_final_downstream_02.gff3
awk '{ print $3"\t"$4"\t""DOWNSTREAM"}' ${FILE##*/}_gene_negative_final_downstream.gff3 > ${FILE##*/}_gene_negative_final_downstream_03.gff3
# Change negative value for start by 0:
awk '{print($0<0?0:$0)}' ${FILE##*/}_gene_negative_final_downstream_02.gff3 > ${FILE##*/}_gene_negative_final_downstream_02_02.gff3
# Concatened the final file:
paste ${FILE##*/}_gene_negative_final_downstream_01.gff3 ${FILE##*/}_gene_negative_final_downstream_02_02.gff3 ${FILE##*/}_gene_negative_final_downstream_03.gff3 > ${FILE##*/}_gene_negative_final_downstream_final.gff3

# Create negative upstream
awk '{ print $1"\t"$3"\t"$3+2000"\t"$4"\t""UPSTREAM"}' ${FILE##*/}_gene_negative_final.gff3 > ${FILE##*/}_gene_negative_final_upstream.gff3


########################################################################################################
## Merge negative & positive files

cat ${FILE##*/}_gene_negative_final_upstream.gff3 ${FILE##*/}_gene_positive_final_upstream_final.gff3 > ${FILE##*/}_gene_upstream.gff3
cat ${FILE##*/}_gene_negative_final_downstream_final.gff3 ${FILE##*/}_gene_positive_final_downstream.gff3 > ${FILE##*/}_gene_downstream.gff3






###### Catch only useful informations
awk '{ print $1"\t"$4"\t"$5}' ${FILE##*/}_gene.gff3 > ${FILE##*/}_gene_02.gff3
awk '{ print $9}' ${FILE##*/}_gene.gff3 > ${FILE##*/}_gene_02_transcripts.gff3
awk -F '[;]' '{ print $1}' ${FILE##*/}_gene_02_transcripts.gff3 > ${FILE##*/}_gene_02_transcripts_02.gff3
sed 's/ID=evm.TU.//g' ${FILE##*/}_gene_02_transcripts_02.gff3 > ${FILE##*/}_gene_02_transcripts_03.gff3
sed 's/size/_/g' ${FILE##*/}_gene_02_transcripts_03.gff3 > ${FILE##*/}_gene_02_transcripts_04.gff3
paste ${FILE##*/}_gene_02.gff3 ${FILE##*/}_gene_02_transcripts_04.gff3 > ${FILE##*/}_gene.gff3
sed -i 's/size/_/g' ${FILE##*/}_gene.gff3
awk '{ print $1"\t"$2"\t"$3"\t"$4"\t""GENE_BODY"}' ${FILE##*/}_gene.gff3 > ${FILE##*/}_gene_02.gff3
mv ${FILE##*/}_gene_02.gff3 ${FILE##*/}_gene.gff3



grep "exon" ${FILE##*/}.gff3 > ${FILE##*/}_exon.gff3

###### Catch only useful informations
awk '{ print $1"\t"$4"\t"$5}' ${FILE##*/}_exon.gff3 > ${FILE##*/}_exon_02.gff3
awk '{ print $9}' ${FILE##*/}_exon.gff3 > ${FILE##*/}_exon_02_transcripts.gff3
awk -F '[;]' '{ print $2}' ${FILE##*/}_exon_02_transcripts.gff3 > ${FILE##*/}_exon_02_transcripts_02.gff3
sed 's/Parent=evm.model.//g' ${FILE##*/}_exon_02_transcripts_02.gff3 > ${FILE##*/}_exon_02_transcripts_03.gff3
sed 's/size/_/g' ${FILE##*/}_exon_02_transcripts_03.gff3 > ${FILE##*/}_exon_02_transcripts_04.gff3
paste ${FILE##*/}_exon_02.gff3 ${FILE##*/}_exon_02_transcripts_04.gff3 > ${FILE##*/}_exon.gff3
awk '{ print $1"\t"$2"\t"$3"\t"$4"\t""EXON"}' ${FILE##*/}_exon.gff3 > ${FILE##*/}_exon_02.gff3
mv ${FILE##*/}_exon_02.gff3 ${FILE##*/}_exon.gff3
sed -i 's/size/_/g' ${FILE##*/}_exon.gff3


sed -i 's/size/_/g' ${FILE##*/}_gene_upstream.gff3
sed -i 's/size/_/g' ${FILE##*/}_gene_downstream.gff3
sed -i 's/size/_/g' ${FILE##*/}_gene.gff3
sed -i 's/size/_/g' ${FILE##*/}_exon.gff3
