function printElementNamesSizesInLogsout(logs)    
    
    for i = 1:logs.numElements
    
        element = logs.getElement(i);
    
        fprintf('\n[%d] %s\n', i, element.Name);
    
        values = element.Values;
    
        if isstruct(values)
            disp(fieldnames(values));
        else
            fprintf('    Type: %s\n', class(values));
            fprintf('    Size: %s\n', mat2str(size(values)));
        end
    
    end
end