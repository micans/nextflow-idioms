#!/usr/bin/env nextflow

process star {
  output: file('*.txt') optional true into ch_input
  script: 'for i in {1..9}; do echo "$i" > f$i.txt; done'
}

ch_input
  .flatMap()
  .map { it.text.trim().toBigInteger() }
  .view()
  .map { it ** it }
  .view()
  .collect()
  .subscribe { numreads = it }


workflow.onComplete {

    summary = [:]
    summary['total read count'] =  numreads.inject(0, { sum, value -> sum + value } )

    log.info "========================================="
    log.info summary.collect { k,v -> "${k.padRight(15)}: $v" }.join("\n")
    log.info "========================================="
}


