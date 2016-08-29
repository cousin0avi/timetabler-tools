function [day_hw, touch_hw, day_var, touch_mean ] = create_metrics(n_soln, n_sub, cell_hw,idx_less,flag_check,flag_done,day_hw,touch_hw,day_var,touch_mean ) %#codegen
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Calculate metric
for ii=1:n_soln
    temp = ~cellfun(@isempty,cell_hw{ii});
    day_hw{ii} = sum(temp,1);
    day_var(ii) = var(day_hw{ii});
    
    for jj=1:n_sub
        if flag_done(jj)
            continue
        end
        b = temp(idx_less{jj}(flag_check{jj}));
        if b(1) && b(end)
            c = 0;
        else
            c = 1;
        end
        
        d = [c;diff(b)];
        touch_hw{ii}(jj) = sum(b(d==0));
    end
    touch_mean(ii) = mean(touch_hw{ii});
end

end