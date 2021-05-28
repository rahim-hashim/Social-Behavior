filepath=uigetdir('','Select Input-folder');
list = rdir(sprintf('%s\\**\\*.mat',filepath))

pilot_table = table([],[],[],[],[],...
            'VariableNames',{'Mouse','Day','Stimulus','Displacement', 'Force'})
        
for i=1:numel(list)
    load(list{i})
    myfiles = who('-file',list{i});    
    mouse_name = extractBetween(list{i},'Erica\','\');   
    day = extractBetween(list{i},sprintf('%s\\',mouse_name{1}),'\');

    for stim = 1:numel(myfiles)
        stimulus = regexp(myfiles{stim},'[^_A-Z0-9].*', 'match' );
        data = evalin('base',myfiles{stim});
        start_sample = find(diff(data.(4)) < -2.9);
        displacement = (data.(1)(start_sample:end)-1)*25;
        force = data.(2)(start_sample:end);
        results=table(categorical(mouse_name),categorical(day),categorical(stimulus),{displacement'},{force'},...
            'VariableNames',{'Mouse','Day','Stimulus','Displacement', 'Force'});
        pilot_table = [pilot_table;results];
    end
     
end

clearvars -except pilot_table
