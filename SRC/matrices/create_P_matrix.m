%To generate the probability of random interaction for n agents.

function P = create_P_matrix(n, delta, seed)
% CREATE_P_MATRIX Generate access probability matrix P for n agents
%
% Inputs:
%   n     - number of agents
%   delta - minimum probability threshold (0 < delta <= 1)
%   seed  - optional, for reproducibility
%
% Output:
%   P - n x n matrix with P_ij ~ Uniform(delta,1)
    if nargin == 3
        rng(seed);
    end

    P = delta + (1 - delta) * rand(n,n); % Uniform(delta,1)
    
    % Optional: set diagonal to 1 (self-access)
    for i = 1:n
        P(i,i) = 1;
    end
end
