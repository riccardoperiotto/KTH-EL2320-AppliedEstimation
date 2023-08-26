% This function is the implementation of the measurement model.
% The bearing should be in the interval [-pi,pi)
% Inputs:
%           S(t)                           4XM
%           j                              1X1
% Outputs:  
%           z_j                              2XM
function z_j = observation_model(S, j)

    global map % map including the coordinates of all landmarks | shape 2Xn for n landmarks
    global M % number of particles

    % YOUR IMPLEMENTATION
    S(3,:) = mod(S(3,:) + pi, 2 * pi) - pi;

    z_j(1,:) = sqrt((repmat(map(1,j),1,M) - S(1,:)).^2 + (repmat(map(2,j),1, M) - S(2,:)).^2);
    z_j(2,:) = atan2(repmat(map(2,j),1,M) - S(2,:), repmat(map(1, j),1, M) - S(1,:)) - S(3,:);
    z_j(2,:) = mod(z_j(2,:) + pi, 2*pi) - pi; % put the steering angle in the interval

end
