% creates all the subplots for Figure S2
%% Parameters
pathName = 'Results/';
caseNames = {'Awake20', 'Awake20n'};
captions = {'20 \mum/s flow in SAS', '2 \mum/s flow in SAS'};
nFramesOld = 200;
dt = 0.05;
reps = 6;
sasThresh = 222.667; % The COMSOL Multiphysics model is offset by 80 microns in the z-direction

nFrames = reps*nFramesOld + 1;
nCases = length(caseNames);
%% Plot Peclet Numbers
for n = 1:length(caseNames)
    maxPecletNumber = plot_peclet_numbers(pathName, caseNames{n}, pecletLimit, captions{n}, ['FigS2a' num2str(n)]);
    fprintf('Maximum time-averaged Peclet number for %s is %.3f \n', captions{n}, maxPecletNumber)
end
%% Calculate the PVS particle trajectories
for n = 1:nCases
    if isfile([pathName caseNames{n} '_reps'  num2str(reps) '.mat'])
        fprintf('file : %s  already exists \n',[pathName caseNames{n} '_reps'  num2str(reps) '.mat'] )
        continue
    end
    particle_trajectories_3D(pathName, [caseNames{n} '/'], reps, dt)
end
%% Calculate and plot the exchange fractions for each case
exchangePercentage = zeros(nFrames, 3, length(caseNames));

for n = 1:length(caseNames)
     exchangePercentage(:, :, n) = pvs_exchange_percentage(pathName, caseNames{n}, reps, sasThresh);
end
plot_exchange_fractions(exchangePercentage, captions, dt, [pathName 'FigS2b'])    
%% Plot particle trajectories
for n = 1:length(caseNames)
    plot_particle_trajectories(pathName, caseNames{n}, captions{n}, dt, reps, ['FigS2c' num2str(n)])
end