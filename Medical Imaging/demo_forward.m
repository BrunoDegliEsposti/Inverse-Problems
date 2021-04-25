iptsetpref('ImshowAxesVisible','on');
I = zeros(100,100);
I(25:75, 25:75) = 1;
theta = 0:179;

[R1,xp] = radon(I,theta);
figure(1);
imshow(R1,[],'Xdata',theta,'Ydata',xp,'InitialMagnification','fit')
xlabel('\theta (degrees)')
ylabel('x''')
colormap(gca,hot), colorbar

[R2,xp] = radon_geo(I,theta);
figure(2);
imshow(R2,[],'Xdata',theta,'Ydata',xp,'InitialMagnification','fit')
xlabel('\theta (degrees)')
ylabel('x''')
colormap(gca,hot), colorbar

[R3,xp] = radon_fft(I,theta);
figure(3);
imshow(R3,[],'Xdata',theta,'Ydata',xp,'InitialMagnification','fit')
xlabel('\theta (degrees)')
ylabel('x''')
colormap(gca,hot), colorbar

err_geo = norm(R1(:)-R2(:),Inf);



