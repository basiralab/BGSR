%simulateData function using Gaussian distribution
function [HR_data,LR_average_data, LR_max_data] = simulateData_LR_HR(mu1, sigma1, mu2, sigma2)

rng(1);

Featurematrix = [];
max_Featurematrix=[];
AV_Featurematrix=[];
Labels = [];
X =[];
data =[];
prompt = 'Select the number of class 1 graphs: ';
C1 = input(prompt);
while (isempty(C1) == 1)
    prompt = 'Please choose a number: ';
    C1 = input(prompt)
end
while (C1<5)
    prompt = 'Please choose a number >4: ';
    C1 = input(prompt)
end

prompt = 'Select the number of class 2 graphs: ';
C2 = input(prompt)
while (isempty(C2) == 1)
    prompt = 'Please choose a number: ';
    C2 = input(prompt)
end
while (C2<5)
    prompt = 'Please choose a number >4: ';
    C2 = input(prompt)
end


prompt = 'Select the number of nodes (i.e., ROIS for brain graphs): ';
m = input(prompt)
while (isempty(m) == 1)
    prompt = 'Please choose a number >20: ';
    m = input(prompt)
end
C = ((mod(m,4)) == 0) &((m>20) == 1)
while (C == 0)
    m = input(prompt)
    prompt = 'Please choose a multiple of 4 and > 20: ';
    C = ((mod(m,4)) == 0) &((m>20) == 1)
   
end


N = C1+C2;
dataC1 = normrnd(mu1,sigma1,[C1,m,m]);% Normal random ditribution
dataC2 = normrnd(mu2,sigma2,[C2,m,m]);% Normal random ditribution
data1 = [dataC1;dataC2];
% %% Drawing samples from two different distributions to simulate both classes
figure
h1 = histogram(dataC1)
hold on
h2 = histogram(dataC2)

for i = 1:N
    LR = zeros(m/4,4,4);
    data1(i,:,:)=squeeze(data1(i,:,:))-diag(diag(squeeze(data1(i,:,:)))); % Eliminate self symetry (diagonal=0)
    data1(i,:,:) = (squeeze(data1(i,:,:))+(squeeze(data1(i,:,:)))')./2; % Insure data symetry
    t = triu(squeeze(data1(i,:,:)),1); % Upper triangular part of matrix
    x = t(:); % Vectorize the triangle
    x1 = x.';
    Featurematrix = [Featurematrix;x1];
    HR_data.Featurematrix = Featurematrix;
    HR_data.X = data1;
    jp=1;
    jc=4;
    r=0;
    H=[];
    while jc < m+1
        
        r=r+1;
        
        for v = jp : 4: jc
            
            ip = 1;
            ic = 4;
            o = 1;
            
            while (ic < m+1)
                
                mm = 1;
                
                for k = ip : ic
                    
                    n = 1;
                    
                    for l = jp : jc
                        
                        LR(o,mm,n) = squeeze(HR_data.X(i,k,l));
                        n = n+1;
                        
                    end
                    
                    mm = mm+1;
                end
                
                ip = ic+1;
                ic = ip+3;
                o = o+1;
            end
            
        end
        
        H.X1{r} = LR;
        jp = jc+1;
        jc = jp+3;
        
    end
    
    
    for a1 = 1 : (m/4)
        
        V = H.X1{1,a1};
        
        for b1 = 1 : (m/4)
            
            Q1 = squeeze(V(b1,:,:));
            maxi(i,b1,a1) = max(max(Q1(:,:)));
            AV(i,b1,a1) = mean(mean(Q1));
            
        end
    end
    
    % Max-pooling LR data 
    t = triu(squeeze(maxi(i,:,:)),1); % Upper triangular part of matrix
    x = t(:); % Vectorize the triangle
    x1 = x.';
    max_Featurematrix = [max_Featurematrix;x1];
    LR_max_data.Featurematrix = Featurematrix;
    LR_max_data.X = maxi;
    
    % Average-pooling LR data 
    t = triu(squeeze(AV(i,:,:)),1); % Upper triangular part of matrix
    x = t(:); % Vectorize the triangle
    x1 = x.';
    AV_Featurematrix = [AV_Featurematrix;x1];
    LR_average_data.Featurematrix = Featurematrix;
    LR_average_data.X = AV;
end
HR_data.Labels = [ones(C1,1);-1*ones(C2,1)];%  Define labels
LR_max_data.Labels = [ones(C1,1);-1*ones(C2,1)];
LR_average_data.Labels = [ones(C1,1);-1*ones(C2,1)];
end