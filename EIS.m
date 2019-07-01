[filelist filepath]=uigetfile('*.txt','MultiSelect','on');
file_num=max(size(filelist));
for i=1:file_num
    data{i}=importfile([filepath filelist{i}]);
end


%%
fig1=figure;
ax1=axes;
ax1.Parent=fig1;
hold on
cmap=parula(file_num);
for i=1:file_num
plot(data{i}.ReZOhm,-data{i}.ImZOhm,'*','Parent',ax1,'DisplayName',filelist{i},'Color',cmap(i,:))
end
legend('show','Location','southeast','Interpreter','none');
xlabel("Z'");
ylabel("Z''");
% small window
ax2=axes;
ax2.Parent=fig1;
ax2.Units='normalized';
ax2.Position=[.6 .6 .3 .3];
for i=1:file_num
hold on
    plot(data{i}.ReZOhm,-data{i}.ImZOhm,'*','Parent',ax2,'Color',cmap(i,:));
    minZ(i)=min(data{i}.ReZOhm);
end
minZ=min(minZ);
xlabel("Z'");
ylabel("Z''");
xlim([0.9*minZ 1]);
ylim([0 0.03]);
ax2.PickableParts='none';
ax2.HandleVisibility='off';
%%
function file_data = importfile(filename, startRow, endRow)

delimiter = '\t';
if nargin<=2
    startRow = 2;
    endRow = inf;
end
formatSpec = '%s%s%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end
fclose(fileID);
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^[-/+]*\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end

file_data = table;
file_data.freqHz = cell2mat(raw(:, 1));
file_data.ReZOhm = cell2mat(raw(:, 2));
file_data.ImZOhm = cell2mat(raw(:, 3));

end