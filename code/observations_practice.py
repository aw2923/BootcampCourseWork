#!/usr/bin/env python3
# Author: Aiyanuj <aw2923@ic.ac.uk>
# Script: observations_practice.py
# Desc: Reading and summarising observations (known and missing counts)


import csv


def load_observations(path):
    with open(path, newline="", encoding="utf-8") as stream:
        return list(csv.DictReader(stream))

def parse_count(count_text):
    if not isinstance(count_text, str):
        raise ValueError("Input must be text")
    if count_text == "":
        return None

    try:
        count = int(count_text)
    except ValueError as error:
        raise ValueError("Count must be an integer") from error

    if count < 0:
        raise ValueError("Count is negative")

    return count
    

def summarise_site(rows, site):
    if not isinstance(site, str) or not site.strip():
        raise ValueError("Site must be a non-empty string")

    try:
        observations = iter(rows)
    except TypeError as error:
        raise ValueError("Rows must be iterable") from error

    known_total = None
    missing_count = 0
    seen_observations = set()

    for observation in observations:
        if not isinstance(observation, dict):
            raise ValueError("Each observation must be a dictionary")
        if set(observation) != {"site", "date", "count"}:
            raise ValueError("Each observation must contain site, date, and count only")
        if not isinstance(observation["site"], str) or not observation["site"].strip():
            raise ValueError("Observation site must be a non-empty string")
        if not isinstance(observation["date"], str) or not observation["date"].strip():
            raise ValueError("Observation date must be a non-empty string")

        count = parse_count(observation["count"])
        observation_key = (observation["site"], observation["date"], observation["count"])
        if observation_key in seen_observations:
            continue
        seen_observations.add(observation_key)

        if observation["site"] != site:
            continue

        if count is None:
            missing_count += 1
        else:
            if known_total is None:
                known_total = 0
            known_total += count

    return known_total, missing_count


if __name__ == "__main__":
    rows = load_observations("data/bootcamp_observations.csv")
    known_total, missing_count = summarise_site(rows, "A")
    print(f"Site A: {known_total} known count, {missing_count} missing counts")
