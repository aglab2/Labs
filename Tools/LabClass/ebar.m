function ebar( dataX, dataY )

x = dataX.Val; y=dataY.Val; errX=dataX.Err; errY=dataY.Err;
x = x(:); y = y(:); errX = errX(:); errY = errY(:);

if isstr(x) | isstr(y) | isstr(errX) | isstr(errY)
    error('Arguments must be numeric.')
end

if ~isequal(size(x),size(y)) | ~isequal(size(x),size(errX)) | ~isequal(size(y),size(errY)),
    error('The sizes of X, Y should be equal');
end

xl = x - errX;
xr = x + errX;
yl = y - errY;
yr = y + errY;

[n, ntr] = size(x);

% Plot graph and bars
hold_state = ishold;
cax = newplot;
next = lower(get(cax,'NextPlot'));

% build up nan-separated vector for bars
% changed from errorbar.m
xb = zeros(n*6, 1);

xb(1:6:end,:) = xl;
xb(2:6:end,:) = xr;
xb(3:6:end,:) = NaN;
xb(4:6:end,:) = x;
xb(5:6:end,:) = x;
xb(6:6:end,:) = NaN;


yb = zeros(n*6,1);
yb(1:6:end,:) = y;
yb(2:6:end,:) = y;
yb(3:6:end,:) = NaN;
yb(4:6:end,:) = yl;
yb(5:6:end,:) = yr;
yb(6:6:end,:) = NaN;
% end change

hold on

plot(xb,yb);
plot(x, y, '.');

end
