
R1 = Channel.create()
R2 = Channel.create()

Channel.from(['Sample_a', ['a.R1.fastq', 'a.R2.fastq']]
           , ['Sample_b', ['b.R1.fastq', 'b.R2.fastq']]
           , ['Sample_c', ['c.R1.fastq', 'c.R2.fastq']])

  .separate ( R1, R2 ) { it -> (id, reads) = it; [ [id, reads[0]], [id, reads[1]] ] }

def sortfqlist(thelist) {
   thelist
   .sort { a,b -> a[0] <=> b[0] }
   .collect { it[1] }
}

R1.toList()
  .subscribe onNext: { list = sortfqlist(it); println "list1: " + list }

R2.toList()
  .subscribe onNext: { list = sortfqlist(it); println "list2: " + list }

