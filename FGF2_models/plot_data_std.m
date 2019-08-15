
figure()
folder = ('Yannick_data/fgf_NaClO3/');
d = dlmread([folder, '250ng.txt']);
t = dlmread([folder, 'time.txt']);

first_stim = 43;
delay = 9;

d(:, t < first_stim - delay) = [];
t(t < first_stim - delay) = [];
t = t - t(1);

% plot(t, d)
dy = std(d)';%.1*(1+rand(size(y))).*y;  % made-up error values

x = t';
y = mean(d)';

n = size(d, 1);
SEM = std(d)' ./sqrt(n);               % Standard Error
ts = tinv([0.025  0.975],n-1);% T-Score

dy(:, 1) = ts(1) .* SEM;
dy(:, 2) = ts(2) .* SEM;
% dy = y + tmp;                      % Confidence Intervals

fill([x;flipud(x)],[y+dy(:, 2);flipud(y+dy(:, 1))], 'k' ,'linestyle','none');
% errorbar(x, y, dy(:, 1))
alpha(.2);
hold on;
plot(x,y, 'k', 'Linewidth', 4)