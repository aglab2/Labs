function [ table ] = count( mu, T )
%COUNT Summary of this function goes here
%   Detailed explanation goes here

%Van Der Vaals
p = polyfit(mu, 1./T, 1);
table(1,1) = p(1);
table(2,1) = p(2);
table(3,1) = abs(p(1)/p(2));

%Diterichi
p = polyfit(mu, 1./nthroot(T,3).^2, 1);
table(1,2) = p(1);
table(2,2) = p(2);
table(3,2) = nthroot(abs(p(1)/p(2)), 2)^3;

%Bertlo
p = polyfit(mu, 1./T.^2, 1);
table(1,3) = p(1);
table(2,3) = p(2);
table(3,3) = nthroot(abs(p(1)/p(2)), 2);

%Redlih
p = polyfit(mu, 1./nthroot(T,3), 1);
table(1,4) = p(1);
table(2,4) = p(2);
table(3,4) = abs(p(1)/p(2)) ^ 3;
end

