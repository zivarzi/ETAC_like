% function [Q]=OP_analyze(discharge_potential)

    %load('for_OP.mat')
charge_time=0;
    a=dir;%(uigetdir);
    meas_data_raw={0};
        for i1=1:size(a,1)
            if size(a(i1).name,2)>4
                if strfind(a(i1).name(end-4:end),'.idf')
                    FID_read=fopen(a(i1).name,'r','n','windows-1252');
                    data=fscanf(FID_read,'%c');
                    indice_of_data=strfind(data,'primary_data')+size('primary_data',2);
                    data_start_indx=find(abs(data(indice_of_data:indice_of_data+100))==10,3);
                    data_start_indx=data_start_indx(end)+indice_of_data;
                    iii=0;
                    while isempty(str2num(data(end-iii)))
                        iii=iii+1;
                    end
                    data_end_indx=iii;
                    FID_temp=fopen('temp.txt','w');
                    fwrite(FID_temp,data(data_start_indx:end-data_end_indx));
                    meas_data_raw{end+1}=dlmread('temp.txt');
                    meas_data=meas_data_raw{end};
                    %% findind the charge total duration
                    charge_duration_ind=1;
                    charge_duration_ind_end=2;
                    number_of_stages=str2num(data(strfind(data,'Stages=')+size('Stages=',2)));
                    discharge_potential_text_index=strfind(data,['Stages.Properties[' num2str(number_of_stages-1) '].E applied='])+size(['[Stages.Properties[' num2str(number_of_stages-1) '].E applied='],2)-1;
                    discharge_potential=str2num(data(discharge_potential_text_index:discharge_potential_text_index+find(abs(data(discharge_potential_text_index:discharge_potential_text_index+6))==13,1)-1));
                    for i=1:number_of_stages
                        charge_index(i)=strfind(data,['Stages.Properties[' num2str(i) '].E applied='])+size(['[Stages.Properties[' num2str(i) '].E applied='],2)-1;
                        charge_potential_i(i)=str2num(data(charge_index(i):charge_index(i)+find(abs(data(charge_index(i):charge_index(i)+6))==13,1)));
                        if charge_potential_i(i)>discharge_potential
                            charge_duration_ind(end+1)=strfind(data,['Stages.Properties[' num2str(i) '].Duration='])+size(['Stages.Properties[' num2str(i) '].Duration='],2);
                            charge_duration_ind_end(end+1)=charge_duration_ind(end)+1;    
                                while str2num(data(charge_duration_ind:charge_duration_ind_end))>0
                                    charge_duration_ind_end=charge_duration_ind_end+1;
                                end
                        end
                    end
                    clear Q
                    for i=2:size(charge_duration_ind,2)
                        charge_potential_index=1; %integrating
                        discharge_potential_index=find(meas_data(:,3)-discharge_potential<0.001,1);
                        clear t_to_ind i_to_ind
                        t_to_ind=meas_data(charge_potential_index:discharge_potential_index,1);
                        i_to_ind=meas_data(charge_potential_index:discharge_potential_index,2);
                        Q(i-1)=trapz(t_to_ind,i_to_ind);

                    end
                    figure
                    title(a(i1).name)
                    hold on
                    plot(meas_data(:,1),meas_data(:,2))
                    area(t_to_ind,i_to_ind)
                    Q=sum(Q);
                    Q_tot(i1)=Q;
                    fclose('all');
                end
                    fclose('all');
                    delete temp.txt;
            end 
        end
        meas_data_raw(1)=[];            
        figure
        plot(Q_tot)
%end
        