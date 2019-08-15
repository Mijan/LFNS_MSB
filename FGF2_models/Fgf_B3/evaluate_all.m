

% my_plot= open('all_sim.fig');
data_folder = '../Yannick_data';
stimulations = {'fgf_sp_5', 'fgf_sp_10', 'fgf_sp_60', 'fgf_sus', 'fgf_3_20', 'fgf_mixed', 'fgf_NaClO3'};
file_names = {'0-25ng_mean_trunc.txt', '2-5ng_mean_trunc.txt', '25ng_mean_trunc.txt', '250ng_mean_trunc.txt'};

results_folder = 'results/all_a50';
results_folder_2 = 'results/sus_3_20';
sim_name = 'sim';
sim_name_2 = 'sim_post';
sim_stimulations = {'sp_5', 'sp_10', 'sp_60', 'sus', '3_20', 'mixed', '3_20'};
sim_strenghts = {'0-25ng', '2-5ng', '25ng', '250ng'};
counter = 1;
c = [0.85, 0.33, 0.1];

mse_all = 0;
mse_prev = 0;
cmap = [0, 0.45, 0.74;0.85, 0.33, 0.1];
for stim_nbr = 1: length(stimulations)
    for file_nbr = 1: length(file_names)
        subplot(7, 4, counter);
        if(stim_nbr == 5 && file_nbr ==1)
        elseif(stim_nbr == 7 && file_nbr < 4)
        else
            
            if(stim_nbr == 7)
                sim_strenghts{4} = '250ngNaCl';
            end
            %         axes(fig.Children((counter)));
            d = dlmread([data_folder, '/', stimulations{stim_nbr}, '/', file_names{file_nbr}]);
            d_t = dlmread([data_folder, '/', stimulations{stim_nbr}, '/time_trunc.txt']);
            sall = dlmread([results_folder, '/', sim_name, '_', sim_stimulations{stim_nbr}, '_', sim_strenghts{file_nbr}, '_measurements.txt']);
            sim_post = dlmread([results_folder_2, '/', sim_name_2, '_', sim_stimulations{stim_nbr}, '_', sim_strenghts{file_nbr}, '_measurements.txt']);
            sall_t = dlmread([results_folder, '/', sim_name, '_times.txt']);
            
            s_previous = dlmread([results_folder_2, '/', sim_name, '_', sim_stimulations{stim_nbr}, '_', sim_strenghts{file_nbr}, '_measurements.txt']);
            
            min_t = min(length(d), length(sall));
            mse_all =mse_all +  norm(d(1:min_t)- sall(1:min_t)) ^2;
            mse_prev =mse_prev +  norm(d(1:min_t) -s_previous(1:min_t)) ^2;
            
            plot(d_t, d, 'k', 'Linewidth', 4);
            hold on;
            
            max_length = min(length(sall_t), length(s_previous));
            hull(1, :) = max(sim_post);
            hull(2, :) = min(sim_post);
            fill([sall_t' ;flipud(sall_t' )],[hull(1, :)';flipud(hull(2, :)')], cmap(1, :),'linestyle','none');
            alpha(.4);
            plot(sall_t(1 : max_length), s_previous(1 : max_length), '-', 'LineWidth', 2, 'Color', cmap(1, :));
            
            plot(sall_t, sall,  'Linewidth', 2, 'Color', c);
        end
        counter= counter + 1;
    end
end