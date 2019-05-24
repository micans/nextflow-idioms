#!/usr/bin/env nextflow

params.in = "foobar"
process print_sleep {
    input:
    val foo from "${params.in}"

    output:
    stdout into result

    script:
    """
    echo ${foo} && sleep 1
    """
}

result.subscribe { println it }
