setwd('~/projects/final-exercise/task_4')

library(tidyverse)

read_tsv("data/columns-all.tsv",
         col_names=c("chrom", "pos", "dot", "ref", "alt", "qual", "DP", "TYPE")) ->
  d

# Plot for Distribution of read depth (DP) qualities INDELS vs. SNPs
d %>%
  ggplot(aes(TYPE, DP, color = TYPE)) +
  geom_boxplot() +
  scale_y_log10()


# Additional Graph
# PHRED qualities distribution over the whole genome and by chromosome
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

