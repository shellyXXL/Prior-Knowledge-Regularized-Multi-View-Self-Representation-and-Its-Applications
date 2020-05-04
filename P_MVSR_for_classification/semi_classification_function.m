function semi_classification_function(label_percent, data,lamdba_arr, thresh_arr )


for per=1:length(label_percent)
    percent=label_percent(per);
    result=[];
    for i=1:length(lamdba_arr)
        lambda=lamdba_arr(i)
        temp=[];
        for j=1:length(thresh_arr)
           thresh= thresh_arr(j)
           [rr]=pmvsr_semi_classification( data,percent, lambda,thresh);
           temp=[temp,rr];
        end
        result=[result;temp];
    end    
    save_name=['semi_pmvsr_' data '_' num2str(percent) '.mat'];
    save(save_name,'result')
    
end