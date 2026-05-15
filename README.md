# Tropical Cyclone Risk to China's High-Speed Rail

Standard MATLAB code package prepared for the paper:

**"Tropical cyclone risk to China's high-speed rail"**

## Package Structure

- `method_model/`
  - core method-side MATLAB scripts for calculating daily city-to-city travel times under cyclones, affected passenger proportions, and passenger delays.
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

### Method-model input data availability

The full method-model workflow requires large input datasets, intermediate outputs and associated method files. These include source data in `method_model/source_data/`, result data in `method_model/result_data/`, and helper routines required by the city-to-city fastest-travel-time calculation. Because the full method-model package is large, these files are not included in the current GitHub release package.

The required method-model input datasets and associated files are available from the corresponding author upon reasonable request. Please contact Min Ouyang at min.ouyang@hust.edu.cn

## MATLAB Requirements

### Figure reproduction

- Statistics and Machine Learning Toolbox
- Mapping Toolbox

### Method model

- MATLAB base environment
- any toolbox or third-party implementation required by the missing `shortest_paths.m` helper

## Tested environment

The code has been tested on Windows 11 with MATLAB R2020a.

## Installation and run time

No compilation or package installation is required. Typical installation time on a normal desktop computer is less than 5 minutes, excluding installation of MATLAB and required MATLAB toolboxes.

The expected run time for the figure-reproduction scripts on a normal desktop computer is about 30 minutes.
