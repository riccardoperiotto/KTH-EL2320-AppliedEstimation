% This function performs the ML data association
%           S_bar(t)                 4XM
%           z(t)                     2Xn
%           association_ground_truth 1Xn | ground truth landmark ID for
%           every measurement  
% Outputs: 
%           outlier                  1Xn    (1 means outlier, 0 means not outlier) 
%           Psi(t)                   1XnXM
%           c                        1xnxM
function [outlier, Psi, c] = associate(S_bar, z, association_ground_truth)
    if nargin < 3
        association_ground_truth = [];
    end
    global DATA_ASSOCIATION
    global lambda_psi % threshold on average likelihood for outlier detection
    global Q % covariance matrix of the measurement model
    global M % number of particles
    global N % number of landmarks
    if size(DATA_ASSOCIATION,1) == 0
    	DATA_ASSOCIATION="on";
    end
    % YOUR IMPLEMENTATION
    n = size(z, 2); % number of observations
    
    outlier = zeros(1,n);
    Psi = zeros(1,n,M);
    c = zeros(1,n,M);
    
    z_hat = zeros(N, 2, M);
    psi = zeros(N,1,M);
    eta = 1 / (2 * pi * sqrt(det(Q))); 

    % for each landmark j in 1..N
    for j = 1 : N
       z_hat(j,:,:) = observation_model(S_bar, j);
    end
    
    % for each observation i in 1..n
    for i = 1 : n
        for j = 1 : N
            % vector of differences between observation and prediction
            nu = z(:,i) - reshape(z_hat(j,:,:), 2, M); 
            nu(2,:) = mod(nu(2,:) + pi, 2 * pi) - pi;
            psi(j,:,:) = eta * exp(- 1/2 * sum(nu .* (Q\ nu), 1));
        end
        [Psi(1,i,:), c(1,i,:)] = max(psi);
        outlier(i) = mean(Psi(:,i,:)) < lambda_psi;
    end

end
