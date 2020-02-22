// This is a variant on http://nextflow-io.github.io/patterns/index.html#_problem_19
// using `when` and `until` instead of Channel.empty().

params.includeB = true

process processA {        // Create a bunch of files, each with its ow sample ID.
  output: file('*.txt') into ch_dummy
  script: 'for i in {1..7}; do echo "sample_$i" > f$i.txt; done'
}
ch_dummy.flatMap().map { f -> [f.text.trim(), f] }.view().into { ch_AB; ch_AC }

process processB {
  when: params.includeB
  input:  set val(sampleid), file(thefile) from ch_AB
  output: set val(sampleid), file('out.txt') into ch_BC
  script: "(cat $thefile; md5 $thefile) > out.txt"
}

ch_AC.until{params.includeB}.mix(ch_BC).set{ ch_C }

process processC {
  publishDir "results"
  input: set val(sampleid), file(a) from ch_C.view()
  output: file('*.out')
  script: "(echo 'C process'; cat $a) > ${sampleid}.out"
}


