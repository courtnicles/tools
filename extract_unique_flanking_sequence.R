library("dplyr")
library("readr")
library("tidyverse")
library("magrittr")
library("Biostrings")
library("seqTools")

df <- readr::read_tsv("pacbio_flanking_region_with_mods_DNMT1_group3-mapped.tsv")
df %<>% mutate(pos = as.character(pos))

my_df <- as.data.frame(df)

# modify for flanking sequences
matches_CpG <- my_df$haplotype[grep("^[CAGT]{2,}CG[CAGT]{2,}$", my_df$haplotype)]
matches_CG <- my_df$haplotype[grep("^[CAGT]{2,}TG[CAGT]{2,}$", my_df$haplotype)]

positive_hit <- filter(my_df,
                       my_df$haplotype %in% matches_CpG)

negative_hit <- filter(my_df,
                       my_df$haplotype %in% matches_CG)

# this groups methylation/nonmethylation groups based on the input threshold
positive_hit_freq_count <- positive_hit %>%
  group_by(read) %>%
  summarize(COUNT = n())
positive_hit_freq_count_sort <- positive_hit_freq_count[order(positive_hit_freq_count$COUNT, decreasing=TRUE), ]
write.csv(positive_hit_freq_count_sort, "positive_hit_freq_count_sort_0p1.csv", row.names=FALSE)

negative_hit_freq_count <- negative_hit %>%
  group_by(read) %>%
  summarize(COUNT = n())
negative_hit_freq_count_sort <- negative_hit_freq_count[order(negative_hit_freq_count$COUNT, decreasing=TRUE), ]
write.csv(negative_hit_freq_count_sort, "negative_hit_freq_count_sort_0p1.csv", row.names=FALSE)

# plots for looking at base frequency at each position
dna <- DNAStringSet(positive_hit$read)
afmc=consensusMatrix(dna, baseOnly=T,as.prob = T)
tafmc=t(afmc)
matplot(tafmc[,-5], type="l", lwd=2, xlab="Read Length", ylab= "Base frequency at each position")
title("Methyl CpG")
legend(legend = colnames(tafmc)[-5],"topright",col=1:4, lty=1:4, lwd=2)


dna2 <- DNAStringSet(negative_hit$read)
afmc2=consensusMatrix(dna2, baseOnly=T,as.prob = T)
tafmc2=t(afmc2)
matplot(tafmc2[,-5], type="l", lwd=2, xlab="Read Length", ylab= "Base frequency at each position")
title("Non-Methyl CG")
legend(legend = colnames(tafmc2)[-5],"topright",col=1:4, lty=1:4, lwd=2)

