#!/usr/bin/env bash
#PBS -q mpi
#PBS -l walltime=48:00:00
#PBS -l select=1:ncpus=28:mem=115g

DATADIRECTORY=
DATAOUTPUT=
BEDTOOLS_ENV= # Bedtool version 2.27.1 # https://bedtools.readthedocs.io/en/latest/content/tools/getfasta.html
WGBS_FILE=

cd $DATADIRECTORY

$BEDTOOLS_ENV


for FILE in $(ls $DATADIRECTORY/*$WGBS_FILE)
do

bedtools intersect -b ${FILE##*/} -a ${FILE##*/}_gene_upstream.gff3 -wa -wb > ${FILE##*/}_${FILE##*/}_gene_upstream.gff
bedtools intersect -b ${FILE##*/} -a ${FILE##*/}_gene_downstream.gff3 -wa -wb > ${FILE##*/}_${FILE##*/}_gene_downstream.gff
bedtools intersect -b ${FILE##*/} -a ${FILE##*/}_gene.gff3 -wa -wb > ${FILE##*/}_${FILE##*/}_gene.gff
bedtools intersect -b ${FILE##*/} -a ${FILE##*/}_exon.gff3 -wa -wb > ${FILE##*/}_${FILE##*/}_exon.gff

done ;
