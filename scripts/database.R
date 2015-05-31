# this file is intended to hold function related to accessing a SQLite database

# constants for this file
create.table.text <- 'Creating table: '

# fields for this file
db.conn <- NULL

for (package in c('RSQLite')) {
	if(!require(package, character.only=T, quietly=T)) {
		install.packages(package)
		library(pacage, character.only=T)
	}
}

if (!exists('db.name')) {
	print('Loading config file')
	source('config.R')
}

if (exists('db.conn')) {
	rm(db.conn)
}

# deletes database
DeleteDb <- function() {
	if(file.exists(db.name)) {
		print(paste('Deleting ', db.name))
		file.remove(db.name)
	} else {
		print(paste(db.name, ' does not exist, no need to delete'))
	}
}

# returns database connection to database
GetDbConnection <- function() {
	print(paste('getting connector for ', db.name))
	dbConnect(SQLite(), dbname = db.name)
}

CreateSymptomsTable <- function(db.conn) {
	PrintTableLine(symptoms.table)
	dbSendQuery( conn = db.conn, paste('CREATE TABLE ', symptoms.table,' (',
		'id INTEGER PRIMARY KEY AUTOINCREMENT,',
		'symptom TEXT',
		');'
		)
	)
}


CreateParsedDataTable <- function() {
	# TODO(abe): add test for symptoms table
	PrintTableLine(parsed.training.data.table)
	dbSendQuery( conn = db.conn, paste('CREATE TABLE ', parsed.training.data.table,' (',
		'filename TEXT primary key,',
		'symptom_id INTEGER,',
		'FOREIGN KEY(symptom_id) REFERENCES ',symptoms.table,'(symptom_id)',
		');'
		)
	)
}

LoadSymptomsTable <- function(){
	print(paste('Loading table: ', symptoms.table))
	dbSendQuery( conn = db.conn, paste('INSERT INTO ', symptoms.table, '(symptom)',
		'VALUES ("cotton_wool_spots"),',
			'("av_nicking")'
		)
	)
}

# sets up a database for diabetic retinopathy machine learning
SetupDatabase <- function() {
	DeleteDb()
	db.conn <- GetDbConnection()
	CreateSymptomsTable()
	LoadSymptomsTable(db.conn)
	CreateParsedDataTable()
}
