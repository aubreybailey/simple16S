#!/bin/bash
cat SRR_Acc_List.txt | 
paste -s -d ',' - |
xargs echo "magicblast \
-num_threads 40 \
-paired -outfmt tabular -gzo -reftype genome -splice F \
-no_unaligned \
-no_discordant \
-db silva_v4 \
-out all.txt.gz
-sra"

