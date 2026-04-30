# Tropical Cyclone Risk to China's High-Speed Rail

Standard MATLAB code package prepared from the current workspace for the paper:

**"Tropical cyclone risk to China's high-speed rail"**

## Package Structure

- `method_model/`
  - core method-side MATLAB scripts for calculating daily city-to-city travel times under cyclones, affected passenger proportions, and passenger delays.
  - current workspace does **not** include the required method-model input datasets
- `figure_reproduction/`
  - caption-aligned figure-reproduction package for the code-backed manuscript figures
  - includes copied figure data and MATLAB scripts; outputs are generated locally when the scripts are run

## Quick Start

### Figure reproduction

1. Open MATLAB.
2. Change directory to:

```matlab
cd('figure_reproduction/code')
```

3. Run an individual figure script or the full set:

```matlab
run_all_manuscript_figures
```

### Method model

1. Add the required inputs to `method_model/source_data/`.
2. Add the missing helper functions noted below if you intend to run the method model from this package.
3. Open MATLAB and change directory to:

```matlab
cd('method_model/src')
```

4. Run the wrapper:

```matlab
run_method_model_task(201)
```

The method-model scripts write outputs to `method_model/result_data/`.

## Current Reproducibility Status

### Included and organized

- method-model MATLAB scripts from `code for method`
- figure-reproduction MATLAB package with figure-specific and shared data aliases
- no pre-generated figure outputs are included in this release package

### Figure coverage

The `figure_reproduction/` package currently covers:

- Fig. 1: panels `b-e`
- Fig. 2: panels `a-f` (`e-f` require method-model input/output files)
- Fig. 3: panels `a-c`
- Fig. 4: panels `a-d`

Still missing as reproducible code outputs:

- Fig. 1a schematic
- final PowerPoint-only panel lettering and layout adjustments

### Method-model gaps in the current workspace

The following are **not** present in the current workspace and therefore are not included as runnable inputs in this release package:

- the `method_model/source_data/` input datasets expected by the main method script
- the legacy helper function `rail_city2city_time_given_disruption.m`
- the helper function `shortest_paths.m` used by the city-to-city fastest-travel-time routine

These missing method-model files also affect execution of Fig. 2e-f, because the new income-ranked curve code depends on socioeconomic inputs and city-level resilience-loss outputs from `method_model/source_data/` and `method_model/result_data/`.

## MATLAB Requirements

### Figure reproduction

- Statistics and Machine Learning Toolbox
- Mapping Toolbox

### Method model

- MATLAB base environment
- any toolbox or third-party implementation required by the missing `shortest_paths.m` helper

## Notes For GitHub Release

- `.gitignore` is included for MATLAB temporary files, Office lock files, and generated outputs.
- `method_model/source_data/` and `method_model/result_data/` include placeholder README files only.
- `figure_reproduction/README.md` contains the detailed figure-package notes carried over from the standalone figure package.
