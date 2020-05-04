function [curvatureM, curvatureIndex ]= GetCurvature(Pos,pos_adj_DistM)
spNum=length(pos_adj_DistM);
curvatureM =zeros(spNum,spNum);
curvatureIndex =zeros(spNum,spNum);
for i=1:spNum
 for j=1:spNum
     if pos_adj_DistM(i,j)>0 
         %min_D=inf;
         min_A=inf;
         k=inf;
         for tempk=1:spNum
%             if ( pos_adj_DistM(i,tempk)>0 && tempk~=j)
%                 D=pos_adj_DistM(j,tempk);
%                 if (D<min_D && (Pos(tempk,2)>Pos(j,2)))
%                     k=tempk;
%                 end
%             end
              if ( pos_adj_DistM(i,tempk)>0 && tempk~=j)
                  l1=Pos(i,:)-Pos(j,:);  %%% row, coloum
                  l2=Pos(i,:)-Pos(tempk,:);
                  tempA=atan2(l1(2)*l2(1)-l2(2)*l1(1),l1(2)*l2(2)+l1(1)*l2(1));
                  tempA=mod(-tempA, 2*pi);
                  if tempA<min_A 
                     k=tempk;
                     A=tempA;
                  end
              end
         end
         %k=tempk;
         %%% here we get the index of i,j,k
%           l1=Pos(i,:)-Pos(j,:);  %%% row, coloum
%           l2=Pos(i,:)-Pos(k,:);
          %A = atan2(l1(1), l1(2))-atan2(l2(1), l2(2));
          %A2=A*A;
          %curvatureM(i,j)=A2/min(pos_adj_DistM(i,j),pos_adj_DistM(i,k));
          %curvatureM(i,j)=k;
          curvatureM(i,j)=A*A/min(pos_adj_DistM(i,j),pos_adj_DistM(i,k));
          curvatureIndex(i,j)=k;
     end
 end
end



%curvatureM =sum(pos_adj_DistM,2);