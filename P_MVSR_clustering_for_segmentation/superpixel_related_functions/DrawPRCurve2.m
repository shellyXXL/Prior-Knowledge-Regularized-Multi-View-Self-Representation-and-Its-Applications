function [rec, prec] = DrawPRCurve2(SMAP, smapSuffix, GT, gtSuffix, targetIsFg, targetIsHigh, color)
% Draw PR Curves for all the image with 'smapSuffix' in folder SMAP
% GT is the folder for ground truth masks
% targetIsFg = true means we draw PR Curves for foreground, and otherwise
% we draw PR Curves for background
% targetIsHigh = true means feature values for our interest region (fg or
% bg) is higher than the remaining regions.
% color specifies the curve color

% Code Author: Wangjiang Zhu
% Email: wangjiang88119@gmail.com
% Date: 3/24/2014

files = dir(fullfile(SMAP, strcat('*', smapSuffix)));
num = length(files);
if 0 == num
    error('no saliency map with suffix %s are found in %s', smapSuffix, SMAP);
end

%precision and recall of all images
ALLPRECISION = zeros(num, 256);
ALLRECALL = zeros(num, 256);

% new_ALLPRECISION = zeros(num, 41);
% new_ALLRECALL = zeros(num, 41);

% t= zeros(num, 1);

for k = 1:num
    smapName = files(k).name;
    smapImg =255-imread(fullfile(SMAP, smapName));    
    
    gtName = strrep(smapName, smapSuffix, gtSuffix);
    gtImg = imread(fullfile(GT, gtName));
    
    [precision, recall] = CalPR(smapImg, gtImg, targetIsFg, targetIsHigh);
    
    ALLPRECISION(k, :) = precision;
    ALLRECALL(k, :) = recall;
    
%     t= uint8(2*mean(mean(smapImg)));
%      new_ALLPRECISION(k, :) = ALLPRECISION(k, (t-20):(t+20));
%     new_ALLRECALL(k, :) = ALLRECALL(k, (t-20):(t+20));
end


prec = mean(ALLPRECISION, 1);   %function 'mean' will give NaN for columns in which NaN appears.
rec = mean(ALLRECALL, 1);





% prec = prec(100:200);   %function 'mean' will give NaN for columns in which NaN appears.
% rec = rec(100:200);

% plot


% rec(find(prec<0.5)) = []; 
% prec(find(prec<0.5)) = []; 




if nargin > 5
     plot(rec, prec, color, 'Marker','*');
    % plot(rec, prec, color, 'linewidth', 2);
    %plot(rec, (1.3*rec.*prec)/(0.3*prec+rec), color, 'linewidth', 2);
    disp(max((1.3*rec.*prec)/(0.3*prec+rec)));
else
    plot(rec, prec, 'r', 'linewidth', 2);
end