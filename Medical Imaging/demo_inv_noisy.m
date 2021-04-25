P = phantom(700);
R = radon(P,0:179);
R = imresize(R,[500,180]);
sigma = 0.05;
R = R + sigma*norm(R(:),Inf)*randn(500,180);

figure(1);
I1 = iradon(R,0:179,'linear','Cosine');
imshow(I1);

figure(2);
a = 0.15;
f = @(x) abs(x).*(abs(x)<a) + (a*(abs(x)-1)/(a-1)).*(abs(x)>=a);
I2 = iradon_fbp(R,0:179,'Custom',f);
imshow(I2);
