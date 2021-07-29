% creates all the subplots for Figure S4
%% Set parameters
pathName = 'Results/';
caseNames = {'k516', 'k115', 'Awake20', 'k415', 'k815'};
permeability = (8.0e-15)*2.^(-4:0);

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
    particle_trajectories_3D(pathName, [caseNames{n} '/'], reps, dt)
end
%% Calculate and plot the exchange fractions for all the cases
exchangePercentage = zeros(nFrames, 3, nCases);
captions = cell(1,6);

for n = 1:nCases
     exchangePercentage(:, :, n) = pvs_exchange_percentage(pathName, caseNames{n}, reps, sasThresh);
     captions{n} = ['Permeability:'  num2str(permeability(n)) '(m^2)' ];
end
plot_exchange_fractions(exchangePercentage, captions, dt, [pathName 'FigS4b_c'])   
%% Plot exchange percentage for the last frame
fig = figure();
set(fig, 'Position', [100 100 1200 900], 'color', 'w')

exchangePercEnd = squeeze(exchangePercentage(end,:,:));
h = bar(permeability, exchangePercEnd', 0.2, 'stacked');
xlabel('Permeability (m^2)')
ylabel('Fluid exchange percentage')
legend('PVS', 'SAS', 'ECS', '')
ylim([0 100])
legend({'PVS', 'SAS', 'ECS'}, 'AutoUpdate', 'off', 'Location', 'northeastoutside')

yyaxis right
plot(permeability, exchangePercEnd(3,:), '.-', 'LineWidth', 3)
ylim([0 100])
set(gca, 'YDir', 'reverse')
ylabel('Fluid exchanged with ECS (%)')

saveas(fig, [pathName 'FigS4a.png'])
saveas(fig, [pathName 'FigS4a.pdf'])
saveas(fig, [pathName 'FigS4a.fig'])
