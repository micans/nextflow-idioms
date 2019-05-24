#!/usr/bin/env nextflow


params.reads = "*R{1,2}_[0-9][0-9][0-9].fastq.gz"
params.inputdir = "input"

Channel
    // .fromFilePairs("inputs/*R{1,2}_[0-9][0-9][0-9].fastq.gz")
    .fromFilePairs("${params.inputdir}/${params.reads}")
    .ifEmpty { error "Cannot find any reads matching: ${params.reads}" }  
    .set { read_pairs }
  

process dostuff {
    tag "$pair_id ${reads.size()}"

    input:
    set pair_id, file(reads) from read_pairs

    script:
    f1 = reads[0]
    f2 = reads[1]
    """
    echo "I have files $f1 and $f2"
    """
}


