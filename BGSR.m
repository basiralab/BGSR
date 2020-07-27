%% Main function of BGSR framework for brain graph super-resolution .
% Details can be found in the original paper:Brain Graph Super-Resolution for Boosting Neurological
% Disorder Diagnosis using Unsupervised Multi-Topology Residual Graph Manifold Learning.


%   ---------------------------------------------------------------------

%     This file contains the implementation of the key steps of our BGSR framework:
%     (1) Estimation of a connectional brain template (CBT)
%     (2) Proposed CBT-guided graph super-resolution :
%
%                       [pHR] = BGSR(train_data,train_Labels,HR_features,kn)
%
%                 Inputs:
%
%                          train_data: ((n-1) × m × m) tensor stacking the symmetric matrices of the training subjects (LR
%                          graphs)
%                                      n the total number of subjects
%                                      m the number of nodes
%
%                          train_Labels: ((n-1) × 1) vector of training labels (e.g., -1, 1)
%
%                          HR_features:   (n × (m × m)) matrix stacking the source HR brain graph.
%
%                          Kn: Number of most similar LR training subjects.
%
%
%                 Outputs:
%                         pHR: (1 × (m × m)) vector stacking the predicted features of the testing subject.
%
%
%
%     To evaluate our framework we used Leave-One-Out cross validation strategy.



%To test BGSR on random data, we defined the function 'simulateData_LR_HR' where the size of the dataset is chosen by the user.
% ---------------------------------------------------------------------
%     Copyright 2019 Islem Mhiri, Sousse University.
%     Please cite the above paper if you use this code.
%     All rights reserved.
%     """

%%------------------------------------------------------------------------------


function [pHR] = BGSR(train_data,train_Labels,HR_features,kn)

[sz1,sz2,sz3] = size(train_data);
%% (1) Estimation of a connectional brain template (CBT)
[CBT] = Atlas(train_data,train_Labels);
%% (2) Proposed CBT-guided graph super-resolution
Cl = zeros(sz1,sz2);
Cd = zeros(sz1,sz2);
Cb = zeros(sz1,sz2);
for i=1: sz1
    
    R(i,:,:) = abs(squeeze(train_data(i,:,:))-CBT);   % Residual brain graph
    Cd(i,:) = degrees(squeeze(R(i,:,:))); % Degree matrix
    Cl(i,:) = closeness(squeeze(R(i,:,:))); % Closeness matrix
    Cb(i,:) = nodeBetweenness(squeeze(R(i,:,:))); % Betweenness matrix
    
end

[t5, SCd, F1, ydata1,alpha1] = SIMLR(Cd,1,10); % Degree similarity matrix
[te9, SCl, Fe9, ydatae9,alphae9] = SIMLR(Cl,1,10); % Closeness similarity matrix
[t9, SCb, F9, ydata9,alpha9] = SIMLR(Cb,1,10); % Betweenness similarity matrix

%%%First, set all the parameters.
K = 20;%number of neighbors, usually (10~30)
alpha = 0.5; %hyperparameter, usually (0.3~0.8)
T = 20; %Number of Iterations, usually (10~20)


Datap1 = Standard_Normalization(SCd);
Distp1 = dist2( Datap1, Datap1);
Wp1 = affinityMatrix(Distp1, K, alpha);

Datap2 = Standard_Normalization(SCl);
Distp2 = dist2( Datap2, Datap2);
Wp2 = affinityMatrix(Distp2, K, alpha);

Datap3 = Standard_Normalization(SCb);
Distp3 = dist2( Datap3, Datap3);
Wp3 = affinityMatrix(Distp3, K, alpha);

F = SNF({Wp1,Wp2,Wp3},K,T); % Fused similarity matrix
Fs = sort(F);

ind =[ ];

for i = 1 : kn
    
    [a,b,pos] = intersect(Fs(length(Fs)-i+1),F);
    ind = [ind;pos];
    HR_ind(i,:)= HR_features(ind(i),:);
    
end


pHR = mean(HR_ind); % Predicted features of the testing subject.



end