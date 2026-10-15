# Assignment 1 feedback - Aiyanuj Wongkomet

**Formative feedback | Rubric 2026.2**

Your own TSV includes an empty field, the Unix notes explain length and motif counting, and the history contains identifiable coursework and documentation changes. The assessment could review this source, but it could not run the student commands.

The reason is a committed derived FASTA, e_coli_new.fasta, of about 75.6 MB. It exceeds the collector's fixed 32 MiB per-file copy limit, so setup stopped before any student code was launched. That is a collection limitation, not a measured algorithm failure. Untrack this generated intermediate and ignore such outputs; keep the original supplied FASTA.

This also exposes a problem with Q5's method: it appends sequence data to that intermediate on each run. The ratio can remain similar while the file keeps growing, so an apparently plausible number does not establish a repeatable calculation. Make the answer self-contained without writing repeatedly into data/. Your use of grep -c after grep -o in Q4 is valid here because the earlier stage has already produced one match per line; keep that explanation.

The converters should check exactly one readable regular file, write directly to the repository's results directory and report failure if conversion or moving fails. They currently can finish with status zero after an error. Also, echo does not substitute %s like printf. Add exact commands, small predicted/observed tests, dependencies and any help record to the README. A new snapshot/run is needed after removing the oversized intermediate.

---

## Project structure

Relevant tracked layout (simplified; missing required paths are marked):

```text
README.md
.gitignore
code/  unixPrac1.txt, tabtocsv.sh, csvtospace.sh
data/fasta/  3 required files present
data/temperatures/  4 required files present
data/tab-example.tsv
results/  no files tracked; generated on run
sandbox/  no files tracked; optional
Also: data/fasta/e_coli_new.fasta
```

All required code and input paths are present, but data/fasta/ also contains the tracked generated e_coli_new.fasta. At about 75.6 MB it is much larger than the supplied sequence and caused the collector's per-file copy limit to stop setup. No result or sandbox files are tracked.

Keep supplied FASTA inputs unchanged and untrack the generated intermediate. Do not append derived data into the input directory; use a generated workspace where needed. Add results/sandbox ignore rules and make the root README describe inputs and outputs separately. This cleanup is needed before a new unchanged snapshot can be executed.

**Assessed snapshot:** `1a6ab96b7208dd5436db3451e00e57c22fd4a590`
