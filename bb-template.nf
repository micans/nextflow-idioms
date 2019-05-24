#!/usr/bin/env nextflow

params.metadata = "datalist.txt"
params.datadir  = "rubendata"
params.outdir   = "bc-results"


Channel.fromPath(params.metadata)
  .flatMap{ it.readLines() }
  .view()
  .set { ch_datalist }


process get_datasets {

    tag "$datasetname"

    input:
    val datasetname from ch_datalist

    output:
    set val(datasetname), file('*.h5ad') into ch_bbknn, ch_scanorama
    set val(datasetname), file('*.rds') into  ch_R_harmony,  ch_R_mnn

    shell:
    '''
    pyfile="!{params.datadir}/!{datasetname}.h5ad"
    Rfile="!{params.datadir}/!{datasetname}.rds"
    if [[ ! -e $pyfile || ! -e $Rfile ]]; then
      echo "Please check existence of $pyfile and $Rfile"
      false
    fi
    ln -s $pyfile .
    ln -s $Rfile .
    '''
}


process py_bbknn {

    tag "bbknn (py) $datasetname"

    input:
    set val(datasetname), file(datain) from ch_bbknn

    output:
    set val(datasetname), val('bbknn'), file('scana.*.h5ad') into ch_bbknn_entryopy

    shell:
    '''
    cat !{datain} > scana.!{datasetname}.h5ad
    '''
}


process py_scanorama {

    tag "scanaorama (py) $datasetname"

    input:
    set val(datasetname), file(datain) from ch_scanorama

    output:
    set val(datasetname), val('scanorama'), file('scana.*.h5ad') into ch_scanorama_entropy

    shell:
    '''
    cat !{datain} > scana.!{datasetname}.h5ad
    '''
}

ch_bbknn_entryopy.mix(ch_scanorama_entropy).set{ch_py_entropy}

process R_harmony {

    tag "harmony (R) $datasetname"

    input:
    set val(datasetname), file(datain) from ch_R_harmony

    output:
    set val(datasetname), val('harmony'), file('harmony.*.rds') into ch_R_entropy1

    shell:
    '''
    cat !{datain} > harmony.!{datasetname}.rds
    '''
}

process R_mnn {

    tag "mnn (R) $datasetname"

    input:
    set val(datasetname), file(datain) from ch_R_mnn

    output:
    set val(datasetname), val('mnn'), file('mnn.*.rds') into ch_R_entropy2

    shell:
    '''
    cat !{datain} > mnn.!{datasetname}.rds
    '''
}

ch_R_entropy1.mix(ch_R_entropy2).set{ch_R_entropy}


process R_entroy {

    tag "entropy (R) $datain $method $datasetname"

    publishDir "${params.outdir}", mode: 'copy'

    input:
    set val(datasetname), val(method), file(datain) from ch_R_entropy

    output:
    file('*.epy')

    shell:
    '''
    echo "!{datasetname} !{method} !{datain}" > "!{method}.!{datasetname}.epy"
    '''
}

process py_entroy {

    tag "entropy (python) $datain $method $datasetname"

    publishDir "${params.outdir}", mode: 'copy'

    input:
    set val(datasetname), val(method), file(datain) from ch_py_entropy

    output:
    file('*.epy')

    shell:
    '''
    echo "!{datasetname} !{method} !{datain}" > "!{method}.!{datasetname}.epy"
    '''
}





