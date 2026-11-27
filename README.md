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




## In class practice scripts


### Shell scripting practice

#### boilerplate.sh
```
bash code/boilerplate.sh
```
- simple boilerplate example with shebang, prints "This is a shell script!" and exits 0 

#### variables.sh
```
bash code/variables.sh
bash code/variables.sh 1 "two words"
```
- takes 2 arguments, then requires 1 string and 2 integers input from user, prints the string and the sum of the two integers 

#### MyExampleScript.sh
```
bash code/MyExampleScript.sh
```
- stores the user's login name in a variable and prints it 

#### CheckLabel.sh
```
bash code/CheckLabel.sh oak
bash code/CheckLabel.sh pine
```
- accepts only 'oak' or 'pine' as user input, gives non-zero exit status if no input or any other input is given 

#### CountLines.sh
```
bash code/CountLines.sh $1
```
- counts the number of lines in $1 input by user 

#### ConcatenateTwoFiles.sh
```
bash code/ConcatenateTwoFiles.sh $1 $2 $3
```
- merge the content of $1 and $2 into $3 

#### tiff2_png.sh
```
project_root=$PWD
script_path=$project_root/code/tiff2_png.sh
cd "<insert image directory>"
bash "$script_path"
cd "$project_root"
```
- converts TIFF to PNG
- has to be used on the directory containing the image file 


### Python practice

#### loops.py
```
python3 code/loops.py
```
- examples of for and while loops

#### cfexercises1.py
```
python3 code/cfexercises1.py
```
- examples of function, containing conditionals and loops
- the function foo_5 has been adjusted to work when x is 0
- uses main guard to run the example tests only when the script is directly executed, not when imported 

#### cfexercises2.py
```
python3 code/cfexercises2.py
```
- more examples of function, containing conditionals and loops 

#### MyExampleScript.py
```
python3 code/MyExampleScript.py
```
- example for saving and running python code 

#### boilerplate.py
```
python3 code/boilerplate.py
```
- boilerplate, prints 'This is a boilerplate' 

#### using_name.py
```
python3 code/using_name.py
```
- example of __name__ == "__main__" 

#### control_flow.py
```
python3 code/control_flow.py
```
- example of a program with control flow, contains functions and example uses
- the examples are under main and run only when the script is directly executed, not when imported 
```
python3 -m doctest -v code/control_flow.py
```
- run doctest for unit testing, to ensure the code is working as intended

#### test_control_flow.py
```
python3 code/test_control_flow.py
```
- imports functions from control_flow.py
- performs assertion tests on the functions, raise an error in case of failure

#### sysargv.py
```
python3 code/sysargv.py
python3 code/sysargv.py oak 12
```
- displays supplied command line arguments

#### require_one_argument.py
```
python3 code/require_one_argument.py
python3 code/require_one_argument.py oak
```
- requires one supplied argument, otherwise prints instruction and produces a non-zero exit

#### debugme.py
- example of a bugged function, debugging process
- this file should be run within ipython3

#### observations_practice.py
```
python3 code/observations_practice.py
```
- separates known and missing counts, raise error when count is invalid
- summarises and returns total of known and missing counts for a site
- input: data/bootcamp_observations.csv
- output: terminal lines

#### test_observations_practice.py
```
python3 code/test_observations_practice.py
```
- testing for observations_practice.py
- assertion tests for `parse_count` and `summarise_site` functions
- tests errors with boundary and invalid data


### R practice

#### basic_io.R
```
Rscript code/basic_io.R
```
- example of importing input and saving output in R
- input: data/trees.csv
- output: results/MyData.csv

### control_flow.R
```
Rscript code/control_flow.R
```
- example of if conditionals, for loops and while loops

### break.R
```
Rscript code/break.R
```
- uses `break` to break out of a loop
- stops running once i == 10

### next.R
```
Rscript code/next.R
```
- uses `next` to skip to the next iteration of a loop
- skips when i is even, prints only odd numbers

### boilerplate.R
```
Rscript code/boilerplate.R
```
- boilerplate R
- a function prints the types of 2 arguments and returns them

### r_conditionals.R
```
Rscript code/r_conditionals.R
```
- examples of functions and conditional statements in R

### browse.R
```
source("code/browse.R")
```
- example for debugging
- this file should be run within R console using source() to enter the browser mode

### try.R
```
source("code/try.R")
```
- example of using try() to catch errors in R
- this file should be run within R console using source()

### data_wrang.R
```
Rscript code/data_wrang.R
```
- example of data wrangling, converting data from wide to long form
- input: data/pound_hill_data.csv
- metadata: data/pound_hill_meta_data.csv
- output: results/pound_hill_long.csv

### data_wrang_tidy.R
```
Rscript code/data_wrang_tidy.R
```
- data wrangling similar to data_wrang.R but using dplyr and tidyr to pivot
- input: data/pound_hill_data.csv
- metadata: data/pound_hill_meta_data.csv
- output: results/pound_hill_long_tidy.csv
- solved errors in formatting by consulting github co-pilot chat

### observations_practice.R
```
Rscript code/observations_practice.R
```
- reads observations data and summarises total known and missing counts
- function `read_observations(path)` checks the exact columns, rejects empty site/date values and invalid counts, and converts valid counts to integers
- function `summarise_observations(data)` removes exact duplicates and returns per-site known totals and missing counts, using NA when all counts are missing
- input: 
  - data/bootcamp_observations.csv
  - data/bootcamp_observations_boundary.csv
  - data/bootcamp_observations_invalid.csv"
- output: 
  - results/observations_summary.png
- AI use: github co-pilot chat in VScode
  - checking invalid cases
  - catching the invalid input error
  - producing the figure
