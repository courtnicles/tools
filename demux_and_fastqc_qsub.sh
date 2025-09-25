#!/bin/bash
#$ -wd /sc1/groups/research/workspace/sam/methylation/20240724_DNMT5_round_4_GK/pipeline_test
#$ -N bclconv
#$ -o /sc1/groups/research/workspace/sam/methylation/20240724_DNMT5_round_4_GK/pipeline_test/.command.log
#$ -j y
#$ -terse
#$ -V
#$ -notify
#$ -q all.q
#$ -pe smp 2
#$ -l h_vmem=15G -S /bin/bash -P rssdsbfxprj
#$ -e /sc1/groups/research/workspace/sam/methylation/20240724_DNMT5_round_4_GK/pipeline_test/.command.error

module load bclconvert/3.9.3
bcl-convert --bcl-input-directory /sc1/raw/illumina/miseq/M02493/240718_M02493_0211_000000000-LJJ2M_A --output-directory /sc1/groups/research/workspace/sam/methylation/20240724_DNMT5_round_4_GK/pipeline_test/demux --sample-sheet /sc1/groups/research/workspace/sam/methylation/20240724_DNMT5_round_4_GK/pipeline_test/samplesheet.csv --force
