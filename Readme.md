# C2M2 Kathmandu Portal Data
This repo contains all the R code for C2M2 Kathmandu portal, from KoboCollect to ADS preparation.


## Directory structure

- `/raw` contains data received as-is from Kobo
- `/utils` contains Rscripts shared by other modules
- `/experimental` contains test code, intermediate outputs and so on.
- `/core` contains Rscripts for the data pipeline, organized by survey, i.e., scripts encompassing the Kobo ➜ ADS for the workforce and business surveys.


## Process

1. Base table schema design + generation of data dictionary.
1. Data cleaning, and base table preparation in R.
2. Export base table to PG database.
2. Use PG database as source for further analysis + ADS preparation codes.     
3. Create PG Dump file for populating APIDB.


## Notes
*Use this space to write down observations.*

#### March 25, 2021

---

**Should we `gitignore` raw files?**

> Maybe its a good idea to do that, but might need to include the original XLSForm, in case someone wants to carry ourt their own deployment.     
 
