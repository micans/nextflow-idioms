#!/usr/bin/env nextflow


  // Collect the full path names of all files in a channel and store these in a metafile,
  // supply the metafile as input to a process.
  // This is useful for merging processes where the number of input files may run
  // to hundreds or thousands.
  // See also collectFile-tuple.nf for more extensive comments,
  // and collect-into-file.nf.

process star {
  output: file('*.txt') into ch_input
  script: 'for i in {00..09}; do echo "some F $i content" > f$i.txt; done'
}

Channel.from('some z 1\n', 'some z 2\n', 'some z 3\n')
  .set{ ch_z }

ch_input
  .flatMap()
  .mix(ch_z)
  .view()
  .set{ ch_merge }

process merge {
   publishDir "$baseDir/results", mode: 'copy'

   input:
   file inputs from ch_merge.collect()

   output:
   file('catmix.txt')

   script:
   """
   cat $inputs > catmix.txt
   """
}


