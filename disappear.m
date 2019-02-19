function names=disappear(names,vis)
names=findobj('DisplayName',names)
    for i=1:size(names,1)
        if vis==1
            names(i).Visible='on';
        else
            names(i).Visible='off';
    end
    end
end