function [deci,label_y] = get_cv_deci(prob_y,SMNet,seq_simi,a,param,nr_fold)
l=length(prob_y);
deci = ones(l,1);
label_y = ones(l,1);
% rand_ind = randperm(l);
K_fold_indx = CV_split_data(prob_y,nr_fold);
for i=1:nr_fold % Cross training : folding
    SMNet_z=SMNet;
    SMNet_z(K_fold_indx{i,1},a)=0; 
    xs=[seq_simi SMNet_z];
    train_ind=K_fold_indx{i,2};
    test_ind=K_fold_indx{i,1};
    model1=svmtrain(prob_y(train_ind),xs(train_ind,:),param);
    model2=svmtrain(prob_y(train_ind),seq_simi(train_ind,:),param);
   [predict_label1,mse1,subdeci1] = svmpredict(prob_y(test_ind),xs(test_ind,:),model1); 
   [predict_label2,mse2,subdeci2] = svmpredict(prob_y(test_ind),seq_simi(test_ind,:),model2);
   if model1.Label(1)==1
         mod1=1;
     else 
         mod1=-1;
   end
   if model2.Label(1)==1
         mod2=1;
     else 
         mod2=-1;
   end
    deci(test_ind,1) = subdeci1*mod1;
    deci(test_ind,2) = subdeci2*mod2;
end
end