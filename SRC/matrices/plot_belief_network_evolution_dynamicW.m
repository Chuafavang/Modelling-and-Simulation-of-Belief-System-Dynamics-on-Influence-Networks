function plot_belief_network_evolution_dynamicW(X_series, W_series, coords, timepoints, labels, opts)
%PLOT_BELIEF_NETWORK_EVOLUTION_DYNAMICW  
% Publication-style 1×3 snapshots (a–c) using time-varying W(t)
%
% Usage:
%   plot_belief_network_evolution_dynamicW(X_series, W_series, coords, [1 5 100])
%
% Inputs:
%   X_series   : n×T belief time series (range [-1,1])
%   W_series   : n×n×T influence matrices (one for each time step)
%   coords     : n×2 layout (pass [] to auto-generate from W at t=1)
%   timepoints : exactly 3 integers, e.g. [1 5 100]
%   labels     : optional {'a','b','c'}
%   opts       : optional struct:
%                   .EdgeAlpha (default 0.7)
%                   .NodeAlpha (default 1.0)
%                   .CLim      (default [-1 1])
%

% ---------- defaults ----------
if nargin < 6, opts = struct; end
if ~isfield(opts,'EdgeAlpha'), opts.EdgeAlpha = 0.7; end
if ~isfield(opts,'NodeAlpha'), opts.NodeAlpha = 1.0; end
if ~isfield(opts,'CLim'),      opts.CLim = [-1 1]; end

[n, T] = size(X_series);
assert(size(W_series,1)==n && size(W_series,2)==n, 'W_series dimension mismatch');
assert(size(W_series,3) >= max(timepoints), 'W_series not long enough');

assert(numel(timepoints)==3, 'Need exactly 3 timepoints');
assert(all(timepoints>=1 & timepoints<=T));

default_labels = {'a','b','c'};
if nargin < 5 || isempty(labels)
    labels = default_labels;
end

% ---------- layout ----------
if isempty(coords)
    coords = generate_layout(W_series(:,:,1));  % initial layout
end

% ---------- figure ----------
figure('Color','w','Position',[100,100,1100,350]);

for k = 1:3
    subplot(1,3,k); hold on;
    t = timepoints(k);

    % beliefs at time t
    cdata = X_series(:,t);
    cdata = min(max(cdata, opts.CLim(1)), opts.CLim(2));

    % ----- choose W at time t -----
    Wt = W_series(:,:,t);

    % adjacency
    A = Wt > 0;

    % degree-based node size
    deg = sum(A,2);
    deg_norm = (deg - min(deg)) / (max(deg)-min(deg) + 1e-9);
    NodeSize = 35 + 45 * deg_norm;

    % edges
    [row, col] = find(A);
    
    % ---------- draw edges ----------
   % ---------- draw edges with fixed arrowhead ----------
    arrow_head_length = 0.08;   % fixed size (adjust)
    arrow_head_width  = 0.02;   % fixed size (adjust)
    
    for e = 1:length(row)
        i = row(e);   % target node
        j = col(e);   % source node (directed: j → i)
    
        x1 = coords(j,1);
        y1 = coords(j,2);
    
        x2 = coords(i,1);
        y2 = coords(i,2);
    
        % shrink endpoints a bit
        shrink = 0.05;
        x1s = x1 + shrink*(x2 - x1);
        y1s = y1 + shrink*(y2 - y1);
    
        x2s = x2 - shrink*(x2 - x1);
        y2s = y2 - shrink*(y2 - y1);
    
        % direction
        dx = x2s - x1s;
        dy = y2s - y1s;
        L = hypot(dx,dy);
    
        if L == 0
            continue;
        end
    
        ux = dx / L;   % unit vector
        uy = dy / L;
    
        % perpendicular direction
        px = -uy;
        py = ux;
        
    
        % Arrowhead points
        hx = x2s - arrow_head_length * ux;
        hy = y2s - arrow_head_length * uy;
    
        leftx  = hx + arrow_head_width * px;
        lefty  = hy + arrow_head_width * py;
    
        rightx = hx - arrow_head_width * px;
        righty = hy - arrow_head_width * py;
    
        % Shaft
        plot([x1s hx], [y1s hy], 'Color', [0.55 0.75 0.95 opts.EdgeAlpha], ...
            'LineWidth', 0.7);
    
        % Arrowhead (triangle)
        patch([x2s leftx rightx], [y2s lefty righty], ...
            [0.55 0.75 0.95], ...
            'EdgeColor','none', ...
            'FaceAlpha', opts.EdgeAlpha);
    end




    % ---------- draw nodes ----------
    scatter(coords(:,1), coords(:,2), ...
            NodeSize, ...
            cdata, 'filled', ...
            'MarkerFaceAlpha', opts.NodeAlpha, ...
            'MarkerEdgeColor', 'none');

    axis off;
    colormap(redblue);
    clim(opts.CLim);

    % Panel label (a,b,c)
    text(-0.12,1.05,labels{k}, ...
         'Units','normalized','FontWeight','bold','FontSize',12);

    % Time label
    text(0.5,-0.10,sprintf('t = %d',t), ...
        'Units','normalized','HorizontalAlignment','center', ...
        'FontSize',11);
end

% ---------- colorbar ----------
h = colorbar('Position',[0.93 0.15 0.015 0.7]);
ylabel(h,'Belief Value (-1 = Anti, +1 = Pro)','FontSize',11);

end
