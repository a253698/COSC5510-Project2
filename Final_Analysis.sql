/* SQL query for running the analysis */

/* Annual number of nonfatal all-drug overdoses in ED and HOSP each year?  */
SELECT `year`, `source`, SUM(`count_alldrug`) AS `number_of_nonfatal_overdoses` FROM DBMSProject2.sex_age_drug_count GROUP BY `year`, `source`;
SELECT `year`, SUM(`count_alldrug`) AS `number_of_nonfatal_overdoses` FROM DBMSProject2.sex_age_drug_count GROUP BY `year`;

/* How many state participate in submission? */
SELECT COUNT(DISTINCT(`state_code`)), `year`, `source` FROM DBMSProject2.state_drug_count GROUP BY `year`, `source`;
SELECT year, COUNT(DISTINCT(`state_code`)) AS `num_states_reported` FROM DBMSProject2.state_drug_count GROUP BY `year`

/* In 2018, states which have top 2 non-fatal yearly overdose rate */
SELECT `state_code`,`year`, SUM(`count_alldrug`) FROM DBMSProject2.state_drug_count WHERE `year`=2018 GROUP BY  `state_code`,`year` ORDER BY SUM(`count_alldrug`) DESC LIMIT 2;

/* From 2018-2022, states which have top 3 nonfatal yearly overdose count?   */
SELECT * FROM ( SELECT sa.`state`, sdc.`year`, SUM(sdc.`count_alldrug`) AS sum_alldrug_count, rank() OVER (PARTITION BY `year` ORDER BY (SUM(`count_alldrug`)) DESC) AS `ranking` FROM DBMSProject2.state_drug_count sdc LEFT JOIN DBMSProject2.state_abbreviation sa ON sdc.`state_code` = sa.`state_code` GROUP BY sdc.`state_code`, sdc.`year`) AS temp_table WHERE temp_table.`ranking` <=3;

/* The nonfatal overdose rate? Is the top 3 states same as 3 non-fatal overdose count? */
SELECT * FROM ( SELECT sa.`state`,  sdc.`year`, AVG(sp.`monthly_state_population`) AS avg_monthly_state_population, SUM(sdc.`count_alldrug`) AS sum_count_alldrug, ROUND(SUM(sdc.`count_alldrug`)/AVG(sp.`monthly_state_population`)*100, 2) AS `drug_use_rate`, RANK() OVER ( PARTITION BY sdc.`year` ORDER BY SUM(sdc.`count_alldrug`)/AVG(sp.`monthly_state_population`) DESC ) AS `drug_use_rate_rank` FROM DBMSProject2.state_drug_count sdc LEFT JOIN DBMSProject2.state_population sp ON sdc.`year` = sp.`year` AND sdc.`state_code` = sp.`state_code` LEFT JOIN DBMSProject2.state_abbreviation sa ON sdc.`state_code` = sa.`state_code` GROUP BY sdc.`state_code`, sdc.`year` ) AS temp_table  WHERE temp_table.`drug_use_rate_rank` <= 3; 

/* From 2018 to 2022, How did the overdose rate change by states? */
SELECT state_abbreviation.state, Table4.overdose_rate-Table3.overdose_rate AS overdose_rate_change FROM ( SELECT Table1.state_code, Table1.yearly_alldrug/Table2.monthly_state_population AS overdose_rate FROM (SELECT state_code, SUM(count_alldrug) AS yearly_alldrug FROM state_drug_count WHERE year = 2018 GROUP BY state_code) AS Table1 RIGHT JOIN (SELECT state_code, monthly_state_population FROM state_population WHERE month = 12 AND year = 2018) AS Table2 ON Table1.state_code = Table2.state_code) AS Table3 INNER JOIN ( SELECT Table1.state_code, Table1.yearly_alldrug/Table2.monthly_state_population AS overdose_rate FROM (SELECT state_code, SUM(count_alldrug) AS yearly_alldrug FROM state_drug_count WHERE year = 2022 GROUP BY state_code) AS Table1 RIGHT JOIN (SELECT state_code, monthly_state_population FROM state_population WHERE month = 12 AND year = 2022) AS Table2 ON Table1.state_code = Table2.state_code) As Table4 ON Table3.state_code = Table4.state_code INNER JOIN state_abbreviation ON state_abbreviation.state_code = Table3.state_code ORDER BY overdose_rate_change DESC;
/* What age group has the highest overdose count from 2018 to 2022? */
SELECT TempTable.age AS age, TempTable.year AS year, TempTable.yearly_alldrug AS yearly_count_alldrug FROM (SELECT age, year, SUM(count_alldrug) AS yearly_alldrug FROM sex_age_drug_count GROUP BY age, year) AS TempTable RIGHT JOIN (SELECT MAX(TempTable1.yearly_alldrug)AS age_max FROM (SELECT age, year, SUM(count_alldrug) AS yearly_alldrug FROM sex_age_drug_count GROUP BY age,year)AS TempTable1 GROUP BY year) AS TempTable2 ON TempTable.yearly_alldrug = TempTable2.age_max;

/* And what kind of drug use among each age group. */
SELECT age, CASE WHEN GREATEST(SUM(count_opioid), SUM(count_heroin), SUM(count_stimulant)) = SUM(count_opioid) THEN 'opioid' WHEN GREATEST(SUM(count_opioid), SUM(count_heroin), SUM(count_stimulant)) = SUM(count_heroin) THEN 'heroin' WHEN GREATEST(SUM(count_opioid), SUM(count_heroin), SUM(count_stimulant)) = SUM(count_stimulant) THEN 'stimulant' END AS Drug FROM ( SELECT age, year, SUM(count_opioid) as count_opioid, SUM(count_heroin) as count_heroin, SUM(count_stimulant) as count_stimulant FROM sex_age_drug_count GROUP BY age, year ) AS age_drug GROUP BY age;


/* Data Cleaning with Excel: 
Remove duplicate or irrelevant observations.
Removing yearly data.
Fix structural errors.
Handle missing data. 
Drop the data that's not disclosed or made publicly available. 
 */

 /*
 All table is in BCNF
 */

/* More details of this project introduction, dataset selection, the data cleaning process, normalization processes and scheme can be found here: https://docs.google.com/document/d/199GgA8BGkCKOUJ6b16gEqntrWcM3bljv/edit?usp=sharing&ouid=107909954438639333398&rtpof=true&sd=true */
