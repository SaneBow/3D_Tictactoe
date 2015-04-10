function initGame(n)
    global GB PLAYER HISTORY;
    % HISTORY data structure:
    % data: history data.
    %       n^3 rows and 4 columns matrix. 
    %       4 columns are [x y z player]
    % top: point to top of history array
    % last: point to last history record
    HISTORY = struct('data',zeros(n*n*n,4),'top',0,'last',0);
    GB = createBoard(n);
    PLAYER = 1;
end