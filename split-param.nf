params.modes = '1,2,3,4,5'

Channel.from( params.modes.tokenize(',') )
.view()
.set{ ch_a }

process foo {
  input: val f from ch_a
  script: "echo $f"
}
