function K_fold_indx = CV_split_data(label,K)
%----------------- ---pre-processing--------------------------
%check whether label and data is consistent
label = reshape(label,[],1); %make sure it's Nx1 vector
%check whether label is consisted of '0' and '1'
if ~isequal(reshape(unique(label),1,[]),[0 1])
    error('Only one class is found, or label contains elements other than 1 and 0!')
end
N = length(label);
% 2<=K<=Number of samples
K = max(K,2);
K = min(K,N);

%----------------- ---perform CV--------------------------
all_indx = (1:N)';
tv_1 = label==1;
indx_1 = find(tv_1);
indx_0 = find(~tv_1);
rng(28,'twister');
N_1= length(indx_1);
N_0= length(indx_0);
indx_1 = indx_1(randperm(N_1));
indx_0 = indx_0(randperm(N_0));

K_fold_indx = cell(K,2);
if K==N %LOO
    for i=1:K
        K_fold_indx{i,1} = i;
        K_fold_indx{i,2} = [1:i-1 i+1:N];
    end
else
    for i=1:K
        test_indx = [indx_1(floor((i-1)*N_1/K)+1:floor(i*N_1/K));indx_0(floor((i-1)*N_0/K)+1:floor(i*N_0/K))];
        K_fold_indx{i,1} = test_indx;
        K_fold_indx{i,2} = setdiff(all_indx,test_indx);
    end
end
