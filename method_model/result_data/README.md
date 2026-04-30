# result_data Placeholder

This folder is the default output location for the method-model scripts.

The main script also expects some intermediate or baseline `.mat` files to already exist here for selected `fun_type` values, for example:

- `current_city_RL.mat` or `current_city_RL_OD.mat`
- `future_city_RL.mat` or `future_city_RL_OD_585_7010_sim_2000.mat`
- `norm_city_city_time.mat`
- `norm_city_route_pass.mat`
- `norm_sys_fun.mat`
- `norm_city_fun.mat`
- `norm_pro_fun.mat`
- `norm_eco_fun.mat`

Generated outputs from completed runs can also be stored here.

The city-level resilience-loss files above are also used by `figure_reproduction/code/fig2_current_future_passenger_impact_patterns_panels_a_to_f.m` for Fig. 2e-f when they are available.
