/Applications/sratoolkit.2.9.6-mac64/bin/prefetch --option-file SRR_Acc_List.txt	-O ./data_files

/Applications/sratoolkit.2.9.6-mac64/bin/fastq-dump --split-files --gzip data_files/*.sra

