
Channel.from([['A', 10], ['B', 8], ['C', 5], ['D', 4]])
  .toList().map{ [it, it].combinations().findAll{ a, b -> a[1] < b[1]} }
  .flatMap()
  .view()

