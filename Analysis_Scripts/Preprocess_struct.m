filepath=uigetdir('','Select Input-folder');
list = rdir(sprintf('%s\\**\\*.mat',filepath))
        


stim_index = 1;
for i=1:numel(list)
    load(list{i})
    myfiles = who('-file',list{i});    
    mouse_name = extractBetween(list{i},'Erica\','\');   
    day = extractBetween(list{i},sprintf('%s\\',mouse_name{1}),'\');

    for stim = 1:numel(myfiles)
        stimulus = regexp(myfiles{stim},'[^_A-Z0-9].*', 'match' );
        data = evalin('base',myfiles{stim});
        start_sample = find(diff(data.(4)) < -2.9);
        if isempty(start_sample)
            % no VBA state change so continue looping
        else
            displacement = (data.(1)(start_sample:end)-1)*25;
            force = data.(2)(start_sample:end);
            pilot_struct(stim_index).Mouse = mouse_name;
            pilot_struct(stim_index).Day = day;
            pilot_struct(stim_index).Stimulus = stimulus;
            pilot_struct(stim_index).Displacement = displacement;
            pilot_struct(stim_index).Force = force;
            stim_index = stim_index + 1;
        end
    end
end

clearvars -except pilot_struct pilot_table
