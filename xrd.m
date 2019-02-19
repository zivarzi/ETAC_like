[file_name file_path]=uigetfile('*.ras','MultiSelect','on');
if iscell(file_name)==0
    number_of_files=1;
else
   number_of_files=size(file_name,2); 
end
for i=1:number_of_files
FID=fopen([file_path file_name{i}]);
xrd_raw_data=fscanf(FID,'%c');
fclose(FID);
txtind=strfind(xrd_raw_data,'*RAS_INT_START')+size('*RAS_INT_START',2);
while isempty(str2num(xrd_raw_data(txtind)))
    txtind=txtind+1;
end
txtind_end=strfind(xrd_raw_data,'*RAS_INT_END')-1;
xrd_data(:,:,i)=str2num(xrd_raw_data(txtind:txtind_end));
end
%%
offset=max(1.5*max(xrd_data(:,2,:)));
offset=0;
figure
hold on
for i=1:number_of_files
plot(xrd_data(:,1,i),smooth(xrd_data(:,2,i))+(i-1)*offset)
end
plot_jcpds(0.5*max(xrd_data(:,2)));