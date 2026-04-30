function run_method_model_task(fun_type)
%RUN_METHOD_MODEL_TASK Run the original method-model main script by task id.

if nargin < 1 || ~isscalar(fun_type) || ~isnumeric(fun_type)
    error('run_method_model_task:InvalidFunType', ...
        'Provide a numeric scalar fun_type, for example 201 or 202.');
end

% The main script preserves the local fun_type variable with clearvars -except.
run(fullfile(fileparts(mfilename('fullpath')), 'main_calculate_railway_resilience_under_typhoon.m'));
end
