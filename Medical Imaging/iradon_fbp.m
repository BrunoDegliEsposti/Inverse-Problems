function [I] = iradon_fbp(R,theta,filter_name,f)
    %IRADON_FFT An iradon()-compatible implementation of the
    %inverse Radon transform, using the filtered back-projection formula
    [nrays, ntheta] = size(R);
    assert(ntheta == size(theta,2));
    if (nargin < 2)
        theta = 0:179;
    end
    if (nargin < 3)
        filter_name = 'Ramp';
    end
    
    % PARSE FILTER CHOICE
    % To see what they look like:
    % https://www.desmos.com/calculator/1avgpqlc5x
    switch filter_name
        case 'Ramp'
            f = @(x) abs(x)+(x==0)/(2*nrays);
        case 'Sinc'
            f = @(x) abs(x).*sinc(x)+(x==0)/(2*nrays);
        case 'Cos'
            f = @(x) abs(x).*cos(pi*x/2)+(x==0)/(2*nrays);
        case 'Custom'
            if (nargin ~= 4)
                error('Function handle is missing');
            end
        otherwise
            error('Unknown filter name');
    end

    % BUILD FILTER
    if (mod(nrays,2) == 1)
        x = linspace(-1,1,nrays);
    else
        x = linspace(-1,1,nrays+1);
        x = x(1:end-1);
    end
    filter = (nrays/2)*f(x);
    
    % APPLY FILTER
    R = fftshift(fft(R,[],1),1); % fourier transform of each column
    R = R .* filter';
    R = (1/nrays)*ifft(ifftshift(R,1),[],1,'symmetric');
    
    % BACKPROJECT
    I = zeros(nrays);
    for k = 1:ntheta
        J = repmat(R(:,k)',nrays,1);
        I = I + imrotate(J,theta(k),'bilinear','crop');
    end
    I = I*pi/ntheta;
    
    % CROP BACKPROJECTIONS
    center = ceil(nrays/2);
    output_size = 2*floor(nrays/(2*sqrt(2))); % like iradon()
    output_range = center + (-output_size/2+1:output_size/2);
    I = I(output_range,output_range);
end




