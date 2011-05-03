default: create_tarball.sh
	tar cvzf files.tar.gz files
clean: files.tar.gz
	rm files.tar.gz
