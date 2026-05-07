function C = create_Ci16(n, a, b, mode)
%CREATE_CI16  Create n Ci matrices (heterogeneous or homogeneous) with conditional normalization
%
%   Inputs:
%       n    : number of Ci matrices
%       a,b  : Beta distribution parameters (default: 2,2)
%       mode : 'heterogeneous' OR 'homogeneous'
%
%   Output:
%       C    : 1×n cell array, each cell contains a Ci matrix

    % Default parameters
    if nargin < 4, mode = 'heterogeneous'; end
    if nargin < 3, b = 2; end
    if nargin < 2, a = 2; end

    % Preallocate cell array
    C = cell(1, n);

    % ---- Helper to create ONE Ci ----
    function Ci = generate_single_Ci()

        % Draw beta_i
        beta_i = round(betarnd(a, b), 2);

        % Draw delta_i and eta_i
        tmp_delta = betarnd(a, b);
        tmp_eta   = betarnd(a, b);

        % Conditional normalization
        s = 0.8;  % normalization target
        if (tmp_delta + tmp_eta) > 0.9
            % Only normalize if sum exceeds 0.9
            sum_tmp = tmp_delta + tmp_eta;
            delta_i = round(s * tmp_delta / sum_tmp, 2);
            eta_i   = round(s * tmp_eta   / sum_tmp, 2);
        else
            % Otherwise, leave as is (rounded to 2 decimals)
            delta_i = round(tmp_delta, 2);
            eta_i   = round(tmp_eta, 2);
        end

        % Build matrix
        Ci = [
            1          0                 0;
           -beta_i     1 - beta_i        0;
            delta_i   -eta_i   1 - (delta_i + eta_i)
        ];
    end

    % ---- Create matrices ----
    switch lower(mode)
        case 'heterogeneous'
            for i = 1:n
                C{i} = generate_single_Ci();
            end

        case 'homogeneous'
            Ci = generate_single_Ci();   % one draw
            C(:) = {Ci};                 % replicate n times

        otherwise
            error('Mode must be ''heterogeneous'' or ''homogeneous''.');
    end
end
