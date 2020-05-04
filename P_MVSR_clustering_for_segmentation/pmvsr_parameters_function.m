function pmvsr_parameters_function(data_name,lambda_arr, features,layers,threshs,prior)

imgRoot = ['.\superpixels_with_extracted_features\' data_name '\'];
imgNames=dir([imgRoot '*' 'mat']);  
imgNum=length(imgNames);
 
for ll=1:length(layers)
    layer=layers(ll)
    for th=1:length(threshs)
       thresh=threshs(th)
        for jj=1:length(lambda_arr)
            lambda=lambda_arr(jj);

         savelabelRoot = ['./results_lables/P_MVSR/' data_name '_' num2str(features) 'features/layer_' num2str(layer) '/th_' num2str(thresh) '/p_' prior  '/lambda_' num2str(lambda)  '/'];
            mkdir( savelabelRoot);

            for i=1:1
                imgname = [ imgRoot imgNames(i).name ]; 
                load( imgname );
               meanPos = spdata.meanPos';
               posDistM = GetDistanceMatrix(meanPos);
               X1=spdata.RGBHist;
              X2=[spdata.lbpHist_r;spdata.lbpHist_g;spdata.lbpHist_b];
              X3=spdata.bogHist;
              X4=spdata.vgg2;
           %           X5=spdata.vgg1;
            switch features
               case 3
                  Xs = {X1, X2, X3};  %%% , X4, X5  
                case 4
                  Xs = {X1, X2, X3, X4};  %%% , X4, X5
            end
  
            [Z_final] = pmvsr(Xs,lambda, spdata.adjmat,posDistM, layer, thresh,prior);
            
                for n_cluster=2:40
                     final_clusters = SpectralClustering(Z_final,n_cluster);                   
                    sp_label=spdata.label;
                    [imh, imw]=size(sp_label);
                    img = zeros(imh, imw);
                    for tt=1:size(X1,2)
                    img(sp_label==tt) = final_clusters(tt);
                    end
                    outname=[savelabelRoot imgNames(i).name(1:end-4) '_' num2str(n_cluster)  '.png'];    
                    imwrite(uint8(img),outname);
                end
            end
         end

    end 
end    