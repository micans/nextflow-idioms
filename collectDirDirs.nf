
process gen_dirs {

  tag "$sample"

  input: val(sample)
  output: path('out_my/???'), emit: ch_merge

  shell:
  '''
  dirname=$(printf "%03d" !{sample})
  mkdir -p out_my/$dirname
  echo 'my !{sample} content' > out_my/$dirname/f!{sample}.txt
  '''
}


process merge_stuff {
   publishDir "results/dirdir/", mode: 'copy'

   input: path('out_new/*')

   output: path('iputs.txt')

   script:
   """
   ls out_new > iputs.txt
   """
}

workflow {

  Channel.of( 1, 3, 5, 7, 9, 11, 13, 15, 17, 19 ).set { ch_input }

  gen_dirs(ch_input) | merge_stuff

  // gen_dirs(ch_input)
  // merge_stuff(gen_dirs.out.ch_merge)


}

