
%% Construct selection metric
a = (soln.day_var-min(soln.day_var));
b = (soln.touch_mean-min(soln.touch_mean));
c = a+b;
d = sort(c);

plot(d)
%% Identify top 10 solutions

idx = find(c<d(11));

aa = zeros(numel(idx),10);
bb = zeros(numel(ii_vec),numel(idx));

for ii=1:numel(idx);
    bb(:,ii) = soln.touch_hw{idx(ii)};
    aa(ii,:) = soln.day_hw{idx(ii)};
end

%% Output results
day_hw = aa.'
touch_hw = bb

