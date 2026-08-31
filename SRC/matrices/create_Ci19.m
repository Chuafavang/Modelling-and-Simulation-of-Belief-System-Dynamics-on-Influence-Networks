function C = create_Ci19(n, a, b, mode)
%CREATE_CI19  Generates n Ci matrices with conditional normalization.
%
%   C = create_Ci19(n, a, b, mode)
%
% Inputs:
%   n     - number of matrices
%   a,b   - Beta distribution parameters
%   mode  - 'heterogeneous' or 'homogeneous'
%
% Output:
%   C     - 1×n cell array of Ci matrices

    % Default parameters
    if nargin < 3, b = 2; end
    if nargin < 2, a = 2; end
    if nargin < 4, mode = 'heterogeneous'; end

    C = cell(1, n);  % preallocate
    s = 0.8;         % normalization target

    % --- Helper function to generate one Ci ---
    function Ci = generate_single_Ci()
        % Step 1: draw Beta variables
        beta_i  = betarnd(a,b);
        eta_i   = betarnd(a,b);
        delta_i = betarnd(a,b);
        mu_i    = betarnd(a,b);

        % Step 2: conditional normalization
        % Normalize (beta_i + eta_i) if sum > 0.9
        if (beta_i + eta_i) > 0.9
            sum_tmp = beta_i + eta_i;
            beta_i = round(s * beta_i / sum_tmp, 2);
            eta_i  = round(s * eta_i  / sum_tmp, 2);
        else
            beta_i = round(beta_i, 2);
            eta_i  = round(eta_i, 2);
        end

        % Normalize (delta_i + mu_i) if sum > 0.9
        if (delta_i + mu_i) > 0.9
            sum_tmp = delta_i + mu_i;
            delta_i = round(s * delta_i / sum_tmp, 2);
            mu_i    = round(s * mu_i    / sum_tmp, 2);
        else
            delta_i = round(delta_i, 2);
            mu_i    = round(mu_i, 2);
        end

        % Step 3: construct matrix
        Ci = [
            1,       0,              0;
            eta_i,   1-(beta_i+eta_i), -beta_i;
            mu_i,   -delta_i,         1-(delta_i+mu_i)
        ];
    end

    % --- Fill cell array ---
    switch lower(mode)
        case 'heterogeneous'
            for i = 1:n
                C{i} = generate_single_Ci();
            end

        case 'homogeneous'
            Ci = generate_single_Ci();
            C(:) = {Ci};

        otherwise
            error("mode must be 'heterogeneous' or 'homogeneous'");
    end
end
