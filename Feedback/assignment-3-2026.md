# Assignment 3 formative feedback

This feedback is organised using the [Computing Bootcamp rubric](https://mulquabio.github.io/MQB/rubrics/Computing_Bootcamp_Rubric.html). It does not award a mark; use it to decide what to revise and check before final submission.

## Criterion 1: Repository organisation & workflow discipline

- Before final submission, **Protect generated outputs from accidental commits.** Your current `.gitignore` does not exclude `results/`, although no generated results are currently tracked. Add an appropriate ignore rule and check Git status after rerunning the analyses.

## Criterion 2: Code completeness & functional correctness

- The fixed tree-height script ran successfully, and `results/TreeHts.csv` matched the checked required output format and values. Your code shows the degrees-to-radians conversion and creation of the output directory.
- Before final submission, **Complete and test the generalised route separately.** `code/get_TreeHeight.R` is present, but the required `code/run_get_TreeHeight.sh` is missing. Restore that launcher and test the complete command-to-output route. The ordinary generalised output was not collected, so its correctness still needs to be checked; test it separately from the fixed script.

## Criterion 3: Code quality & style

As you revise, keep names descriptive, use comments to explain decisions rather than restating code, and avoid repeating the same calculation in several places.

## Criterion 4: Documentation

- The root README documents purposes, inputs, commands and outputs. Commits describe separate tasks, and no generated results are tracked.
- Before final submission, **Make the tree-height function available through the required interface.** The interface check stopped with `object 'TreeHeight' not found`; your code instead defines `TreeHeightCalculation` with distance first. The required function's first input should be the angle in degrees and its second the horizontal distance. Align the function name, argument order and calling code, then try the taught example call and compare it with a direct calculation. Your README records a simple calculation check, but this is not execution evidence: repeat it through the required interface and explain the degree conversion.

## Criterion 5: Version-control practice

Commit each functional revision with a short message that says what changed; this makes your development easier to follow than one large final commit.

## Criterion 8: Basic error-handling & input validation

- The invalid-distance runs stopped with useful messages identifying zero as out of range and infinity as non-finite. This supports those particular checks, rather than establishing validation of every input.

## Criterion 9: Problem-solving approach & method implementation

- Your Pound Hill source sets out a scientific question and a clear route from positive species counts to quadrat richness and then plot-level means. Your interpretation appropriately cautions against inferring causation from the figure alone; its specific biological claims still need checking against regenerated outputs.
- Before final submission, **Make Pound Hill independent of earlier runs.** Execution stopped when writing the CSV because `results/` did not exist. Unlike your fixed tree script, this script does not create the directory before writing. Ensure it does so itself, then rerun from the directory containing `code/`, `data/` and the root `README.md`. Check for exactly `results/pound_hill_plot_richness.csv` and `results/pound_hill_plot_richness.pdf`, comparing these paths with the filenames the script actually creates. Both were missing in the outputs. Once generated, inspect the PDF's labels, plotted values and biological meaning, and trace one quadrat's richness through to its plot mean before confirming your interpretation.

## Criterion 10: Learning progression demonstration

Use this feedback as a revision checklist. Make the changes in small, descriptive commits, then add a short README note explaining what you changed and how you checked it. This will make your development from this formative checkpoint visible in the final portfolio.

## Priorities before final submission

- Rerun one ordinary and one invalid case for each tree-height route. Check the error message as well as the exit, and confirm that the invalid run produces no new result. Update the README to match the repaired interface and launcher, including these test examples. Prioritise reproducible required outputs before the optional abundance analysis.
