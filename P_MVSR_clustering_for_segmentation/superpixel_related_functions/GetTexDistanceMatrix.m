function distM = GetTexDistanceMatrix(feature,adjcMatrix)
%%%%%%%%% this function is modified by xxl so that tex distance is only
%%%%%%%%% calculated on neighbourhood region

% Get pair-wise distance matrix between each rows in feature
% Each row of feature correspond to a sample

% Code Author: Wangjiang Zhu
% Email: wangjiang88119@gmail.com
% Date: 3/24/2014

spNum = size(feature, 1);
DistM2 = zeros(spNum, spNum);

for n = 1:size(feature, 2)
    DistM2 = DistM2 + ( repmat(feature(:,n), [1, spNum]) - repmat(feature(:,n)', [spNum, 1]) ).^2;
end
DistM2 = DistM2./size(feature, 2);
distM = sqrt(DistM2);

%adjcMatrix=full(adjcMatrix);
%distM(adjcMatrix==0)=0;