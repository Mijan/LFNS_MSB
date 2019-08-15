function [ ] = plot_erk_states_paper( t, sim, varargin)

titles = {'FgfR', 'HSGAG', 'Nfb', 'Ras', 'Raf', 'Mek', 'Erk'};
num_plots = length(titles);
num_cols = 2;
num_species = 15;
if(length(varargin) > 0)
    indices = varargin{1};
    sim_tmp = [];
    [n, m] = size(indices);
    if n > 1 && m == 1
        indices = indices';
    end
    for i = indices
        sim_tmp = [sim_tmp; sim((i-1) * num_species +1: i*num_species, :)];
    end
    sim =sim_tmp;
end
num_simulations = length(sim(:, 1)) / num_species;
spec_indices{1} = [11, 12];
legends{1} = {'FgfR', 'FgfR^*'};
spec_indices{2} = [13, 14, 15];
legends{2} = {'H', 'H-F', 'H-F-R'};
spec_indices{3} = [9, 10];
legends{3} = {'Nfb', 'Nfb^*'};
spec_indices{4} = [1, 2];
legends{4} = {'Ras', 'Ras^*'};
spec_indices{5} = [3, 4];
legends{5} = {'Raf', 'Raf^*'};
spec_indices{6} = [5, 6];
legends{6} = {'Mek', 'Mek^*'};
spec_indices{7} = [7, 8];
legends{7} = {'Erk', 'Erk^*'};
species_indices = [12, 13, 14, 15, 10, 2, 4, 6, 8];

cmap = colormap(lines);
for i = 1 : num_plots
    subplot(ceil(num_plots /num_cols), num_cols, i);
    hold on;
    ind = spec_indices{i};
    for j = 1 : length(ind)
        plot(t, sim(ind(j) : num_species : end , :), 'Color', cmap(j, :));
    end
    legend(legends{i});
    title(titles{i});
end
end

