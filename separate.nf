

R1 = Channel.create()
R2 = Channel.create()

Channel.from(['Sample_a', ['a.R1.fastq', 'a.R2.fastq']], ['Sample_b', ['b.R1.fastq', 'b.R2.fastq']], ['Sample_c', ['c.R1.fastq', 'c.R2.fastq']])
  .map { it[1] }
  .separate ( R1, R2 ) { it -> [it[0], it[1]] }

R1.toSortedList()
  .subscribe onNext: { println "list1: " + it }

R2.toSortedList()
  .subscribe onNext: { println "list2: " + it }

