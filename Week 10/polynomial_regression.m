%% Point a)

n = 8;
mu_a = zeros(n,1);
sigma_a = diag((1:n).^(-2));
x = linspace(0,1,100);
figure(1);
hold on;

for i = 1:50
    a = mvnrnd(mu_a, sigma_a, 1);
    y = horner_noisy(a,x,0);
    plot(x,y);
end

%% Points b), c), d), e)

N = 8;
x = [0.01, 0.1, 0.6, 0.65, 0.7, 0.72, 0.8, 0.9]';
n = 8;
a = zeros(n,1);
%a(1:4) = 5*[-3/32, 11/16, -3/2, 1]';
%a(1:3) = [0,0,1]';
a(1:6) = [1,-1,0.5,0,2,-0.2]';
sigma = 0.05;
y = horner_noisy(a,x,sigma);

mu_a = zeros(n,1);
sigma_a = diag((1:n).^(-2));
%sigma_a = eye(n);
sigma_eps = sigma^2*eye(N);
A = fliplr(vander(x));
A = A(:,1:n);
K = sigma_a*A'/(sigma_eps + A*sigma_a*A');
mu_posterior = mu_a + K*(y-A*mu_a);
sigma_posterior = sigma_a - K*A*sigma_a;
sigma_posterior = 0.5*(sigma_posterior+sigma_posterior');

x_plot = linspace(0,1,100);
figure(2);
hold on;
for i = 1:200
    a_sampled = mvnrnd(mu_posterior, sigma_posterior, 1);
    y_plot = horner_noisy(a_sampled,x_plot,0);
    plot(x_plot,y_plot,'k');
end
y_plot = horner_noisy(a,x_plot,0);
plot(x_plot,y_plot,'r');
y_plot = horner_noisy(a,x,0);
plot(x,y_plot,'.r');
plot(x,y,'.g');
% p = fliplr(polyfit(x,y,n-1));
% y_plot = horner_noisy(p,x_plot,0);
% plot(x_plot,y_plot,'b');
% ylim([-1 1]);



