% Recreates all subplots of Fig 5 in the paper
%% Parameters
pathName = 'COMSOLExports/';
caseNames = {'Awake20', 'Awake40', 'Sleep20', 'Sleep40'};
captions = {'\zeta = 0.2, 20% dilation','\zeta = 0.2, 40% dilation', '\zeta = 0.3, 20% dilation', '\zeta = 0.3, 40% dilation'};
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
%% Plot particle trajectories
fig_name = {'a', '', '', 'd'}; 
for n = [1 nCases]
    plot_particle_trajectories(pathName, caseNames{n}, captions{n}, dt, reps, ['Fig5' fig_name{n}])
end
%% Calculate and plot the exchange fractions for each case
exchangePercentage = zeros(nFrames, 3, nCases);

for n = 1:length(caseNames)
     exchangePercentage(:, :, n) = pvs_exchange_percentage(pathName, caseNames{n}, reps, sasThresh);
end
plot_exchange_fractions(exchangePercentage, captions, dt, [pathName 'Fig5b_e'])   

%% Plot pie chart of particle positions at t=30s
fig =figure();
set(fig, 'Position', [100 100 1200 300*(1+nCases/2)])
newColors = [0.5,       0.5,   0.5;   %black
                    63/255, 169/255, 245/255;   %blue
                    1, 0, 1];  %magenta
for n = 1:nCases
    subplot(ceil(length(caseNames)/2), 2, n)
    p = pie(exchangePercentage(nFramesOld*reps/2 +1, :, n)/100, [0, 1, 1]);
    pText = findobj(p,'Type','text');
    percentValues = get(pText,'String');
    txt = {'PVS: '; 'SAS: '; 'ECS: '};
    combinedtxt = strcat(txt,percentValues);
    
    pText(1).String = combinedtxt(1);
    pText(2).String = combinedtxt(2);
    pText(3).String = combinedtxt(3);
    
    for n1 = 1:3
        pText(n1).FontSize = 15;
    end
    
    set(gca, 'FontSize', 20)
    set(gca, 'Colormap', newColors)
    title(captions{n})
    titleHandle = get( gca ,'Title' );
    pos  = get( titleHandle , 'position' );
    pos1 = pos + [0 0.05 0];
    set( titleHandle , 'position' , pos1 );
end

saveas(fig, [pathName 'Fig5c.png'])
saveas(fig, [pathName 'Fig5c.fig'])