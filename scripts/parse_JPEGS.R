# This file is intended to hold functions used to pasrse individual portions of 
# a larger JPEG into smaller ones.

require("jpeg")

# saves a cropped version of the img.matrix into the destination dir
SubsetJPEG <- function(img.matrix, file.name, destination.dir, x.coord, y.coord, width, height) {
	size <- dim(img.matrix)
	
	if(y.coord + height > size[1]) {
		cat('Y co-ordinate and height will be out of bounds on the image matrix')
		return(-1)
	}
	if(x.coord + width > size[2]) {
		cat('X co-ordinate and width will be out of bounds on the image matrix')
		return(-1) 
	}
	# extract file name from path
	dirs <- strsplit(file.name, '/')
	name <- dirs[[1]][length(dirs[[1]])]
	dest.file.name <- paste(name,'_',as.character(x.coord),'_',as.character(y.coord),'.jpeg', sep = '')
	cat(paste('Writing ',dest.file.name, '\n', sep = ''))

	y.seq <- seq(y.coord,y.coord+height)
	x.seq <- seq(x.coord,x.coord+width)
	writeJPEG(img.matrix[y.seq, x.seq, 1:3], paste(destination.dir,'/',dest.file.name, sep = ''),1)
}

# Parses a JPEG in to smaller JPEGs
ParseJPEG <- function(file.name, destination.dir, width, height) {
	img.matrix <- readJPEG(file.name)
	size <- dim(img.matrix)
	i <- 1
	while(i + width <= size[2]) {
		j <- 1
		while(j + height <= size[1]) {
			SubsetJPEG(img.matrix, file.name, destination.dir, i, j, width, height)
			j <- j + height
		}
		i <- i + width
	}
}