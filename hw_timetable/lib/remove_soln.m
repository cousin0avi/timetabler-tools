function [ soln ] = remove_soln( soln,idx_out )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

n_soln = numel(soln.id);
idx = 1:n_soln;
idx(idx_out)=[];

soln.id = soln.id(idx);
soln.cell_hw = soln.cell_hw(idx);
soln.day_hw = soln.day_hw(idx);
soln.touch_hw = soln.touch_hw(idx);
soln.day_var = soln.day_var(idx);
soln.touch_mean = soln.touch_mean(idx);
end

