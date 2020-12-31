# NGS-COURSE 2020: Final exercise solution

## Presentation

This repository is a bioinformatics pipeline repository to perform some analyses of the Luscinia genome. 
The pipeline is used as a final exercise solution at the course on Unix and work with genomic data. 
More information on the Luscinia species can be found on [Wikipedia](https://en.wikipedia.org/wiki/Common_nightingale).

About NGS-COURSE [here](https://ngs-course.readthedocs.io/en/praha-november-2020/index.html).

## 1. Run the unix script

#### 1.1. Data directory preparation

```
mkdir -p ~/projects/final-exercise/task_4/data
cd ~/projects/final-exercice/task_4
```

#### 1.2 **Script editing**

To write my script, I used the text editor integred in unix nano. It can be called with the command `<nano myscriptename.sh>`


#### 1.3. **Import and filter data**

```
</data-shared/vcf_examples/luscinia_vars.vcf.gz zcat |
  grep -v '##' |
  tail -c +2 | 
  grep grep '^\chr[0-9]' |
> data/luscinia_vars.vcf
```

#### 1.4. **Prepare data by creating tsv files**

```
# Define variable FILE as my filtered data
FILE=data/luscinia_vars.vcf
 
# extract CHROM and QUAL columns
<$FILE cut -f 1-6 > data/columns1-6.tsv 

# extract DP columns
<$FILE egrep -o 'DP=[^;]*' | sed 's/DP=//' > data/column-dp.tsv

# extract extract variant type
<$FILE grep -v '^#' | awk '{if($0 ~ /INDEL/) print "INDEL"; else print "SNP"}' > data/column-type.tsv


# join all columns in one tsv file
paste data/columns1-6.tsv data/column-dp.tsv data/column-type.tsv > data/columns-all.tsv
```

#### 1.5. **Make the script executable and run it**

```
chmod +x workflow.sh

./workflow.sh
```

#### Check that my files are correctly created

```
wc -l data/*.tsv
```

## 2. **R script for resulting data plotting**

#### 2.1. **setup my repository**

```
setwd('~/projects/final-exercise/task_4')
```

#### 2.2. **R packages for data science**

```
library(tidyverse)
```

#### 2.3. **charge data**

```
read_tsv("data/columns-all.tsv",
         col_names=c("chrom", "pos", "dot", "ref", "alt", "qual", "DP", "TYPE")) ->
  d
```

#### 2.4. **Graphs**


```
# Plot for Distribution of read depth (DP) qualities INDELS vs. SNPs
d %>%
  ggplot(aes(TYPE, DP, color = TYPE)) +
  geom_boxplot() +
  scale_y_log10()

# hPHRED qualities distribution over the whole genome and by chromosome
d %>%
  filter(qual < 500) %>%
  ggplot(aes(chrom, qual)) +
  geom_boxplot(outlier.colour = NA, fill = "yellow") +
  theme(axis.text.x = element_text(angle = 40, hjust = 1)) +
  scale_y_log10()

#  DP distribution over the whole genome and by chromosome
d %>%
  ggplot(aes(chrom, DP)) +
  geom_boxplot(outlier.colour = NA, fill = "yellow") +
  theme(axis.text.x = element_text(angle = 40, hjust = 1)) +
  scale_y_log10()

# PHRED qualities distribution INDELS vs. SNPs
d %>%
  ggplot(aes(TYPE, qual, color = TYPE)) +
  geom_boxplot() +
  scale_y_log10()
```

## 3. Result

#### Plot for Distribution of read depth (DP) qualities INDELS vs. SNPs

![Rplot_4.png](https://github.com/mameyoo/ngs-course/blob/main/Rplot_4.png)

#### PHRED qualities distribution over the whole genome and by chromosome

![Rplot_1.png](https://github.com/mameyoo/ngs-course/blob/main/Rplot_1.png)

#### DP distribution over the whole genome and by chromosome

![Rplot_2.png](https://github.com/mameyoo/ngs-course/blob/main/Rplot_2.png)

#### PHRED qualities distribution INDELS vs. SNPs

![Rplot_3.png](https://github.com/mameyoo/ngs-course/blob/main/Rplot_3.png)
