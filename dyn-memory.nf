

A = file('foobar.txt')

process foo {
        /* Below sets a minimum of 4.GB (4*(1<<30)), and expresses the memory as gigabytes.
         * It uses sqrt(task.attempt) to have a sublinear increase of memory over attempts made.
        */
    memory { 1.GB * Math.max(4*(1<<30), ((1<<30) + (int) task.attempt ** 0.5 * inputfile.size())).intdiv(1<<30) }
    echo true
    input: file(inputfile) from A
    script: "ls $inputfile && echo ${task.memory} ${task.attempt}"
}


