function index = findFirstUnmarked(buffer_content)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Constants
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    UNMARKED = 0;
    
    index = -1;   
    for i = 1 : length(buffer_content)
        if buffer_content(i, 3) == UNMARKED
            index = i;
            break;
        end
    end
end