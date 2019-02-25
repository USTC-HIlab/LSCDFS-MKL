function [weight2,InfoKernel2] = KernelAlignment(x,Weight,InfoKernel,y,kerneloptionvect)
alignment=[];
for k = 1:length(InfoKernel)
    Kr=svmkernel(x(:,InfoKernel(k).variable),InfoKernel(k).kernel,InfoKernel(k).kerneloption,...
                x(:,InfoKernel(k).variable));
    align = norm(Kr.*(y*y'),'fro')/(norm(Kr.*Kr,'fro')*norm((y*y').*(y*y'),'fro'));
    InfoKernel(k).KA=align;
    alignment=[alignment;align];
end
count=1;
for k=1:length(InfoKernel)
    if InfoKernel(k).kerneloption == kerneloptionvect{1}(length(kerneloptionvect{1}))
        align_max=max(alignment((k-length(kerneloptionvect{1})+1):k));
        align_indx = find(alignment((k-length(kerneloptionvect{1})+1):k)==align_max);
        InfoKernel2(count).kernel = InfoKernel((count-1)*length(kerneloptionvect{1})+align_indx).kernel;
        InfoKernel2(count).kerneloption = InfoKernel((count-1)*length(kerneloptionvect{1})+align_indx).kerneloption;
        InfoKernel2(count).variable = InfoKernel((count-1)*length(kerneloptionvect{1})+align_indx).variable;
%         InfoKernel2(count).Weigth = InfoKernel((count-1)*length(kerneloptionvect{1})+align_indx).Weigth;
%         InfoKernel2(count).KA = InfoKernel((count-1)*length(kerneloptionvect{1})+align_indx).KA;
%         weight2(count) = Weight((count-1)*length(kerneloptionvect{1})+align_indx);
        count=count+1;
    end
end
for i = 1:(count-1)
    weight2(i)=1/(count-1);
end
end