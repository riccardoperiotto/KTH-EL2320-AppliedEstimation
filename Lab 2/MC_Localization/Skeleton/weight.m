% This function calcultes the weights for each particle based on the
% observation likelihood
%           S_bar(t)            4XM
%           outlier             1Xn
%           Psi(t)              1XnXM
% Outputs: 
%           S_bar(t)            4XM
function S_bar = weight(S_bar, Psi, outlier)

    % YOUR IMPLEMENTATION
    mask = logical(repmat(outlier, 1, 1, size(S_bar,2)));
    Psi(mask) = 1;

    S_bar(4,:) = prod(Psi,2);
    S_bar(4,:) = S_bar(4,:) / sum(S_bar(4,:));
end
