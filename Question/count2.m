function [ T ] = count2( T, mu, n, Tmin, Tmax )
%COUNT2 Summary of this function goes here
%   Detailed explanation goes here
[p, S, m] = polyfit(1./T, mu, n);

Tl = Tmin;
Tr = Tmax;

x = Tl:0.1:Tr;
y = polyval(p, 1./x, S, m);

hold on; grid on;
plot(T, mu, '+');
if n == 1
    plot(x, y, 'g');
else
    plot(x, y, 'r');
end
    
while Tr-Tl > 0.001
    Tm = (Tr+Tl) / 2;
    if polyval(p, 1/Tm, S, m) < 0
        Tr = Tm;
    else
        Tl = Tm;
    end
end
T = Tm;
end

