function pert_resp = get_formant_pert_response(trial_pert_types,parsed_formant_in,parsed_formant_out,good_trials,parsed_frame_taxis,pert_types)

if nargin < 6 pert_types = []; end

pert_type_list = unique(trial_pert_types(logical(good_trials)));
if isempty(pert_types)
  pert_resp.pert_types = pert_type_list';
else
  len_pert_type_list = length(pert_type_list);
  len_pert_types = length(pert_types);
  error_if_unequal(len_pert_types,len_pert_type_list,'%d');
  if any(abs(pert_type_list' - sort(pert_types)) ~= 0)
    error('pert_types mismatch');
  end
  pert_resp.pert_types = pert_types;
end
pert_resp.npert_types = length(pert_resp.pert_types);

for ipert_type = 1:(pert_resp.npert_types + 1) % last "pert_type" is resp to all perts, regardless of type
  if ipert_type > pert_resp.npert_types
    pert_resp.good_trials{ipert_type} = sort([pert_resp.good_trials{1:(ipert_type-1)}]);
  else
    pert_resp.good_trials{ipert_type} = find((trial_pert_types == pert_resp.pert_types(ipert_type)) & good_trials)';
  end
   pert_resp.n_good_trials(ipert_type) = length(pert_resp.good_trials{ipert_type});
  pert_resp.formant_in.dat{ipert_type} = parsed_formant_in(pert_resp.good_trials{ipert_type},:);
  pert_resp.formant_in.mean(ipert_type,:) = mean(pert_resp.formant_in.dat{ipert_type},1);
  pert_resp.formant_in.stde(ipert_type,:) = std(pert_resp.formant_in.dat{ipert_type},0,1)/sqrt(pert_resp.n_good_trials(ipert_type));
  pert_resp.formant_out.dat{ipert_type} = parsed_formant_out(pert_resp.good_trials{ipert_type},:);
  pert_resp.formant_out.mean(ipert_type,:) = mean(pert_resp.formant_out.dat{ipert_type},1);
  pert_resp.formant_out.stde(ipert_type,:) = std(pert_resp.formant_out.dat{ipert_type},0,1)/sqrt(pert_resp.n_good_trials(ipert_type));
end

pert_resp.frame_taxis = parsed_frame_taxis;
nframeswin = length(parsed_frame_taxis);
pert_resp.nframeswin = nframeswin;

npert_types = pert_resp.npert_types;


