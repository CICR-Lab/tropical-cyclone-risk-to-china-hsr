# source_data Placeholder

Place the method-model input datasets required by `src/main_calculate_railway_resilience_under_typhoon.m` in this folder.

The current workspace does not contain these files, but the script references inputs such as:

- `pro_railway_system.mat`
- `model_para.mat`
- `rail_net_time.mat`
- `rail_city.mat`
- `typhoon_train_outage.mat`
- `current_typhoon_train_outage.mat`
- `current_sim_TC_id.mat`
- `future_typhoon_train_outage.mat`
- `future_typhoon_train_outage_sim.mat`
- `future_typhoon_train_outage_ssp245_7010_sim.mat`
- `future_typhoon_train_outage_ssp585_7010_sim.mat`
- `future_sim_TC_id.mat`
- `current_typhoon_station_outage_sim.mat`
- `future_typhoon_station_outage_sim.mat`
- `city_center.mat`
- `city_Income.mat`
- `city_pop.mat`
- `city_TF_mat.mat`
- `ssp245_2070_2100_climate.mat`
- `future_climate_era5.mat`
- `future_climate_mix_gcms.mat`

If additional source files are needed for your chosen `fun_type`, add them here as well.

These socioeconomic inputs are also used by `figure_reproduction/code/fig2_current_future_passenger_impact_patterns_panels_a_to_f.m` to generate the income-ranked curves in Fig. 2e-f.
