subjdir = subj_info(isubj).subjdir;
consolidate_audiodir = subj_info(isubj).speak_consolidate_audiodir;
speak_audiodirs = subj_info(isubj).speak_audiodirs;
  
nblocks = length(speak_audiodirs);
curdir = cd;
curdir_subj = cd;
parse_fig_pos = [1000  371  991 1127];

yes_add_ampl_info = 0;
tic
parfor iblock = 1:nblocks
  expr_audiodir = speak_audiodirs{iblock};
  cd(expr_audiodir); fprintf('cd expr_audiodir(%s)\n',expr_audiodir);
  if yes_add_ampl_info || (yes_overwrite >= 6) || ~exist('formant_trials.mat','file'), make_formant_trials(vods,0); end
  cd(curdir_subj);
end
toc
cd(consolidate_audiodir); fprintf('cd consolidate_audiodir(%s)\n',consolidate_audiodir);
if yes_add_ampl_info || (yes_overwrite >= 5) || ~exist('formant_trials.mat','file')
cd(curdir_subj)
  make_consolidated_formant_trials(consolidate_audiodir,speak_audiodirs);
 cd(consolidate_audiodir); fprintf('cd consolidate_audiodir(%s)\n',consolidate_audiodir);
end
load('formant_trials');
if (yes_overwrite >= 4) || ~exist('parsed_formant_trials_test.mat','file')
    make_parsed_formant_trials(perttrial_pre,perttrial_dur,fs,ystep,ntrials,formant_in,formant_out,...
                           parse_fig_pos);
end