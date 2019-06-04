#!/usr/bin/env nextflow

params.includeB = true

process processA {        // Create a bunch of files, each with its ow sample ID.
  output: file('*.txt') into ch_dummy
  script: 'for i in {1..7}; do echo "sample_$i" > f$i.txt; done'
}
ch_dummy.flatMap().map { f -> [f.text.trim(), f] }.view().into { ch_doB; ch_skipB }

(ch_AC, ch_AB) = ( params.includeB ? [Channel.empty(), ch_doB] : [ch_skipB, Channel.empty()] )

process processB {
  input:  set val(sampleid), file(thefile) from ch_AB
  output: set val(sampleid), file('out.txt') into ch_BC
  script: "(cat $thefile; md5sum $thefile) > out.txt"
}

ch_BC.mix(ch_AC).set{ ch_C }

process processC {
  publishDir "results"
  input: set val(sampleid), file(a) from ch_C.view()
  output: file('*.out')
  script: "(echo 'C process'; cat $a) > ${sampleid}.out"
}
