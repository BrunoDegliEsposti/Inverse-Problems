function [R,xp] = radon_fft(I,theta)
    %RADON_FFT A radon()-compatible implementation of
    %the Radon transform, using the fast fourier transform
    if (nargin < 2)
        theta = 0:179;
    end
    nrays = 2*ceil(norm(size(I)-floor((size(I)-1)/2)-1))+3;
    ntheta = length(theta);
    R = zeros(nrays,ntheta);
    center = (nrays+1)/2;
    xp = 1:nrays - center;
    padding = [nrays,nrays] - size(I);
    prepadding = floor(padding/2);
    postpadding = ceil(padding/2);
    I = padarray(I,prepadding,'pre');
    I = padarray(I,postpadding,'post');
    % I is now nrays by nrays. As explained in class,
    % odd numbers work best.
    for i = 1:ntheta
        angle = theta(i);
        J = imrotate(I, -angle, 'bilinear', 'crop');
        Jhat = fftshift(fft2(J));
        slice = Jhat(center,:);
        R(:,i) = ifft(ifftshift(slice));
    end
end



