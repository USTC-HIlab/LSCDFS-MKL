function [result, weights] = mklclassify(xapp, yapp, xtest, ytest, C )
% Example of how to use the mklsvm for  classification
%
%
%ratio=0.75;
%C = [300];
verbose=2;

options.algo='svmclass'; % Choice of algorithm in mklsvm can be either
                         % 'svmclass' or 'svmreg'
% options.algo='svmreg';
% options.svmreg_epsilon=0.01;
%------------------------------------------------------
% choosing the stopping criterion
%------------------------------------------------------
options.stopvariation=0; % use variation of weights for stopping criterion 
options.stopKKT=0;       % set to 1 if you use KKTcondition for stopping criterion    
options.stopdualitygap=1; % set to 1 for using duality gap for stopping criterion 
%------------------------------------------------------
% choosing the stopping criterion value
%------------------------------------------------------
options.seuildiffsigma=1e-2;        % stopping criterion for weight variation 
options.seuildiffconstraint=0.1;    % stopping criterion for KKT
options.seuildualitygap=0.0005;       % stopping criterion for duality gap
%------------------------------------------------------
% Setting some numerical parameters 
%------------------------------------------------------
options.goldensearch_deltmax=1e-1; % initial precision of golden section search
options.numericalprecision=1e-8;   % numerical precision weights below this value
                                   % are set to zero 
options.lambdareg = 1e-8;          % ridge added to kernel matrix 
%------------------------------------------------------
% some algorithms paramaters
%------------------------------------------------------
options.firstbasevariable='first'; % tie breaking method for choosing the base 
                                   % variable in the reduced gradient method 
options.nbitermax=10000;             % maximal number of iteration  
options.seuil=0;                   % forcing to zero weights lower than this 
options.seuilitermax=10;           % value, for iterations lower than this one 

options.miniter=0;                 % minimal number of iterations 
options.verbosesvm=0;              % verbosity of inner svm algorithm 
options.efficientkernel=4;         % use efficient storage of kernels 

[~,dim]=size(xapp);
%------------------------------------------------------------------------

    [xapp,xtest]=normalizemeanstd(xapp,xtest);
    %% here is the key function for creating multiple kernels, the algorithm will cost too much time if not apporitly set.
%     [kernel,kerneloptionvect,variableveccell]=CreateKernelListWithVariable(variablevec,dim,kernel,kerneloptionvect);

   kernel = {'gaussian'  'gaussian' 'gaussian' 'gaussian'  };
   kerneloptionvect = { [9:100] [9:100] [9:100] [9:100]   };
   variableveccell =  { [1:10] [11:34] [35:50] [51:dim]  };


    %%
    [Weight2,InfoKernel2]=UnitTraceNormalization(xapp,kernel,kerneloptionvect,variableveccell);
    [Weight,InfoKernel] = KernelAlignment(xapp,Weight2,InfoKernel2,yapp,kerneloptionvect);
    K=mklkernel(xapp,InfoKernel,Weight,options);

    %------------------------------------------------------------------
    % 
    %  K is a 3-D matrix, where K(:,:,i)= i-th Gram matrix 
    %
    %------------------------------------------------------------------
    % or K can be a structure with uses a more efficient way of storing
    % the gram matrices
    %
    % K = build_efficientK(K);
    
    tic
    [beta,w,b,posw,~,~] = mklsvm(K,yapp,C,options,verbose);
    toc

    Kt=mklkernel(xtest,InfoKernel,Weight,options,xapp(posw,:),beta);
    weights = Weight;
    ypred=Kt*w+b;

    mean(sign(ypred)==ytest)

    result = ypred;

end



