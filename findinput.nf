params.inputdir="specify-me-please"

process get_data {
  output: file('index.txt') into channel_index

  shell:
  '''
  find !{params.inputdir} -name '*.txt' > index.txt
  '''
}

process use_data {
  echo true
  input: file myfile from channel_index.readLines().flatMap().map{file(it)}.view()

  shell:
  '''
  cat !{myfile}
  '''
}
