clear a data FID FID_read index_of_measurements header
header=char([0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 1 0 0]);
footer=char([0 0 0 0 13 10 0 0 0 13 10]);
a=dir;
for i1=1:size(a,1)
	if size(a(i1).name,2)>4
        if strfind(a(i1).name(end-4:end),'.ids')
            FID_read=fopen(a(i1).name,'r','n','windows-1252')
            data=fscanf(FID_read,'%c');
            dat=textscan(FID_read,'%c');
            index_of_measurements=strfind(data,'QR=');
            doubledagger_temp=strfind(data,char('‡'));
            
            dotplus_temp=strfind(data,'.+');
            for i=2:size(index_of_measurements,2)
                footer=['    '];
                FID=fopen([a(i1).name(1:end-4) '_scan' num2str(i-1) '.idf'],'w');
                fwrite(FID,[header newline data(index_of_measurements(i-1):index_of_measurements(i)) footer],'char');
            end
            fclose('all');
        end 
    end
end