function make_parsed_formant_trials(perttrial_pre,perttrial_dur,fs,ystep,ntrials,formant_in,formant_out,...
                           parse_fig_pos, formant_pert)
                           
nframeswin  = round(perttrial_dur*fs/ystep);
nframes_pre = round(perttrial_pre*fs/ystep);
iframe4pert = nframes_pre + 1;
iframe_low = iframe4pert - nframes_pre;
iframe_hi  = iframe_low + nframeswin - 1;
parsed_frame_taxis = (0:(nframeswin-1))*ystep/fs - perttrial_pre;
colors = {'m','c','r','g','b','k'};
ncolors = length(colors);
i_onsets = cell(ntrials,1);
i_offsets = cell(ntrials,1);
trial_pert_types = zeros(ntrials,1);
good_trials = ones(ntrials,1);
parsed_formant_in = zeros(ntrials,nframeswin);

for itr = 1:ntrials
  i_onoffsets = find(diff(formant_pert(itr,:)))+1;
  n_onoffsets = length(i_onoffsets);
  if ~n_onoffsets
      good_trials(itr) = 0;
      i_onsets{itr}  = -1; % i.e., not a valid array index
      i_offsets{itr} = -1; % i.e., not a valid array index
  else
      if rem(n_onoffsets,2)
          good_trials(itr) = 0;
       end
      if n_onoffsets > 2, error('not currently setup to handle multiple perts per trial'); end
      n_onsets = n_onoffsets/2;
      i_onsets{itr}  = i_onoffsets(1:2:(n_onoffsets-1));
      i_offsets{itr} = i_onoffsets(2:2:(n_onoffsets));
  end
end
for itr = 1:ntrials
  if good_trials(itr)
      trial_pert_types(itr) = formant_pert(itr,round((i_onsets{itr} + i_offsets{itr})/2));
      end
end
for itr = 1:ntrials
  if good_trials(itr)
       adj_formant_temp = adj2onset(formant_in(itr,:), iframe4pert,i_onsets{itr});
    parsed_formant_in(itr,:)  = adj_formant_temp(iframe_low:iframe_hi);
  end
end
ibaselims = dsearchn(parsed_frame_taxis',[-0.5, -0.25]');
inoiselims = dsearchn(parsed_frame_taxis',[0.15, 1.18]');
hf = figure;
set(hf,'Position',parse_fig_pos);
while 1
  clf
  hax1 = subplot(211)
  hax2 = subplot(212)
  for itr = 1:ntrials
    if good_trials(itr)
      color_idx = rem(itr,ncolors); if ~color_idx, color_idx = ncolors; end
      axes(hax1);
      hpl = plot(parsed_frame_taxis,parsed_formant_out(itr,:),colors{color_idx}); set(hpl,'Tag','formant_out'); set(hpl,'Userdata',itr);
      hold on
      axis([parsed_frame_taxis(1) parsed_frame_taxis(end) ]);
      axes(hax2);
      hpl = plot(parsed_frame_taxis,parsed_formant_in(itr,:),colors{color_idx}); set(hpl,'Tag','formant_in'); set(hpl,'Userdata',itr);
      hold on
      axis([parsed_frame_taxis(1) parsed_frame_taxis(end) ]);
    end
  end
  reply = input('delete any trials? [y]/n: ','s'); %change default to yes
  if strcmp(reply,'n'), break; end
  fprintf('pick trial to delete\n');
  
  [xx,yy] = ginput(1);
  cur_obj = get(hf,'CurrentObject');
  itrial2del = get(cur_obj,'Userdata')
  switch(get(cur_obj,'Tag'))
    case 'formant_out'
      axes(hax1);
      hpl = plot(parsed_frame_taxis,parsed_formant_out(itrial2del,:),'r'); set(hpl,'LineWidth',3);
    case 'formant_in'
      axes(hax2);
      hpl = plot(parsed_frame_taxis,parsed_formant_in(itrial2del,:),'r'); set(hpl,'LineWidth',3);
  end
  while 1
    reply = input('delete this trial? [y]/n/p: ','s');
    if isempty(reply), reply = 'y'; end
    switch reply
      case 'y', good_trials(itrial2del) = 0; break;
      case 'n', good_trials(itrial2del) = 1; delete(hpl); break;
      case 'p', soundsc(wave_out(itrial2del,:),fs); soundsc(wave_in(itrial2del,:),fs);
    end
  end
end
close(hf);
save('parsed_formant_trials_test','nframeswin','nframes_pre','iframe4pert','iframe_low','iframe_hi', ...
     'parsed_frame_taxis','colors','ncolors','i_onsets','i_offsets','trial_pert_types','good_trials','parsed_formant_out','parsed_formant_in');


          