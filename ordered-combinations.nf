
Channel.from('A', 'B', 'C', 'D')
  .toList().map{ ['dummy', [it, it].combinations().findAll{ a, b -> a < b}] }
  .transpose()
  .map { it[1] }
  .view()

