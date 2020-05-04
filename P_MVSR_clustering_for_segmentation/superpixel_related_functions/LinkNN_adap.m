function adjcMatrix = LinkNN_adap(adjcMatrix, layer)
%link 2 layers of neighbor super-pixels and boundary patches

% Code Author: Wangjiang Zhu
% Email: wangjiang88119@gmail.com
% Date: 3/24/2014
% if nseg<100
%     adjcMatrix = (adjcMatrix * adjcMatrix + adjcMatrix) > 0;
% elseif nseg>=100 && nseg<200
%     adjcMatrix = (adjcMatrix * adjcMatrix* adjcMatrix+adjcMatrix * adjcMatrix + adjcMatrix) > 0;
% else 
%     adjcMatrix = (adjcMatrix * adjcMatrix* adjcMatrix*adjcMatrix+adjcMatrix * adjcMatrix* adjcMatrix+adjcMatrix * adjcMatrix + adjcMatrix) > 0;
% end

if layer==3
    adjcMatrix = (adjcMatrix * adjcMatrix* adjcMatrix+adjcMatrix * adjcMatrix + adjcMatrix) > 0;
elseif layer==4
     tmp4=adjcMatrix * adjcMatrix* adjcMatrix*adjcMatrix;
    adjcMatrix = (tmp4+adjcMatrix * adjcMatrix* adjcMatrix+adjcMatrix * adjcMatrix + adjcMatrix) > 0;
elseif layer==5
    tmp4=adjcMatrix * adjcMatrix* adjcMatrix*adjcMatrix;
    tmp5=adjcMatrix * adjcMatrix* adjcMatrix*adjcMatrix*adjcMatrix;
    adjcMatrix = (tmp4+tmp5+adjcMatrix * adjcMatrix* adjcMatrix+adjcMatrix * adjcMatrix + adjcMatrix) > 0;
end


% 
% % adjcMatrix = (adjcMatrix * adjcMatrix + adjcMatrix) > 0;
%  tmp4=adjcMatrix * adjcMatrix* adjcMatrix*adjcMatrix;
% % tmp5=adjcMatrix * adjcMatrix* adjcMatrix*adjcMatrix*adjcMatrix;
% %   tmp6=adjcMatrix * adjcMatrix* adjcMatrix*adjcMatrix*adjcMatrix*adjcMatrix;
% %   tmp7=adjcMatrix * adjcMatrix* adjcMatrix*adjcMatrix*adjcMatrix*adjcMatrix*adjcMatrix;
% %   tmp8=adjcMatrix * adjcMatrix* adjcMatrix*adjcMatrix*adjcMatrix*adjcMatrix*adjcMatrix*adjcMatrix;
% %  tmp9=adjcMatrix * adjcMatrix* adjcMatrix*adjcMatrix*adjcMatrix*adjcMatrix*adjcMatrix*adjcMatrix*adjcMatrix;
%  %tmp7=adjcMatrix * adjcMatrix* adjcMatrix*adjcMatrix*adjcMatrix*adjcMatrix*adjcMatrix;
% %% tmp5+tmp6+tmp7+
% adjcMatrix = (tmp4+adjcMatrix * adjcMatrix* adjcMatrix+adjcMatrix * adjcMatrix + adjcMatrix) > 0;
%%tmp6+tmp7+tmp8+  tmp4+adjcMatrix * adjcMatrix* adjcMatrix+
    adjcMatrix = double(adjcMatrix);

%adjcMatrix(bdIds, bdIds) = 1;