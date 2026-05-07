function coords = generate_layout(W)
%GENERATE_LAYOUT  Arrange nodes evenly on a circle

    n = size(W,1);

    % angles for each node
    theta = linspace(0, 2*pi, n+1).';
    theta(end) = [];   % remove duplicate at 2π

    R = 1.0;  % radius of circle

    % coordinates on circle
    coords = [R*cos(theta), R*sin(theta)];
end
