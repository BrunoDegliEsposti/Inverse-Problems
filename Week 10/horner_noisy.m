function [y] = horner_noisy(a, x, sigma)
    % Evaluate y = a_0 + a_1*x + a_2*x^2 + ...
    y = a(end) + zeros(size(x));
    for i = length(a)-1:-1:1
        y = a(i) + y .* x;
    end
    y = y + sigma*randn(size(x));
end
