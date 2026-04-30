function [citiesShp, cityNames, nanhaiBoundary] = load_city_map_inputs(dataDir)
%LOAD_CITY_MAP_INPUTS Load shapefiles used by the spatial figure scripts.

cityBoundaryPath = fullfile(dataDir, 'shared_city_boundaries_367.shp');
if ~exist(cityBoundaryPath, 'file')
    cityBoundaryPath = fullfile(dataDir, '行政边界_市级.shp');
end

southSeaPath = fullfile(dataDir, 'shared_south_sea_boundary_wgs84.shp');
if ~exist(southSeaPath, 'file')
    southSeaPath = fullfile(dataDir, 'south_sea_boun_wgs84.shp');
end

citiesShp = shaperead(cityBoundaryPath);

% Keep the Chengdu ordering fix used in the original scripts.
if numel(citiesShp) >= 40
    bufferShape = citiesShp(1);
    citiesShp(1:39) = citiesShp(2:40);
    citiesShp(40) = bufferShape;
end

cityNames = {citiesShp.City}';
nanhaiBoundary = shaperead(southSeaPath);

end
