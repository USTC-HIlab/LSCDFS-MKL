function [auc,sn,sp,acc,pre,mcc] = roc(deci,label_y,colour)
[threshold,ind] = sort(deci,'descend');
roc_y = label_y(ind);
stack_x = cumsum(roc_y == -1)/sum(roc_y == -1);
stack_y = cumsum(roc_y == 1)/sum(roc_y == 1);
auc=sum((stack_x(2:length(roc_y))-stack_x(1:length(roc_y)-1)).*stack_y(2:length(roc_y)));

% sn = stack_y;
% sp = 1-stack_x;
% 
% N = length(label_y);
% n = sum(label_y==0);
% p = sum(label_y==1);
% acc = (sn*p+sp*n)/N;
len = length(deci);
sn = zeros(len,1);
sp = zeros(len,1);
acc = zeros(len,1);
pre = zeros(len,1);
mcc = zeros(len,1);
for i=1:len
    pre_label = deci>=threshold(i);
    [tp,tn,fp,fn] = statistic1(label_y,pre_label);
    sn(i) = tp/(tp+fn);
    sp(i) = tn/(tn+fp);
    acc(i) = (tn+tp)/len;
    pre(i) = tp/(tp+fp);
    mcc(i) = (tp*tn-fp*fn)/sqrt((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn));
end
% subplot(2,2,1);

plot(stack_x,stack_y,colour);
title(['AUC = ' num2str(auc) ]);
xlabel('1-Sp');
ylabel('Sn');
end
