%% Exercise 1.1
fun = @(x) x.^2;
qc_grid = linspace(0,1,201);
qc_h = 1/200;
f = fun(qc_grid)';

%% Esercise 1.2
qc_A = qc_h*tril(ones(201));

%% Exercise 1.3
Ftilde = qc_A*f;

%% Exercise 1.4
grid = linspace(0,1,62); % MCD(200,61) = 1
h = 1/62;
F = spline(qc_grid, Ftilde, grid)';
Fnoisy = F + 0.01*norm(F,Inf)*randn(size(F));

%% Exercise 1.5
A = h*tril(ones(62));

%% Exercise 1.6
f1 = A\F;
f2 = A\Fnoisy;
plot(qc_grid, f, grid, f1, grid, f2);

%% Exercise 3
alpha = 0.04731;
Ralpha = A + alpha*eye(size(A));
f3 = Ralpha\Fnoisy;
plot(qc_grid, f, grid, f2, grid, f3);
% g = @(alpha) norm(f1-(A+alpha*eye(size(A)))\Fnoisy);
% fminbnd(g,0.01,1)









