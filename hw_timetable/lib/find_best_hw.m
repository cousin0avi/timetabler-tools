
%% Construct selection metric
a = (soln.day_var-min(soln.day_var));
b = (soln.touch_mean-min(soln.touch_mean));
c = a+b;
d = sort(c);

plot(d)
%% Identify top 10 solutions
if numel(d)>10
    idx = find(c<d(11));
    if isempty(idx)
       idx = find(c==d(1));
       idx = idx(1:10);
    end
    aa = zeros(numel(idx),10);
    bb = zeros(numel(ii_vec),numel(idx));
else
    idx = 1:numel(d);
    aa = zeros(numel(idx),10);
    bb = zeros(numel(ii_vec),numel(idx)); 
end

for ii=1:numel(idx);
    bb(:,ii) = soln.touch_hw{idx(ii)};
    aa(ii,:) = soln.day_hw{idx(ii)};
end

%% Output results
day_hw = aa.'
touch_hw = bb
idx
