function bCell = num2bin_vector(n)
% Takes an integer as an input and returns an  2^n x 1 cell array of vectors
% representing binary numbers from 0:n-1

b = de2bi(0:2^n-1);
bCell = mat2cell(b, ones(2^n, 1));

end