#!/usr/bin/env nextflow

  // Create a bunch of files, associate with a random number in 0..9,
  // create random/transient errors for a subset of them,
  // then filter them using a custom Groovy function.

params.threshold = 5

process make_files {
  output: file '*.txt' into ch_genesis       // These files are serialised below
  script:
  """
  for i in {00..15}; do
    rv=\$((\$RANDOM % 13))
    echo "reads \$rv" > f\$i.txt
  done
  """
}

ch_nums = Channel.from(0,1,2,3,4,5,6,7,8,9)


ch_genesis                    // Just some work to create a channel ....
  .flatMap()                  //    (serialise)
  .merge(ch_nums)             //    (add integers values)
  .map { it.reverse() }       // That has tuples [i, file]
  .set { ch_transient }


      // This will flip a (biased) coin, and decide to pass files along,
      // or fail. This is a stochastic error, transient, potentially recurrent;
      // May or may not happen once or repeatedly.
process transient_error {

  // errorStrategy 'ignore'
  // errorStrategy 'retry'

  errorStrategy { task.attempt <= 3 ? 'retry' : 'ignore' }
  maxRetries 3

  output: set val(i), file('newfile.txt') into ch_filter

  input: set val(i), file(afile) from ch_transient
  script:
  if (task.attempt > 0) {
    log.info "-- attempt ${task.attempt} value $i file $afile"
  }
  """
  read txt val < $afile
  rv=\$((\$RANDOM % 10))
  if (( \$rv > 4 )); then       # This fails 50% of the time.
    (echo "attempt ${task.attempt}"; cat $afile) > newfile.txt
  else
    false
  fi
  """
}

n_ok = 0

      // A filter function that looks inside a file; it says its ok
      // if there are at least params.threshold reads.
      //
def myfilter(i, afile) {
   percent = 0
   afile.eachLine { line ->
      if ((matcher = line =~ /reads (\d+)/)) {
         percent = matcher[0][1].toInteger()
log.info "file $i percent $percent found"
      }
   }
   if (percent < params.threshold) {
      return false
   }
   else {
      n_ok++
      return true
   }
}

ch_filter
  .filter { i, f -> myfilter(i, f) }
  .view()
  .set{ ch_output }


process publish {
   publishDir "$baseDir/results", mode: 'copy'

   input:
   set val(i), file(afile) from ch_output

   output:
   file('anotherfile.*')

   script:
   """
   cp $afile anotherfile.$i
   """
}


workflow.onComplete {
   log.info "passed threshold: $n_ok"
}

