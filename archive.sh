name="SYS1"
git archive -v --prefix=$name/ -o zip/$name.zip HEAD .
git bundle create zip/$name.bundle main
