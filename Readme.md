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


#### April 25, 2021

- Ran into an issue with RPostgreSQL not installing in linux. Use this command to fix: `sudo apt-get install libpq-dev`

#### April 21, 2021


- Wasn't able to correctly parse UTF-8 files in windows. Issue arose when trying to import labels for survey question choises. I had to switch to RStudio Server in WSL2 ([how-to here](https://support.rstudio.com/hc/en-us/articles/360049776974-Using-RStudio-Server-in-Windows-WSL2))

- Exporting PG database steps:


1. Create dump from PG
```

Inside the container:

docker exec -it <CONTAINER_ID> bash
pg_dump -U c2m2 -h localhost c2m2 >> /var/tmp/c2m2_dump.sql


Outside the container:
docker cp <CONTAINER_ID>:/var/tmp/c2m2_dump.sql ./
```

#### March 25, 2021

---

**Should we `gitignore` raw files?**

> Maybe its a good idea to do that, but might need to include the original XLSForm, in case someone wants to carry ourt their own deployment.     
 
