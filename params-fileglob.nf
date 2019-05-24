
params.input_files = '*.vfl'

Channel.fromPath( params.input_files )
.view()
.set{ ch_a }


process foo {

  publishDir 'VFL'

  input:
  file f from ch_a

  output:
  set file('*.vfl3'), file('*.vfl2')

  script:
  """
  cp $f ${f}2
  cp $f ${f}3
  """
}

