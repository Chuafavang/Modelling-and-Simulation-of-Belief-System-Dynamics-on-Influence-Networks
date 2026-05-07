%Remove random interaction from the time-varying networks

function W = create_init_W_No_matrix(X, epsilon, seed, t)
% CREATE_INIT_W_MATRIX Generate influence matrix without stochastic access
%
% Inputs:
%   X       - m x n opinion matrix (rows = topics, cols = agents)
%   epsilon - confidence threshold
%   seed    - random seed
%
% Output:
%   W - n x n row-stochastic influence matrix

    if nargin == 4
        rng(seed);
    end

    [m,n] = size(X);
    W = zeros(n,n);
    d = 2*sqrt(m); % max Euclidean distance

    rng(seed + t);

    for i = 1:n
        % self-weight
        W(i,i) = rand();

        for j = 1:n
            if i ~= j
                dist = norm(X(:,i) - X(:,j));

                if dist <= epsilon
                    W(i,j) = 1 - dist / d;
                else
                    W(i,j) = 0;
                end
            end
        end
    end

    % Normalize rows to make W row-stochastic
    row_sums = sum(W,2);
    W = W ./ row_sums;

end