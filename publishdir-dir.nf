

process foo {
  publishDir "mylog", mode: 'move', pattern: '*.log'
  publishDir "mybcl", mode: 'link', pattern: 'bcl*'

  output:
    file('bcl*') into ch_bcl
    file('*.log')
  script:
  """
    mkdir bcl1; mkdir bcl2; > bcl1/a.txt; > bcl2/b.txt
    echo -e "foo\nbar\nzut" > untar.log
  """
}

process bar {
  echo true
  input: file(mydir) from ch_bcl.flatten()

  script: "echo have file $mydir && ls $mydir"
}

