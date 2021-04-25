function [err,uT] = Tikhonov(u0,N,dt,T,sigma,alpha,p,pflag)
    ntimesteps = round(T/dt);
    xs = linspace(0,1,N);
    L = -2*eye(N)+diag(ones(N-1,1),1)+diag(ones(N-1,1),-1);
    L(1,:) = 0; L(1,1) = 1;
    L(end,:) = 0; L(end,end) = 1;
    A = eye(N)+dt*L;
    u = u0;
    if pflag
        figure(1);
    end
    for i = 1:ntimesteps
        old = u;
        u = A*u;
        if pflag
            plot(xs,u);
            drawnow;
            pause(5/ntimesteps);
        end
    end
    uT = u;
    u = u + sigma*randn(N,1);
    [U,D,V] = svd(A);
    Dalpha = D./(D.^2+alpha);
    if pflag
        figure(2);
    end
    for i = 1:ntimesteps
        u = V*Dalpha*U'*u;
        if pflag
            plot(xs,u);
            drawnow;
            pause(5/ntimesteps);
        end
    end
    err = norm(u-u0,p);
end

