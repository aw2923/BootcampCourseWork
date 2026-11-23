#!/usr/bin/env python3
# Author: Aiyanuj <aw2923@ic.ac.uk>
# Script: test_silwood_trees.py
# testing for clean_silwood_trees.py

from clean_silwood_trees import load_records, validate_records, process_records, summarise_oaks


# Example records: valid, invalid and boundary 

row_valid = {
        "record_id": "ST012",
        "location": "Manor House",
        "genus": "Fraxinus",
        "species": "excelsior",
        "distance_m": "13.6",
        "angle_degrees": "37",
    }

row_boundary = {
        "record_id": "ST013 ",
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

process_rows = [
    {
        "record_id": "ST012",
        "location": "Manor House",
        "genus": "Quercus",
        "species": "robur",
        "distance_m": "13.6",
        "angle_degrees": "37",
    },
    {
        "record_id": "ST013 ",
        "location": "manor house ",
        "genus": "quercus",
        "species": "petraea",
        "distance_m": "99",
        "angle_degrees": "80.7",
    },
        {
        "record_id": "ST014 ",
        "location": "Manor house ",
        "genus": "Acer",
        "species": "pseudoplatanus",
        "distance_m": "99",
        "angle_degrees": "80.7",
    },
    {
        "record_id": "ST09",
        "location": "Silwood botto ",
        "genus": "Quercus",
        "species": "robur",
        "distance_m": "",
        "angle_degrees": "37",
    }
]



# Check accept/reject assertion tests for validate_records() function

def test_valid_records(row):
    cleaned, errors = validate_records(row, 2, set())

    print("Cleaned: ", cleaned)
    print("Errors: ", errors)
    
    assert cleaned is not None
    assert errors == []

test_valid_records(row_valid)
test_valid_records(row_boundary)

def test_invalid_records(row):
    cleaned, errors = validate_records(row, 2, set())

    print("Cleaned: ", cleaned)
    print("Errors: ", errors)
    
    assert cleaned is None

test_invalid_records(row_invalid)



# Check process_records() function sorts records correctly

accepted, issues = process_records(process_rows)

assert accepted == [
    {'record_id': 'ST012', 'location': 'Manor House', 'genus': 'Quercus', 'species': 'robur', 'distance_m': '13.6', 'angle_degrees': '37'}, 
    {'record_id': 'ST013', 'location': 'Manor House', 'genus': 'Quercus', 'species': 'petraea', 'distance_m': '99', 'angle_degrees': '80.7'}, 
    {'record_id': 'ST014', 'location': 'Manor House', 'genus': 'Acer', 'species': 'pseudoplatanus', 'distance_m': '99', 'angle_degrees': '80.7'}
]

assert len(issues) == 1
assert issues[0]["record_id"] == "ST09"
assert set(issues[0]["reasons"].split("; ")) == {
    "invalid record_id",
    "invalid location",
    "missing distance_m",
}

print("Accepted:", accepted)
print("Issues:", issues)



# Check summarise_oaks() function counts accepted records correctly

oak_counts = summarise_oaks(accepted)

assert oak_counts == ({'species':'petraea', 'count': '1'}, {'species':'robur', 'count': '1' })
print("oak_counts:", oak_counts)