function [acc]=pmvsr_semi_classification(data,percent, lambda,thresh)


load([ './data/' data '.mat']); 
K = length(X); N = size(X{1},2); 
Pori=thresh*ones(N,N);   %%%%%%%%%%%%%%%% prior knowledge matrix
class_num= length(unique(GT));
each_class_num=zeros(class_num,1);
for c=1:class_num
  each_class_num(c)= sum(GT==c); 
end
List = [];   
for c = 1:class_num
    cur_part = floor(percent*each_class_num(c));
    list=1:1:cur_part;
    previous_sum=sum(each_class_num(1:c-1));
    List = [List list+previous_sum];
end
labeled_N =length(List);
List_ = setdiff(1:1:N,List); % the No. of unlabeled data
for pp=1:length(List)
  for qq=1:length(List)
      if GT(List(pp))==GT(List(qq))
         Pori(List(pp),List(qq))=1; 
      end
  end   
end
for pp=1:length(List)
  for qq=1:length(List)
      if GT(List(pp))~= GT(List(qq))
         Pori(List(pp),List(qq))=0; 
      end
  end   
end

 for v=1:K
    [X{v}]=NormalizeData(X{v});
 end

% Initialize...



for k=1:K
    Z{k} = zeros(N,N); 
    W{k} = zeros(N,N);
    G{k} = zeros(N,N);
    E{k} = zeros(size(X{k},1),N); 
    Y{k} = zeros(size(X{k},1),N);    
    D{k} = zeros(N,N);  
     T{k} = zeros(N,N);  
     P{k} =Pori;
end
sX = [N, N, K];
Isconverg = 0;epson = 1e-4;
iter = 0;
mu = 10e-5; max_mu = 10e10; pho_mu = 2;
rho = 0.0001; max_rho = 10e12; pho_rho = 2;

while(Isconverg == 0)
    %fprintf('----processing iter %d--------\n', iter+1);
    for k=1:K
        
         %%%%%%%%%% 1 UPDATE Zv
        Q=D{k}-T{k}./mu;
        S=G{k}-W{k}./rho;
        temp=(mu*P{k}.*Q+rho*S)./(rho+mu*P{k}.*P{k});
        Z{k}  =temp;
        
         %%%%%%%%%% 2 UPDATE Dv
       tmp1   = X{k}-E{k}+Y{k}./mu;
       tmp2   = P{k}.*Z{k}+T{k}./mu;
       D{k}   = inv(eye(N,N)+X{k}'*X{k})*(X{k}'*tmp1+tmp2);
        
        %3 update E^k     
       F=[];
       for ff=1:K
           F = [F;X{ff}-X{ff}*D{ff}+Y{ff}/mu];
       end
        [Econcat] = solve_l1l2(F,lambda/mu);
        beg_ind = 0;
        end_ind = 0;
        for v=1:K
            if(v>1)
                beg_ind = beg_ind+size(X{v-1},1);
            else
                beg_ind = 1;
            end
            end_ind = end_ind+size(X{v},1);
            E{v} = Econcat(beg_ind:end_ind,:);
        end
     
        %4 update Yk
        Y{k} = Y{k} + mu*(X{k}-X{k}*D{k}-E{k});
        
        %5 update Tk
        T{k} = T{k} + mu*(P{k}.*Z{k}-D{k}); 
    end
    
    %6 update G
    Z_tensor = cat(3, Z{:,:});
    W_tensor = cat(3, W{:,:});
    z = Z_tensor(:);
    w = W_tensor(:);
    %twist-version
    [g, ~] = wshrinkObj(z + 1/rho*w,1/rho,sX,0,3)   ;
    G_tensor = reshape(g, sX);
    
    %7 update W
    w = w + rho*(z - g);
    
    % coverge condition
    Isconverg = 1;
    for k=1:K
        if (norm(X{k}-X{k}*D{k}-E{k},inf)>epson)
            history.norm_Z = norm(X{k}-X{k}*D{k}-E{k},inf);
            %fprintf('    norm_Z %7.10f    ', history.norm_Z);
            Isconverg = 0;
        end
        
        G{k} = G_tensor(:,:,k);
        W_tensor = reshape(w, sX);
        W{k} = W_tensor(:,:,k); 
        if (norm(Z{k}-G{k},inf)>epson)
            history.norm_Z_G = norm(Z{k}-G{k},inf);
            %fprintf('norm_Z_G %7.10f    \n', history.norm_Z_G);
            Isconverg = 0;
        end
        
        if (max(max(P{k}.*Z{k}-D{k}))>epson)
            history.norm_PZD = max(max(P{k}.*Z{k}-D{k}));
           % fprintf('norm_PZD %7.10f    \n', history.norm_PZD);
            Isconverg = 0;
        end
    end
    
    if (iter>200)
        Isconverg  = 1;
    end
    iter = iter + 1;
    mu = min(mu*pho_mu, max_mu);
    rho = min(rho*pho_rho, max_rho);
end

S = 0;
for k=1:K
    S = S + abs(G{k})+abs(G{k}');
end
SimM=S;
for pp=1:length(List_)
  for qq=1:length(List_)
         SimM(List_(pp),List_(qq))=0; 
  end   
end
 [~, position]=max(SimM,[],2);
 cnt=0;
for pp=1:length(List_)
    if GT(List_(pp))== GT(position(List_(pp)))
        cnt=cnt+1;
    end
end
acc = cnt/(N-labeled_N);

