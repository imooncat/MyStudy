close all; clear; clc;

x = imread('img.jpg');
t = imread('info.png');

F = fft(x);
Fa = abs(F);
Fp = angle(F);

[m,n,c] = size(x);
s = ones(m, n, c) * 255;
[mt,nt,ct] = size(t);
s(1:mt, 1:nt, 1:ct) = t;
s(m : -1 : ceil(m / 2 + 1), :, :) = s(1 : floor(m / 2), :, :);
s = double(s) / 255;

Fa = Fa .* s;

G = Fa .* exp(Fp * 1i);
y = uint8(ifft(G));
figure; imshow(y);
figure; imshow(real(fft(y)));

imwrite(y, 'output.png');
