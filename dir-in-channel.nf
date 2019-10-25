

process foo {
  output: file('foo') into ch_bar
  script: 'mkdir foo && touch foo/foo.txt'
}
process bar {
  echo true
  input: file('foo') from ch_bar
  script: 'echo "content of bar" && ls foo'
}


