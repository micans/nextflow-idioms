#!/usr/bin/env nextflow

myfiles = Channel.fromPath('[a-e].txt')
n_bytes = 0

process blob {
   input: file x from myfiles
   output: stdout dummy

   script:
   "wc -c < ${x}"
}

dummy
   .into { ch_value; ch_file }

process get_value {
   echo true
   input: val(v) from ch_value
   output: stdout dummy2
   script: "echo value $v"
}

process get_file {
   echo true
   input: file(f) from ch_file
   output: stdout dummy3
   script: "echo file $f"
}


