all: test

test:
	@vim -X -N -u NONE -i NONE -V1 -e -s +'set runtimepath+=.' +'call test#run()'
