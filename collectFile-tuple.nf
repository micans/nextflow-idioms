#!/usr/bin/env nextflow

  // How to deal with a process that has a large number of input files, say
  // hundreds or thousands, for example when merging the outputs of previous tasks.
  //
  // - Use the Nextflow collectFile() operator.
  // - Nextflow will not link the input files into the work execution directory.
  // - Nextflow will create a metafile with in each line the full path name of an input file.
  // - We can control the naming of the metafile.
  // - The application in the process can use this metafile to know its inputs.
  //
  // This example is more complicated as it features collectFile() on separate
  // groups emitted fromt the same channel.


process star {
  output: set val('star'), file('*.txt') into ch_f
  script: 'for i in {00..14}; do echo "some F $i content" > f$i.txt; done'
}
process moon {
  output: set val('moon'), file('*.txt') into ch_g
  script: 'for i in {00..14}; do echo "some G $i content" > g$i.txt; done'
}

    // In a more realistic example the files in ch_f would come from
    // a process executed many times in parallel, similar for ch_g.
    // We mimic this by using the transpose() operator below.
    // This can be observed by running with -dump-channels input

ch_g.mix(ch_f)
  .transpose()
  .dump(tag: 'input')
  .groupTuple()
  .collectFile { id, files -> [ id, files.collect{ it.toString() }.join('\n') + '\n' ] }
  .into{ch_report; ch_merge}

ch_report.println()

process merge {
   publishDir "$baseDir/results", mode: 'copy'

   input:
   file metafile from ch_merge

   output:
   file('*.output')

   script:
   basename = metafile.baseName
   """
   cat $metafile | while read f; do
      cat \$f
   done > ${basename}.output

   # more realistically, a script/program would e.g. execute
   # my_merge_program -I $metafile 
   """
}

