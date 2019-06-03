#!/usr/bin/env nextflow

myfiles = Channel.fromPath('[a-e].txt')
n_bytes = 0

process blob {
   input: file x from myfiles
   output: file 'out' into ch_value, ch_file

   script:
   "wc -c < ${x} > out"
}

process get_value {
   echo true
   input: val(v) from ch_value
   output: stdout dummy2
   script:
   """
   echo -n value $v
   if [[ -f $v ]]; then
      echo " is a regular file"
   else
      echo " is not a regular file"
   fi
   """
}

process get_file {
   echo true
   input: file(f) from ch_file
   output: stdout dummy3
   script: "echo file $f"
}

