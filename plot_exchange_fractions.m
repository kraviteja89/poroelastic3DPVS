function plot_exchange_fractions(exchangePercentages, captions, dt, fName)
% Make area plots for the exchange fractions
% exchangePercentages is an n_frames X 3 X n_cases array. The exchange
% percentages are in the order PVS, SAS, ECS
[n_frames, ~, n_cases] = size(exchangePercentages);
the_times = 1:n_frames;
the_times = dt*(the_times - 1);

fig = figure();
set(fig, 'Color', 'w')
set(fig, 'Position', [100 100 2000 150*(1+n_cases/2)])

newColors = [ 0.5,       0.5,   0.5;   %black
                    63/255, 169/255, 245/255;   %blue
                    1, 0, 1];  %magenta

for n = 1:n_cases
    subplot(ceil(n_cases/2), 2, n)
    a = area(the_times, fliplr(exchangePercentages(:,:,n)));
    
    a(3).FaceColor = newColors(1, :);
    a(2).FaceColor = newColors(2, :);
    a(1).FaceColor = newColors(3, :);
    xlabel('Time(s)')
    ylabel('Fluid position (%)')
    ylim([0 100])
    set(gca, 'box', 'off')
    legend({'ECS', 'SAS', 'PVS'}, 'AutoUpdate', 'off', 'Location', 'northeastoutside')
    title(captions{n})
end

saveas(fig, [fName '.png'])
saveas(fig, [fName '.pdf'])
saveas(fig, [fName '.fig'])