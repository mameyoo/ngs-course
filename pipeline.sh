
#!/bin/bash

# Import and filter data

</data-shared/vcf_examples/luscinia_vars.vcf.gz zcat |
  grep -v '^#' |
  grep -e 'chr1\s' -e 'chr2\s' -e 'chr3\s' -e 'chr4\s' -e 'chr5\s' -e 'chr6\s' -e 'chr7\s' -e 'chr8\s' -e 'chr9\s' -e 'chr10\s' -e 'chr11\s' -e 'chr12\s' -e 'chr13\s' -e 'chr14\s' -e 'chr15\s' -e 'chr16\s' -e 'chr17\s' -e 'chr18\s' -e 'chr19\s' -e 'chr20\s' -e 'chr21\s' -e 'chr22\s' -e 'chr23\s' -e 'chr24\s' -e 'chr25\s' -e 'chr26\s' -e 'chr27\s' -e 'chr28\s' \
> data/luscinia_vars.vcf


# Prepare data

IN=data/luscinia_vars.vcf

# extract CHROM and QUAL columns
<$IN cut -f 1-6 > data/columns1-6.tsv

# extract DP columns
<$IN egrep -o 'DP=[^;]*' | sed 's/DP=//' > data/column-dp.tsv

# extract extract variant type
<$IN grep -v '^#' | awk '{if($0 ~ /INDEL/) print "INDEL"; else print "SNP"}' > data/column-type.tsv


# create a new tsv file and join all columns
paste data/columns1-6.tsv data/column-dp.tsv data/column-type.tsv > data/columns-all.tsv
