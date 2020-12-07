// a common pattern is to have a command take a single option multiple times
// and this option can be used to do things like merge collected outputs
// together in a single process.  e.g.:
//   command --option 1 --option 2 --option 3 [...]

Channel.from( [1,2,3,4,5])
.set{ ch_a }

process foo {
  input: val f from ch_a.collect()
  output:
    stdout myout

  script:

  combined = f.join(' --option ')

  """
    echo command --option ${combined}
    echo ""
  """
}

myout.subscribe { print "$it"}