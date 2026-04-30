function paths = package_paths(callerFullPath, outputSubdir)
%PACKAGE_PATHS Resolve common paths inside the standalone figure package.

if nargin < 1 || isempty(callerFullPath)
    callerFullPath = mfilename('fullpath');
end

codeDir = fileparts(callerFullPath);
packageRoot = fileparts(codeDir);

paths = struct();
paths.package_root = packageRoot;
paths.code_dir = codeDir;
paths.data_dir = fullfile(packageRoot, 'data');
paths.output_root = fullfile(packageRoot, 'outputs');

if ~exist(paths.output_root, 'dir')
    mkdir(paths.output_root);
end

if nargin >= 2 && ~isempty(outputSubdir)
    paths.output_dir = fullfile(paths.output_root, outputSubdir);
    if ~exist(paths.output_dir, 'dir')
        mkdir(paths.output_dir);
    end
else
    paths.output_dir = paths.output_root;
end

end
