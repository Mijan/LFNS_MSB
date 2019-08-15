clear all

folder_name = 'Fgf_B3';
results_folder_name = strcat(folder_name, '/results/all_a50');
file_name = 'fgf_';
problem_file = 'problem_fgf_all.xml';

file = dir(strcat(results_folder_name));
file_param = regexpi({file.name}, strcat(file_name, 'live_points_[0-9]*.txt'),'match');
file_like = regexpi({file.name}, strcat(file_name, 'live_points_[0-9]*_log_likelihoods.txt'),'match');
file_post = [file_name, 'posterior.txt'];
model_summary_file  = [results_folder_name, '/', file_name, 'model_summary.txt'];
[param_names, species_names, scale, bounds] = readModelDescription(model_summary_file);


file_param = [file_param{:}];
file_like = [file_like{:}];

max_nbr_like = -1;
max_ind_like = -1;
for i = 1 : length(file_like)
   str = strsplit(file_like{i}, '_');
   nbr = str2num(str{4});
   if(nbr > max_nbr_like)
      max_nbr_like = nbr; max_ind_like = i; 
   end
end

max_nbr_param = -1;
max_ind_param = -1;
for i = 1 : length(file_param)
   str = strsplit(file_param{i}, '_');
   str = strsplit(str{4}, '.');
   nbr = str2num(str{1});
   if(nbr > max_nbr_param)
      max_nbr_param = nbr; max_ind_param = i; 
   end
end

if max_nbr_param ~=max_nbr_like
    fprintf('parameter and likelihood indices seem not to be consistent!');
    return
end

l = dlmread(strcat(results_folder_name, '/', file_like{max_ind_like}));
particles = dlmread(strcat(results_folder_name, '/', file_param{max_ind_param}));

fprintf(strcat('parameters read from ', results_folder_name, '/', file_param{max_ind_param}, '\n'));
fprintf(strcat('likelihoods read from ', results_folder_name, '/',  file_like{max_ind_like}, '\n'));



p = particles(l == max(l), :);
p = p(1, :);
%p = [0.0093616 3.5274e-06 0.039974 0.049206 71.252 1.1763e-05 6.9714e-05 0.094988 0.0096454 26.788 0.17642 0.20527 0.10982 0.39827 5.036e-05 0.82189 0.43044 0.00022149 0.00010465 7.3656e-05 0.00056135 0.78498 0.84399 0.066517 0.038914 0.010783 0.089931 94.556 1.5657 0.37434 0.16043 0.27185 0.0079062 0.010478];

sim_command = ['simulate ', folder_name, ...
   '/', problem_file, ' -O ', results_folder_name, '/sim.txt -p'];
for i = 1: length(p)
    if strcmp(param_names{i}, 'FRET_sigma')
        sim_command = [sim_command, ' ', '0.0001'];
    else
        sim_command = [sim_command, ' ', num2str(p(i))];
    end
end

system(sim_command);

%% plot siulations
cmap = [0, 0.45, 0.74;
    0.85, 0.33, 0.1];

delay = 9;

t = dlmread([results_folder_name, '/sim_times.txt']);
sim = dlmread([results_folder_name, '/sim_3_20_2-5ng_measurements.txt']);
max_length = length(sim);
fig = openfig('training_data_std.fig');
fig_axes = fig.Children;
axes(fig_axes(1));
hold on;
plot(t(1 : max_length) + delay, sim(1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(1, :));

sim = dlmread([results_folder_name, '/sim_3_20_250ng_measurements.txt']);
max_length = length(sim);
axes(fig_axes(4));
hold on;
plot(t(1 : max_length) + delay, sim(1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(1, :));


sim = dlmread([results_folder_name, '/sim_sus_2-5ng_measurements.txt']);
max_length = length(sim);
axes(fig_axes(2));
hold on;
plot(t(1 : max_length) + delay, sim(1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(1, :));

sim = dlmread([results_folder_name, '/sim_sus_250ng_measurements.txt']);
max_length = length(sim);
axes(fig_axes(3));
hold on;
plot(t(1 : max_length) + delay, sim(1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(1, :));

saveas(fig, [results_folder_name, '/model_training.fig']);
saveas(fig, [results_folder_name, '/model_training.eps'], 'epsc');

sim = dlmread([results_folder_name, '/sim_sp_5_2-5ng_measurements.txt']);
max_length = length(sim);
fig = openfig('validation_data_std.fig');
fig_axes = fig.Children;
% axes(fig_axes(6));
axes(fig_axes(4));
hold on;
plot(t(1 : max_length) + delay, sim(1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(1, :));

% sim = dlmread([results_folder_name, '/sim_measurements_sp_5_25ng.txt']);
% max_length = length(sim);
% axes(fig_axes(5));
% hold on;
% plot(t(1 : max_length) + delay, sim(1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(1, :));

sim = dlmread([results_folder_name, '/sim_sp_5_250ng_measurements.txt']);
max_length = length(sim);
% axes(fig_axes(4));
axes(fig_axes(2));
hold on;
plot(t(1 : max_length) + delay, sim(1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(1, :));

sim = dlmread([results_folder_name, '/sim_mixed_2-5ng_measurements.txt']);
max_length = length(sim);
axes(fig_axes(3));
hold on;
plot(t(1 : max_length) + delay, sim(1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(1, :));

% sim = dlmread([results_folder_name, '/sim_measurements_mixed_25ng.txt']);
% max_length = length(sim);
% axes(fig_axes(2));
% hold on;
% plot(t(1 : max_length) + delay, sim(1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(1, :));

sim = dlmread([results_folder_name, '/sim_mixed_250ng_measurements.txt']);
max_length = length(sim);
axes(fig_axes(1));
hold on;
plot(t(1 : max_length) + delay, sim(1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(1, :));

saveas(fig, [results_folder_name, '/model_validation.fig']);
saveas(fig, [results_folder_name, '/model_validation.eps'], 'epsc');


% %% plot posterior
% fig = figure('units','normalized','outerposition',[0 0 1 1]);
% plot_erk_params(posterior, folder_name);
% savefig([results_folder_name, '/posterior.fig']);
% 
% 
%% plot latent states
sim_latent = dlmread([results_folder_name, '/sim_sus_2-5ng_latent_states.txt']);
max_length = size(sim_latent, 2);
fig = figure('units','normalized','outerposition',[0 0 1 1]);
hold on;
plot_erk_states(t(1: max_length) + delay,sim_latent(:, 1:max_length), species_names);

sim_latent = dlmread([results_folder_name, '/sim_sus_250ng_latent_states.txt']);
max_length = size(sim_latent, 2);
plot_erk_states(t(1: max_length) + delay,sim_latent(:, 1:max_length), species_names);
plot_pulse(fig,  1, 200, 0, delay);
savefig(fig,  [results_folder_name, '/latent_states_sus.fig']);

sim_latent = dlmread([results_folder_name, '/sim_3_20_2-5ng_latent_states.txt']);
max_length = size(sim_latent, 2);
fig = figure('units','normalized','outerposition',[0 0 1 1]);
hold on;
plot_erk_states(t(1: max_length) + delay,sim_latent(:, 1:max_length), species_names);

sim_latent = dlmread([results_folder_name, '/sim_3_20_250ng_latent_states.txt']);
max_length = size(sim_latent, 2);
plot_erk_states( t(1: max_length) + delay,sim_latent(:, 1:max_length), species_names);
plot_pulse(fig,  20 + delay, 3, 20, delay -1);
savefig(fig, [results_folder_name, '/latent_states_3_20.fig']);

sim_latent = dlmread([results_folder_name, '/sim_sp_5_2-5ng_latent_states.txt']);
max_length = size(sim_latent, 2);
fig = figure('units','normalized','outerposition',[0 0 1 1]);
hold on;
plot_erk_states(t(1: max_length) + delay, sim_latent(:, 1:max_length), species_names);

sim_latent = dlmread([results_folder_name, '/sim_sp_5_250ng_latent_states.txt']);
max_length = size(sim_latent, 2);
plot_erk_states(t(1: max_length) + delay, sim_latent(:, 1:max_length), species_names);
plot_pulse(fig,  1 + delay, 5, 200, delay-1);
savefig(fig, [results_folder_name, '/latent_states_sp_5.fig']);

%% Bayes factor
% max_post = max(posterior_likes);
% posterior_likes = posterior_likes - max_post;
% bayes_factor = log(mean(exp(posterior_likes))) + max_post



