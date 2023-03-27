function fval = fitnessfun1(weight)
%fmincon 计算最小值不能有惩罚函数，否则极易造成不可导而产生刚性
global n_weight n_refine
global foil_up foil_down 

dz_down = foil_down(end,2);
dz_up  = foil_up(end,2);

x_down = foil_down(:,1);
x_up = foil_up(:,1);
x_down = min(x_down):(max(x_down)-min(x_down))/n_refine:max(x_down);
x_up = min(x_up):(max(x_up)-min(x_up))/n_refine:max(x_up);
x_down = x_down';
x_up = x_up';
[foil_co] = CST_airfoil(x_down,x_up,weight(1:n_weight/2),weight(n_weight/2+1:end),dz_down,dz_up);
% foil_co= foil_head_smooth(20,foil_co,5);
split_x = find(foil_co(:,1)==min(foil_co(:,1)));
if(length(split_x)> 1)
foil_p1 = foil_co(split_x:-1:1,:);
foil_p2 = foil_co(split_x+1:end,:);
else
foil_p1 = foil_co(split_x:-1:1,:);
foil_p2 = foil_co(split_x:end,:);
end


if(mean(foil_p1(:,2)) > mean(foil_p2(:,2)))
    foil_up_cst = foil_p1;
    foil_down_cst = foil_p2;
else
    foil_up_cst = foil_p2;
    foil_down_cst = foil_p1;
end


  xl = foil_down_cst(:,1);
  xu = foil_up_cst(:,1);
%   up_cst = foil_up_cst(:,2);
%   down_cst = foil_down_cst(:,2);
%   
%   up_geo = foil_up(:,2);
%   down_geo = foil_down(:,2);
  if(length(xl) > length(xu))
      x_int = xl;
  else
      x_int = xu;
  end
  
  up_cst = interp1(foil_up_cst(:,1),foil_up_cst(:,2),x_int,'spline');
  down_cst = interp1(foil_down_cst(:,1),foil_down_cst(:,2),x_int,'spline');
  
  up_geo = interp1(foil_up(:,1),foil_up(:,2),x_int,'spline');
  down_geo = interp1(foil_down(:,1),foil_down(:,2),x_int,'spline');  
  
 a1 = 1.0;
 a2 = 1.0;


fval_up = a1.*(up_cst - up_geo);
fval_down = a2.*(down_cst - down_geo);

% fval = mean(abs(fval_up))+ mean(abs(fval_down));
% fval = max(fval, max(std(fval_up),std(fval_down)));
fval = norm(fval_up)+ norm(fval_down);
% fval = max(fval, max(std(fval_up),std(fval_down)));



% fval = fval*1.e10;
% fval = fval + abs(mean(fval_up)) + abs(mean(fval_down));
% disp(['Up_mean:' num2str(mean(fval_up))]);
% disp(['Down_mean:' num2str(mean(fval_down))]);
% disp(['Up_var:' num2str(std(fval_up))]);
% disp(['Down_var:' num2str(std(fval_down))]);
% disp(['Weight:' num2str(weight)]);
fig = figure(2);
clf(fig);
plot(x_int,up_geo,'-r');hold on;
plot(x_int,down_geo,'-r');hold on;
plot(x_int,up_cst,'-k');hold on;
plot(x_int,down_cst,'-k');hold on;
axis([0 1  1.2*min(down_geo) 1.2*max(up_geo)]);


end