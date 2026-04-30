function export_figure_bundle(figHandle, outputDir, baseName)
%EXPORT_FIGURE_BUNDLE Export a figure as PNG and FIG when possible.

if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

pngPath = fullfile(outputDir, [baseName '.png']);
figPath = fullfile(outputDir, [baseName '.fig']);

try
    exportgraphics(figHandle, pngPath, 'Resolution', 300);
catch
    saveas(figHandle, pngPath);
end

try
    savefig(figHandle, figPath);
catch
    % Older MATLAB versions may not support savefig in some environments.
end

end
