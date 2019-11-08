
Channel.from([['a', [1, 2, 3]], ['b', [10,11, 12]], ['a', [4,5,6]], ['b', [13,14,15]]])
   .transpose()
   .view()
   .groupTuple()
   .view()

