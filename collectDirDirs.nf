#!/usr/bin/env nextflow


ch_input = Channel.from( 1, 3, 5, 7, 9, 11, 13, 15, 17, 19 )

process gen {
  tag "$sample"

  input:
  val sample from ch_input
  output: file('out_my/???') into ch_merge

  shell:
  '''
  dirname=$(printf "%03d" !{sample})
  mkdir -p out_my/$dirname
  echo 'my !{sample} content' > out_my/$dirname/f!{sample}.txt
  '''
}


process merge {
   publishDir "$baseDir/results", mode: 'copy'

   input:
   file('out_new/*') from ch_merge.collect()

   output:
   file('iputs.txt')

   script:
   """
   ls out_new > iputs.txt
   """
}


