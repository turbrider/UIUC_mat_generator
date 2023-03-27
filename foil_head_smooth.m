function [nodes] = foil_head_smooth(n_s,nodes,p_n)
n_f = length(nodes);
n_f_half = round(n_f/2);
sec_sm = nodes(n_f_half-n_s:n_f_half+n_s,:);
%  plot(sec_sm(:,2),sec_sm(:,1));hold on;
p = polyfit(sec_sm(:,2),sec_sm(:,1),p_n);
sec_sm(:,2) = linspace(min(sec_sm(:,2)),max(sec_sm(:,2)),2*n_s+1);
sec_sm(:,1) = polyval(p,sec_sm(:,2));
nodes(n_f_half-n_s:n_f_half+n_s,:)=flip(sec_sm,1) ;
% plot(nodes(n_f_half-n_s:n_f_half+n_s,2),nodes(n_f_half-n_s:n_f_half+n_s,1));
nodes(:,1) = (nodes(:,1) - min(nodes(:,1)))/(max(nodes(:,1))-min(nodes(:,1)));
end