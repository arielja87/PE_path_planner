function [h1, h2] = plot_dir (vX, vY)
%function [h1, h2] = plot_dir (vX, vY)
%Plotting x-y variables with direction indicating vector to the next element.
%Example
%   vX = linspace(0,2*pi, 10)';
%   vY = sin (vX);
%   plot_dir(vX, vY);

rMag = .2;

% Length of vector
lenTime = length(vX);

% Indices of tails of arrows
vSelect0 = 1:(lenTime-1);
% Indices of tails of arrows
vSelect1 = vSelect0 + 1;

% X coordinates of tails of arrows
vXQ0 = vX(vSelect0, 1);
% Y coordinates of tails of arrows
vYQ0 = vY(vSelect0, 1);

% X coordinates of heads of arrows
vXQ1 = vX(vSelect1, 1);
% Y coordinates of heads of arrows
vYQ1 = vY(vSelect1, 1);

% vector difference between heads & tails
vPx = (vXQ1 - vXQ0)/norm(vXQ1 - vXQ0) * norm(vXQ1 - vXQ0) * rMag;
vPy = (vYQ1 - vYQ0)/norm(vYQ1 - vYQ0) * norm(vYQ1 - vYQ0) * rMag;

% make plot 
h1 = plot (vX, vY, 'LineStyle', '--', 'Color', [.1 0 .9], 'LineWidth', 1); hold on;
% add arrows 
for i = 1: length(vXQ0)
    h2(i) = quiver (vXQ0(i),vYQ0(i), vPx(i), vPy(i), 1/norm([vPx(i), vPy(i)]), 'Color', [.1 0 .9], 'LineWidth', 1, 'MaxHeadSize', 1/norm([vPx(i) vPy(i)])); 
end
end