#!/usr/bin/env nextflow

a = Channel.from(['a', 'b', 'c', 'd', 'e', 'f', 'g'])

process foo {
  input:
  val bar from a.collect()

  script:
  zut = bar.collect{ "--par $it" }.join(' ')
  """
  echo $zut
  """
}


