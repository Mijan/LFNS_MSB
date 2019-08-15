function [] = plotPosterior(summary_file_name)
%% The input is
%   summary_file_name: The path and name of the model summary file. The
%                       path can be absolute or relative
%                       (./results/birth_death_model_summary.txt for
%                       instance. The model summary file must be in the
%                       same folder as all other results files

clear global
max_it = 5000000;
folder_index = strfind(summary_file_name, '/');
file_name_index = strfind(summary_file_name, '_model_summary.txt');

if isempty(file_name_index)
    fprintf('The provided file musst be the *_model_summary.txt file. It must be in the same folder as the other output files ( *_times.txt, _latent_states*.txt, *_measurements.txt)' );
    return;
end

folder_name = summary_file_name(1:folder_index(end));
file_name = [folder_name, summary_file_name(folder_index(end) +1 : file_name_index)];


[param_names, species_names, scales, bounds] = readModelDescription(summary_file_name);
[posterior, weights] = getPosteriorParticles(summary_file_name, max_it);

for i = 1: length(scales)
    if strcmp( scales{i}, 'log')
        posterior(:, i) = log10(posterior(:, i));
    end
end

num_params = length(param_names);
num_cols = 1;
if num_params > 1
    num_cols = 2;
end
num_rows = ceil(num_params / 2);

samples = randsample(1:size(posterior, 1), 100000, true, weights);

for i = 1 : num_params
    subplot(num_cols, num_rows, i);
    [f, xi] =   ksdensity(posterior(:, i), 'weights', weights);%, 'Bandwidth', 0.5);
    plot(xi, f);
    hold on;
    [counts, bin] = hist(posterior(samples, i));
%     bar(bin, (counts / (max(counts))) * max(f), 'FaceColor', [0, .45, .74]);
    bar(bin, (counts / (max(counts))) * max(f), 'FaceColor', [0.85, .33, .1]);
%     bar(bin, (counts / (max(counts))) * max(f), 'FaceColor', [0.93, .69, .13]);
    hold on;
    if strcmp(scales{i}, 'log') == 1
        title(['log(', param_names{i}, ')']);
        xlim(log10(bounds(i, :)));
    else
        title(param_names{i});
        xlim(bounds(i, :));
    end
end

% figure();
% plotErrors(summary_file_name, max_it);

end