% Recreates figure 3b of the paper
%% Parameters
pathName = 'Results/';
caseNames = {'Awake20', 'Symmetric20'};
captions = {'Asymmetric waveform 20% dilation', 'Symmetric waveform 20% dilation'};
pecletLimit = 1;

%% Plot Peclet Numbers
for n = 1:length(caseNames)
    maxPecletNumber = plot_peclet_numbers(pathName, caseNames{n}, pecletLimit, captions{n}, ['Fig3b' num2str(n)]);
    fprintf('Maximum time-averaged Peclet number for %s is %.3f \n', captions{n}, maxPecletNumber)
end