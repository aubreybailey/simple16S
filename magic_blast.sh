#!/bin/bash -l

MAGICBLAST_PATH="/Applications/ncbi-magicblast-1.4.0/bin/magicblast"
BLASTDB="16SMicrobial"
BLAST_INDEXES="./"
NUM_PROCS=8

MAGICBLAST_ARGS="-db ${BLAST_INDEXES}/${BLASTDB} \
-num_threads ${NUM_PROCS} \
-paired -infmt fastq -outfmt tabular -gzo -reftype genome -splice F \
-perc_identity 97 -score 100 \
-no_discordant \
-no_unaligned"

# check if BLAST is working
if [ ! -x $BLAST_PATH ]; then
echo "STAR not loaded correctly. Please check that $STAR_PATH exists"
        exit 1
fi

# check if there are even any files given
if [ $# -eq 0 ]; then
echo "Please provide at least one fastq.gz!"
        exit 1
fi

#perhaps- while [[ $# -gt 1 ]]
for filename in ${@}; do
	key="$1"
	case $key in
        # parse -n into the number of processors to use
        -f|--force)
                delete_existing=1
                shift # past argument
        ;;
        *)  # treat everything else as a filename
                dname=$(dirname ${filename})
                fname=$(basename ${filename} .fastq.gz)
                #make sure we have real files
                if [[ -f $1 ]]; then
                        dname=$(dirname ${filename})
                        #check if we end in .gz and unzip accordingly
                        if [ ${1: -3} == ".gz" ]
                                then
                                        fname=$(basename ${filename} _1.fastq.gz)
                                        in=${dname}/${fname}_1.fastq.gz
					in2=${dname}/${fname}_2.fastq.gz
					out=${dname}/${fname}.txt.gz
				else
                                        fname=$(basename ${filename} _1.fastq)
                                        in=${dname}/${fname}_1.fastq
                                        in2=${dname}/${fname}_2.fastq
                                        out=${dname}/${fname}.txt.gz
                        fi
                fi
                # if output file already exists, just exit
                if [[ -f $out ]]; then
                        if [[ $delete_existing == 1 ]]; then
                                rm ${out}
                        else
                                echo "ERROR: $out already exists! Use -f to force overwrite."
                                exit
                        fi
                fi

                #make sure we have real files
                if [[ ! -f ${in} ]]; then
                        echo "file ${in} does not exist"
                        exit
                else
			echo "${MAGICBLAST_PATH} ${MAGICBLAST_ARGS} -query ${in} -query_mate ${in2} -out ${out}"
		fi
	;;
	esac
	shift
done
