all: Plex
	nvcc -rdc=true plex.cu helpers/helper.cu helpers/checks.cu fileops/plexFile.cu  -o Plex