function [Y_tensor]= LRTC_TMac(Y, data, A, X, Y_tensorP, Nway, known, opts)
%% Initiation

if isfield(opts,'maxit');       maxit = opts.maxit;       else maxit = 100;   end
if isfield(opts,'tol');       tol = opts.tol;       else tol = 1e-3;   end
if isfield(opts,'alpha');      alpha = opts.alpha;        else alpha = [1/3 1/3 1/3];   end

Out.Res     = [];
Out.Real    = []; 
Out.PSNR    = [];
Out.ratio_X = [];
Out.ratio_A = [];
Out.ratioX  = [];
deltar = 5;
R = opts.R;
Y_p = Y;
X_p = X;
A_p = A;

nrmb     = norm(data);
res0     = zeros(1,3); 
TotalRes = 0;
res      = res0;

for n = 1:3  
    Mn       = Fold(X{n}*A{n},Nway,n);
    res0(n)  = norm(Mn(known)-data);
    TotalRes = TotalRes+res0(n);  
end
%%
fprintf('Iteration:     ');
for k=1: maxit

    fprintf('\b\b\b\b\b%5i',k);
    %% update X
    temp=A_p{1}*A_p{1}';
    X{1}=(Y_p{1}*A_p{1}')*pinv(temp);
    
    temp=A_p{2}*A_p{2}';
    X{2}=(Y_p{2}*A_p{2}')*pinv(temp);
    
    temp=A_p{3}*A_p{3}';
    X{3}=(Y_p{3}*A_p{3}')*pinv(temp);
    %% update A
    temp=X{1}'*X{1};
    A{1}=pinv(temp)*(X{1}'*Y_p{1});
    
    temp=X{2}'*X{2};
    A{2}=pinv(temp)*(X{2}'*Y_p{2});
    
    temp=X{3}'*X{3};
    A{3}=pinv(temp)*(X{3}'*Y_p{3});
    %% update Y 
    Y{1} = X{1}*A{1}; Y1 = Fold(Y{1}', Nway, 1); res(1) = norm(Y1(known)-data);
    
    Y{2} = X{2}*A{2}; Y2 = Fold(Y{2}', Nway, 2); res(2) = norm(Y2(known)-data);
    
    Y{3} = X{3}*A{3}; Y3 = Fold(Y{3}', Nway, 3); res(3) = norm(Y3(known)-data);
    
    Y_tensor = alpha(1)*Y1+alpha(2)*Y2+alpha(3)*Y3;
    
                 real       = norm(Y_tensor(known)-data)/ norm(data);
              Out.Real      = [Out.Real,real];
    Y_tensor(gather(known)) = data;
    
    Res = norm(Y_tensor(:)-Y_tensorP(:))/norm(Y_tensorP(:));
    Out.Res = [Out.Res,Res];
     
    Y_tensorP = Y_tensor;
    
    TotalRes0 = TotalRes;  
    TotalRes = res(1)^2+res(2)^2+res(3)^2;
   
    % rank increase
    if k > 1 
        for j = 1:3
            temp1 = X_p{j}*A_p{j}; temp1 = temp1';
            temp1(known) = 0;
            temp2 = X{j}*A{j}; temp2 = temp2';
            temp2(known) = 0;
           % fprintf('%f %f\n',norm(temp2),norm(temp1));
            flag = abs(1-(norm(temp2)/norm(temp1)));
            if (flag < 0.001) & (size(X{j},2) + deltar <= R(j))
                X{j} = [X{j}, rand(size(X{j},1),deltar)];
                A{j} = [A{j}; rand(deltar,size(A{j},2))];
            end
        end
    end
    
    
    %% check stopping criterion
    crit = Res<tol;
    if crit
        break
    end
    
    if isfield(opts, 'Ytr')
        Out.truerel(k)= norm(Y_tensor(:)- opts.Ytr(:))/ norm(opts.Ytr(:));
       % Out.PSNR(k) = PSNR(Y_tensor,opts.Ytr);
    end
    Y{1} = Unfold(Y_tensor,Nway,1); Y{1} = Y{1}';
    Y{2} = Unfold(Y_tensor,Nway,2); Y{2} = Y{2}';
    Y{3} = Unfold(Y_tensor,Nway,3); Y{3} = Y{3}';
    
    Y_p=Y;X_p=X;A_p=A;    
        
end
end