# Project: Biological Computing Bootcamp Coursework
This is a repository to store coursework created as part of the biological computing bootcamp at Imperial College London Silwood Park 2026

## Author
Aiyanuj Wongkomet (aiyanuj@gmail.com / ai.wongkomet23@imperial.ac.uk)


## Assignment 1

Code: **unixPrac1.txt** inspect and summarise FASTA genome sequences
1. Count file lines
2. Display sequence lines
3. Count sequence length
4. Count a literal motif
5. Calculate AT/GC ratio

Code: **tabtocsv.sh** change tab delimited file to comma delimited, 
input: data/tab-example.tsv

Code: **csvtospace.sh** change comma delimited file to space delimited, 
input: data/temperatures


## Assignment 2

### Code: **clean_silwood_trees.py** validate and clean the tree survey file

### Pseudocode:

**INPUT**: data/silwood_trees_raw.csv

**validate_records** # clean record or return rejection reason

    cleaned: 
    errors: 

    record_id:
            remove surrounding whitespace
            if record_id == ""
                reject `missing record_id`
            else if record_id != "ST" and exactly three digits
                reject `invalid record_id`
            else if record_id in accepted_id
                reject `duplicate record_id`
            else
                append accepted_id
                append cleaned
    Valid_locations = ["Silwood Bottom", "Nash's Field", "Manor House", "Reactor Wood"]
    location:
            remove surrounding whitespace
            if location == ""
                reject `missing location`
            else if location != == Valid_locations, ignoring letter case
                `invalid location`
            else
                append cleaned
    Valid_genus = [ `Quercus`, `Acer`, `Betula`, `Fagus`, `Fraxinus` ]
    genus:
            remove surrounding whitespace
            if genus == ""
                reject `missing genus`
            else if genus != == Valid_genus, ignoring letter case
                reject `invalid genus`
            else
                append cleaned
    Valid_species = [`robur`, `petraea`, `pseudoplatanus`, `pendula`, `sylvatica`, `excelsior`]
    species: 
            remove surrounding whitespace
            if species == ""
                reject `missing species`
            else if species != == Valid_species, ignoring letter case
                reject `invalid species`
            else
                append cleaned
    Valid_taxonpairs = []
    if genus and species valid:
        if (cleaned[genus], cleaned[species]) not in Valid_taxonpairs:
            reject `invalid genus/species combination`
    distance_m:
            if distance_m == ""
                reject `missing distance_m
            else if distance_m <0 or >100
                reject `distance_m out of range`
            else 
                append cleaned
    angle_degrees
            if angle_degrees == ""
                reject `missing angle_degrees`
            else if angle_degrees <0 or >90
                reject `angle_degrees out of range`
            else
                append cleaned

    if errors:
        cleaned = None

    return cleaned, errors


**process_records** # sort records into accepted rows and issue reports

    accepted = []
    issues = []

    for row in records:
        cleaned, errors = validate_records()

        if cleaned is not None:
            accepted.append = cleaned
        else:
            issues.append = errors
    
    return accepted, issues


**summarise_oaks** # count accepted oak records by species

    robur_count = 0
    petraea_count = 0

    if clean["genus"] == "Quercus":
        if clean_records["species"] == "robur":
            robur += 1
        else if clean["species"] == "petraea":
            petraea += 1

    oak_counts = ({'species':'robur', 'count': robur_count }, {'species':'petraea', 'count': petraea_count })
    return oak_counts


**OUTPUT**:
- results/silwood_trees_clean.csv -> accepted records
- results/silwood_tree_issues.csv ->  rejected rows and their reasons
- results/oak_species_counts.csv -> oak summary



### Running and testing:


**code run testing in ipython3**: 
run clean_silwood_trees.py
run test_silwood_trees.py


**checkpoint prints**:

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


**test importing modules**:

from clean_silwood_trees import load_records, validate_records, process_records
    -> does not run 


**assertion testing**:

row_valid = {
        "record_id": "ST012",
        "location": "Manor House",
        "genus": "Fraxinus",
        "species": "excelsior",
        "distance_m": "13.6",
        "angle_degrees": "37",
    }

row_boundary = {
        "record_id": "ST012 ",
        "location": "manor house ",
        "genus": "fraxinus",
        "species": " excelSIOR ",
        "distance_m": "99",
        "angle_degrees": "80.7",
    }

row_invalid = {
        "record_id": "ST09",
        "location": "Silwood botto ",
        "genus": "Fraxinus",
        "species": "sylvatica",
        "distance_m": "",
        "angle_degrees": "37",
    }


def test_valid_records(row):
    cleaned, errors = validate_records(row, 2, set())

    print("cleaned: ", cleaned)
    print("Errors: ", errors)
    
    assert cleaned is not None
    assert errors == []

test_valid_records(row_valid)
test_valid_records(row_boundary)



def test_invalid_records(row):
    cleaned, errors = validate_records(row, 2, set())

    print("cleaned: ", cleaned)
    print("Errors: ", errors)
    
    assert cleaned is None

test_invalid_records(row_invalid)



**AI use**: Co-pilot 14-15 Oct 2026
- clarify type hints and csv loading
- how to match "ST" and 3 digits exactly
- how to match values while ignoring letter cases in an if statement
- how to find whether a value is a numeric number and raise an error statement when it is not
- how to capitalise the first letter of each word in 'location' without capitalising the 's 
- what is the most suitable format for storing VALID_TAXONPAIRS
- how to include source_row in the process_records iterations and exclude header row
- how is row.get("record_id", "") differ from row["record_id"]