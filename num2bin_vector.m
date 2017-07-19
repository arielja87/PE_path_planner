function bCell = num2bin_vector(n)
% Takes an integer as an input and returns an  2^n x 1 cell array of vectors
% representing binary numbers from 0:n-1

for i = 0:2^n-1
    bStr = dec2bin(i, n);
    j = 1;
    vecStr = '';
    for j = 1:numel(bStr)
        vecStr = [vecStr, bStr(j), ' '];
    end
    bCell{i+1} = str2num(vecStr);
end

end