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

ch_input
  .collectFile { file -> file.collect{ it.toString() }.join('\n') + '\n' }
  .view()
  .set{ ch_merge }

process merge {
   publishDir "$baseDir/results", mode: 'copy'

   input: file metafile from ch_merge

   output: file('*.txt')

   script:
   """
   cat $metafile | while read f; do
      cat \$f
   done > ttt.txt
   """
}


