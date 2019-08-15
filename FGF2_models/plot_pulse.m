function plot_pulse(fig, num_pulses, length, pause, initial_time)

fig_axes = fig.Children;
num_figs = size(fig_axes, 1);
for i = 1 : num_figs
    axes(fig_axes(i));
    xlimits = xlim;
    ylimits = ylim;
    hold on;
    t = initial_time;
    pulse_nbr = 0;
    while  pulse_nbr < num_pulses && t < xlimits(2)
        length = min(length, xlimits(2) - t);
        patch([t t+length t+length t], [0 0 ylimits(2) ylimits(2)],[0.4 0.4 0.4], 'FaceAlpha',0.5, 'EdgeColo', 'None');
        pulse_nbr= pulse_nbr + 1;
        t = t + length + pause;
    end
    xlim(xlimits);
    ylim(ylimits);
end

end