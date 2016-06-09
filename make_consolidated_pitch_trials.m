function make_consolidated_formant_trials(consolidate_audiodir,speak_audiodirs)
curdir_subj = cd;
nblocks = length(speak_audiodirs);
for iblock = 1:nblocks
  expr_audiodir = speak_audiodirs{iblock};
  cd(expr_audiodir); fprintf('cd expr_audiodir(%s)\n',expr_audiodir);
    if ~exist('formant_trials.mat','file'), error('formant_trials.mat not found'); end
    formant_trials4block = load('formant_trials');
if iblock == 1
    consld_formant_trials = formant_trials4block;
    consld_formant_trials.iblock = iblock*ones(formant_trials4block.ntrials,1);
    consld_formant_trials.itrial_in_block = (1:(formant_trials4block.ntrials))';
    fldname = fieldnames(formant_trials4block);
    nfldnames = length(fldname);
else
  for ifldname = 1:nfldnames
      the_fldname = fldname{ifldname};
      switch the_fldname
        case 'ntrials'
          consld_formant_trials.ntrials = consld_formant_trials.ntrials + formant_trials4block.ntrials;
          consld_formant_trials.iblock = [consld_formant_trials.iblock; iblock*ones(formant_trials4block.ntrials,1)];
          consld_formant_trials.itrial_in_block = [consld_formant_trials.itrial_in_block; (1:(formant_trials4block.ntrials))'];
        otherwise
          if size(formant_trials4block.(the_fldname),1) > 1
            consld_formant_trials.(the_fldname) = [consld_formant_trials.(the_fldname); pitch_trials4block.(the_fldname)];
          else
            if any(consld_formant_trials.(the_fldname) ~= formant_trials4block.(the_fldname))
              error('mismatch in (%s) at block(%d)',the_fldname,iblock);
            end
          end
      end
    end
  end
  cd(curdir_subj);
end
cd(consolidate_audiodir)
save('formant_trials','-struct','consld_formant_trials');
cd(curdir_subj)      