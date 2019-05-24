
process processA {
  output: file "name.txt" into name_ch

  script:
  """
    #!/usr/bin/python
    with open("name.txt", 'w') as file1:
      file1.write("/nfs/users/nfs_s/svd/git/cellgeni/patterns/file2.txt")
  """
  // ^ Note that full path is required.
}

process process_file2 {
  input: file(file2) from name_ch.map { file(it.text) }

  script:
  """
  echo I have file $file2
  """
}

