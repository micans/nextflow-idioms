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
   .map { it.trim().toInteger() }
   .sum()
   .subscribe { n_bytes = it }

workflow.onComplete {
   log.info "Total byte count ${n_bytes}\n"
}

