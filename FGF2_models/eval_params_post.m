clear all

num_post = 1000;
folder_name = 'Fgf_A1_positive';
results_folder_name = strcat(folder_name,  '/results/sus_3_20_a50');
file_name = 'fgf_';

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

 [posterior_particles, full_weights] = getPosteriorParticles(model_summary_file);
 
sample_indices = randsample(length(full_weights), num_post, 'true', full_weights);
posterior_particles = posterior_particles(sample_indices, :);

fprintf(strcat('parameters read from ', results_folder_name, '/', file_param{max_ind_param}, '\n'));
fprintf(strcat('likelihoods read from ', results_folder_name, '/',  file_like{max_ind_like}, '\n'));


p = particles(l == max(l), :);
for i = 1 : length(p)
%     if strcmp(scale{i}, 'log')
% %         posterior_particles(:, i) = 10.^posterior_particles(:, i);
%         p(i) = 10 .^ p(i);
%     end
    if strcmp(param_names{i}, 'FRET_sigma')
        posterior_particles(:, i) = 0.0001;
    end
end

if exist([results_folder_name, '/posterior.txt'], 'file') ~= 2
    dlmwrite([results_folder_name, '/posterior.txt'], posterior_particles, ' ');
    %% simulate posterior
    sim_command = ['simulate ', folder_name, ...
        '/problem_fgf_sus_3_20.xml -O ', results_folder_name, '/sim_post.txt -P ', results_folder_name, '/posterior.txt'];
    system(sim_command);
end

%% simulate best parameter
sim_command = ['simulate ', folder_name, ...
    '/problem_fgf_sus_3_20.xml -O ', results_folder_name, '/sim.txt -p'];
for i = 1: length(p)
    if strcmp(param_names{i}, 'FRET_sigma')
        sim_command = [sim_command, ' ', '0.0001'];
    else
        sim_command = [sim_command, ' ', num2str(p(i))];
    end
end

system(sim_command);

%% plot siulations
blue = [0, 0.45, 0.74];
cmap = [0, 0.45, 0.74;
    0.85, 0.33, 0.1;
    0.39, 0.47, 0.64];

delay = 9;

t = dlmread([results_folder_name, '/sim_times.txt']);
sim = dlmread([results_folder_name, '/sim_3_20_2-5ng_measurements.txt']);
max_length = length(sim);
fig = openfig('training_data_std.fig');
fig_axes = fig.Children;
axes(fig_axes(1));
hold on;

sim_post = dlmread([results_folder_name, '/sim_post_3_20_2-5ng_measurements.txt']);
% plot(t(1 : max_length) + delay, sim_post(:, 1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(3, :));
hull(1, :) = max(sim_post); 
hull(2, :) = min(sim_post);
fill([t' + delay;flipud(t' + delay)],[hull(1, :)';flipud(hull(2, :)')], cmap(1, :),'linestyle','none');
alpha(.4);
plot(t(1 : max_length) + delay, sim(1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(1, :));


sim = dlmread([results_folder_name, '/sim_3_20_250ng_measurements.txt']);
max_length = length(sim);
axes(fig_axes(4));
hold on;

sim_post = dlmread([results_folder_name, '/sim_post_3_20_250ng_measurements.txt']);
% plot(t(1 : max_length) + delay, sim_post(:, 1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(3, :));
hull(1, :) = max(sim_post); 
hull(2, :) = min(sim_post);
fill([t' + delay;flipud(t' + delay)],[hull(1, :)';flipud(hull(2, :)')], cmap(1, :),'linestyle','none');
alpha(.4);
plot(t(1 : max_length) + delay, sim(1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(1, :));


sim = dlmread([results_folder_name, '/sim_sus_2-5ng_measurements.txt']);
max_length = length(sim);
axes(fig_axes(2));
hold on;
sim_post = dlmread([results_folder_name, '/sim_post_sus_2-5ng_measurements.txt']);
% plot(t(1 : max_length) + delay, sim_post(:, 1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(3, :));
hull(1, :) = max(sim_post); 
hull(2, :) = min(sim_post);
fill([t' + delay;flipud(t' + delay)],[hull(1, :)';flipud(hull(2, :)')], cmap(1, :),'linestyle','none');
alpha(.4);
plot(t(1 : max_length) + delay, sim(1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(1, :));

sim = dlmread([results_folder_name, '/sim_sus_250ng_measurements.txt']);
max_length = length(sim);
axes(fig_axes(3));
hold on;
sim_post = dlmread([results_folder_name, '/sim_post_sus_250ng_measurements.txt']);
% plot(t(1 : max_length) + delay, sim_post(:, 1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(3, :));
hull(1, :) = max(sim_post); 
hull(2, :) = min(sim_post);
fill([t' + delay;flipud(t' + delay)],[hull(1, :)';flipud(hull(2, :)')], cmap(1, :),'linestyle','none');
alpha(.4);
plot(t(1 : max_length) + delay, sim(1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(1, :));

saveas(fig, [results_folder_name, '/model_training_4.fig']);
saveas(fig, [results_folder_name, '/model_training_4.svg'], 'svg');


%% prediction data set

if exist([results_folder_name, '/like_prediction.txt'], 'file') ~= 2
    %% compute prediction likelihood
    sim_command = ['evaluate_likelihood ', folder_name, ...
        '/problem_fgf_sus_3_20.xml -O ', results_folder_name, '/like_prediction.txt -P ', results_folder_name, '/posterior.txt', ' -H 1'];
    system(sim_command);
end

pred_likes = dlmread([results_folder_name, '/like_prediction.txt']);
pred_index = find(pred_likes == max(pred_likes));
posterior = dlmread([results_folder_name, '/posterior.txt']);
pred_p = posterior(pred_index, :);
sim_coplotmmand = ['simulate ', folder_name, ...
    '/problem_fgf_sus_3_20.xml -O ', results_folder_name, '/sim_pred.txt -p'];
for i = 1: length(pred_p)
    sim_command = [sim_command, ' ', num2str(pred_p(i))];
end
system(sim_command);


sim = dlmread([results_folder_name, '/sim_pred_sp_5_2-5ng_measurements.txt']);
max_length = length(sim);
fig = openfig('validation_data_std.fig');
fig_axes = fig.Children;
axes(fig_axes(4));
hold on;

sim_post = dlmread([results_folder_name, '/sim_post_sp_5_2-5ng_measurements.txt']);
% plot(t(1 : max_length) + delay, sim_post(:, 1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(3, :));
hull(1, :) = max(sim_post); 
hull(2, :) = min(sim_post);
fill([t' + delay;flipud(t' + delay)],[hull(1, :)';flipud(hull(2, :)')], cmap(1, :),'linestyle','none');
alpha(.4);
plot(t(1 : max_length) + delay, sim(1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(1, :));
xlim([0, 140]);

sim = dlmread([results_folder_name, '/sim_pred_sp_5_250ng_measurements.txt']);
max_length = length(sim);
axes(fig_axes(2));
hold on;
sim_post = dlmread([results_folder_name, '/sim_post_sp_5_250ng_measurements.txt']);
% plot(t(1 : max_length) + delay, sim_post(:, 1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(3, :));
hull(1, :) = max(sim_post); 
hull(2, :) = min(sim_post);
fill([t' + delay;flipud(t' + delay)],[hull(1, :)';flipud(hull(2, :)')], cmap(1, :),'linestyle','none');
alpha(.4);
plot(t(1 : max_length) + delay, sim(1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(1, :));
xlim([0, 140]);

sim = dlmread([results_folder_name, '/sim_pred_mixed_2-5ng_measurements.txt']);
max_length = length(sim);
axes(fig_axes(3));
hold on;

sim_post = dlmread([results_folder_name, '/sim_post_mixed_2-5ng_measurements.txt']);
% plot(t(1 : max_length) + delay, sim_post(:, 1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(3, :));
hull(1, :) = max(sim_post); 
hull(2, :) = min(sim_post);
fill([t' + delay;flipud(t' + delay)],[hull(1, :)';flipud(hull(2, :)')], cmap(1, :),'linestyle','none');
alpha(.4);
plot(t(1 : max_length) + delay, sim(1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(1, :));


sim = dlmread([results_folder_name, '/sim_pred_mixed_250ng_measurements.txt']);
max_length = length(sim);
axes(fig_axes(1));
hold on;

sim_post = dlmread([results_folder_name, '/sim_post_mixed_250ng_measurements.txt']);
% plot(t(1 : max_length) + delay, sim_post(:, 1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(3, :));
hull(1, :) = max(sim_post); 
hull(2, :) = min(sim_post);
fill([t' + delay;flipud(t' + delay)],[hull(1, :)';flipud(hull(2, :)')], cmap(1, :),'linestyle','none');
alpha(.4);
plot(t(1 : max_length) + delay, sim(1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(1, :));

saveas(fig, [results_folder_name, '/model_validation_4.fig']);
saveas(fig, [results_folder_name, '/model_validation_4.svg'], 'svg');


%% plot posterior
fig = figure('units','normalized','outerposition',[0 0 1 1]);
plot_erk_params(posterior_particles, full_weights, folder_name);
% savefig([results_folder_name, '/posterior.fig']);
%
%
% %% plot latent states
% sim_latent = dlmread([results_folder_name, '/sim_latent_states_sus_2-5ng.txt']);
% max_length = size(sim_latent, 2);
% fig = figure('units','normalized','outerposition',[0 0 1 1]);
% hold on;
% plot_erk_states(t(1: max_length) + delay,sim_latent(:, 1:max_length), folder_name);
%
% sim_latent = dlmread([results_folder_name, '/sim_latent_states_sus_250ng.txt']);
% max_length = size(sim_latent, 2);
% plot_erk_states(t(1: max_length) + delay,sim_latent(:, 1:max_length), folder_name);
% plot_pulse(fig,  1, 200, 0, delay);
% savefig(fig,  [results_folder_name, '/latent_states_sus.fig']);
%
% sim_latent = dlmread([results_folder_name, '/sim_latent_states_3_20_2-5ng.txt']);
% max_length = size(sim_latent, 2);
% fig = figure('units','normalized','outerposition',[0 0 1 1]);
% hold on;
% plot_erk_states(t(1: max_length) + delay,sim_latent(:, 1:max_length), folder_name);
%
% sim_latent = dlmread([results_folder_name, '/sim_latent_states_3_20_250ng.txt']);
% max_length = size(sim_latent, 2);
% plot_erk_states( t(1: max_length) + delay,sim_latent(:, 1:max_length), folder_name);
% plot_pulse(fig,  20 + delay, 3, 20, delay -1);
% savefig(fig, [results_folder_name, '/latent_states_3_20.fig']);
%
% sim_latent = dlmread([results_folder_name, '/sim_latent_states_sp_5_2-5ng.txt']);
% max_length = size(sim_latent, 2);
% fig = figure('units','normalized','outerposition',[0 0 1 1]);
% hold on;
% plot_erk_states(t(1: max_length) + delay, sim_latent(:, 1:max_length), folder_name);
%
% sim_latent = dlmread([results_folder_name, '/sim_latent_states_sp_5_250ng.txt']);
% max_length = size(sim_latent, 2);
% plot_erk_states(t(1: max_length) + delay, sim_latent(:, 1:max_length), folder_name);
% plot_pulse(fig,  1 + delay, 5, 200, delay-1);
% savefig(fig, [results_folder_name, '/latent_states_sp_5.fig']);
%
% %% Bayes factor
% % max_post = max(posterior_likes);
% % posterior_likes = posterior_likes - max_post;
% % bayes_factor = log(mean(exp(posterior_likes))) + max_post




