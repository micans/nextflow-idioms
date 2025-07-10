

params.out = 'publish'


process blob {

   publishDir "${params.out}", mode: 'copy', overwrite: true, pattern: "*.foo"

   input:
   path(x)

   output: stdout emit: dummy
   output: '*.foo'

   shell:
   '''
   foo=!{x}
   wc -c < $foo
   cp $foo ${foo%.txt}.foo
   '''
}

workflow {

  myfiles = Channel.fromPath('[a-e].txt')
  n_bytes = 0

  blob(myfiles)

  blob.out.dummy
   .view()
   .map { it.trim().toInteger() }
   .sum()
   .subscribe { n_bytes = it }

  workflow.onComplete {
    log.info "Total byte count ${n_bytes}\n"
  }

}

