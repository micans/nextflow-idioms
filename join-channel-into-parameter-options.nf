

Channel.from( [1,2,3,4,5])
.collect()
// .view()
.set{ ch_a }

process foo {
  input: val f from ch_a
  output:
    stdout myout


  script:

  combined = f.join(' --input ')

  """
    echo command --input ${combined}
  echo ""
  """
}

myout.subscribe { print "$it"}