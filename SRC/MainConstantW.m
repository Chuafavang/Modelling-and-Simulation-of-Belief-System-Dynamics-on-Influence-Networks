% This is the file to simulate opinion dynamics in constant social
% influence networks

% There are three main functions for the project.

% Other functions used to generate X, W, and C are saved in the folder
% named "matrices".

function [opinion_history, W_series]  = simulate(X, C, T, W)
    % SIMULATE_OPINIONS - Simulate opinion dynamics
    % Inputs:
    %   X : m x n initial opinions
    %   W : n x n influence matrix
    %   C : cell array of m x m logic matrices for each agent
    %   T : number of time steps
    % Output:
    %   opinion_history : m x n x (T+1) matrix of opinions over time

    [m, n] = size(X);

    % Preallocate 3D matrix: topics x agents x time
    opinion_history = zeros(m, n, T+1);
    W_series = zeros(n, n, T);
    % Store initial opinions
    opinion_history(:,:,1) = X;
   
    % Simulation loop
    for t = 1:T

        % Step 1: apply influence matrix W (social mixing)
        W_series(:,:,t) = W;
        X_mixed = X * W';

        % Step 2: apply logic matrix C_i to each agent
        for i = 1:n
        X(:, i) = C{i} * X_mixed(:, i);
        end

        % Step 3: store results
        opinion_history(:,:,t+1) = X;
       
    end
end

function plot_opinions(opinion_history)
    % PLOT_OPINIONS - Plot the opinion dynamics over time
    % Input:
    %   opinion_history : m x n x (T+1) matrix (topics x agents x time)

    [m, n, Tplus1] = size(opinion_history);
    time = 0:(Tplus1-1);

    figure;
    hold on;
    colors = lines(m); % distinct colors per topic
    topic_handles = gobjects(m,1);

    for topic = 1:m
        for agent = 1:n
            h = plot(time, squeeze(opinion_history(topic, agent, :)), ...
                     'LineWidth', 1.2, ...
                     'Color', colors(topic,:));
            % store one handle per topic (first agent only)
            if agent == 1
                topic_handles(topic) = h;
            end
        end
    end

    xlabel('Time t');
    ylabel('Opinion value x_i(t)');
    % title('Opinion Dynamics Across Topics and Agents');
    legend(topic_handles, arrayfun(@(t) sprintf('Topic %d', t), 1:m, 'UniformOutput', false), ...
           'Location', 'bestoutside');
    ylim([-1 1]);
    grid on;
    hold off;
end

function [mu, var_val] = calculate_plot_mean_variance(opinion_history, t)
% CALCULATE_PLOT_MEAN_VARIANCE
% Compute mean & variance for each topic at time t
% and plot distribution
%
% Input:
%   opinion_history : m x n x (T+1)
%   t               : time step
%
% Output:
%   mu      : m x 1 mean for each topic
%   var_val : m x 1 variance for each topic

    [m, ~] = size(opinion_history);

    mu = zeros(m,1);
    var_val = zeros(m,1);

    figure;

    for k = 1:m
        % opinions of topic k at time t (across agents)
        data = squeeze(opinion_history(k,:,t));

        % compute mean and variance
        mu(k) = mean(data);
        var_val(k) = var(data);

        % plot distribution
        subplot(m,1,k)
        histogram(data, 'Normalization','pdf')
        hold on

        % mean line
        xline(mu(k),'r','LineWidth',2)

        % labels
        xlabel('Opinion value')
        ylabel('Density')

        title(sprintf('Topic %d at t = %d  |  Mean = %.2f  Variance = %.4f', ...
            k, t-1, mu(k), var_val(k)))

        grid on
    end
end

addpath(fullfile(pwd, 'matrices'));
n = 100; % Number of agents
m = 3; % Number of topics
seed = 123; % To keep reproducibility 
T = 20; % Time steps
d = 4; % Number of neighbours
p = 0.5; % Rewiring probability


cfg.mu    = [0.3 0.5 0.7];
% cfg.kappa = 10 * ones(1,m);
cfg.scale = 'att';     % or 'att' or 'prob'
% cfg.corr  = 0.5;        % add correlation
rng(123);
[X0, cfg_used] = generate_X0_core(n, m, cfg);
plot_X0_distributions(X0, cfg_used);


C = create_Ci16(n, 2, 2, 'heterogeneous');

% C6 = [ 1     0     0;
%       0.2   0.8   0;
%        0.4  -0.3   0.3 ];
% C{end+1} = C6;

W = create_initial_W_matrix(n, d, p, [], seed, 'WS');
plot_network(W, 'network', 'WS', 'd', d, 'p', p, 'seed', seed);

[op_history, W_series]  = simulate(X0', C, T, W);

figure(1);
plot_opinions(op_history);
drawnow;

[mu, var_val] = calculate_plot_mean_variance(op_history, 21);
disp(mu);
disp("Variance");
disp(var_val);