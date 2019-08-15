index = 1;
index_full = 1;
index_removed = [];
d = [];


while index +91 < length(tmp(:, 1))
t_full = tmp(index : index + 90,1);
if(t_full(end) == 180)
    d(end+1, :) = tmp(index : index + 90,2);
    index = index + 91;
else
    index= index + find(t_full == 180);
    index_removed = [index_removed, index_full]
    
end
        index_full = index_full +1;

end


