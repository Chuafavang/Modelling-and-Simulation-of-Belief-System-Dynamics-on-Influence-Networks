function C = create_Ci17(n, a, b, mode)
%CREATE_CI17  Generates n logic matrices C{i} using conditional normalized Beta draws.
%
%   Inputs:
%       n     - number of matrices
%       a,b   - Beta distribution parameters
%       mode  - 'heterogeneous' or 'homogeneous'
%
%   Output:
%       C     - 1×n cell array of Ci matrices

    % Default Beta parameters
    if nargin < 3
        b = 2;
    end
    if nargin < 2
        a = 2;
    end
    if nargin < 4
        mode = 'heterogeneous';
    end

    % Set θ and τ
    theta = 0.5;  % adjust as needed
    tau   = 0.3;  % adjust as needed

    % Preallocate cell array
    C = cell(1, n);

    % Helper to generate a single Ci
    function Ci = generate_single_Ci()
        % Step 1: draw raw Beta samples
        beta_raw  = betarnd(a,b);
        delta_raw = betarnd(a,b);

        % Step 2: compute scaled values
        beta_i  = beta_raw;
        delta_i = delta_raw;

        % Conditional normalization for beta_i
        if (1 + theta) * beta_i > 0.9
            beta_max = 0.9 / (1 + theta);  % scale down
            beta_i = beta_i * beta_max / beta_i; % effectively beta_i = beta_max
        end

        % Conditional normalization for delta_i
        if (1 + tau) * delta_i > 0.9
            delta_max = 0.9 / (1 + tau);
            delta_i = delta_i * delta_max / delta_i; % effectively delta_i = delta_max
        end

        % Round to 2 decimals
        beta_i  = round(beta_i, 2);
        delta_i = round(delta_i, 2);

        % Step 3: build matrix
        Ci = [
            1,             0,                     0;
            theta*beta_i,  1-(1+theta)*beta_i,   -beta_i;
            tau*delta_i,   -delta_i,             1-(1+tau)*delta_i
        ];
    end

    % ---- Fill cell array ----
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

