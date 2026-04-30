function run_all_manuscript_figures()
%RUN_ALL_MANUSCRIPT_FIGURES Run the caption-aligned manuscript figure scripts.

fprintf('Running Fig. 1 code-backed validation panels...\n');
fig1_event_level_impact_validation_panels_b_to_e();

fprintf('Running Fig. 2 code-backed passenger-impact panels...\n');
fig2_current_future_passenger_impact_patterns_panels_a_to_f();

fprintf('Running Fig. 3 downstream accessibility and economic-loss panels...\n');
fig3_downstream_accessibility_and_economic_losses_panels_a_to_c();

fprintf('Running Fig. 4 spatial-risk persistence panels...\n');
fig4_persistence_of_spatial_risk_concentration_panels_a_to_d();

paths = package_paths(mfilename('fullpath'));
fprintf('Done. Outputs were written under:\n%s\n', paths.output_root);

end
