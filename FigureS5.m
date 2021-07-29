% creates subplots b, c and d for Figure S4
%% Set parameters
pathName = 'Results/';
caseNames = {'Freq8', 'Freq4', 'Freq2', 'Awake20', 'Freqpt5' };
dilation_times = 10*2.^(-4:0);

nFramesOld = 200;
dt = 0.05;
reps = 6;
sasThresh = 222.667; % The COMSOL Multiphysics model is offset by 80 microns in the z-direction

nFrames = reps*nFramesOld + 1;
nCases = length(caseNames);
%% Calculate the PVS particle trajectories
for n = 1:nCases
    if isfile([pathName caseNames{n} '_reps'  num2str(reps) '.mat'])
        fprintf('file : %s  already exists \n',[pathName caseNames{n} '_reps'  num2str(reps) '.mat'] )
        continue
    end
    particle_trajectories_3D(pathName, [caseNames{n} '/'], reps)
end
%% Calculate and plot the exchange fractions for all the cases
exchangePercentage = zeros(nFrames, 3, nCases);
captions = cell(1,6);

for n = 1:nCases
     exchangePercentage(:, :, n) = pvs_exchange_percentage(pathName, caseNames{n}, reps, sasThresh);
     captions{n} = [num2str(dilation_times(n)) 's Dilation' ];
end
plot_exchange_fractions(exchangePercentage, captions, dt, [pathName 'FigS5c_d'])   
%% Plot exchange percentage for the last frame
fig = figure();
set(fig, 'Position', [100 100 1200 900], 'color', 'w')

exchangePercEnd = squeeze(exchangePercentage(end,:,:));
h = bar(dilation_times, exchangePercEnd', 0.2, 'stacked');
xlabel('Dilation time (s)')
ylabel('Fluid exchange percentage')
legend('PVS', 'SAS', 'ECS', '')
ylim([0 100])
legend({'PVS', 'SAS', 'ECS'}, 'AutoUpdate', 'off', 'Location', 'northeastoutside')

yyaxis right
plot(dilation_times, exchangePercEnd(3,:), '.-', 'LineWidth', 3)
ylim([0 100])
set(gca, 'YDir', 'reverse')
ylabel('Fluid exchanged with ECS (%)')

saveas(fig, [pathName 'FigS5b.png'])
saveas(fig, [pathName 'FigS5b.pdf'])
saveas(fig, [pathName 'FigS5b.fig'])
