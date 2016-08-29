function [idx,a,b] = identify_worest(soln)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

idx = find(soln.id~=0,1,'last');

a = quantile(soln.touch_mean(1:idx),0.5);
b = quantile(soln.day_var(1:idx),0.5);

aa = find(soln.touch_mean>=a);
bb = find(soln.day_var>=b);

idx = union(aa,bb);
end