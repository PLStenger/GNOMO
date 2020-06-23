#!/usr/bin/env bash

DIRECTORY= #Set your working directory
WGBS_FILE= 


cd $DIRECTORY

#### Clean Upstream files by individuals

for FILE in $(ls $DATADIRECTORY/*$WGBS_FILE)
do
awk '{ print $1"_"$7"\t"$5}' ${WGBS_FILE##*/}_gene_upstream.gff > ${WGBS_FILE##*/}_gene_upstream_02.gff
done ;


#### Clean Downstream files by individuals

for FILE in $(ls $DATADIRECTORY/*$WGBS_FILE)
do
awk '{ print $1"_"$7"\t"$5}' ${WGBS_FILE##*/}_gene_downstream.gff > ${WGBS_FILE##*/}_gene_downstream_02.gff
done ;

#### Clean Exons files by individuals

for FILE in $(ls $DATADIRECTORY/*$WGBS_FILE)
do
awk '{ print $1"_"$7"\t"$5}' ${WGBS_FILE##*/}_exon.gff > ${WGBS_FILE##*/}_exon_02.gff
done ;


#### Clean Genes files by individuals

for FILE in $(ls $DATADIRECTORY/*$WGBS_FILE)
do
awk '{ print $1"_"$7"\t"$5}' ${WGBS_FILE##*/}_gene.gff > ${WGBS_FILE##*/}_gene.gff
done ;
