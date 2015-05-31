#!/usr/bin/env

import sys
import os

num_of_dir = 0
len_of_num = 0
dir_start = 'jpegs'

def main(argv):
	if len(sys.argv) != 2:
		print('This script should be called in the following manner:')
		print('python setup_directories <number of directories>')
	else:
		try:
			num_of_dir = int(sys.argv[1])
			len_of_num = len(sys.argv[1])
		except:
			print('The number of directories argument must be an integer') 

	for x in range(1, num_of_dir + 1):
		dir_name = dir_start + str(x).zfill(len_of_num)
		try:
			os.makedirs(dir_name)
		except OSError:
			if not os.path.isdir(dir_name):
				raise

	list_dir = os.listdir('.')
	count = 0
	for file in list_dir:
		if file.endswith('jpeg'):
			end_ind = file.find('_')
			file_num = int(file[:end_ind])
			dir_num = file_num % num_of_dir + 1
			dir_name = dir_start + str(dir_num).zfill(len_of_num)
			os.rename(file, dir_name + '//' + file)

if __name__ == "__main__":
	main(sys.argv)
