clear all; close all
addpath('lib')

name_year = 'Y8';
in_sheet  = '2017/8b.xls';
out_sheet = '2017/8b.xls';
hw_alloc_xls = '2017/hw_alloc.xls';
hw_alloc_range = 'A1:B11';

nf1 = '8N';
nf2 = '8P';
nf3 = '8R';
nf4 = '8T';

t_small = 30;
t_big = 90;

%% Create subjects structures
form_1 = make_subjects_struct(in_sheet,nf1,hw_alloc_xls,name_year,hw_alloc_range);
form_2 = make_subjects_struct(in_sheet,nf2,hw_alloc_xls,name_year,hw_alloc_range);
form_3 = make_subjects_struct(in_sheet,nf3,hw_alloc_xls,name_year,hw_alloc_range);
form_4 = make_subjects_struct(in_sheet,nf4,hw_alloc_xls,name_year,hw_alloc_range);

%% Run solver
soln_1 = find_many_sol(form_1.subjects,form_1.hw_vec,form_1.ii_vec,form_1.period_vec,form_1.ic,4e4,t_small);
soln_2 = find_many_sol(form_2.subjects,form_2.hw_vec,form_2.ii_vec,form_2.period_vec,form_2.ic,4e4,t_small);
soln_3 = find_many_sol(form_3.subjects,form_3.hw_vec,form_3.ii_vec,form_3.period_vec,form_3.ic,4e4,t_small);
soln_4 = find_many_sol(form_4.subjects,form_4.hw_vec,form_4.ii_vec,form_4.period_vec,form_4.ic,4e4,t_small);

%% Find MAT occurences
idx1 = find(strcmp(form_1.subjects.id,'MAT')==1);
idx2 = find(strcmp(form_2.subjects.id,'MAT')==1);
idx3 = find(strcmp(form_3.subjects.id,'MAT')==1);
idx4 = find(strcmp(form_4.subjects.id,'MAT')==1);

count_mat_1 = find_sub_occurr(soln_1,form_1,idx1)
count_mat_2 = find_sub_occurr(soln_2,form_2,idx2)
count_mat_3 = find_sub_occurr(soln_3,form_3,idx3)
count_mat_4 = find_sub_occurr(soln_4,form_4,idx4)

%% Find MFL1 occurences
idx1 = find(strcmp(form_1.subjects.id,'ML1')==1);
idx2 = find(strcmp(form_2.subjects.id,'ML1')==1);
idx3 = find(strcmp(form_3.subjects.id,'ML1')==1);
idx4 = find(strcmp(form_4.subjects.id,'ML1')==1);

count_mfl1_1 = find_sub_occurr(soln_1,form_1,idx1)
count_mfl1_2 = find_sub_occurr(soln_2,form_2,idx2)
count_mfl1_3 = find_sub_occurr(soln_3,form_3,idx3)
count_mfl1_4 = find_sub_occurr(soln_4,form_4,idx4)

%% Find MFL2 occurences
idx1 = find(strcmp(form_1.subjects.id,'ML2')==1);
idx2 = find(strcmp(form_2.subjects.id,'ML2')==1);
idx3 = find(strcmp(form_3.subjects.id,'ML2')==1);
idx4 = find(strcmp(form_4.subjects.id,'ML2')==1);

count_mfl2_1 = find_sub_occurr(soln_1,form_1,idx1)
count_mfl2_2 = find_sub_occurr(soln_2,form_2,idx2)
count_mfl2_3 = find_sub_occurr(soln_3,form_3,idx3)
count_mfl2_4 = find_sub_occurr(soln_4,form_4,idx4)

%% Choose constraints
n_mat = sum(form_1.hw_vec==find(strcmp(form_1.subjects.id,'MAT')==1));
force_mat = zeros(1,n_mat);
for ii=1:n_mat
    force_mat(ii) = input('Force a MAT hw to period: ');
end

n_ml1 = sum(form_1.hw_vec==find(strcmp(form_1.subjects.id,'ML1')==1));
force_ml1 = zeros(1,n_ml1);
for ii=1:n_ml1
    force_ml1(ii) = input('Force a MFL1 hw to period: ');
end

n_ml2 = sum(form_1.hw_vec==find(strcmp(form_1.subjects.id,'ML2')==1));
force_ml2 = zeros(1,n_ml2);
for ii=1:n_ml2
    force_ml2(ii) = input('Force a MFL2 hw to period: ');
end

%% Push constraints onto system
force_hw_vec = [force_mat force_ml1 force_ml2];

[form_1.subjects,form_1.period_vec ] = force_hw(form_1.subjects,form_1.period_vec,form_1.ic,force_hw_vec);
[form_2.subjects,form_2.period_vec ] = force_hw(form_2.subjects,form_2.period_vec,form_2.ic,force_hw_vec);
[form_3.subjects,form_3.period_vec ] = force_hw(form_3.subjects,form_3.period_vec,form_3.ic,force_hw_vec);
[form_4.subjects,form_4.period_vec ] = force_hw(form_4.subjects,form_4.period_vec,form_4.ic,force_hw_vec);

%% Run solver
soln_1 = find_many_sol(form_1.subjects,form_1.hw_vec,form_1.ii_vec,form_1.period_vec,form_1.ic,4e4,t_big);
soln_2 = find_many_sol(form_2.subjects,form_2.hw_vec,form_2.ii_vec,form_2.period_vec,form_2.ic,4e4,t_big);
soln_3 = find_many_sol(form_3.subjects,form_3.hw_vec,form_3.ii_vec,form_3.period_vec,form_3.ic,4e4,t_big);
soln_4 = find_many_sol(form_4.subjects,form_4.hw_vec,form_4.ii_vec,form_4.period_vec,form_4.ic,4e4,t_big);

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