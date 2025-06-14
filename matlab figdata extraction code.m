fig_file = 'CF_sensitivity.fig';      % 替换为你的fig文件路径
output_csv = 'CF_sensitivity.csv';    % 替换为你想要的输出路径

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
        % 若DisplayName为空，则自动命名
        if isempty(name)
            name = sprintf('Curve_%d',j);
        end
        % 确保数据长度一致
        xData = xData(:);
        yData = yData(:);
        maxLen = max(length(xData), length(yData));
        xData(end+1:maxLen) = NaN;
        yData(end+1:maxLen) = NaN;
        % 添加数据和列名
        allData{end+1} = [xData yData];
        headers{end+1} = [name '_X'];
        headers{end+1} = [name '_Y'];
    end
end

% 合并所有数据
maxRows = max(cellfun(@(c) size(c,1), allData));
numCurves = length(allData);
outputData = nan(maxRows, numCurves*2);
for k = 1:numCurves
    curveData = allData{k};
    outputData(1:size(curveData,1), 2*k-1:2*k) = curveData;
end

% 写入CSV
fid = fopen(output_csv, 'w');
fprintf(fid, '%s,', headers{1:end-1});
fprintf(fid, '%s\n', headers{end});
fclose(fid);
dlmwrite(output_csv, outputData, '-append');

disp(['数据已保存到 ', output_csv]);