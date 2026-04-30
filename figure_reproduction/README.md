# Figure Reproduction Package

This package has been refined to align with the current manuscript captions for Figs. 1 to 4.

The authoritative entry-point scripts are now the figure-numbered MATLAB files in `code/`:

- `fig1_event_level_impact_validation_panels_b_to_e.m`
- `fig2_current_future_passenger_impact_patterns_panels_a_to_f.m`
- `fig3_downstream_accessibility_and_economic_losses_panels_a_to_c.m`
- `fig4_persistence_of_spatial_risk_concentration_panels_a_to_d.m`
- `run_all_manuscript_figures.m`

Older `figure_*.m` scripts from the first package pass are still present as legacy intermediate versions, but the `fig1` to `fig4` scripts above are the caption-aligned ones that should be used.
Those older scripts were moved to `code/legacy/` to keep the top-level figure runners clean.

## Folder layout

- `code/`: MATLAB scripts
- `data/`: copied data files
- `outputs/`: created automatically when the scripts are run

## How to run

1. Open MATLAB.
2. Change directory to `figure_reproduction/code`.
3. Run a single figure script, for example:

```matlab
fig2_current_future_passenger_impact_patterns_panels_a_to_f
```

4. Or run the full caption-aligned set:

```matlab
run_all_manuscript_figures
```

Generated files will be written under `outputs/`.

## MATLAB requirements

- Statistics and Machine Learning Toolbox
  - used by `ksdensity`, `ranksum`, `ecdf`, `corr(...,'Type','Spearman')`, and `tiedrank`
- Mapping Toolbox
  - used by `shaperead`, `geoaxes`, `geoplot`, and `geopolyshape`

If basemap tiles are unavailable in your MATLAB environment, the polygon layers should still draw, but the background basemap may not match the original presentation exports.

## Figure scripts and panel coverage

### Fig. 1

Caption:
- event-level impact-propagation model and event-based validation

Script:
- `code/fig1_event_level_impact_validation_panels_b_to_e.m`

Panels covered by code:
- `b` route-reconstruction deviation distribution
- `c` interrupted trains during Doksuri
- `d` PAP during Doksuri
- `e` ATD during Doksuri

Panel not recoverable from code:
- `a` conceptual model schematic
  - this panel was assembled outside the recoverable MATLAB figure scripts

Figure-specific data aliases used by this script:
- `data/fig1b_route_reconstruction_deviation_july2023.mat`
- `data/fig1cde_doksuri_daily_validation_outputs.mat`

### Fig. 2

Caption:
- current-climate passenger-impact patterns and future amplification of affected-passenger proportions and delays

Script:
- `code/fig2_current_future_passenger_impact_patterns_panels_a_to_f.m`

Panels covered by code:
- `a` event-level PAP distribution under current climate vs SSP5-8.5
- `b` event-level ATD distribution under current climate vs SSP5-8.5
- `c` city-level APAP map under the current climate
- `d` city-level AATD map under the current climate
- `e` income-ranked cumulative share of affected passengers
- `f` income-ranked average travel delay among affected passengers

Figure-specific data aliases used by this script:
- `data/fig2ab_current_vs_ssp585_event_windows.mat`
- `data/fig2_fig3_city_level_current_and_future_impacts.mat`

Shared data also used:
- `data/shared_city_boundaries_367.*`
- `data/shared_south_sea_boundary_wgs84.*`

Additional method-model inputs used by panels `e-f` when available:
- `../method_model/source_data/city_Income.mat`
- `../method_model/source_data/city_pop.mat`
- `../method_model/source_data/rail_city.mat`
- `../method_model/result_data/current_city_RL.mat` or `../method_model/result_data/current_city_RL_OD.mat`
- `../method_model/result_data/future_city_RL.mat` or `../method_model/result_data/future_city_RL_OD_585_7010_sim_2000.mat`

Important note for panels `e-f`:
- the code is now included and is derived from `equality_analysis.m`
- if the required method-model files are not present, the Fig. 2 `a-f` runner will generate panels `a-d`, warn, and skip panels `e-f`

### Fig. 3

Caption:
- downstream accessibility and economic losses under current-climate tropical cyclone risk

Script:
- `code/fig3_downstream_accessibility_and_economic_losses_panels_a_to_c.m`

Panels covered by code:
- `a` one-hour metropolitan accessibility loss
- `b` two-hour megaregional accessibility loss
- `c` sectoral composition of economy-wide losses through the rail passenger-transport channel

Figure-specific data aliases used by this script:
- `data/fig3ab_accessibility_loss_values.mat`
- `data/fig3a_metropolitan_area_lookup.mat`
- `data/fig3b_megaregion_lookup.mat`
- `data/fig3c_sectoral_economywide_losses.mat`

Shared data also used:
- `data/fig2_fig3_city_level_current_and_future_impacts.mat`
  - reused here because the accessibility-loss lookups are mapped back to the same city polygon index
- `data/shared_city_boundaries_367.*`
- `data/shared_south_sea_boundary_wgs84.*`

### Fig. 4

Caption:
- persistence of spatial risk concentration across future climates and response strategies

Script:
- `code/fig4_persistence_of_spatial_risk_concentration_panels_a_to_d.m`

Panels covered by code:
- `a` APAP top-ranked city-set overlap
- `b` AATD top-ranked city-set overlap
- `c` APAP rank trajectories for the top ten current-climate cities
- `d` AATD rank trajectories for the top ten current-climate cities

Figure-specific data alias used by this script:
- `data/fig4abcd_city_rankings_current_and_future.xlsx`

Important note on scenario count:
- the workbook contains five future-scenario columns
- the current caption refers to four alternative scenarios
- the packaged Fig. 4 script therefore uses the current climate plus scenarios 1 to 4, consistent with the latest overlap-script variant in the repository

Important note on current-city subset filtering:
- panels `a-b` exclude cities with zero current-climate APAP or AATD before forming the top `x%` sets
- panels `c-d` and the Spearman outputs use the same nonzero-current subset for APAP and AATD, respectively
- for the packaged data, this leaves 289 cities in the APAP subset and 289 cities in the AATD subset

Spearman outputs:
- `fig4c_apap_rank_trajectories_spearman.csv`
- `fig4d_aatd_rank_trajectories_spearman.csv`
- `fig4cd_spearman_rank_consistency.csv`

## Figure-specific data naming rule

To align with the current manuscript structure, figure-specific aliases were added in `data/`:

- files prefixed `fig1`, `fig2`, `fig3`, or `fig4` are the caption-aligned aliases that the current scripts use
- files prefixed `shared_` are reused by multiple figures

This means:

- if a data file is dedicated to one figure or one figure block, its filename now begins with that figure number
- if a data file is reused across multiple figures, it keeps a `shared_` prefix and is explained here in the README

## Shared files

These files are reused across multiple figure scripts, so they are not labeled with a single figure number:

- `data/shared_city_boundaries_367.*`
  - shared city-boundary shapefile used by Figs. 2 and 3
- `data/shared_south_sea_boundary_wgs84.*`
  - shared inset boundary shapefile used by Figs. 2 and 3

## Legacy original-name copies

Original source filenames from the earlier packaging pass were moved into:

- `code/legacy/`
- `data/legacy/`

They are kept there as provenance copies only. The caption-aligned scripts do not depend on those legacy names; they use the `fig*` and `shared_*` aliases listed above.

## What is still missing

The following parts of the current caption set are still not reproducible from source code and source data present in this repository:

1. Fig. 1a
   - the conceptual event-level framework schematic

2. Final composite assembly details
   - panel letters
   - some final callouts and annotation placement
   - full manuscript-page layout
   These were finalized in PowerPoint rather than in recoverable MATLAB subplot or tiled-layout scripts.

## Verification status

Completed:
- package paths were converted to local relative paths
- figure-numbered scripts were added
- figure-numbered data aliases were added
- shared shapefiles were copied to ASCII `shared_*` names
- static dependency checks confirmed that the caption-aligned scripts point to files present in `data/`

Not completed here:
- full `matlab -batch` execution verification
  - a local MATLAB startup file-system error occurred inside the sandbox
  - a follow-up outside-sandbox verification request could not complete because the approval review timed out
