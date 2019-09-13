
Channel.from(['a', [1, 2, 3]], ['b', [4, 5]], ['c', [6, 7, 8]])
   .map { tag, stuff -> tuple( groupKey(tag, stuff.size()), stuff ) }
   .view()
   .transpose()
   .map { tag, num -> [tag, num*num+1 ] }
   .view()
   .groupTuple()
   .view()

