function [idxImg, adjcMatrix, pixelList] = FH_Split(noFrameImg)


%% Segment using SLIC:

image=noFrameImg;
 seg_paras = [0.3	350	1200;
                     0.4	350	1200;
                     0.5	350	1200;
                     0.6	350	1200;
                     0.7	350	1200;
                     0.8	350	1200;
                     0.9	350	1200;
                     1.0	350	1200];
                 
    % bin of color histogram
    if ~exist('bins', 'var')
        bins = [8 16 16 4];       % CIE L*, a*, b*, and hue respectively
    end
    
    % threshold for merging adjacent superpixels
    if ~exist('th', 'var')
        th = 0.2;
    end
                  
       
%for ix = 1 : size(seg_paras,1)
                     
   imsegs = im2superpixels(image, seg_paras(1,:));
   
%    % compute quantize the image for color histogram generation
%     Q = computeQuantMatrix(image, bins);
%    
%    rh = computeRegionHist(Q, bins, imsegs.segimage);
%    imsegs2 = mergeAdjacentRegions_fast(rh, imsegs, th);
%    %num_region = max(imsegs2.segimage(:));
% 
   
  imsegs2 =imsegs;
   idxImg=double(imsegs2.segimage);

%end   
%%
%adjcMatrix = GetAdjMatrix(idxImg, num_region);
adjcMatrix =double(imsegs2.adjmat);
%%
pixelList = cell(imsegs2.nseg, 1);
for n = 1:imsegs2.nseg
    pixelList{n} = find(idxImg == n);
end
