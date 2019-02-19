clear data Q
convergence_parameter=0.05;
[filenames folder_path]=uigetfile('*.txt','MultiSelect','on');
cd(folder_path)
for i=1:size(filenames,2)
    data=dlmread([folder_path filenames{i}]);
    Q(i)=trapz(data(:,1),data(:,2));
end
figure
plot(Q,'o')
ylim([0 1.1*max(Q)])
xlabel('Measurement number')
ylabel('Charge [C]')

i=1
while std(Q(i:end))>convergence_parameter*mean(Q(i:end))
    i=i+1;
end
i=6;
txt=['Q average: Q' num2str(i) ' to Q' num2str(numel(Q)) ' : ' num2str(mean(Q(i:end))) ' [C]',newline,'Q stdev: Q' num2str(i) ' to Q' num2str(numel(Q)) ' : ' num2str(std(Q(i:end))) ' [C]']
disp(txt)
title(inputdlg('Title'))
% FID=fopen('Q.txt','w');
% fwrite(FID,