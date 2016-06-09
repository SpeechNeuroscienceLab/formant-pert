function [vods,perttrial_pre, perttrial_dur,  pert_type, yes_overwrite] = get_formant_init_info(subj_info)
init_info_file = './formant_analysis_init_info.mat';
curdir = cd;

if ~exist(init_info_file,'file')
    yes_overwrite = 0;
else
    load(init_info_file);
end
vods=input(sprintf('Was formant perturbation triggered relative to voice onset? [Y]/N : '),'s');
if isempty(vods) 
    vods = 'Y';
end
prompt={'Pre-perturbation time: ', 'Duration of trial: ','Formant pert values: '};
title='Formant Perturbation Parameters ';
num_lines=1;
if ~exist(init_info_file,'file')
  def={'0.2','1.2',['100' '0']};  
 else
def ={num2str(perttrial_pre),num2str(perttrial_dur),num2str(pert_type)};
end 
reply=inputdlg(prompt,title,num_lines,def,'on');
perttrial_pre = str2num(reply{1}); 
  perttrial_dur = str2num(reply{2});
  pert_type = str2num(reply{3});
  fprintf('set overwrite level to 6 for complete reprocessing, or 1 for final step (xcspec) reprocessing, or 0 to just reprint response plots\n');
reply = input(sprintf('use overwrite level(%d)? [y]/n: ',yes_overwrite),'s');
if ~isempty(reply) && ~strcmp(reply,'y')
  yes_overwrite = input('overwrite level: ');
end
save(init_info_file,'perttrial_pre','perttrial_dur','pert_type','yes_overwrite');

cd(curdir);