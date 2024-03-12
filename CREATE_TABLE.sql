DROP DATABASE IF EXISTS DBMSProject2;
CREATE DATABASE IF NOT EXISTS DBMSProject2;
USE DBMSProject2;
DROP TABLE IF EXISTS country_submission_count,county_count,fips_code,sex_age_drug_count,state_abbreviation,state_drug_count,state_population;


CREATE TABLE country_submission_count(
    sourse    VARCHAR(4)    NOT NULL,
    month   INT     NOT NULL,
    year   YEAR(4)     NOT NULL,
    jurisdiction_count   INT     NOT NULL,
    PRIMARY KEY (`month`, `year`, `sourse`)
);

CREATE TABLE county_count(
    fips   INT  NOT NULL,
    year   YEAR(4)   NOT NULL,
    count_alldrug   INT  NOT NULL,
    population	INT  NOT NULL,
   PRIMARY KEY (`fips`, `year`)
);

CREATE TABLE fips_code(
    state     INT        NOT NULL,
    county   CHAR(50)   NOT NULL,
    fips     INT     NOT NULL,
    PRIMARY KEY (`fips`)
); 

CREATE TABLE sex_age_drug_count(
sex VARCHAR(1) NOT NULL ,
age VARCHAR(10) NOT NULL ,
month INT NOT NULL ,
year YEAR(4) NOT NULL ,
source VARCHAR(4) NOT NULL ,
count_alldrug BIGINT NOT NULL ,
count_opioid BIGINT NOT NULL ,
count_heroin BIGINT NOT NULL ,
count_stimulant BIGINT NOT NULL ,
PRIMARY KEY (`sex`, `age`, `month`, `year`, `source`)
);

CREATE TABLE state_abbreviation(
state VARCHAR(20) NOT NULL ,
state_code VARCHAR(2) NOT NULL ,
PRIMARY KEY (`state_code`)
);

CREATE TABLE state_drug_count(
state_code VARCHAR(2) NOT NULL ,
month INT NOT NULL ,
year YEAR(4) NOT NULL ,
source VARCHAR(4) NOT NULL ,
count_alldrug TEXT NOT NULL ,
count_opioid TEXT NOT NULL ,
count_heroin TEXT NOT NULL ,
count_stimulant TEXT NOT NULL ,
PRIMARY KEY (`state_code`, `month`, `year`, `source`)
);

CREATE TABLE state_population(
state_code VARCHAR(2) NOT NULL ,
month INT NOT NULL ,
year YEAR(4) NOT NULL ,
monthly_state_population INT NOT NULL ,
PRIMARY KEY (`state_code`, `month`, `year`)
);


LOAD DATA LOCAL INFILE "/Users/chaochinliu/Documents/GitHub/COSC5510-Project2/opioid_overdose_nonfatal_cvs/country_submission_count.csv"
INTO TABLE	country_submission_count
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "/Users/chaochinliu/Documents/GitHub/COSC5510-Project2/opioid_overdose_nonfatal_cvs/county_count.csv"
INTO TABLE	county_count
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "/Users/chaochinliu/Documents/GitHub/COSC5510-Project2/opioid_overdose_nonfatal_cvs/fips_code.csv"
INTO TABLE	fips_code
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "/Users/chaochinliu/Documents/GitHub/COSC5510-Project2/opioid_overdose_nonfatal_cvs/sex_age_drug_count.csv"
INTO TABLE	sex_age_drug_count
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "/Users/chaochinliu/Documents/GitHub/COSC5510-Project2/opioid_overdose_nonfatal_cvs/state_abbreviation.csv"
INTO TABLE	state_abbreviation
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "/Users/chaochinliu/Documents/GitHub/COSC5510-Project2/opioid_overdose_nonfatal_cvs/state_drug_count.csv"
INTO TABLE	state_drug_count
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "/Users/chaochinliu/Documents/GitHub/COSC5510-Project2/opioid_overdose_nonfatal_cvs/state_population.csv"
INTO TABLE	state_population
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;