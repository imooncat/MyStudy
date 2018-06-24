close all; clear; clc;

x = imread('img.jpg');

F = fft(x);
Fa = abs(F);
Fp = angle(F);

fp = fopen('hello.txt');
s = fread(fp);
s = [length(s); s];
s
s = dec2bin(s, 8);
s = reshape(s', 1, []);

[m, n, c] = size(x);
nbits = size(s);

ibit = 1;

% for xi = 1:m
%     for xj = 1:n
%         for xc = 1:c
%             sv = s(ibit) - '0';
%             fu = round(Fa(xi, xj, xc));
%             fu = fu + mod(fu, 2) + sv;
%             Fa(xi, xj, xc) = fu;
% %             Fa(m - xi + 1, xj, xc) = Fa(xi, xj, xc);
%             ibit = ibit + 1;
%             if ibit > nbits
%                 break;
%             end
%         end
%         if ibit > nbits
%             break;
%         end
%     end
%     if ibit > nbits
%         break;
%     end
% end

for xi = 64:64:m-8
    for xj = 64:64:n-8
        sv = s(ibit) - '0';
%         fu = round(Fa(xi, xj, :));
%         fu = fu + mod(fu, 2) + sv;
        Fa(xi:xi+8, xj:xj+8, :) = sv * 10;
        Fp(xi:xi+8, xj:xj+8, :) = 0;
        Fa(m + 1 - (xi:xi+8), xj:xj+8, :) = Fa(xi:xi+8, xj:xj+8, :);
        Fp(m + 1 - (xi:xi+8), xj:xj+8, :) = Fp(xi:xi+8, xj:xj+8, :);
        ibit = ibit + 1;
        if ibit > nbits
            break;
        end
    end
    if ibit > nbits
        break;
    end
end

G = Fa .* exp(Fp * 1i);
y = uint8(ifft(G));
figure;
subplot(1, 2, 1); imshow(x);
subplot(1, 2, 2); imshow(y);
figure; imshow(real(fft(y)));

imwrite(y, 'hidefile.png');
