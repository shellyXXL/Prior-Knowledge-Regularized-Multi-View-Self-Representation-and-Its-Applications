function [S_com,Smean, D,W] = D_compact(colDistM,centroidSP,imgCenter,pixelList,adjcMatrix, bdIds,sigma2, alpha)
%%%D_compact_map
L=(colDistM-min(min(colDistM)))./(max(max(colDistM))-min(min(colDistM)));
L=exp(-L.^2 / sigma2);

adjcMatrix(bdIds, bdIds) = 1;
W = L;
%%%%%% diag set to 1
for i=1:length(colDistM)
 W(i,i)=0;
end
 W(adjcMatrix==0)=0;


D=diag(sum(W));
A=L;
optAff=(D-alpha*W)\eye(length(colDistM)); 
mz=diag(ones(length(colDistM),1));
mz=~mz;
optAff=optAff.*mz;
Ht=optAff*A;   %%%%  Ht=inv(D-alpha*W)*A
H=Ht';
%H=(H-min(min(H)))./(max(max(H))-min(min(H)));
% for i=1:length(colDistM)
%  H(i,:)=(H(i,:)-min(H(i,:)))./(max(H(i,:))-min(H(i,:)));
% end



N_matrix=zeros(length(pixelList),1);
for i=1:length(pixelList)
  N_matrix(i,1)=length(pixelList{i});
end
HN_matrix=H*N_matrix;

NB_xmatrix=N_matrix.*centroidSP(:,1);
NB_ymatrix=N_matrix.*centroidSP(:,2);
Smean=[(H*NB_xmatrix)./(HN_matrix),(H*NB_ymatrix)./(HN_matrix)];
SV=zeros(length(pixelList),1);
for i=1:length(pixelList)
 D=[centroidSP(:,1)-Smean(i,1),centroidSP(:,2)-Smean(i,2)];
 D=D(:,1).*D(:,1)+D(:,2).*D(:,2);
 NBmiu_matrix=N_matrix.*D;
 SV(i,1)=H(i,:)*NBmiu_matrix;
end
SV=SV./HN_matrix;

Dp=[centroidSP(:,1)-imgCenter(1),centroidSP(:,2)-imgCenter(2)];
Dp=Dp(:,1).*Dp(:,1)+Dp(:,2).*Dp(:,2);
N_Dp=N_matrix.*Dp;
SD=H*N_Dp./HN_matrix;
S_com=SV+SD;
S_com=(S_com-min(S_com))./(max(S_com)-min(S_com));
S_com=1-S_com;


% removeLowVals = true;
% if removeLowVals
%     thresh = graythresh(S_com);  %automatic threshold
%     S_com(S_com < thresh) = 0;
% end













