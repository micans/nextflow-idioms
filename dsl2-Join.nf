
// Simple example of channel wrangling in DSL 2; join two channels.

process processB {
  input:  tuple val(sampleid), val(yval)
  output: tuple val(sampleid), path('*.txt'), emit: txt
  shell: 'echo !{yval} > !{sampleid}-!{yval}.txt'
}

process processA {
  input:  tuple val(sampleid), val(xval)
  output: tuple val(sampleid), path('*.txt'), emit: txt
  shell: 'echo !{xval} > !{sampleid}-!{xval}.txt'
}

process processAB {
  publishDir 'tstAB', mode: 'copy'
  input:  tuple val(sampleid), path(a), path(b)
  output: path('*.txt')
  shell: 'cat !{a} !{b} > AB!{sampleid}.txt' 
}

workflow {

    processA ( Channel.of(['X', 'donkey'], ['Y', 'horse'] ))
    processB ( Channel.of(['X', 'diligent'], ['Y', 'hoarse'] ))
 
    processAB( processA.out.txt.join( processB.out.txt ).view() )

}

