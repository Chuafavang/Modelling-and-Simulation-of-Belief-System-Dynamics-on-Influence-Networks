%To plot the network of C matrix

function plot_networkC(C)
% PLOT_NETWORKC  Visualize a logic matrix C with signed arrows.
%
% Rules:
%   • If C(i,j) ~= 0, draw arrow j -> i
%   • Blue = positive influence
%   • Red  = negative influence

    n = size(C,1);

    % --- generate coordinates automatically
    G = abs(C) > 0;
    coords = generate_layout(G);

    figure('Color','w'); 
    hold on;

    % ---------- edges ----------
    [row, col] = find(C ~= 0);

    arrow_head_length = 0.2;
    arrow_head_width  = 0.04;

    for e = 1:length(row)

        i = row(e);     % target
        j = col(e);     % source

        x1 = coords(j,1);
        y1 = coords(j,2);

        x2 = coords(i,1);
        y2 = coords(i,2);

        % shorten arrow ends
        shrink = 0.05;
        x1s = x1 + shrink*(x2 - x1);
        y1s = y1 + shrink*(y2 - y1);
        x2s = x2 - shrink*(x2 - x1);
        y2s = y2 - shrink*(y2 - y1);

        dx = x2s - x1s;
        dy = y2s - y1s;
        L = hypot(dx,dy);

        if L == 0
            continue
        end

        ux = dx / L;
        uy = dy / L;

        px = -uy;
        py = ux;

        % arrowhead base
        hx = x2s - arrow_head_length * ux;
        hy = y2s - arrow_head_length * uy;

        leftx  = hx + arrow_head_width * px;
        lefty  = hy + arrow_head_width * py;

        rightx = hx - arrow_head_width * px;
        righty = hy - arrow_head_width * py;

        % choose color by sign
        if C(i,j) > 0
            col_edge = [0.1 0.4 0.95];   % blue
        else
            col_edge = [0.85 0.1 0.1];   % red
        end

        % arrow shaft
        plot([x1s hx], [y1s hy], ...
            'Color', col_edge, ...
            'LineWidth', 1.4);

        % arrowhead
        patch([x2s leftx rightx], ...
              [y2s lefty righty], ...
              col_edge, ...
              'EdgeColor','none');

    end

    % ---------- nodes ----------
    scatter(coords(:,1), coords(:,2), 220, "k", "filled");

    % ---------- node labels ----------
    center = mean(coords);
    offset = 0.40;   % push labels outward

    for k = 1:n

        dir = coords(k,:) - center;

        if norm(dir) == 0
            dir = [0 1];
        else
            dir = dir / norm(dir);
        end

        label_pos = coords(k,:) + offset * dir;

        text(label_pos(1), label_pos(2), ...
            sprintf('Topic %d',k), ...
            'HorizontalAlignment','center', ...
            'VerticalAlignment','middle', ...
            'FontSize',11, ...
            'FontWeight','bold', ...
            'BackgroundColor','w', ...
            'Margin',2, ...
            'Clipping','off');

    end

    % ---------- legend ----------
    % h1 = plot(nan,nan,'Color',[0.1 0.4 0.95],'LineWidth',1.8);
    % h2 = plot(nan,nan,'Color',[0.85 0.1 0.1],'LineWidth',1.8);
    % 
    % lgd = legend([h1 h2], ...
    %     {'Positive influence (+)','Negative influence (-)'}, ...
    %     'Location','best');
    % lgd.FontSize = 16;

    axis equal off

    pad = 0.8;
    xlim([min(coords(:,1))-pad, max(coords(:,1))+pad])
    ylim([min(coords(:,2))-pad, max(coords(:,2))+pad])
    
    hold off

end