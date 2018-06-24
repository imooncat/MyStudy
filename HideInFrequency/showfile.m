close all; clear; clc;

x = imread('hidefile.png');

F = fft(x);
Fa = abs(F);
Fp = angle(F);

figure; imshow(x);
figure; imshow(real(F));

[m, n, c] = size(x);

sbyte = '';
nbytes = -1;
vbyte = 0;
ibyte = -1;

for xi = 64:64:m-8
    for xj = 64:64:n-8
%         sv = 0;
%         for xc = 1:c
%             fu = round(Fa(xi, xj, xc));
%             sv = sv + mod(fu, 2);
%         end
        sv = sum(sum(sum(Fa(xi:xi+8, xj:xj+8, :))));
        sv = (sv >= 320);
        sbyte = [sbyte, sv + '0'];
        if length(sbyte) == 8
            vbyte = bin2dec(sbyte);
            ibyte, sbyte
            if nbytes == -1
                nbytes = vbyte;
                s = zeros(nbytes, 1);
                ibyte = 1;
            else
                s(ibyte) = vbyte;
                ibyte = ibyte + 1;
                if ibyte > nbytes
                    break;
                end
            end
            sbyte = '';
        end
    end
    if ibyte > nbytes
        break;
    end
end
