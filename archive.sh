cd ${0%/*}
name="SYS1"
git archive -v -o zip/$name.zip HEAD .
git bundle create zip/$name.bundle main
zip -rv zip/$name.zip zip/$name.bundle
