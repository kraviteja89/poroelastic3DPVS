% Recreates Figure4 c and d of the paper
%% Parameters
pathName = 'COMSOLExports/';
caseNames = {'Awake20', 'Symmetric20'};
captions = {'Asymmetric waveform 20% dilation', 'Symmetric waveform 20% dilation'};
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
%% Calculate and plot the exchange fractions for each case
exchangePercentage = zeros(nFrames, 3, length(caseNames));

for n = 1:length(caseNames)
     exchangePercentage(:, :, n) = pvs_exchange_percentage(pathName, caseNames{n}, reps, sasThresh);
end
plot_exchange_fractions(exchangePercentage, captions, dt, [pathName 'Fig4c'])    
%% Plot particle trajectories
for n = 1:length(caseNames)
    plot_particle_trajectories(pathName, caseNames{n}, captions{n}, dt, reps, ['Fig4d' num2str(n)])
end