
Channel.of(1, 2, 3, 4, 5)
   .into { ch_foo_a; ch_bar_a }

Channel.empty()
   .into { ch_foo_b; ch_foo_c; ch_bar_b; ch_bar_c }

// Process foo will run due to the ifEmpty() operators.
// The collect() will make it parallelise over the values from ch_foo_a

process foo {
   
   debug true

   input:
      val a from ch_foo_a
      val b from ch_foo_b.collect().ifEmpty([])
      val c from ch_foo_c.collect().ifEmpty("-")

   shell:
   '''
   echo "(collect) I have values !{a} and !{b} and !{c}"
   '''
}

// Process bar will not run, because some its inputs are empty.

process bar {
   
   debug true

   input:
      val a from ch_bar_a
      val b from ch_bar_b
      val c from ch_bar_c

   shell:
   '''
   echo "(won't be seeing this) I have values !{a} and !{b} and !{c}"
   '''
}

