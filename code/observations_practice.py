import csv


def load_observations(path):
    with open(path, newline="", encoding="utf-8") as stream:
        return list(csv.DictReader(stream))

def parse_count(count_text):
    if count_text == "":
        return None
    if count_text == "0":
        return 0
    if int(count_text) < 0:
        raise ValueError("Count is negative")
    if isinstance(count_text, str):
        return int(count_text)
    if isinstance(count_text, int):
        raise ValueError("Input must be text")
    

summarise_site(rows, site)

parse_count(row["count"])


missing = 0
knowncount = 0

for observation in observations:
    if observation['Count'] == None:
        missing += 1
    else:
        knowncount += int(observation['Count'])
    print (f"For site {observation['Site']}, there were {missing} missing counts and {knowncount} total known counts.")













if __name__ == "__main__":
    rows = load_observations("data/bootcamp_observations.csv")
    print(rows[0])
    print(rows[2])
