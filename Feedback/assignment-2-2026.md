# Assignment 2 formative feedback

This feedback is organised by the relevant computing bootcamp criteria. Use it to decide what is already working, what you need to investigate, and what to revise before the cumulative submission.

The full criteria are in the [Computing Bootcamp assessment rubric](https://github.com/MulQuaBio/MQB/blob/main/content/rubrics/Computing_Bootcamp_Rubric.md).

## 1. Repository organisation and workflow discipline

- Your root README, `.gitignore`, cleaning script and supplied data files are in the expected locations, and the supplied inputs are unchanged. Add `code/test_silwood_trees.py` under `code/`, as described under Criterion 8.

## 2. Code completeness and functional correctness

- Your cleaning script ran and produced all three output files. Separately, output checks found that the cleaned records, issues table and oak summary satisfied the required output format and contents in both test runs. The outputs are correct for the checked input; now make sure you can explain the method and test important edge cases.

## 3. Code quality and style

- Your `main()` function gives the program a clear overall structure by connecting loading, processing, summarising and writing. Keep these stages distinct as you revise; use descriptive names and add short comments where the reason for a validation check or data-cleaning step is not obvious.

## 4. Documentation

- Your root README is in place. Make it useful to someone opening the repository for the first time: explain what the cleaner does, how to run the script and tests from the repository root, and which three files it creates. Test the instructions in a newly cloned copy of your repository (a separate folder created with `git clone`): enter that folder and run each README command exactly as written. If something fails, correct the command or add the missing step.

## 5. Version-control practice

- Since the previous formative feedback was added, the saved history contains 3 non-merge commits. `add input files for tree survey practical` identifies a clear setup step, while `finish assignment 2 tree survey, update README` combines code completion and documentation in one broad commit.
- Before each commit, run `git diff --staged` to see exactly what will be recorded. Keep one coherent, working change per commit and write a concise message that names what changed—for example, the validation rule added, the failing test fixed or the README instruction clarified.

## 8. Basic error handling and input validation

- **Add separate, repeatable tests.** `code/test_silwood_trees.py` is absent. This file was added retrospectively to the notebook, so its absence is not being treated as disregard of the original instructions; it remains required for the cumulative submission. A separate test file lets you check individual decisions without relying on a successful full-data run. Start with a valid record, an invalid record and a boundary case drawn from the released rules. Check the returned values and whether each record reaches the appropriate accepted or issues collection. Add a small oak-summary check using records whose counts you can work out by hand.
- Add and run the separate test file, then rerun the complete cleaning workflow to check that the three outputs still satisfy the brief.
- Check that the README explains the accepted/rejected record flow and gives working run and test commands. Test the instructions in a newly cloned copy of your repository (a separate folder created with `git clone`): enter that folder and run each README command exactly as written. If something fails, correct the command or add the missing step.

## 9. Problem-solving approach and method implementation

- Your supplied raw CSV and metadata are unchanged. Your code shows a clear connected workflow: `main()` calls `load_records()`, passes the rows to `process_records()`, which uses `validate_records()` and returns `(accepted, issues)`, then sends the cleaned collection to `summarise_oaks()` before three calls to `write_csv()`. The route from input to outputs is clear.
- Before final submission, make this check visible in your repository. In `code/test_silwood_trees.py`, add or refine a small assertion-based test with one valid and one invalid record. Check that `process_records()` places them in the cleaned and issues collections respectively. Then pass the returned cleaned collection to `summarise_oaks()` and check that the invalid record does not contribute. Briefly explain this flow in your root README.
