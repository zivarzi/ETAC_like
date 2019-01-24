[file_name file_path]=uigetfile('*.ras');
FID=fopen([file_path file_name]);
xrd_raw_data=fscanf(FID,'%c');
fclose(FID);
txtind=strfind(xrd_raw_data,'*RAS_INT_START')+size('*RAS_INT_START',2);
while isempty(str2num(xrd_raw_data(txtind)))
    txtind=txtind+1;
end
txtind_end=strfind(xrd_raw_data,'*RAS_INT_END')-1;
xrd_data=str2num(xrd_raw_data(txtind:txtind_end));
figure
plot(xrd_data(:,1),smooth(xrd_data(:,2)))

plot_jcpds(1200);