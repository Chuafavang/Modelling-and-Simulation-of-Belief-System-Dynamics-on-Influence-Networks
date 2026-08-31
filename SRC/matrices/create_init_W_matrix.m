function W = create_init_W_matrix(X, epsilon, delta, seed,t)
% CREATE_INIT_W_MATRIX Generate initial influence matrix with probabilistic access
%
% Inputs:
%   X       - m x n opinion matrix (rows = topics, cols = agents)
%   epsilon - confidence threshold
%   delta   - minimum access probability for P
%   seed    - random seed for reproducibility
%
% Output:
%   W - n x n row-stochastic influence matrix

    if nargin == 4
        rng(seed);
    end

    [m,n] = size(X);
    W = zeros(n,n);
    d = 2*sqrt(m); % max Euclidean distance

    % Generate access probability matrix P
    P = create_P_matrix(n, delta, seed);
    % disp(P)
    rng(seed + t);
    for i = 1:n
        % Diagonal random entries
        W(i,i) = rand();
        for j = 1:n
            if i ~= j
                dist = norm(X(:,i) - X(:,j));
                r = rand(); % random draw for interaction
                % disp(r)
                if dist <= epsilon && r < P(i,j)
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
% n = 6;
% m = 4;
% seed = 123;
% T = 30;
% 
% % cfg.mu    = [0.2 0.3 0.7 0.8];
% % cfg.kappa = 10 * ones(1,m);
% cfg.scale = 'att';     % or 'att' or 'prob'
% % cfg.corr  = 0.5;        % add correlation
% rng(123);
% [X0, cfg_used] = generate_X0_core(n, m, cfg);
% epsilon = 0.2;
% delta= 0.8;
% disp('new')
% W = create_init_W_matrix(X0', epsilon, delta, seed, 2);