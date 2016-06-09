speak_consolidate_audiodir = 'speak_consolidate_audiodir';
isubj = 1;
subj_info(isubj) = get_subj_info_dirs(speak_consolidate_audiodir);
[vods,perttrial_pre, perttrial_dur, pert_type, yes_overwrite] = get_formant_init_info(subj_info);
runformantpertanalysis_core
