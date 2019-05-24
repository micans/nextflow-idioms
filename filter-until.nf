#!/usr/bin/env nextflow

a = Channel.from(['a', 'b', 'c', 'd', 'e', 'f', 'g'])

found = false
a.filter{ found || (it == 'd' && (found = true) && false ) }
.view()

