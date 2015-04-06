function winner = isWin()
global GB;
dim = size(GB,1);

%% lines on each surface
for i = 1:dim
    % slides by pages
    plane = GB(:,:,i);
    winner = checkLine(plane,dim);
    if winner > 0
        return;
    end
    % slides by rows
    plane = squeeze(GB(i,:,:));
    winner = checkLine(plane,dim);
    if winner > 0
        return;
    end
    % slides by columns
    plane = squeeze(GB(:,i,:));
    winner = checkLine(plane,dim);
    if winner > 0
        return;
    end
    
end


%% body diagonals (4 line)
%line 1
flag = GB(1,1,1);
for t = 0:dim-1
    if flag ~= GB(1+t,1+t,1+t)
        flag = 0;
        break;
    end
end
if flag > 0
    winner = GB(1,1,1);
    return;
end

%line 2
flag = GB(1,dim,1);
for t = 0:dim-1
    if flag ~= GB(1+t,dim-t,1+t)
        flag = 0;
        break;
    end
end
if flag > 0
    winner = GB(1,dim,1);
    return;
end

%line3
flag = GB(dim,1,1);
for t = 0:dim-1
    if flag ~= GB(dim-t,1+t,1+t)
        flag = 0;
        break;
    end
end
if flag > 0
    winner = GB(dim,1,1);
    return;
end

%line4
flag = GB(dim,dim,1);
for t = 0:dim-1
    if flag ~= GB(dim-t,dim-t,1+t)
        flag = 0;
        break;
    end
end
if flag > 0
    winner = GB(dim,dim,1);
    return;
end

end

%% check lines in given plane
% return 0 if no winner
% return 1 or 2 if line formed
function result = checkLine(P,dim)
    result = 0;
    %rows
    for row = 1:dim
        if P(row,:) == ones(1,dim)
            result = 1;
            return;
        elseif P(row,:) == 2*ones(1,dim)
            result = 2;
            return;
        end
    end
    %columns
    for col = 1:dim
        if P(:,col) == ones(dim,1)
            result = 1;
            return;
        elseif P(:,col) == 2*ones(dim,1)
            result = 2;
            return;
        end
    end
    %diagonals
    for k = 0:1
        diagline = diag(rot90(P,k));
        if diagline == ones(dim,1)
            result = 1;
            return;
        elseif diagline == 2*ones(dim,1)
            result = 2;
            return;
        end
    end
    
end