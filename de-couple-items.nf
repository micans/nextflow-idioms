
ch1 = Channel.create()
ch2 = Channel.create()

Channel.from([['samp1', 1,'one'], ['samp2', 2,'two'], ['samp3', 3,'three'], ['samp4', 4,'four'], ['samp5', 5,'five']])
   .map { [ [it[0], it[1]], [it[0], it[2]] ] }.view()
   .separate ( ch1, ch2 )

process a {
   input: set val(sampid), val(x) from ch1.view()
   output: set val(sampid), val(xx) into ch_a
   shell: xx = x+x
   'true'
}

process b {
   input: set val(sampid), val(x) from ch2.view()
   output: set val(sampid), val(xx) into ch_b
   shell: xx = x+x
   'true'
}

process c {
   echo true
   input: set val(sampid), val(resa), val(resb) from ch_a.join(ch_b)
   shell: 'echo "!{sampid} !{resa} !{resb}"'
}

