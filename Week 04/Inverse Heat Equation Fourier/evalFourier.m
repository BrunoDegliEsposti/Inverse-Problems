function fx = evalFourier(xs, a)
  N_f = length(a);
  modes = (1:N_f )';
  [M, X] = ndgrid(modes, xs);
  entries = pi*(M.*X);
  fx = sum(repmat(a, 1, length(xs)).*sin(entries), 1);
end
