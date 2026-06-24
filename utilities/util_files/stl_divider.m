%% check stls
% get all .stl files starting with "starting_pattern_to_keep" in "filepath"
% folder and plot them in the same figure
filepath = "/home/gaz/catkin_ws/src/trp_master/trp_rover/urdf/meshes";
% starting_pattern_to_keep = "MSL_Gale_DEM_Mosaic_1m_v3_1000x20";
starting_pattern_to_keep = 'MSL_Gale_DEM_Mosaic_1m_v3_200x200_I1_R1_X_30201-30400_Y_22708-22907';

filenames = dir(filepath);
filenames = arrayfun(@(x) string(x.name),filenames);
filenames = filenames(startsWith(filenames,starting_pattern_to_keep));
filenames = filenames(endsWith(filenames,".stl"));

figure;
hold on;
for ii = 1:length(filenames)
    stl = stlread(sprintf("%s/%s",filepath,filenames(ii)));

%     trimesh(stl);
    trisurf(stl,'EdgeAlpha',0.3);
end
axis equal;


%% load stl
filepath = "/home/gaz/catkin_ws/src/trp_master/trp_rover/urdf/meshes";
filename = "MSL_Gale_DEM_Mosaic_1m_v3_1000x20_I1_R1_X_3745-4744_Y_37641-37660.stl";

filepath = '';
filename = "/home/s250877/terramech_plugin_test_data/20260310_data/terrain_cropped.stl";

stl = stlread(sprintf("%s/%s",filepath,filename));


%% divide stl by planes
trim_planes_coord = [-40 -30]';
trim_dir = 1;   % trim along: 1 -> yz planes (trim_planes_coord are x coords)
                %             2 -> xz planes (trim_planes_coord are y coords)
                %             3 -> xy planes (trim_planes_coord are z coords)

% stl_to_crop = stl;
stl_to_crop = stl_crops{2};
stl_crops = cell(size(trim_planes_coord,1)+1, 1);

for ii = 1:size(trim_planes_coord,1)
    points_divider = true(size(stl_to_crop.Points,1),1);

    points_divider(stl_to_crop.Points(:,trim_dir) > trim_planes_coord(ii)) = false;

    connectivityList_divider = points_divider(stl_to_crop.ConnectivityList);

    crop1_cells = (connectivityList_divider(:,1) & connectivityList_divider(:,2) & connectivityList_divider(:,3));
    crop2_cells = (~connectivityList_divider(:,1) & ~connectivityList_divider(:,2) & ~connectivityList_divider(:,3));

    border_cells = ((connectivityList_divider(:,1) ~= connectivityList_divider(:,2)) | (connectivityList_divider(:,1) ~= connectivityList_divider(:,3)));

    if ~(all(crop1_cells | crop2_cells | border_cells) && ~any(crop1_cells & crop2_cells & border_cells))
        warning('Something is wrong with the number of cells');
    end

    % Original code, moved to subTriang function - not tested for this section yet
    % crop1_connectivityList = stl_to_crop.ConnectivityList(crop1_cells | border_cells,:);
    % tmp_pts_indx = unique(reshape(crop1_connectivityList,[],1));
    % crop1_points = stl_to_crop.Points(tmp_pts_indx,:);
    % tmp_connect_dict = dictionary(tmp_pts_indx,(1:length(tmp_pts_indx))');
    % crop1_connectivityList = tmp_connect_dict(crop1_connectivityList);
    % stl_crops{ii} = triangulation(crop1_connectivityList,crop1_points);
    % 
    % crop2_connectivityList = stl_to_crop.ConnectivityList(crop2_cells | border_cells,:);
    % tmp_pts_indx = unique(reshape(crop2_connectivityList,[],1));
    % crop2_points = stl_to_crop.Points(tmp_pts_indx,:);
    % tmp_connect_dict = dictionary(tmp_pts_indx,(1:length(tmp_pts_indx))');
    % crop2_connectivityList = tmp_connect_dict(crop2_connectivityList);
    % stl_crops{ii+1} = triangulation(crop2_connectivityList,crop2_points);
    % 
    stl_crops{ii} = subTriang(stl_to_crop, crop1_cells | border_cells);
    stl_crops{ii+1} = subTriang(stl_to_crop, crop2_cells | border_cells);

    stl_to_crop = stl_crops{ii+1};
end

%% divide stl in sparse zones
rng shuffle;

stl_to_crop = stl;
stl_crops = cell(2, 1);

% coord of starting points for the areas [Nx3] matrix
% seeds = [36 35 0];
seeds = [2+rand([25,2])*69 zeros(25,1)];

% max area of each zone to crop [m^2] [Nx1 or 1xN] matrix
% max_size = 20;
max_size = 30 + rand([size(seeds,1) 1])*40;


rng shuffle;
stl_to_crop_areas = triangArea(stl_to_crop);
crop1_cells = [];
for ii = 1:size(seeds,1)
    % get nearest vertex to seed
    starting_vertex = nearestNeighbor(stl_to_crop, seeds(ii,:));
    % faces connected to starting vertex
    crop_cells_ii = cell2mat(vertexAttachments(stl_to_crop, starting_vertex))';
    crop_cells_ii = crop_cells_ii(1);

    while sum(stl_to_crop_areas(crop_cells_ii)) < max_size(ii)
        % neighbor faces to the current ones
        candidates = reshape(neighbors(stl_to_crop, crop_cells_ii), [],1);
        % exclude already taken faces and nan values (edge case)
        candidates(ismember(candidates, crop_cells_ii) | isnan(candidates)) = [];

        % random number between 0-1 for each face
        selection = rand(size(candidates));

        % keep faces with selection > 0.5
        crop_cells_ii = [crop_cells_ii; unique(candidates(selection > 0.5))];
    end
    crop1_cells = unique([crop1_cells; crop_cells_ii]);
end

stl_crops{1} = subTriang(stl_to_crop, crop1_cells);

% crop 2 is just the remaining area, no overlapping zone for now
crop2_cells = 1:size(stl_to_crop.ConnectivityList,1);
crop2_cells(ismember(crop2_cells, crop1_cells)) = [];
stl_crops{2} = subTriang(stl_to_crop, crop2_cells);

%% plot crops
figure;
trisurf(stl,'EdgeColor','none');
hold on;
axis equal;
colors = 'rbgcmyk';
for ii = 1:numel(stl_crops)
    trimesh(stl_crops{ii},'EdgeColor',colors(ii));
end

%% save crops
if false
    % filepath_save = filepath;
    % filename_to_save = strcat(extractBefore(filename,".stl"), '_crop',string(1:length(stl_crops))','.stl');

    filepath_save = '/home/s250877/archimede_ros2_ws/src/tmp_mars_worlds';
    filename_to_save = strcat('MSL_Gale_DEM_Mosaic_1m_v3_71x71_I1_R1_X_6380-6450_Y_35593-35663',{'_spotsP1','_spotsN1'}','.stl');

    for ii = 1:numel(stl_crops)
        stlwrite(stl_crops{ii}, fullfile(filepath_save,filename_to_save{ii}));
    end
end

%% FUNCTIONS
function out = subTriang(TR, cell_indx)
% SUBTRIANG creates a triangulation from the sub-set of faces cell_indx of
% the original triangulation TR
% 

    sub_connectivityList = TR.ConnectivityList(cell_indx,:);
    pts_indx = unique(reshape(sub_connectivityList,[],1));
    sub_points = TR.Points(pts_indx,:);
    connect_dict = dictionary(pts_indx,(1:length(pts_indx))');
    sub_connectivityList = connect_dict(sub_connectivityList);
    out = triangulation(sub_connectivityList,sub_points);
end

function out = triangArea(TR)
% TRIANGAREA finds the area of all triangles in triangulation obj and
% returns it as a vector
% 

    % points
    p1 = TR.Points(TR.ConnectivityList(:,1),:);
    p2 = TR.Points(TR.ConnectivityList(:,2),:);
    p3 = TR.Points(TR.ConnectivityList(:,3),:);

    % edges
    l12 = vecnorm(p1 - p2, 2,2);
    l23 = vecnorm(p2 - p3, 2,2);
    l13 = vecnorm(p1 - p3, 2,2);

    % angle opposed to l23
    theta = acos((l12.^2 + l13.^2 - l23.^2) ./ (2 * l12 .* l13));

    % area
    out = l12 .* (l13 .* sin(theta)) /2;

end



