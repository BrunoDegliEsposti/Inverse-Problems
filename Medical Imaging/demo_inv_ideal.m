P = phantom(512);
R = radon(P,0:179);

figure(1);
I1 = iradon(R,0:179);
imshow(I1);

figure(2);
I2 = iradon_fbp(R,0:179);
imshow(I2);

err = norm(I1(:)-I2(:),Inf);
sum(I1(:))
sum(I2(:))