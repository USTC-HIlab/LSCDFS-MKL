clear;
addpath('./data/')
data=importdata('lusc_data.txt');
label=importdata('lusc_label.txt');

K_fold_indx = CV_split_data(label,5);
label_new=label;
label_new(label==0)=-1;
deci = zeros(size(data,1),1);
for i = 1:5
    patch_train_indx = K_fold_indx{i,2};
    patch_test_indx = K_fold_indx{i,1};

    patch_train_data = data(patch_train_indx,:);
    patch_train_label = label_new(patch_train_indx);
    patch_test_data = data(patch_test_indx,:);
    patch_test_label = label_new(patch_test_indx);

   [result, ~] = mklclassify(patch_train_data, patch_train_label, patch_test_data,patch_test_label, 350);
   deci(patch_test_indx) = result;   
end

[auc]=roc(deci,label_new,'red');