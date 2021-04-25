function [R,xp] = radon_geo(I,theta)
    %RADON_GEO An implementation of radon() from scratch,
    %using the geometrical definition of Radon transform
    if (nargin < 2)
        theta = 0:179;
    end
    if iscolumn(theta)
        theta = theta'; % theta must be a row vector
    end
    ntheta = length(theta);
    [n,m] = size(I);
    nbins = 2*ceil(norm(size(I)-floor((size(I)-1)/2)-1))+3;
    offset = (nbins+1)/2;
    xp = 1:nbins - offset;
    bins = zeros(nbins,1);
    R = zeros(nbins,ntheta);
    centralpx = floor((size(I)+1)/2);
    pivot = centralpx + [-1/2,1/2]; % it should be -1/2,-1/2, but this is what radon() uses
    subpixels = [-3/4,-1/4; -1/4,-1/4; -3/4,-3/4; -1/4,-3/4];
    v = [cos(pi*theta/180); sin(pi*theta/180)];
    for t = 1:ntheta
        for i = 1:n
            for j = 1:m
                for s = 1:4
                    p = [j,n-i+1]+subpixels(s,:);
                    x = dot(p-pivot,v(:,t));
                    k1 = offset + round(x); % closest bin
                    k2 = offset + round(x) + sign(x-round(x)); % 2nd closest bin
                    d = abs(x-round(x)); % distance to closest bin center
                    c1 = (1-d)*I(i,j)/4; % contribution to closest bin
                    c2 = d*I(i,j)/4; % contribution to 2nd closest bin
                    bins(k1) = bins(k1) + c1;
                    bins(k2) = bins(k2) + c2;
                end
            end
        end
        R(:,t) = bins;
        bins = zeros(nbins,1);
    end
end



