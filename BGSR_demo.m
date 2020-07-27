clc, clear all, close all,
rng default
addpath('src')
addpath('snnf')
addpath('libsvm-3.23')
addpath('libsvm-3.23/matlab')
addpath('aeolianine')



%% Setting parameters

mu1 = 0.8; % Mean parameter of the first Gaussian distribution
sigma1 = 0.4; % Standard deviation parameter of the first Gaussian distribution

mu2 = 0.7; % Mean parameter of the second Gaussian distribution
sigma2 = 0.6; % Standard deviation parameter of the second Gaussian distribution

kn = 10; % Number of selected features


%% Simulate graph data for simply running the code

% In this exemple,each class has its own statistical distribution

[HR_data,LR_average_data, LR_max_data] = simulateData_LR_HR(mu1, sigma1, mu2, sigma2); % data simulation using Gaussian distribution

%%  Initialisation

c = cvpartition(size(LR_average_data.Labels,1),'LeaveOut');
decision_score = zeros(size(LR_average_data.Labels,1),1); %vector of decision values (indep.of treshold)
[sz1,sz2,sz3] = size(LR_average_data.X);
% ind_Nf = zeros(size(LR_average_data.Labels,1),Nf); % Store the indices of thr top discriminative features
HR_features = HR_data.Featurematrix;

for m = 1 : c.NumObservations
    
    mm = num2str(m)
    
    % Create training and testing sets
    testIndex = c.test(m);
    trainIndex = c.training(m);
    train_Labels = LR_average_data.Labels(trainIndex);
    train_data = LR_average_data.X(trainIndex,:,:);
    test_Label = LR_average_data.Labels(testIndex);
    test_data = LR_average_data.X(testIndex,:,:);
    
    
    %% BGSR execution
    
    [pHR] = BGSR(train_data,train_Labels,HR_features,kn); 
    pHR_all(m,:)=pHR;
end
    
    GT_HR = (squeeze(HR_data.X(size(HR_data.Labels,1),:,:)));
 
    figure
    
    imagesc(GT_HR) ,title('Ground truth HR ','Color','b') % Display Ground truth of the last subject
    
    pause(2)
    
    figure
    
    imagesc(squeeze(LR_average_data.X(size(LR_average_data.Labels,1),:,:))) ,title('LR ','Color','b') % Display the LR matrix of the last subject
    
    pause(2)
    
    Pred_HR = reshape(pHR,(size(GT_HR,1)),(size(GT_HR,1)));
    Pred_HR = Pred_HR + Pred_HR'; 
    
    figure
    
    imagesc(Pred_HR) ,title('Predicted HR ','Color','b') % Display of the predicted HR of the last subject
    
    pause(2)
    
    Res = abs((GT_HR) - Pred_HR);
    
    figure
    
    imagesc(Res) ,title('Residual between predicted HR and GT HR ','Color','b') % Display of the residual between predicted and GT HR the last subject
    
    pause(2)
    
er = HR_features-pHR_all;
 
MAE = mae(er);
 
PC = corrcoef(HR_features,pHR_all);
%% Display final results

fprintf('\n')
disp( '                             Final results using LOO-CV                            ');
fprintf('\n')
disp(['****************** Mean absolute error = ' num2str(MAE) ' ******************']);
fprintf('\n')
disp(['****************** Pearson correlation = ' num2str(PC(2,1)) ' ******************']);

 