# Project: Biological Computing Bootcamp Coursework
This is a repository to store coursework created as part of the biological computing bootcamp at Imperial College London Silwood Park 2026

## Author
Aiyanuj Wongkomet (aiyanuj@gmail.com / ai.wongkomet23@imperial.ac.uk)

## Running the codes
The files can be run from the coursework root directory terminal using the commands in the code blocks



## Assignment 1

### **unixPrac1.txt** - inspect and summarise FASTA genome sequences
```
bash code/unixPrac1.txt 
```
- functions
1. Count file lines
2. Display sequence lines
3. Count sequence length
4. Count a literal motif (ATGC)
5. Calculate AT/GC ratio
- input: data/fasta407228326.fasta data/fasta/407228412.fasta data/fasta/e_coli.fasta
- output: terminal lines
- changes after feedback: remove the use of intermediate fasta file for counting bases and count from the input file directly, untrack the intermediate file

### **tabtocsv.sh** - change tab delimited file to comma delimited
```
bash code/tabtocsv.sh data/tab-example.tsv
```
- convert tsv to csv file, produce useful errors for missing, unreadable, or invalid input, or when output is saved unsuccessfully
- input: data/tab-example.tsv
- output: results/tab-example.tsv.csv
- changes after feedback: add error messages for when input is not exactly one or output is not in the results directory, correct the results directory path, use printf instead of echo, run the code with different cases of invalid input in the terminal to check the errors are working

### **csvtospace.sh** - change comma delimited file to space delimited
```
bash code/csvtospace.sh data/temperatures/1800.csv
bash code/csvtospace.sh data/temperatures/1801.csv
bash code/csvtospace.sh data/temperatures/1802.csv
bash code/csvtospace.sh data/temperatures/1803.csv
```
- convert csv to space delimited txt file, produce useful errors for missing, unreadable, or invalid input, or when output is saved unsuccessfully
- input: data/temperatures/1800.csv data/temperatures/1801.csv data/temperatures/1802.csv data/temperatures/1803.csv 
- output: results/1800.csv.txt results/1801.csv.txt results/1802.csv.txt results/1803.csv.txt
- changes after feedback: add error messages for when input is not exactly one or output is not in the results directory, correct the results directory path, run the code with different cases of invalid input in the terminal to check the errors are working



## Assignment 2

### **clean_silwood_trees.py** - validate and clean the tree survey file
```
python3 code/clean_silwood_trees.py
```
- the codes clean the tree survey data, accept valid entries, reject entries with missing or invalid values, compile the accepted and rejected records, and produce a summary of oak trees count by species
- metadata (contains the intruction for cleaning and rejection): data/silwood_trees_metadata.md
- input: data/silwood_trees_raw.csv
- output: 
  1. results/silwood_trees_clean.csv (accepted records)
  2. results/silwood_tree_issues.csv (rejected records and reasons)
  3. results/oak_species_counts.csv (oak count summary)
- testing:
```
python3 code/test_silwood_trees.py
```

#### Function explanations and pseudocodes:

1. **validate_records**   
for each record, run through each column, clean entry, return rejection reason in `errors` if the entry is missing/invalid/duplicate (using canonical rejection reasons from the metadata), otherwise add the entry to `cleaned`, if there is one or more errors then `cleaned` is converted to 'None'
```
    cleaned:
    errors:

    record_id:  
            remove surrounding whitespace  
            if record_id == ""  
                reject 'missing record_id'  
            else if record_id != "ST" and exactly three digits  
                reject 'invalid record_id'  
            else if record_id in accepted_id  
                reject 'duplicate record_id'  
            else  
                append accepted_id  
                append cleaned  
    Valid_locations = ["Silwood Bottom", "Nash's Field", "Manor House", "Reactor Wood"]  
    location:  
            remove surrounding whitespace  
            if location == ""  
                reject 'missing location'  
            else if location != == Valid_locations, ignoring letter case  
                'invalid location'  
            else  
                append cleaned  
    Valid_genus = [ "Quercus", "Acer", "Betula", "Fagus", "Fraxinus" ]  
    genus:  
            remove surrounding whitespace  
            if genus == ""  
                reject 'missing genus'  
            else if genus != == Valid_genus, ignoring letter case  
                reject 'invalid genus'  
            else  
                append cleaned  
    Valid_species = ["robur", "petraea", "pseudoplatanus", "pendula", "sylvatica", "excelsior"]  
    species:  
            remove surrounding whitespace  
            if species == ""  
                reject 'missing species'  
            else if species != == Valid_species, ignoring letter case  
                reject 'invalid species'  
            else  
                append cleaned  
    Valid_taxonpairs = []  
    if genus and species valid:  
        if (cleaned[genus], cleaned[species]) not in Valid_taxonpairs:  
            reject 'invalid genus/species combination'  
    distance_m:  
            if distance_m == ""  
                reject 'missing distance_m'  
            else if distance_m <0 or >100  
                reject 'distance_m out of range'  
            else   
                append cleaned  
    angle_degrees  
            if angle_degrees == ""  
                reject 'missing angle_degrees'  
            else if angle_degrees <0 or >90  
                reject 'angle_degrees out of range'  
            else  
                append cleaned  

    if errors:  
        cleaned = None  

    return cleaned, errors  
```

2. **process_records**  
sort accepted and rejected records into two lists, append records in `cleaned` to `accepted`, and append `errors` to `issues`  
```
    accepted = []  
    issues = []  

        for row in records:  
        cleaned, errors = validate_records()  

        if cleaned is not None:  
            accepted.append = cleaned  
        else:  
            issues.append = errors  

    return accepted, issues  
```

3. **summarise_oaks**   
count the number of oaks in the accepted records by species  
```
    robur_count = 0  
    petraea_count = 0  

    if clean["genus"] == "Quercus":  
        if clean_records["species"] == "robur":  
            robur += 1  
        else if clean["species"] == "petraea":  
            petraea += 1  

    oak_counts = ({'species':'robur', 'count': robur_count }, {'species':'petraea', 'count': petraea_count })  
    return oak_counts  
```

#### Testing:

**checkpoint print tests**:  
```
    records = load_records()  

    print("Loaded Silwood trees data:")  
    for row in records:  
        print(row)  

    clean_records, issues = process_records(records)  

    print("Accepted records: ")  
    for record in clean_records:  
        print(record)  

    print("Issue report: ")  
    for record in issues:  
        print(record)  

    oak_counts = summarise_oaks(clean_records)  

    print(oak_counts)  
```

**importing modules test**:  
```
from clean_silwood_trees import load_records, validate_records, process_records  
```

**assertion tests**:

```
python3 code/test_silwood_trees.py
```
assert tests on each function by creating example cases of valid, invalid and boundary records  
- check if validate_records() correctly cleans and recognises the validity of each case
- check if process_records() sorts accepted and rejected records accordingly
- check if summarise_oaks() counts the number of oak trees correctly


#### Notes:  

**AI use**: Co-pilot 14-15 Oct 2026
- clarify type hints and csv loading
- how to match "ST" and 3 digits exactly
- how to match values while ignoring letter cases in an if statement
- how to find whether a value is a numeric number and raise an error statement when it is not
- how to capitalise the first letter of each word in 'location' without capitalising the 's 
- what is the most suitable format for storing VALID_TAXONPAIRS
- how to include source_row in the process_records iterations and exclude header row
- how is row.get("record_id", "") differ from row["record_id"]

**changes after feedback**
- move test_silwood_trees.py from `sandbox/` to `code/` directory
- add assertion tests with for process_records() and summarise_oaks() in test_silwood_trees.py
- add another invalid example case for testing in test_silwood_trees.py
- add and clarify explanations for each function in README



## Assignment 3


### **TreeHeight.R**
```
Rscript code/TreeHeight.R
```
- the code uses a function to calculate tree heights using angle and distance from the trees
- checks for invalid or out of range angles and distance, and checks if the function produces the correct height calculation
- input: data/trees.csv
- output: results/TreeHts.csv
- function:
```
TreeHeight <- function(Angle.degrees, Distance.m) {
    radians <- Angle.degrees * pi / 180
    height_m <- Distance.m * tan(radians)
    return(height_m)
}
```
- changes after feedback:
  - align the function name, changing from `TreeHeightCalculation` to `TreeHeight`
  - make the degree to radian conversion an explicit step in the function
  - add a test to ensure the function is making the calculation correctly, raise an error if not
  - streamline the code by appending the function output directly to the data frame


### **get_TreeHeight.R**
```
Rscript code/get_TreeHeight.R <input.csv>
```
- from a general data set input by user, the code calculates tree heights using angle and distance from the trees
- checks for invalid input (input not exactly 1, does not exist, or contain invalid headers), then checks for invalid or out of range angles and distance
- input: csv file input by user which must contain the following headers: "Species", "Distance.m", "Angle.degrees"
- output: results/<input_basename>_treeheights.csv
- changes after feedback:
  - change the function name to `TreeHeight` to align with TreeHeight.R
  - print out the output path containing the exact basename from the input


### **run_get_TreeHeight.sh**
```
bash code/run_get_TreeHeight.sh
```
- the code runs get_TreeHeight.R with data/trees.csv as input, and stops if the command fails
- output: results/trees_treeheights.csv
- this file was created following the formative feedback


### **pound_hill_analysis.R**
```
Rscript code/pound_hill_analysis.R
```
- from the pound hill data, the code compiles the species richness in each quadrat, calculates the mean richness in each plot, then creates a table summarising mean richness by plot and a figure comparing mean richness across the three cultivation treatments
- input: data/pound_hill_data.csv
- metadata: data/pound_hill_meta_data.csv
- output: 
  1. table = results/pound_hill_plot_richness.csv
  2. figure = results/pound_hill_plot_richness.pdf
- changes after feedback:
  - create results/ directory if it does not exist, so the code can run independently
  - adjust R packages calling






