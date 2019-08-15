
clear all;

setenv('LD_LIBRARY_PATH', 'LD_LIBRARY_PATH:/usr/local/lib64');
config_file = 'expression_model/expression_config_file.xml';
output_file = 'expression_model/sim_results.txt';
num_sim  = 1;
sim_command = ['simulate ', config_file, ' -O ', output_file, ' -n ', int2str(num_sim)];
system(sim_command);

plotSystem('expression_model/sim_results_model_summary.txt');