function [count_sub] = find_sub_occurr( soln,form,sub_ref )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

n1 = numel(soln.id);
one_sixty = 1:60;
sub_idx = one_sixty(form.ic==sub_ref);

n_hw = sum(form.hw_vec==8);
sub_1 = zeros(n1,n_hw);

for ii=1:n1
    sub_1(ii,:) = sub_idx(~strcmp(soln.cell_hw{ii}(sub_idx),''));
end

[C,~,ic_sub_1] = unique(sub_1);
n_sub_1 = numel(C);
count_sub = zeros(n_sub_1,2);
count_sub(:,1) = C;

for ii=1:n_sub_1
    count_sub(ii,2) = sum(ic_sub_1==ii);
end


end

