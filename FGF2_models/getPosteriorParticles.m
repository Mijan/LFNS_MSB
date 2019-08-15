function [posterior_particles, full_weights] = getPosteriorParticles(summary_file_name, varargin)

max_it = 1e6;
if length(varargin) > 0
    max_it = varargin{1};
end


folder_index = strfind(summary_file_name, '/');
file_name_index = strfind(summary_file_name, '_model_summary.txt');

if isempty(file_name_index)
    fprintf('The provided file musst be the *_model summary.txt file. It must be in the same folder as the other output files ( *_times.txt, _latent_states*.txt, *_measurements.txt)' );
    return;
end

folder_name = summary_file_name(1:folder_index(end));
file_name = [folder_name, summary_file_name(folder_index(end) +1 : file_name_index)];


posterior_particles = dlmread([file_name, 'posterior.txt']);

log_weights = dlmread([file_name, 'posterior_log_weights.txt']);
full_weights = exp(log_weights - max(log_weights));

end