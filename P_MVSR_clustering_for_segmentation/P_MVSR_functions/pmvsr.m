%% For convinience, we assume the order of the tensor is always 3;
function [S]=pmvsr(X,lambda, adjmatM,posDistM, layer, thresh,prior)
K = length(X); N = size(X{1},2); %sample number

adjmatM_NN= LinkNN_adap(adjmatM, layer);

switch prior
    case 'adj'
       adjmatM_NN(adjmatM_NN<thresh)=thresh;
       cur_prior=adjmatM_NN;
    case 'spa'
       spa_sigma=1;
       Wspa=Dist2WeightMatrix(posDistM, spa_sigma);
       Wspa(adjmatM_NN==0)=0;
       Wspa(Wspa<thresh)=thresh;
       cur_prior=Wspa;
end

 for v=1:K
    [X{v}]=NormalizeData(X{v});
 end


for k=1:K
    Z{k} = zeros(N,N); 
    W{k} = zeros(N,N);
    G{k} = zeros(N,N);
    E{k} = zeros(size(X{k},1),N); 
    Y{k} = zeros(size(X{k},1),N); 
    D{k} = zeros(N,N);  
    T{k} = zeros(N,N);  
    P{k} =cur_prior;
end

sX = [N, N, K];

Isconverg = 0;epson = 1e-5;
iter = 0;
mu = 10e-5; max_mu = 10e10; pho_mu = 2;
rho = 0.0001; max_rho = 10e12; pho_rho = 2;
tic;

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
        
        %5 update Tk   %%%%%%%%%%%% the prior knowledge is included    
        T{k} = T{k} + mu*(P{k}.*Z{k}-D{k});
    end
    
    %6 update G
    Z_tensor = cat(3, Z{:,:});
    W_tensor = cat(3, W{:,:});
    z = Z_tensor(:);
    w = W_tensor(:);
    % twist-version
   [g, objV] = wshrinkObj(z + 1/rho*w,1/rho,sX,0,3)   ;
    G_tensor = reshape(g, sX);
    
    %7 update W
    w = w + rho*(z - g);


    %% coverge condition
    Isconverg = 1;
    for k=1:K
        if (norm(X{k}-X{k}*D{k}-E{k},inf)>epson)
            history.norm_Z = norm(X{k}-X{k}*D{k}-E{k},inf);
            Isconverg = 0;
        end
        
        G{k} = G_tensor(:,:,k);
        W_tensor = reshape(w, sX);
        W{k} = W_tensor(:,:,k); 
        if (norm(Z{k}-G{k},inf)>epson)
            history.norm_Z_G = norm(Z{k}-G{k},inf);
            Isconverg = 0;
        end
        
        if (norm(P{k}.*Z{k}-D{k},inf)>epson)
            history.norm_PZD = norm(P{k}.*Z{k}-D{k},inf);
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
    S = S + abs(Z{k})+abs(Z{k}');
end





