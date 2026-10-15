#!/usr/bin/env python3
"""Validate and clean the synthetic Silwood tree survey."""


from __future__ import annotations

import csv
from pathlib import Path
from typing import Iterable

PROJECT_ROOT = Path(__file__).resolve().parents[1]
INPUT_PATH = PROJECT_ROOT / "data" / "silwood_trees_raw.csv"
RESULTS_DIR = PROJECT_ROOT / "results"


INPUT_FIELDS = [
    "record_id",
    "location",
    "genus",
    "species",
    "distance_m",
    "angle_degrees",
]
ISSUE_FIELDS = ["source_row", "record_id", "reasons"]
OAK_COUNT_FIELDS = ["species", "count"]




def load_records(path: Path = INPUT_PATH) -> list[dict[str, str]]:
    """Read the survey and check its column names."""
    with path.open(newline="", encoding="utf-8") as source:
        reader = csv.DictReader(source)
        if reader.fieldnames != INPUT_FIELDS:
            raise ValueError(
                f"Expected columns {INPUT_FIELDS}, found {reader.fieldnames}"
            )
        return list(reader)



def validate_records(
    row: dict[str, str],
    source_row: int,
    accepted_ids: set[str],
) -> tuple[dict[str, str] | None, list[str]]:
    """Clean one record, or return the reasons it cannot be used."""

    cleaned = {}
    errors = []


    VALID_LOCATIONS = [ "Silwood Bottom", "Nash's Field", "Manor House", "Reactor Wood" ]

    VALID_GENUS = ["Quercus", "Acer", "Betula", "Fagus", "Fraxinus"]

    VALID_SPECIES = ["robur", "petraea", "pseudoplatanus", "pendula", "sylvatica", "excelsior"]

    VALID_TAXONPAIRS = { ("Quercus", "robur"), ("Quercus", "petraea"), ("Acer", "pseudoplatanus"), ("Betula", "pendula"), ("Fagus", "sylvatica"), ("Fraxinus", "excelsior") }


    record_id = row["record_id"].strip()
    if record_id == "":
        errors.append("missing record_id")
    elif ( len(record_id) != 5 
            or not record_id.startswith("ST") ): # match exactly ST + 3 digits
        errors.append("invalid record_id")
    elif record_id in accepted_ids: # identify duplicates from compiled accepted records
        errors.append("duplicate record_id")
    else:
        accepted_ids.add(record_id)
        cleaned["record_id"] = record_id


    location = row["location"].strip()
    if location == "":
        errors.append("missing location")
    else:
        for valid_location in VALID_LOCATIONS:
            if location.casefold() == valid_location.casefold():
                cleaned["location"] = valid_location # use canonical formatting
                break
            else:
                cleaned["location"] = ""
        if cleaned["location"] == "":
            errors.append("invalid location")

    
    genus = row["genus"].strip()
    genus_valid = "FALSE"
    if genus == "":
        errors.append("missing genus")
    elif genus.casefold() not in { x.casefold() for x in VALID_GENUS }:
        errors.append("invalid genus")
    else:
        cleaned["genus"] = genus.capitalize()
        genus_valid = "TRUE"


    species = row["species"].strip()
    species_valid = "FALSE"
    if species == "":
        errors.append("missing species")
    elif species.casefold() not in { x.casefold() for x in VALID_SPECIES }:
        errors.append("invalid species")
    else:
        cleaned["species"] = species.lower()
        species_valid = "TRUE"


    if genus_valid == "TRUE" and species_valid == "TRUE": # only check pairing when both genus and species are accepted
        if (cleaned["genus"], cleaned["species"]) not in VALID_TAXONPAIRS:
            errors.append("invalid genus/species combination")


    distance_m = row["distance_m"].strip()
    if distance_m == "":
        errors.append("missing distance_m")
    else:
        try:
            value = float(distance_m)
            if 0 < value <= 100:
                cleaned["distance_m"] = distance_m
            else:
                errors.append("distance_m out of range") 
        except ValueError: # non-numeric distance_m cannot be converted to float
            errors.append("invalid distance_m")
    

    angle_degrees = row["angle_degrees"].strip()
    if angle_degrees == "":
        errors.append("missing angle_degrees")
    else:
        try:
            value = float(angle_degrees)
            if 0 < value < 90:
                cleaned["angle_degrees"] = angle_degrees
            else:
                errors.append("angle_degrees out of range")              
        except ValueError:
            errors.append("invalid angle_degrees")

    if errors == []:
        return cleaned, []
    else: 
        return None, errors




def process_records(
    rows: Iterable[dict[str, str]],
) -> tuple[list[dict[str, str]], list[dict[str, str]]]:
    """Sort records into accepted rows and issue reports."""

    accepted = []
    issues = []

    accepted_ids = set()

    for source_row, row in enumerate(rows, start=2): # use enumerate(rows) to obtain source_row and specify start=2 to exclude header row
        cleaned, errors = validate_records(row, source_row, accepted_ids)
        
        if cleaned is not None:
            accepted.append(cleaned)
        else: 
            issues.append(
                {
                    "source_row": str(source_row),
                    "record_id": row.get("record_id", ""),
                    "reasons": "; ".join(errors)
                }
            )

    return accepted, issues




def summarise_oaks(clean_records: Iterable[dict[str, str]]) -> list[dict[str, str]]:
    """Count accepted oak records by species."""

    petraea_count = 0
    robur_count = 0
    
    for record in clean_records:
        if record["genus"] == "Quercus":
            if record["species"] == "petraea":
                petraea_count += 1
            elif record["species"] == "robur":
                robur_count += 1

    oak_counts = ({'species':'petraea', 'count': petraea_count }, {'species':'robur', 'count': robur_count })
    return oak_counts




def write_csv(
    path: Path,
    fieldnames: list[str],
    rows: Iterable[dict[str, str]],
) -> None:
    """Write rows to a CSV file, replacing an older copy."""
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as destination:
        writer = csv.DictWriter(destination, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    """Clean the survey and write the three result files."""
    clean_records, issues = process_records(load_records())
    oak_counts = summarise_oaks(clean_records)

    write_csv(
        RESULTS_DIR / "silwood_trees_clean.csv",
        INPUT_FIELDS,
        clean_records,
    )
    write_csv(
        RESULTS_DIR / "silwood_tree_issues.csv",
        ISSUE_FIELDS,
        issues,
    )
    write_csv(
        RESULTS_DIR / "oak_species_counts.csv",
        OAK_COUNT_FIELDS,
        oak_counts,
    )

    print("Done!")


if __name__ == "__main__":
    main()
