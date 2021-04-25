function [err,uT,uR] = heat_TSVD(u0,Ngt,Nds,T,sigma,noise,K,p)
    % forward heat equation
    xgt = linspace(0,1,Ngt);
    L = -2*eye(Ngt)+diag(ones(Ngt-1,1),1)+diag(ones(Ngt-1,1),-1);
    L = (Ngt^2)*L;
    L(1,:) = 0; L(1,1) = 1;
    L(end,:) = 0; L(end,end) = 1;
    A = expm(T*L);
    uT = A*u0;
    
    % downsample and add noise (to avoid inverse crime)
    xds = linspace(0,1,Nds);
    u = spline(xgt,uT,xds)' + sigma*norm(uT,Inf)*noise;
    
    % backwards heat equation, with TSVD regularization
    L = -2*eye(Nds)+diag(ones(Nds-1,1),1)+diag(ones(Nds-1,1),-1);
    L = (Nds^2)*L;
    L(1,:) = 0; L(1,1) = 1;
    L(end,:) = 0; L(end,end) = 1;
    A = expm(T*L);
    [U,D,V] = svd(A);
    for i = 1:K
        if D(i,i) ~= 0
            D(i,i) = 1/D(i,i);
        end
    end
    D(K+1:end,:) = 0;   % keep the first K singular values only
    uR = V*(D*(U'*u));
    
    % upsample uR and estimate error in the p norm
    err = norm(spline(xds,uR,xgt)'-u0,p);
end

