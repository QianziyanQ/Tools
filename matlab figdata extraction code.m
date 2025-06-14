fig_file = 'CF_sensitivity.fig';      % replace with you fig file path
output_csv = 'CF_sensitivity.csv';    % Replace with the output path you want

fig = openfig(fig_file, 'invisible');
axesObjs = findobj(fig, 'Type', 'axes');
allData = {};
headers = {};

for i = 1:length(axesObjs)
    lineObjs = findobj(axesObjs(i), 'Type', 'line');
    for j = 1:length(lineObjs)
        xData = get(lineObjs(j), 'XData');
        yData = get(lineObjs(j), 'YData');
        name  = get(lineObjs(j), 'DisplayName');
        % if DisplayName is null，automatically name
        if isempty(name)
            name = sprintf('Curve_%d',j);
        end
        % Ensure data length is consistent
        xData = xData(:);
        yData = yData(:);
        maxLen = max(length(xData), length(yData));
        xData(end+1:maxLen) = NaN;
        yData(end+1:maxLen) = NaN;
        % add data and column name
        allData{end+1} = [xData yData];
        headers{end+1} = [name '_X'];
        headers{end+1} = [name '_Y'];
    end
end

% merge all data
maxRows = max(cellfun(@(c) size(c,1), allData));
numCurves = length(allData);
outputData = nan(maxRows, numCurves*2);
for k = 1:numCurves
    curveData = allData{k};
    outputData(1:size(curveData,1), 2*k-1:2*k) = curveData;
end

% write to CSV
fid = fopen(output_csv, 'w');
fprintf(fid, '%s,', headers{1:end-1});
fprintf(fid, '%s\n', headers{end});
fclose(fid);
dlmwrite(output_csv, outputData, '-append');

disp(['数据已保存到 ', output_csv]);
