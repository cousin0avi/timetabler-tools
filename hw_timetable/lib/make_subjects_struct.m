function [form_struct] = make_subjects_struct(in_sheet,name_form,hw_alloc_xls,name_year,hw_alloc_range  )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

%% Identify all subjects in timetable
[~,timetable] = xlsread(in_sheet,name_form,'A2:J7');
[~,~,hw_alloc] = xlsread(hw_alloc_xls,name_year,hw_alloc_range);

[hw_alloc(:,1),idx]=sort(hw_alloc(:,1));
hw_alloc(:,2) = hw_alloc(idx,2);

[subs,~,ic] = unique(timetable);

ic=cast(ic,'uint8');

n_sub = size(subs);
n_sub = cast(n_sub(1),'uint8');
ii_vec= 1:n_sub;

%% Construct subjects struct
subjects = make_subjects(ic,subs,hw_alloc);

%% Create vector that will keep track of available periods
period_vec = true([60,1]);
for ii=ii_vec
    if subjects.flag_done(ii)
        period_vec(subjects.idx_less{ii}(1:subjects.n_less(ii)))=false;
    elseif any(~subjects.flag_avail{ii})
        period_vec(subjects.idx_less{ii}(~subjects.flag_avail{ii}(1:subjects.n_less(ii))))=false;
    end
end
%% Add any a priori information here

%% Create vector which will randomise the subjects
temp = cell([n_sub 1]);
for ii=ii_vec
    temp{ii} = repmat(ii,[subjects.n_hw(ii) 1]);
end
hw_vec = vertcat(temp{:});

form_struct.name_form = name_form;
form_struct.timetable = timetable;
form_struct.subjects = subjects;
form_struct.hw_vec = hw_vec;
form_struct.ii_vec = ii_vec;
form_struct.period_vec = period_vec;
form_struct.ic = ic;

end

