function [ ] = plot_erk_states( t, sim, species_names)

species_of_interest = {'FgfR_star', 'H_F', 'H_F_R', 'Ras_star', 'Raf_star', 'Nfb_star', 'Pfb_star', 'Mek_star', 'Erk_star'};

title_index = 1;
for i = 1: length(species_of_interest)
    for j = 1: length(species_names)
        if strcmp(species_names{j}, species_of_interest{i})
            string = strsplit(species_of_interest{i}, '_');
            if strcmp(string{2}, 'star')
                title_tmp = ['$\textnormal{', string{1}, '}^*$'];
            elseif strcmp(species_of_interest{i}, 'H_F_R')
                title_tmp = ['HSGAG-FGFR-FGF2'];
            elseif strcmp(species_of_interest{i}, 'H_F')
                title_tmp = ['HSGAG-FGF2'];
            end
            titles{title_index} =title_tmp;
            species_indices(title_index) = j;
            title_index = title_index+1;
        end
    end
end

num_plots = length(titles);
num_cols = 2;
num_species = size(sim, 1);

for i = 1 : num_plots
    subplot(ceil(num_plots /num_cols), num_cols, i);
    hold on;
    plot(t, sim(species_indices(i) : num_species : end , :), 'LineWidth', 2);
    title(titles{i}, 'Interpreter', 'Latex');
end
end

