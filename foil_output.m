function [coor] = foil_output(weight,foil_up,foil_down)
global n_weight n_refine
dz_down = foil_down(end,2);
dz_up  = foil_up(end,2);

x_down = foil_down(:,1);
x_up = foil_up(:,1);
x_down = min(x_down):(max(x_down)-min(x_down))/n_refine:max(x_down);
x_up = min(x_up):(max(x_up)-min(x_up))/n_refine:max(x_up);
x_down = x_down';
x_up = x_up';
[coor] = CST_airfoil(x_down,x_up,weight(1:n_weight/2),weight(n_weight/2+1:end),dz_down,dz_up);  
end