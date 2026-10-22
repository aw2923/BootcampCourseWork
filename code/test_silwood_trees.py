
from clean_silwood_trees import load_records, validate_records, process_records, summarise_oaks


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