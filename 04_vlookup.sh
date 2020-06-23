#!/usr/bin/env bash
#PBS -q mpi
#PBS -l walltime=48:00:00
#PBS -l select=1:ncpus=28:mem=115g

DATADIRECTORY=
WGBS_FILE=

cd $DATADIRECTORY

for FILE in $(ls $DATADIRECTORY/*$WGBS_FILE)
do

awk '
    # { sub(/\r$/,"") }    # uncomment to remove Windows style line-endings.
    NR==FNR{a[$1]          # hash $1 of genes file to a
    next
}
($1 in a) {                # lookup from transcriptome
    print
}' ${WGBS_FILE##*/}_gene_upstream_02.gff ${WGBS_FILE##*/}_gene_02.gff > ${WGBS_FILE##*/}_gene_MATCH_w_upstream.txt

done;
