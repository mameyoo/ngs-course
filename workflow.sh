
#!/bin/bash

# Import and filter data

</data-shared/vcf_examples/luscinia_vars.vcf.gz zcat |
  grep -v '^#' | 
  tail -c +2 | 
  grep '^\chr[0-9]' \
> data/luscinia_vars.vcf


# Define variable FILE as my filtered data
FILE=data/luscinia_vars.vcf


# Prepare data by creating tsv files 
# extract CHROM and QUAL columns
<$FILE cut -f 1-6 > data/columns1-6.tsv 

# extract DP columns
<$FILE egrep -o 'DP=[^;]*' | 
  sed 's/DP=//' > data/column-dp.tsv

# extract extract variant type
<$FILE grep -v '^#' | 
  awk '{if($0 ~ /INDEL/) print "INDEL"; else print "SNP"}' \
> data/column-type.tsv


# join all columns in one tsv file
paste data/columns1-6.tsv data/column-dp.tsv data/column-type.tsv \
> data/columns-all.tsv
