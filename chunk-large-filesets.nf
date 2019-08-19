
process make_file {
  output: file('*.txt') into ch_f
  script: 'for i in {00..09}; do echo "some F $i content" > f$i.txt; done'
}

ch_f.flatten().set{ch_g}        // This is just to make some example files.

process make_md5_index {
  input: file myfile from ch_g
  output: set file('*.vcf'), file('*.md5') into ch_h
  script:
  """
  g=${myfile}
  cp ${myfile} \${g%.txt}.vcf
  md5sum ${myfile} > \${g%.txt}.md5
  """
}                               // After this we have dummy vcf file and dummy index (md5) file

ch_h
  .buffer(size: 3, remainder: true)
  .map { mytuple -> [ mytuple.collect{ it[0] }, mytuple.collect{ it[1] } ] }    // split into vcfs and md5s
  .set{ch_i}

process chunk {
   echo true

   input:
   set file(vcfs), file(md5s) from ch_i

   script:
   """
   echo "my vcfs: ${vcfs}"
   echo "my md5s: ${md5s}"
   """
}

