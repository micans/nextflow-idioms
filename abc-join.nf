#!/usr/bin/env nextflow
// This script mimics merging results by sample ID in the following scenario:
// A  --ch1---> B  ----ch3---,-----ch4--- C
//  `---------ch2------------'

process processA {        // Create a bunch of files, each with its ow sample ID.
  output: set val('dummy'), file('*.txt') into ch_dummy
  script: 'for i in {1..7}; do echo "sample_$i" > f$i.txt; done'
}
// above and below use transpose trick to serialise the files into two channels,
// just so that we have some example data.
ch_dummy.transpose().map { dummy, f -> [f.text.trim(), f] }.view().into { ch1; ch2 }

process processB {
  input:  set val(sampleid), file(thefile) from ch2
  output: set val(sampleid), file('out.txt') into ch3
  script: "(cat $thefile; md5sum $thefile) > out.txt"
}

ch1.join(ch3).set{ ch4 }

process processC {
  input: set val(sampleid), file(a), file(b) from ch4.view()
  script: "echo $sampleid $a $b"
}
