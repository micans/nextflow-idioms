/*
This code shows an example on how to create multiple samples from a single sample after cutadapt demultiplexing (https://cutadapt.readthedocs.io/en/stable/guide.html#demultiplexing) on sequencing data.

The input channel has a typical nf-core sample structure and contains a list of tuples, where the first element is a map with the sample identifier and a boolean indicating if the data is single-end or paired-end, and the second element is a list of file names after cutadapt demultiplexing (the original R1 and R2 fastq files are split into multiple files based on the barcodes which are defined in a barcode file; the barcode is then added to the file name).

The files are sorted (to make sure R1 and R2 files with the same barcode are next to each other) and flattened, then collated into pairs.

The new sample identifier is created from the input file names using string manipulation.
*/

Channel
    .of( 
        [
            [id:'sample1', single_end:false], 
            [
                'trimmed_barcode1_sample1_R2.fastq.gz',
                'trimmed_barcode2_sample1_R1.fastq.gz', 
                'trimmed_barcode2_sample1_R2.fastq.gz', 
                'trimmed_barcode1_sample1_R1.fastq.gz'
            ]
        ],
        [
            [id:'sample2', single_end:false], 
            [
                'trimmed_barcode1_sample2_R1.fastq.gz', 
                'trimmed_barcode2_sample2_R1.fastq.gz', 
                'trimmed_barcode2_sample2_R2.fastq.gz', 
                'trimmed_barcode1_sample2_R2.fastq.gz'
            ]
        ]
    )
    .map( { it[1].sort() } )
    .flatten()
    .collate( 2 )
    .map( { [[id: it[0].split( 'trimmed_' )[1].split('_R')[0], single_end: false], it] } )
    .view()