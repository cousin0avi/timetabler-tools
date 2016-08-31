function [ subjects ] = make_subjects(ic,subs,hw_alloc)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

subjects = struct('id','','n_hw',zeros(1,1,'uint8'),'n_avail',zeros(1,1,'uint8'),'n_less',zeros(1,1,'uint8'),'flag_done',false,...
    'idx_less',[],'flag_avail',[],'flag_hw',[],'flag_check',[]);

[~,n_mode] = mode(ic); %Needed to make cells homogeneous
idx_0 = zeros(n_mode,1,'uint8');

v_hw = zeros(numel(subs),1,'uint8');
v_hw(ismember(subs,hw_alloc(:,1))) = cast([hw_alloc{:,2}],'uint8');


for ii=1:numel(subs)
    idx_less = cast(find(ismember(ic,ii)),'uint8');
    if(numel(idx_less))~=1
        idx_less(numel(idx_less)+1:n_mode)=idx_0(numel(idx_less)+1:n_mode); %Assigns 0 to fake lessons
    else
        idx_less(numel(idx_less)+1:n_mode)=idx_0(numel(idx_less)+1:n_mode); %Assigns 0 to fake lessons
        idx_less = idx_less.';
    end
    flag_avail = [true;diff(idx_less)~=1];
    flag_avail(idx_less==0) = false; %Ensures HW canot be allocated to fake lessons
    
    flag_hw = false(size(flag_avail));
    
    idx = mod(idx_less(flag_avail==0),6)==1;
    
    
    % The code thinks that when 2 lessons appear on consecutive days on P6
    % then P1 then these form a double a period.
    if any(idx)
        p6_p1 = strfind(mod(idx_less,6).',[0 1]) + 1;
        flag_avail(p6_p1) = true;
    end
    
    % Count the number of available lessons
    n_less = cast(sum(idx_less~=0),'uint8');
    n_avail = cast(sum(flag_avail),'uint8');
    
    % Mark subjects that don't have HW as complete
    if v_hw(ii)==0
        flag_done = true;
    else
        flag_done = false;
    end
    
    subjects.id{ii} = subs{ii};
    subjects.n_hw(ii) = v_hw(ii);
    subjects.n_avail(ii)= n_avail;
    subjects.n_less(ii) = n_less;
    subjects.flag_done(ii)= flag_done;
    subjects.idx_less{ii} = idx_less;
    subjects.flag_avail{ii} = flag_avail;
    subjects.flag_check{ii} = flag_avail;
    subjects.flag_hw{ii} = flag_hw;
end

end

