% creates all the subplots for Figure S6
%% Set parameters
pathName = 'Results/';
asymmCases = {'Awake05', 'Awake10', 'Awake15', 'Awake20', 'Awake25', 'Awake30'};
symmCases = {'Symmetric05', 'Symmetric10', 'Symmetric15', 'Symmetric20', 'Symmetric25', 'Symmetric30'};

nFramesOld = 200;
dt = 0.05;
reps = 6;
sasThresh = 222.667; % The COMSOL Multiphysics model is offset by 80 microns in the z-direction

nFrames = reps*nFramesOld + 1;

max_dilation = 0.375*(1:6); %micron
asymm_AOC = 0.825*(1:6); %micron-second
symm_AOC = 0.4125*(1:6); %micron-second
%% Calculate the PVS particle trajectories
for n = 1:6
    if isfile([pathName asymmCases{n} '_reps'  num2str(reps) '.mat'])
        fprintf('file : %s  already exists \n',[pathName asymmCases{n} '_reps'  num2str(reps) '.mat'] )
        continue
    end
    particle_trajectories_3D(pathName, [asymmCases{n} '/'], reps, dt)
end

for n = 1:6
    if isfile([pathName symmCases{n} '_reps'  num2str(reps) '.mat'])
        fprintf('file : %s  already exists \n',[pathName symmCases{n} '_reps'  num2str(reps) '.mat'] )
        continue
    end
    particle_trajectories_3D(pathName, [symmCases{n} '/'], reps, dt)
end
%% Calculate the fluid exchange with ECS
asymmExchangePercentage = zeros(6, 3);
symmExchangePercentage = zeros(6, 3);

for n = 1:6
     asymmExchangePercentage(n,:) = end_exchange_percentage(pathName, asymmCases{n}, reps, sasThresh);
     symmExchangePercentage(n,:) = end_exchange_percentage(pathName, symmCases{n}, reps, sasThresh);
end
%% Calculate the maximum peclet number 
max_Peclet_asymm = zeros(1, 6); 
max_Peclet_symm = zeros(1,6);
pecletLimit = 1;

for n = 1:6
    max_Peclet_asymm(n) = plot_peclet_numbers(pathName, asymmCases{n});
    max_Peclet_symm(n) = plot_peclet_numbers(pathName, symmCases{n});
end
%% Compare the maximum displacement and AOC with fluid exchange parameters
fig = figure();
set(fig, 'Position', [100 100 1400 900], 'color', 'w')

subplot(2,2,1)
plot(max_dilation, max_Peclet_asymm, 'go-', 'LineWidth', 2);
hold on
plot(max_dilation, max_Peclet_symm, 'm^-', 'LineWidth', 2);
legend('Asymmetric', 'Symmetric', 'Location', 'northwest')
xlabel('Max dilation amplitude (\mum)')
ylabel('Maximum radial Peclet number')
set(gca, 'box', 'off', 'FontSize', 15, 'XLim', [0 2.5], 'YLim', [0 3.5])


subplot(2,2,2)
plot(asymm_AOC(1:3), max_Peclet_asymm(1:3), 'go-', 'LineWidth', 2);
hold on
plot(symm_AOC, max_Peclet_symm, 'm^-', 'LineWidth', 2);
legend('Asymmetric', 'Symmetric', 'Location', 'northwest')
xlabel('Area under dilation curve (\mum-s)')
ylabel('Maximum  radial Peclet number')
set(gca, 'box', 'off', 'FontSize', 15, 'XLim', [0 2.5], 'YLim', [0 2.5])

subplot(2,2,3)
plot(max_dilation, asymmExchangePercentage(:,3) , 'go-', 'LineWidth', 2);
hold on
plot(max_dilation, symmExchangePercentage(:,3), 'm^-', 'LineWidth', 2);
legend('Asymmetric', 'Symmetric', 'Location', 'northwest')
xlabel('Max dilation amplitude (\mum)')
ylabel('Fluid exchanged with ECS (%)')
set(gca, 'box', 'off', 'FontSize', 15, 'XLim', [0 2.5], 'YLim', [0 50])


subplot(2,2,4)
plot(asymm_AOC(1:3),  asymmExchangePercentage(1:3,3) , 'go-', 'LineWidth', 2);
hold on
plot(symm_AOC, symmExchangePercentage(:,3), 'm^-', 'LineWidth', 2);
legend('Asymmetric', 'Symmetric', 'Location', 'northwest')
xlabel('Area under dilation curve (\mum-s)')
ylabel('Maximum  radial Peclet number')
set(gca, 'box', 'off', 'FontSize', 15, 'XLim', [0 2.5], 'YLim', [0 27])

saveas(fig, [pathName 'FigS6.png']);
saveas(fig, [pathName 'FigS6.pdf']);
saveas(fig, [pathName 'FigS6.fig']);
