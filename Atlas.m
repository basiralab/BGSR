%% Estimation of the connectional brain template
function [CBT] = Atlas(train_data,train_Labels)
%Disentangling the heterogeneous distribution of the input_ networks using SIMLR clustering method

 k = [];
 
 for l = 1:length(train_Labels)
     k1 = squeeze((train_data(l,:,:)));
     k2 = k1(:); %vectorize the matrix
     k = [k;k2'];
 end
 
 [t, S1, F1, ydata1,alpha1] = SIMLR(k,2,2);
 
 
 % After using SIMLR, we extract each cluster independently 
 

 qC11 = 1;
 qC12 = 1;
 qC13 = 1;
 
 for qC1 = 1: length(train_Labels)
     
     if t(qC1) == 1
         Ca1(qC11,:,:) = abs(train_data(qC1,:,:));
         qC11 = qC11+1;
        
     elseif t(qC1) == 2
         Ca2(qC12,:,:) = abs(train_data(qC1,:,:));
         qC12 = qC12+1;
           

      end
     
 end
 
 
 % For each cluster, we non-linearly diffuse and fuse all networks into a local cluster-specific CBT using SNF
 
 % Setting all the parameters.
 K = 4;%number of neighbors, 
 alpha = 0.5; %hyperparameter, usually (0.3~0.8)
 T = 20; %Number of Iterations, usually (10~20)
 for l = 1: (qC11-1)
     
     ll = num2str(l);
     Datap1.(['datap',ll,'']) = Standard_Normalization(squeeze(Ca1(l,:,:)));
     Distp1.(['distp',ll,'']) = dist2( Datap1.(['datap',ll,'']), Datap1.(['datap',ll,'']));
     Wp1.(['Wp1',ll,'']) = affinityMatrix(Distp1.(['distp',ll,'']), K, alpha);
 end
 
 Wall1 = struct2cell(Wp1);
 
 if qC11>2
     AC11 = SNF(Wall1,K,T) ;% First cluster-specific CBT  
 else
     AC11 = squeeze(Ca1(1,:,:));
 end
 
 for l = 1: (qC12-1)
     ll = num2str(l);
     Datap2.(['datap',ll,'']) = Standard_Normalization(squeeze(Ca2(l,:,:)));
     Distp2.(['distp',ll,'']) = dist2( Datap2.(['datap',ll,'']), Datap2.(['datap',ll,'']));
     Wp2.(['Wp1',ll,'']) = affinityMatrix(Distp2.(['distp',ll,'']), K, alpha);
 end
 
 Wall2 = struct2cell(Wp2);
 
 if qC12>2
     AC12 = SNF(Wall2,K,T); % Second cluster-specific CBT 
 else
     AC12 = squeeze(Ca2(1,:,:));
 end
 
 
 %% SNF-SNF
 
 CBT = SNF({AC11,AC12},K,T); % Global connectional brain template
end    