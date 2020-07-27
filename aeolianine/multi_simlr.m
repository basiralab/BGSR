% clc, clear all, close all,
mat=dir('D:\thesis\super resolution\code\data\Processed_NewFunctionalData_10_25y_allAttributes') %list foldercontents
num= length(mat) ;
rng(1)
addpath('D:\thesis\super resolution\thesis\matlab\src')
% addpath('D:\thesis\super resolution\code\example-CV')
% rng default
addpath('D:\thesis\super resolution\thesis\matlab\snnf')
tic
load('T','T')
% for i=1:300
%      t=squeeze(T(i,:,:));
%     t1= triu(t,1);
% xr=t1(find(t1)); % vectorize the triangle
%     xr1=xr.';
%       HRn(i,:)=abs(xr1);
% end
%%
tic
for mm=1:300   

jp=1;
jc=4;

r=0;
H=[];
while jc<117
     r=r+1;
    for v=jp:4:jc
       ip=1;
       ic=4;
        o=1;
  while (ic<117)
    m=1;
    for k= ip:ic
        n=1;
        for l=jp:jc
            X(o,m,n)=squeeze(T(mm,k,l));
             n=n+1;
        end
        m=m+1;
    end
   ip=ic+1;
   ic=ip+3;
    o=o+1;
  end
  end
    H.X1{r}=X;
    jp=jc+1;
   jc=jp+3;
  

end
 
for a1=1:29
    V=H.X1{1,a1};
  
    for b1= 1:29
          Q1=abs (squeeze(V(b1,:,:)));
    A_maxi(mm,b1,a1)=max(max(Q1(:,:)));
     A_AV(mm,b1,a1)=mean(mean(Q1(:,:)));
    end
end
end
%%
Cb=zeros(300,29);
Cl=zeros(300,29);
Ce=zeros(300,29);
D=zeros(300,29);
  for p = 1:300
 
% Dm(p,:)=degrees(squeeze(A_maxi(p,:,:)));
% Clm(p,:)=closeness(squeeze(A_maxi(p,:,:)));
% % Cb(p,:)=edgeBetweenness(t);
% Cem(p,:)=eigenCentrality(squeeze(A_maxi(p,:,:)));
Dv(p,:)=degrees(squeeze(A_AV(p,:,:)));
Clv(p,:)=closeness(squeeze(A_AV(p,:,:)));
% Cb(p,:)=edgeBetweenness(t);
Cev(p,:)=eigenCentrality(squeeze(A_AV(p,:,:)));

  end
 
[t5, SDv, F1, ydata1,alpha1] = SIMLR(Dv,2,20,0,1);
 [te9, SCev, Fe9, ydatae9,alphae9] = SIMLR(Cev,2,20,0,1);
  [t9, SClv, F9, ydata9,alpha9] = SIMLR(Clv,2,20,0,1);
%   [t5m, SDm, F1m, ydatam1,alpham1] = SIMLR(Dm,1,10);
%  [te9m, SCem, Fe9m, ydataem9,alphae9m] = SIMLR(Cem,2,20,0,1);
%   [t9m, SClm, F9m, ydatam9,alpham9] = SIMLR(Clm,2,20,0,1);
 
  %%%First, set all the parameters.
 K = 20;%number of neighbors, usually (10~30)
 alpha = 0.5; %hyperparameter, usually (0.3~0.8)
 T = 20; %Number of Iterations, usually (10~20)
 
 
%  Datapm1= Standard_Normalization(SDm);
%  Distpm1 = dist2( Datapm1, Datapm1);
%   Wpm1 = affinityMatrix(Distpm1, K, alpha);
%   
%   Datapm2= Standard_Normalization(SCem);
%  Distpm2 = dist2( Datapm2, Datapm2);
%   Wpm2 = affinityMatrix(Distpm2, K, alpha);
%   
% Datapm3= Standard_Normalization(SClm);
%  Distpm3 = dist2( Datapm3, Datapm3);
%   Wpm3 = affinityMatrix(Distpm3, K, alpha);
%   Fm = SNF({Wpm1,Wpm2,Wpm3},K,T);
  
  Datapv1= Standard_Normalization(SDv);
 Distpv1 = dist2( Datapv1, Datapv1);
  Wpv1 = affinityMatrix(Distpv1, K, alpha);
  
  Datapv2= Standard_Normalization(SCev);
 Distpv2 = dist2( Datapv2, Datapv2);
  Wpv2 = affinityMatrix(Distpv2, K, alpha);
  
Datapv3= Standard_Normalization(SClv);
 Distpv3 = dist2( Datapv3, Datapv3);
  Wpv3 = affinityMatrix(Distpv3, K, alpha);

  Fv= SNF({Wpv1,Wpv2,Wpv3},K,T);
% Allm(1,:,:)=SDm;
% Allm(2,:,:)=SCem;
% Allm(3,:,:)=SClm;
% rMAX= squeeze(mean(Allm));
% Allv(1,:,:)=SDv;
Allv(2,:,:)=SCev;
Allv(3,:,:)=SClv;
rAVE= squeeze(mean(Allv));
%  save('rAVE','rAVE')
%  save('rMAX','rMAX')
%   save('Fv','Fv')
toc
%    save('Fm','Fm')