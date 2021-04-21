## Data flow

To help you follow the data, the following section shows the overall data flow. This gives us an indication of the different I/O steps involved.  

```
Main Route:
XLSForm > Kobo Dashboard > Raw Survey Data XLS > R Scripts


Sub Route 1:
R Scripts > Bivariate Statistics Table > PG Database for API use > Crosstabs Visualization API


Sub Route 2:
R Scripts > Univariate Statistics Table > PG Database for API use > Unvariate analysis visualization API (similar to ODP)

```
#### Notes: 
1. We need to carefully design the input and output tables/JSONs/CSVs at different stages.
2. Different people are involved at different stages. We need to synchronize our variables names and data formats efficiently.
3. Ideally, we want no manual steps. Therefore, practically, we would want to minimize.


## Data processing

This section lists out all the things I did for data processing. This should aid us in future projects as well.

### Data related things to do at **XLSForm**
1. Rename variables: You should pay careful attention to the names you assign to different questions and option variables throughout your XLSForm (read about [XLSForm](https://xlsform.org) here). 

2. Tip 1: Have a system for naming that helps you easily call variables in R. When designing your own conventions, think about whether that convention is easy for others to understand as well. 

> As an example, in our worker's question, we've used suffixes (`i_` for impact, `p_` for preparedness, `m_` for metadata, `o_` for outlook, `b_` for baseline). We have also grouped similar columns( e.g.,`_econ` for questions around economic effects of Covid19, `_lvlhd_` for effects to workers' livelihoods. Finally we've tried using shorter names (like `shrt_names`). However, when naming variables, we've prioritized readability and specificity over name length (Good name `p_econ_hhd_items_pre_covid` Bad name: `p_e_h_pc`)

3. Tip 2: Don't fret too much. This is an iterative process.  Note however, that once you go live, don't change variable names. You've got until then to experiment and come up with a usable, legible naming convention for your variables.

4. Tip 3: In the XLS form, the columns you need to work with are:
    1. "name" column in the "survey" sheet 
    1. "list_name" column in the "choices" sheet 



### Data related things to do at **Kobo Dashboard stage**
1. Use appropriate download settings, here's what we use. Note that the "Group Seperator" - though disabled - is set to "__" (two underscores.) This is important and must be followed.

![](/misc/KoboExportSettings.png)

2. Not much else, Bhawak uploads the file and deploys the survey here.


### Data related things to do at **Raw Survey Data XLS**:
Nothing. This is the idea, to not play with the data file. Everything must be doneeiather before this stage or after this stage.

### Data related things to do at **R Scripts** stage:

1. :heavy_check_mark: Generate tables for API use:
    a. univariate stats table
    b. Bivartiate stats table
    c. ...other?
2. :heavy_check_mark: Finalize variable names for API use. The `keys`, `values`, `labels`, if set here, can simplify integration to Django.
3. Isolate single-select, multiselect variables.
3. Think of what to do for branced variables
3. :heavy_check_mark: Map variable names to respective labels in English and Nepali. 
4. More:
    -  :heavy_check_mark: write reusable, general functions
    - Simplify code
    - Use comments
    - Name properly
    - etc.

