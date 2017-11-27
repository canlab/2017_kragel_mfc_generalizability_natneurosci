function imagenames = check_image_names_get_full_path(imagenames)

if ~iscell(imagenames), imagenames = cellstr(imagenames); end

for i = 1:length(imagenames)
    
    if exist(imagenames{i}, 'file')
        
        % do nothing. Sometimes which returns empty even though file
        % exists. Do not use which if returns empty. Otherwise, do.
        
        if ~isempty(which(imagenames{i}))
            imagenames{i} = which(imagenames{i});
        end
        
    else
        fprintf('CANNOT FIND %s \n', imagenames{i})
        error('Exiting.');
        
    end
    
    
end

end % function
