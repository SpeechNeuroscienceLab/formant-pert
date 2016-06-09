function make_formant_trials(vods,yes_plot_trials)

if nargin < 2 || isempty(yes_plot_trials), yes_plot_trials = 1; end

fs = 11025;
nsamps_frame = 32;
ffr = fs/nsamps_frame;
[B,A] = butter(5,(20/(ffr/2)));

clear vec_hist
vec_hist(1) = get_vec_hist6('inbuffer',3);
vec_hist(2) = get_vec_hist6('outbuffer',3);
vec_hist(3) = get_vec_hist6('blockalt',3);
voice_onset=strcmpi(vods,'y');
if voice_onset==1
    vec_hist(4) = get_vec_hist6('voice_onset_detect',2);
    vec_hist(5) = get_vec_hist6('blockalt',3);
    voice_onset_detect_sig = vec_hist(4).data;
    pert_alt_sig = squeeze(vec_hist(5).data(:,:,1));
    vec_hist(6) = get_vec_hist6('lpc_inbuf_formants_freq',3);
    vec_hist(7) = get_vec_hist6('lpc_outbuf_formants_freq',3);
end

ntrials = find_ntrials_in_vechist(vec_hist(1));
nframes = vec_hist(1).nvecs;
ystep = vec_hist(1).vec_size;
taxis_frame = (0:(nframes-1))*ystep/fs;
taxis = (0:((nframes*ystep)-1))/fs;

for itr = 1:ntrials
    formant_in(itr,:) = plot_vec_hist6(vec_hist(6),itr);
    formant_out(itr,:) = plot_vec_hist6(vec_hist(7),itr);
    if voice_onset ==1
        thistrialaltsigs = pert_alt_sig(:,2)';
  frame_onset_pert = find(voice_onset_detect_sig(itr,:),1) + find(pert_alt_sig(itr,:),1);
    frame_offset_pert = find(voice_onset_detect_sig(itr,:),1,'last') + find(pert_alt_sig(itr,:),1,'last');
     subframelength = frame_offset_pert - frame_onset_pert;
    
    onsetblockpert = find(diff(thistrialaltsigs),1) + 1;
    offsetblockpert = find(diff(thistrialaltsigs),1,'last');
    subblockpert = offsetblockpert - onsetblockpert;
    
    absaltsigsthistrial = abs(thistrialaltsigs);
    [maxabsaltsigs, maxabsaltsigsindex]  = max(absaltsigsthistrial);
    pertdirectionval = thistrialaltsigs(1, maxabsaltsigsindex);
    
    vodaltsigs = zeros(1,length(thistrialaltsigs));
    if subframelength ~= subblockpert
        difflengths2 = subblockpert - subframelength;
        check_frame_offset_pert = frame_offset_pert + difflengths2;
        
        if check_frame_offset_pert > length(thistrialaltsigs)
            frame_offset_pert = length(thistrialaltsigs);
            %warning('Perturbation for this trial extends beyond the end of the trial. Subject most likely spoke too late.');
            thisblockbadtrials(1,itr) = 1;
        else
            frame_offset_pert = frame_offset_pert + difflengths2;
        end
    end
    
    vodaltsigs(1,frame_onset_pert:frame_offset_pert) = pertdirectionval;
    vodaltsigs = vodaltsigs';
        
    end
if voice_onset==0
 pitch_pert(itr,:) = altsigs(:,2);
end
if voice_onset==1
    pitch_pert(itr,:) = vodaltsigs;
end
if yes_plot_trials
        clf
        plot(taxis_frame, formant_in(itr,:),'b');
        plot(taxis_frame, formant_out(itr,:),'k');
        pause
end
fprintf('.');
end
fprintf('\n');

save('formant_trials','fs','ntrials','nframes','ystep','taxis','taxis_frame', ...
    'formant_in','formant_out','formant_pert');
