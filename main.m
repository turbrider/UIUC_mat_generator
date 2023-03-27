clear;clc;
global n_weight n_refine
%-----------------Section 1------------------------
% The code will process all UIUC airfoil data to a MAT file with same
% discrete points.
% Code by Yang Zhang from XJTU China
% Email: youngz@xjtu.edu.cn
%--------------------------------------------------------
data_folder = '.\data';
%--------------------------------------------------------------
n_weight = 18; % Num of design variables
n_refine = 401; % Num of airfoil points/ half surface
method = 'CST';
%----------------------------------------------------------------
UIUC_names = dir([data_folder '\UIUC_database\*.dat']);
airfoil_raw = struct2table(UIUC_names);
foil_names = airfoil_raw{:,1};
if(fix_foil ~=1)

nfoil = length(foil_names);
UIUC_shapes = [];    
    for i = 1:nfoil
        foil_path = [data_folder '\UIUC_database\' foil_names{i}];
        C = importdata(foil_path,' ',1);
        temp = C.data;
        
        coor_num = length(temp);
        coor_temp = temp;
        UIUC_shape.name{i} = foil_names{i};
        UIUC_shape.coord{i} = coor_temp;
        UIUC_shape.num{i} = coor_num;
    end
else
nfoil = length(set_foil);
UIUC_shapes = [];       
    for i = 1:nfoil
    foil_path = [data_folder '\UIUC_database\' set_foil{i}];
    i_judge = find(ismember(foil_names,set_foil{i}));
    if (isempty(i_judge))
    disp(['Cant find' set_foil{i} 'airfoil£¡']);
    return;
    end
    C = importdata(foil_path,' ',1);
    temp = C.data;
    
    coor_num = length(temp);
    coor_temp = temp;
    UIUC_shape.name{i} = set_foil{i};
    UIUC_shape.coord{i} = coor_temp;
    UIUC_shape.num{i} = coor_num;
    end
end



%--------------Section 2-----------------------------
%  Using CST parameterization method to duplicate the airfoil
%----------------------------------------------------
foil_name = UIUC_shape.name';
foil_coor = UIUC_shape.coord;
foil_coor_num = UIUC_shape.num;
for i = 1:nfoil
        % airfoil split to upper and lower face
        temp = foil_head_smooth(3,foil_coor{i},2);
        [up,down] = airfoil_split(temp);
        disp(['The No. ' num2str(i) '  airfoil is doing!!!!!']);
        [wt,ft]= find_weight(method,up,down);    
        foil_smooth = foil_output(wt,up,down); 
        foil_smooth= foil_head_smooth(20,foil_smooth,5);
        gap = up(end,end)-down(end,end) ;
        UIUC_shape.coord_smooth{i} = foil_smooth;
        UIUC_shape.gap{i} = gap;
        UIUC_shape.weight{i} = wt;
        UIUC_shape.fval{i} = ft;

 end


save('UIUC_shape.mat','UIUC_shape');