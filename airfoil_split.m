function [foil_up,foil_down] = airfoil_split(raw_data)
% airfoil_raw = cell2mat(raw_data);
airfoil_raw = raw_data;
adj_coor = diff(airfoil_raw,1);
n_adj = length(adj_coor);
if(find(adj_coor(:,2)==0 & adj_coor(:,1)==0))
    n = find(adj_coor(:,2)==0);
    nn = length(n);
    for i = 1:nn
    airfoil_raw(n(i),:)=[];
    end
end
j = 1;
for i = 1:n_adj-1
    temp = adj_coor(i,1)*adj_coor(i+1,1);
    if(temp <= 0)
        split_index(j) = i+1;
        j = j + 1;
    end

end
if(length(split_index) > 1 && (max(split_index)-min(split_index)) == 1)
foil_p1 = airfoil_raw(1:split_index(1),:);
foil_p2 = airfoil_raw(split_index(2):end,:);
else
foil_p1 = airfoil_raw(1:split_index,:);
foil_p2 = airfoil_raw(split_index+1:end,:);
end
foil_p1 = sortrows(foil_p1,1);
foil_p2 = sortrows(foil_p2,1);
if(mean(foil_p1(:,2)) > mean(foil_p2(:,2)))
    foil_up = foil_p1;
    foil_down = foil_p2;
else
    foil_up = foil_p2;
    foil_down = foil_p1;
end
end