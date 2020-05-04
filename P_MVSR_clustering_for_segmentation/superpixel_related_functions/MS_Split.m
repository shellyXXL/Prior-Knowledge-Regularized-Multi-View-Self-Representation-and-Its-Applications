function [idxImg, adjcMatrix, pixelList] = MS_Split(noFrameImg)


%% Segment using MS:

image=noFrameImg;
[fimage labels modes regSize grad conf] = edison_wrapper(image, @RGB2Luv, 'MinimumRegionArea',3000);
idxImg=double(labels+1);
spNum=max(max(idxImg));
%%
adjcMatrix = GetAdjMatrix(idxImg, spNum);

%%
pixelList = cell(spNum, 1);
for n = 1:spNum
    pixelList{n} = find(idxImg == n);
end
