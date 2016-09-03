clear all; close all
addpath('lib')

name_year = 'Y11';
in_sheet  = '2017/11b.xls';
out_sheet = '2017/11b.xls';
hw_alloc_xls = '2017/hw_alloc.xls';
hw_alloc_range = 'A1:B11';

nf1 = '2ac';
nf2 = '2bb';
nf3 = '5aa';
nf4 = '5bb';
nf5 = '0ac';
nf6 = '0ba';

t_small = 2;
t_big = 90;

%% Create subjects structures
warning('off','TTT:HW_ALLOC')
form_1 = make_subjects_struct(in_sheet,nf1,hw_alloc_xls,name_year,hw_alloc_range);
form_2 = make_subjects_struct(in_sheet,nf2,hw_alloc_xls,name_year,hw_alloc_range);
form_3 = make_subjects_struct(in_sheet,nf3,hw_alloc_xls,name_year,hw_alloc_range);
form_4 = make_subjects_struct(in_sheet,nf4,hw_alloc_xls,name_year,hw_alloc_range);
form_5 = make_subjects_struct(in_sheet,nf5,hw_alloc_xls,name_year,hw_alloc_range);
form_6 = make_subjects_struct(in_sheet,nf6,hw_alloc_xls,name_year,hw_alloc_range);
%% Add a priori infomoration
force_hw_vec_1 = [ [6 26 44] [13 14 43 60] [19 59] [12 27 41] [16 23 32 49] [ 2 31 51] [9 39 53] ];
force_hw_vec_2 = [ [6 26 44] [13 14 43 60] [19 59] [12 27 41] [16 24 32 49] [ 2 31 51] [9 39 53] ];
force_hw_vec_3 = [ [6 26 44] [13 14 43 54] [19 25 59] [12 27 41] [16 23 32 49] [21 31] [9 39 53] ]; 
force_hw_vec_4 = [ [6 26 44] [13 14 43 54] [19 25 59] [12 27 41] [16 24 32 49] [21 31] [9 39 53] ];
force_hw_vec_5 = [ [6 26 44] [13 43 60] [19 25 59] [12 27 41] [16 23 32 49] [ 2 31 51] [9 39 53] ];
force_hw_vec_6 = [ [6 26 44] [13 43 60] [19 25 59] [12 27 41] [16 24 32 49] [ 2 31 51] [9 39 53] ];

[form_1.subjects,form_1.period_vec ] = force_hw(form_1.subjects,form_1.period_vec,form_1.ic,force_hw_vec_1);
[form_2.subjects,form_2.period_vec ] = force_hw(form_2.subjects,form_2.period_vec,form_2.ic,force_hw_vec_2);
[form_3.subjects,form_3.period_vec ] = force_hw(form_3.subjects,form_3.period_vec,form_3.ic,force_hw_vec_3);
[form_4.subjects,form_4.period_vec ] = force_hw(form_4.subjects,form_4.period_vec,form_4.ic,force_hw_vec_4);
[form_5.subjects,form_5.period_vec ] = force_hw(form_5.subjects,form_5.period_vec,form_5.ic,force_hw_vec_5);
[form_6.subjects,form_6.period_vec ] = force_hw(form_6.subjects,form_6.period_vec,form_6.ic,force_hw_vec_6);
%% Run solver
soln_1 = find_many_sol(form_1.subjects,form_1.hw_vec,form_1.ii_vec,form_1.period_vec,form_1.ic,4e4,t_small);
soln_2 = find_many_sol(form_2.subjects,form_2.hw_vec,form_2.ii_vec,form_2.period_vec,form_2.ic,4e4,t_small);
soln_3 = find_many_sol(form_3.subjects,form_3.hw_vec,form_3.ii_vec,form_3.period_vec,form_3.ic,4e4,t_small);
soln_4 = find_many_sol(form_4.subjects,form_4.hw_vec,form_4.ii_vec,form_4.period_vec,form_4.ic,4e4,t_small);
soln_5 = find_many_sol(form_5.subjects,form_5.hw_vec,form_5.ii_vec,form_5.period_vec,form_5.ic,4e4,t_small);
soln_6 = find_many_sol(form_6.subjects,form_6.hw_vec,form_6.ii_vec,form_6.period_vec,form_6.ic,4e4,t_small);

%% Remove solutions that have poor metrics
if false
    if numel(soln_1.id)>1e3
        idx_bad = identify_worest(soln_1);
        soln_1 = remove_soln(soln_1,idx_bad);
    end
    if numel(soln_2.id)>1e3
        idx_bad = identify_worest(soln_2);
        soln_2 = remove_soln(soln_2,idx_bad);
    end
    if numel(soln_3.id)>1e3
        idx_bad = identify_worest(soln_3);
        soln_3 = remove_soln(soln_3,idx_bad);
    end
    if numel(soln_4.id)>1e3
        idx_bad = identify_worest(soln_4);
        soln_4 = remove_soln(soln_4,idx_bad);
    end
    if numel(soln_5.id)>1e3
        idx_bad = identify_worest(soln_5);
        soln_5 = remove_soln(soln_5,idx_bad);
    end
    if numel(soln_6.id)>1e3
        idx_bad = identify_worest(soln_6);
        soln_6 = remove_soln(soln_6,idx_bad);
    end
end

%% Find occurences -1
tag1 = 'OP2'
idx1 = find(strcmp(form_1.subjects.id,tag1)==1);
idx2 = find(strcmp(form_2.subjects.id,tag1)==1);
idx3 = find(strcmp(form_3.subjects.id,tag1)==1);
idx4 = find(strcmp(form_4.subjects.id,tag1)==1);
idx5 = find(strcmp(form_5.subjects.id,tag1)==1);
idx6 = find(strcmp(form_6.subjects.id,tag1)==1);

count_1_1 = find_sub_occurr(soln_1,form_1,idx1)
count_1_2 = find_sub_occurr(soln_2,form_2,idx2)
count_1_3 = find_sub_occurr(soln_3,form_3,idx3)
count_1_4 = find_sub_occurr(soln_4,form_4,idx4)
count_1_5 = find_sub_occurr(soln_5,form_5,idx5)
count_1_6 = find_sub_occurr(soln_6,form_6,idx6)

%% Find occurences -2
tag2 = 'ELG'
idx1 = find(strcmp(form_1.subjects.id,tag2)==1);
idx2 = find(strcmp(form_2.subjects.id,tag2)==1);
idx3 = find(strcmp(form_3.subjects.id,tag2)==1);
idx4 = find(strcmp(form_4.subjects.id,tag2)==1);
idx5 = find(strcmp(form_5.subjects.id,tag2)==1);
idx6 = find(strcmp(form_6.subjects.id,tag2)==1);

count_2_1 = find_sub_occurr(soln_1,form_1,idx1)
count_2_2 = find_sub_occurr(soln_2,form_2,idx2)
count_2_3 = find_sub_occurr(soln_3,form_3,idx3)
count_2_4 = find_sub_occurr(soln_4,form_4,idx4)
count_2_5 = find_sub_occurr(soln_5,form_5,idx5)
count_2_6 = find_sub_occurr(soln_6,form_6,idx6)

%% Find MFL2 occurences
tag3 = 'OP6'
idx1 = find(strcmp(form_1.subjects.id,tag3)==1);
idx2 = find(strcmp(form_2.subjects.id,tag3)==1);
idx3 = find(strcmp(form_3.subjects.id,tag3)==1);
idx4 = find(strcmp(form_4.subjects.id,tag3)==1);
idx5 = find(strcmp(form_5.subjects.id,tag3)==1);
idx6 = find(strcmp(form_6.subjects.id,tag3)==1);

count_3_1 = find_sub_occurr(soln_1,form_1,idx1)
count_3_2 = find_sub_occurr(soln_2,form_2,idx2)
count_3_3 = find_sub_occurr(soln_3,form_3,idx3)
count_3_4 = find_sub_occurr(soln_4,form_4,idx4)
count_3_5 = find_sub_occurr(soln_5,form_5,idx5)
count_3_6 = find_sub_occurr(soln_6,form_6,idx6)

%% Choose constraints
% n_mat = sum(form_1.hw_vec==find(strcmp(form_1.subjects.id,tag1)==1));
% force_mat = zeros(1,n_mat);
% for ii=1:n_mat
%     force_mat(ii) = input(['Force a ', tag1, ' hw to period: ']);
% end
% 
% n_ml1 = sum(form_1.hw_vec==find(strcmp(form_1.subjects.id,tag2)==1));
% force_ml1 = zeros(1,n_ml1);
% for ii=1:n_ml1
%     force_ml1(ii) = input(['Force a ', tag2, ' hw to period: ']);
% end
% 
% % n_ml2 = sum(form_1.hw_vec==find(strcmp(form_1.subjects.id,'ML2')==1));
% % force_ml2 = zeros(1,n_ml2);
% % for ii=1:n_ml2
% %     force_ml2(ii) = input('Force a MFL2 hw to period: ');
% % end
% 
% %% Push constraints onto system
% force_hw_vec = [force_mat];
% 
% [form_1.subjects,form_1.period_vec ] = force_hw(form_1.subjects,form_1.period_vec,form_1.ic,force_hw_vec);
% [form_2.subjects,form_2.period_vec ] = force_hw(form_2.subjects,form_2.period_vec,form_2.ic,force_hw_vec);
% [form_3.subjects,form_3.period_vec ] = force_hw(form_3.subjects,form_3.period_vec,form_3.ic,force_hw_vec);
% [form_4.subjects,form_4.period_vec ] = force_hw(form_4.subjects,form_4.period_vec,form_4.ic,force_hw_vec);
% 
% %% Run solver
% soln_1 = find_many_sol(form_1.subjects,form_1.hw_vec,form_1.ii_vec,form_1.period_vec,form_1.ic,4e4,t_big);
% soln_2 = find_many_sol(form_2.subjects,form_2.hw_vec,form_2.ii_vec,form_2.period_vec,form_2.ic,4e4,t_big);
% soln_3 = find_many_sol(form_3.subjects,form_3.hw_vec,form_3.ii_vec,form_3.period_vec,form_3.ic,4e4,t_big);
% soln_4 = find_many_sol(form_4.subjects,form_4.hw_vec,form_4.ii_vec,form_4.period_vec,form_4.ic,4e4,t_big);

%% Find the best and write solution
soln = soln_1;
ii_vec = form_1.ii_vec;
name_form = nf1;
write_best

soln = soln_2;
ii_vec = form_2.ii_vec;
name_form = nf2;
write_best

soln = soln_3;
ii_vec = form_3.ii_vec;
name_form = nf3;
write_best

soln = soln_4;
ii_vec = form_4.ii_vec;
name_form = nf4;
write_best

soln = soln_5;
ii_vec = form_5.ii_vec;
name_form = nf5;
write_best

soln = soln_6;
ii_vec = form_6.ii_vec;
name_form = nf6;
write_best