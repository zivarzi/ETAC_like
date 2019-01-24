
%% clearing the workspace
close_all=string(questdlg('Do you want to close all the open figures?','',"Yes","No","Yes"));
if close_all=="Yes"
    close all
end
clear_all=string(questdlg('Do you want to clear all the workspace variables?','',"Yes","No","Yes"));
if close_all=="Yes"
    clear
    clc;
    warning off
    delete([pwd '\max_q.xls']);
end
FID = fopen('caxis_tool.m','w');
fprintf(FID,'%s\n','function caxis_tool()',...
    "x_pos=0.05;",...
    "caxis_tool_figure=figure('Name','Unifying scales for heat maps','Units','normalized','Position',[0.7 0.4 0.2 0.5]);",...
    ["open_figures_btn=uicontrol(caxis_tool_figure,'String','open existing figure files','Callback','unify_figure_files','Units','normalized','Position',[x_pos 0.65 0.9 0.25]);"],...
    "add_to_caxis_btn=uicontrol(caxis_tool_figure,'String','add to figure list','Callback',join('last_gcf=gcf;if exist(''last_gcf'')==0;last_gcf=get_last_gcf();else;last_gcf(end+1)=get_last_gcf();end'),'Units','normalized','Position',[x_pos 0.35 0.9 0.25]);",...
    "apply_caxis_btn=uicontrol(caxis_tool_figure,'String','apply unifying heat maps scales','Callback','apply_caxis(last_gcf);close(gcf)','Units','normalized','Position',[x_pos 0.05 0.9 0.25]);",...
    "end");
fclose(FID);

FID = fopen('unify_figure_files.m','w');
fprintf(FID,'%s\n',...
    "function unify_figure_files()",...
        "questdlg('All the figures need to be in the same folder','','OK','OK')",...
        "[names path]=uigetfile('MultiSelect','on');",...
        "for i=1:size(names,2)",...
        "    open(char(join([path '\' names(i)],'')))",...
        "   last_gcf(i)=gcf;",...
        "end",...
        "for i=1:size(last_gcf,2)",...
        "    global_max(i)=max(max(last_gcf(i).CurrentAxes.Children(2).ZData));",...
        "    max_x(i)=last_gcf(i).CurrentAxes.XLim(2);",...
        "    max_y(i)=last_gcf(i).CurrentAxes.YLim(2);",...
        "end",...
        "global_max=max(max(global_max));",...
        "for i=1:size(last_gcf,2)",...
        "    last_gcf(i).CurrentAxes.XLim=[0 min(max_x)];",...
        "    last_gcf(i).CurrentAxes.YLim=[0 min(max_y)];",...
        "    ca=last_gcf(i).CurrentAxes.Children(2);",...
        "    local_max(i)=max(max(ca.ZData(find(ca.XData(1,:)==min(max_x)),find(ca.YData(:,1)==min(max_y)))));",...
        "end",...
        "local_max=max(max(local_max));",...
        "for i=1:size(last_gcf,2)",...
        "    ca=last_gcf(i).CurrentAxes.Children(2);",...    
        "    caxis(last_gcf(i).CurrentAxes,[0 local_max])",...
        "    ca.LevelStep=round(local_max*0.1);",...
        "    saveas(last_gcf(i),[last_gcf(i).Name ' unified'],'png');",...
        "end",...
        "end");
fclose(FID);

FID = fopen('get_last_gcf.m','w');
fprintf(FID,'%s\n','function return_last_gcf=get_last_gcf()',...
    "last_fig=findobj('Type','figure');",...
    "return_last_gcf=last_fig(2);",...
    "",...
    "end");
fclose(FID);
FID = fopen('apply_caxis.m','w');
fprintf(FID,'%s\n','function apply_caxis(last_gcf)',"for i=1:size(last_gcf,2)",...
    "    global_max(i)=max(max(last_gcf(i).CurrentAxes.Children(2).ZData));",...
    "    max_x(i)=last_gcf(i).CurrentAxes.XLim(2);",...
    "    max_y(i)=last_gcf(i).CurrentAxes.YLim(2);",...
    "end",...
    "global_max=max(max(global_max));",...
    "",...
    "for i=1:size(last_gcf,2)",...
    "    last_gcf(i).CurrentAxes.XLim=[0 min(max_x)];",...
    "    last_gcf(i).CurrentAxes.YLim=[0 min(max_y)];",...
    "    ca=last_gcf(i).CurrentAxes.Children(2);",... %(2) is because of the scatter
    "    local_max(i)=max(max(ca.ZData(find(ca.XData(1,:)==min(max_x)),find(ca.YData(:,1)==min(max_y)))));",...
    "end",...
    "local_max=max(max(local_max));",...
    "for i=1:size(last_gcf,2)",...
    "    caxis(last_gcf(i).CurrentAxes,[0 local_max])","end","end");
fclose(FID);

FID = fopen('apply_caxis.m','w');
fprintf(FID,'%s\n','function apply_caxis(last_gcf)',"for i=1:size(last_gcf,2)",...
    "    global_max(i)=max(max(last_gcf(i).CurrentAxes.Children(2).ZData));",...
    "    max_x(i)=last_gcf(i).CurrentAxes.XLim(2);",...
    "    max_y(i)=last_gcf(i).CurrentAxes.YLim(2);",...
    "end",...
    "global_max=max(max(global_max));",...
    "",...
    "for i=1:size(last_gcf,2)",...
    "    last_gcf(i).CurrentAxes.XLim=[0 min(max_x)];",...
    "    last_gcf(i).CurrentAxes.YLim=[0 min(max_y)];",...
    "    ca=last_gcf(i).CurrentAxes.Children(2);",... %(2) is because of the scatter
    "    local_max(i)=max(max(ca.ZData(find(ca.XData(1,:)==min(max_x)),find(ca.YData(:,1)==min(max_y)))));",...
    "end",...
    "local_max=max(max(local_max));",...
    "for i=1:size(last_gcf,2)",...
    "    caxis(last_gcf(i).CurrentAxes,[0 local_max])","end","end");
fclose(FID);

FID = fopen('get_last_ui_position.m','w');
fprintf(FID,'%s\n',...    
    "function [ypos height]=get_last_ui_position(panel_name,panel_name_type)",...
    "panel_name_type='uipanel';",...
    "if nargin==1",...
    "panel_name_type='uicontrol';",...
    "end",...
    "info=findobj(panel_name,'Type',panel_name_type);",...
    "ypos=info(1).Position(2);",...
    "height=info(1).Position(4);",...
    "end");
fclose(FID);

C_to_kg=0.00398;%*Q %0.0813 density[kg/m^3]*2Q*R*298K/1 atm    RT! m^3/mol
%% GUI
ziv_version=1.07;
if exist('logo.png')==0
    emd_logo(1:68,1:443,1:3)=255;
else
    emd_logo=imread('logo.png');
end
x_pos=.05; text_w=.5; text_h=.07; height_interval=.07; initial_height=1-text_h; %initial position and size for text fields

uif=figure('name','Parameters and options','Units','normalized','Position',[0.25 0.05 0.5 0.85]);
image_panel=uipanel(uif,'Units','normalized','Position',[0 0.92 1 0.08],'BackgroundColor','w');
set(gcf,'units','pixels'); fig_width=get(gcf,'Position');
ax=axes('Parent',image_panel,'Units','pixels','Position',[(fig_width(3)-size(emd_logo,2))/2 0 size(emd_logo,2) size(emd_logo,1)]);
ax.Units='normalized';
image(emd_logo,'Parent',ax)
box off
set(gca,'Box','off','XColor','none','YColor','none')

folder_select_panel=uipanel(uif,'Units','normalized','Position',[0 0.88 1 0.04]);
folder_text=uicontrol(folder_select_panel,'Style','text','String','','Callback','uif.Visible=''off'';caxis_tool();','Units','normalized','Position',[0.01 0.01 0.45 0.9],'BackgroundColor','w','HorizontalAlignment','left');
folder_btn=uicontrol(folder_select_panel,'String','Select folder','Callback','path_of_folder=uigetdir;folder_text.String=path_of_folder;','Units','normalized','Position',[0.5 0.01 0.2 0.9]);
uicontrol(folder_select_panel,'Style','text','String',{['Version ' num2str(ziv_version)],'Created by Ziv Arzi'},'Units','normalized','Position',[0.75 0.01 0.2 0.9])


tab_group=uitabgroup(uif,'Position',[0.01 0.01 0.98 0.86]);
etac_like_general_tab=uitab(tab_group,'Title','ETAC Like');
etac_like_advanced_tab=uitab(tab_group,'Title','ETAC Like Advanced options');
etac_tab=uitab(tab_group,'Title','ETAC');
xrd_tab=uitab(tab_group,'Title','XRD');

uigraphic=uipanel(etac_like_general_tab,'title','Graphic options'); %creating panel for the input
%Creating the checkboxes 
panel_name=uigraphic;
uigraphic.Units='normalized';
verification_plot=uicontrol(uigraphic,'Style','checkbox','String','Display all I(t) plots','Units','normalized','Position',[x_pos initial_height text_w text_h]);
height_lines_checkbox=uicontrol(uigraphic,'Style','checkbox','String','Show elevation level on the heat maps','Units','normalized','Position',[x_pos get_last_ui_position(panel_name)-height_interval text_w text_h],'HorizontalAlignment','left','Value',1);
uigraphic_height=1-get_last_ui_position(panel_name);
uigraphic_ypos=get_last_ui_position(uif,'uitab');

uifitting=uipanel(etac_like_general_tab,'title','fitting'); %creating panel for the input
panel_name=uifitting;
fit_diag_checkbox=uicontrol(uifitting,'Style','checkbox','String','Plot the fit of the diagonal of the Q charged matrix','Units','normalized','Position',[x_pos initial_height text_w text_h],'HorizontalAlignment','left');
extrapulate_by_rows_checkbox=uicontrol(uifitting,'Style','checkbox','String','extrapulate empty data points using rows [Q_{sat}*(1-exp(1/\tau*t)]','Units','normalized','Position',[x_pos get_last_ui_position(panel_name)-height_interval text_w text_h],'HorizontalAlignment','left','Value',1);
plot_extrapulate_by_rows_checkbox=uicontrol(uifitting,'Style','checkbox','String','Plot the fitting','Units','normalized','Position',[x_pos+text_w get_last_ui_position(panel_name) text_w text_h],'HorizontalAlignment','left','Value',0);
extrapulate_by_columns_checkbox=uicontrol(uifitting,'Style','checkbox','String','extrapulate empty data points using columns [Q_{sat}*(1-exp(1/\tau*t)]','Units','normalized','Position',[x_pos get_last_ui_position(panel_name)-height_interval text_w text_h],'HorizontalAlignment','left','Value',1);
plot_extrapulate_by_columns_checkbox=uicontrol(uifitting,'Style','checkbox','String','Plot the fitting','Units','normalized','Position',[x_pos+text_w get_last_ui_position(panel_name) text_w text_h],'HorizontalAlignment','left');
fit_3D_checkbox=uicontrol(uifitting,'Style','checkbox','String','Fit the Q charge matrix to 3D surface','Units','normalized','Position',[x_pos get_last_ui_position(panel_name)-height_interval text_w text_h],'HorizontalAlignment','left','Value',1);
plot_Js_checkbox=uicontrol(uifitting,'Style','checkbox','String','Plot current densities','Units','normalized','Position',[x_pos get_last_ui_position(panel_name)-height_interval text_w text_h],'HorizontalAlignment','left','Value',0);
plot_Q_norm_to_sat_checkbox=uicontrol(uifitting,'Style','checkbox','String','Plot Q normalized to Q maximum','Units','normalized','Position',[x_pos get_last_ui_position(panel_name)-height_interval text_w text_h],'HorizontalAlignment','left','Value',0);
plot_Q_norm_to_max_checkbox=uicontrol(uifitting,'Style','checkbox','String','Plot Q normalized to Q saturation (automatically runs the diagonal fit)','Units','normalized','Position',[x_pos get_last_ui_position(panel_name)-height_interval text_w text_h],'HorizontalAlignment','left','Value',0);
plot_q_tau_checkbox=uicontrol(uifitting,'Style','checkbox','String','Plot the Q_{sat} and \tau parameters for different samples','Units','normalized','Position',[x_pos get_last_ui_position(panel_name)-height_interval text_w text_h],'HorizontalAlignment','left');
plot_kg_day_checkbox=uicontrol(uifitting,'Style','checkbox','String','Plot Q charged in Kg H2/day units','Units','normalized','Position',[x_pos get_last_ui_position(panel_name)-height_interval text_w text_h],'HorizontalAlignment','left');

uifitting.Units='normalized';
uifitting_height=1-get_last_ui_position(panel_name)-uigraphic_height+text_h;
uifitting.Position=[0 uifitting_height-uigraphic_height 1 1-uifitting_height];

%creating the parameters input fields
uiparameters=uipanel(etac_like_general_tab,'title','Measurement paramteres'); %creating panel for the input
panel_name=uiparameters;
label_h=text_h;
input_h=text_h;
sample_name_text=uicontrol(uiparameters,'Style','text','String','What is the sample name?','Units','normalized','Position',[x_pos 1-label_h text_w label_h],'HorizontalAlignment','left');
sample_name_ui=uicontrol(uiparameters,'Style','edit','String','','Units','normalized','Position',[x_pos get_last_ui_position(panel_name)-height_interval text_w/5 input_h]);

time_of_deposition_text=uicontrol(uiparameters,'Style','text','String','What is the deposition time [hours]?','Units','normalized','Position',[x_pos+0.3 1-label_h text_w label_h],'HorizontalAlignment','left');
time_of_deposition_ui=uicontrol(uiparameters,'Style','edit','String','','Units','normalized','Position',[x_pos+0.3 get_last_ui_position(panel_name)-height_interval text_w/5 input_h]); 

charge_potential_text=uicontrol(uiparameters,'Style','text','String','What is the charging potential? [V Vs. RHE]','Units','normalized','Position',[x_pos+0.65 1-label_h text_w label_h],'HorizontalAlignment','left');
charge_potential_ui=uicontrol(uiparameters,'Style','edit','String','','Units','normalized','Position',[x_pos+0.65 get_last_ui_position(panel_name)-height_interval text_w/5 input_h],'String',1.48); 

number_of_peaks_text=uicontrol(uiparameters,'Style','text','String','How many cycles the measurement contain?','Units','normalized','Position',[x_pos get_last_ui_position(panel_name)-2*height_interval text_w label_h],'HorizontalAlignment','left');
number_of_peaks_ui=uicontrol(uiparameters,'Style','edit','String','10','Units','normalized','Position',[x_pos get_last_ui_position(panel_name)-height_interval text_w/5 input_h]); 

q_terms_to_avg_text=uicontrol(uiparameters,'Style','text','String','How many of the last measurements you want to average?','Units','normalized','Position',[x_pos+0.3 get_last_ui_position(panel_name)+height_interval text_w-0.2 label_h],'HorizontalAlignment','left');
q_terms_to_avg_ui=uicontrol(uiparameters,'Style','edit','String','5','Units','normalized','Position',[x_pos+0.3 get_last_ui_position(panel_name)-height_interval text_w/5 input_h]); 

electrode_area_text=uicontrol(uiparameters,'Style','text','String','What is the electrode area? [cm^2]','Units','normalized','Position',[x_pos+0.65 get_last_ui_position(panel_name)+height_interval text_w label_h],'HorizontalAlignment','left');
electrode_area_ui=uicontrol(uiparameters,'Style','edit','String','1','Units','normalized','Position',[x_pos+0.65 get_last_ui_position(panel_name)-height_interval text_w/5 input_h]);
electrode_area=str2num(electrode_area_ui.String);
uiparameters.Units='normalized';
uiparameters_height=get_last_ui_position(panel_name);
uiparameters.Position=[0 uiparameters_height-uifitting_height-uigraphic_height 1 1-uiparameters_height];
is_etac_checkbox=uicontrol(uiparameters,'Style','checkbox','String','Is this E-TAC measurement?','Units','normalized','Position',[x_pos get_last_ui_position(panel_name)-2*height_interval text_w input_h]);

advanced_panel=uipanel(etac_like_advanced_tab,'title','Advanced options','units','normalized','Position',[0 .1 1 0.9]);
panel_name=advanced_panel;

caxis_btn=uicontrol(advanced_panel,'String','Open scale unifier','Callback','uif.Visible=''off'';caxis_tool();','Units','normalized','Position',[0.55 0.9 0.3 0.1]);

smooth_data_ui=uicontrol(advanced_panel,'Style','checkbox','String','Smooth noisy data','Value',1,'Units','normalized','Position',[x_pos initial_height text_w text_h]);
save_fit_figure=uicontrol(advanced_panel,'Style','checkbox','String','Save Q matrix diagonal fitting figure','Value',1,'Units','normalized','Position',[x_pos get_last_ui_position(panel_name)-height_interval text_w text_h]);
save_Q_norm_to_Qmax_figure=uicontrol(advanced_panel,'Style','checkbox','String','Save Q normalized to Q maximum figure','Value',1,'Units','normalized','Position',[x_pos get_last_ui_position(panel_name)-height_interval text_w text_h]);
save_Q_norm_to_Qsat_figure=uicontrol(advanced_panel,'Style','checkbox','String','Save Q normalized to Q saturation figure','Value',1,'Units','normalized','Position',[x_pos get_last_ui_position(panel_name)-height_interval text_w text_h]);
save_Q_data.checkbox=uicontrol(advanced_panel,'Style','checkbox','String','Save Q data to files','Value',0,'Units','normalized','Position',[x_pos get_last_ui_position(panel_name)-height_interval text_w text_h]);
save_figures_in_subfolder_checkbox=uicontrol(advanced_panel,'Style','checkbox','String','Save figures in subfolder (''figures'')','Value',1,'Units','normalized','Position',[x_pos get_last_ui_position(panel_name)-height_interval text_w text_h]);
save_other_dir_checkbox=uicontrol(advanced_panel,'Style','checkbox','String','Save the data in other folder','Value',0,'Units','normalized','Position',[x_pos get_last_ui_position(panel_name)-height_interval text_w text_h],'value',0);
show_final_data_checkbox=uicontrol(advanced_panel,'Style','checkbox','String','Show the data table in the end of the analysis','Value',0,'Units','normalized','Position',[x_pos get_last_ui_position(panel_name)-height_interval text_w text_h]);
define_treshold_I_for_maximum_text=uicontrol(advanced_panel,'Style','text','String','Define lower I of previous measurment [mA]','Tooltip','if you have problem with finding the right indices','Units','normalized','Position',[x_pos get_last_ui_position(panel_name)-2*height_interval text_w/2 label_h],'HorizontalAlignment','left');
define_treshold_I_for_maximum=uicontrol(advanced_panel,'Style','edit','String','10','Units','normalized','Position',[x_pos+text_w/2 get_last_ui_position(panel_name)+input_h/2 text_w/5 input_h/2],'Value',10);

save_preset=uicontrol(advanced_panel,'Style','pushbutton','String','Save preset','Callback','uisave','Units','normalized','Position',[x_pos get_last_ui_position(panel_name)-2*height_interval 0.3 0.07]);
load_preset=uicontrol(advanced_panel,'Style','pushbutton','String','load preset','Callback','close;[file,path]=uigetfile;load([path file])','Units','normalized','Position',[x_pos+.4 get_last_ui_position(panel_name) 0.3 0.07]);

etac_panel=uipanel(etac_tab,'title','ETAC','units','normalized','Position',[0 .1 1 0.9]);
panel_name=etac_panel;
etac_text=uicontrol(etac_panel,'Style','text','String','Choose a folder with exported text files from IVIUM ETAC experiment','Units','normalized','Position',[.01 initial_height .9 text_h],'FontSize',16);
etac_btn=uicontrol(etac_panel,'Style','pushbutton','String','ETAC analysis','Callback','integrate_etac','Units','normalized','Position',[x_pos get_last_ui_position(panel_name)-2*height_interval text_w text_h]);

xrd_panel=uipanel(xrd_tab,'title','XRD','units','normalized','Position',[0 .1 1 0.9]);
panel_name=xrd_panel;
etac_text=uicontrol(xrd_panel,'Style','text','String','Choose a XRD RAS file you want to plot with phases','Units','normalized','Position',[.01 initial_height .9 text_h],'FontSize',16);
etac_btn=uicontrol(xrd_panel,'Style','pushbutton','String','plot XRD spectrum','Callback','xrd','Units','normalized','Position',[x_pos get_last_ui_position(xrd_panel)-2*height_interval text_w text_h]);


start_btn=uicontrol('String','Start analysis','Callback',...
                                        'if or(isempty(sample_name_ui.String),isempty(time_of_deposition_ui.String));msgbox(''Punk, Enter all the fields!'');else;save(''vars''); close(uif);end'...
                                        ,'Units','normalized','Position',[0.05 0.02 0.9 0.07]);

%% function start_analysis
warning off
waitfor(uif)
load('vars')
number_of_peaks=str2num(number_of_peaks_ui.String);
q_terms_to_avg=str2num(q_terms_to_avg_ui.String);
if q_terms_to_avg==number_of_peaks
    q_terms_to_avg=q_terms_to_avg-1;
end
electrode_area=str2num(electrode_area_ui.String);
uif.Visible='off';
define_treshold_I_for_maximum_num=str2num(define_treshold_I_for_maximum.String)*1E-3;
open_cell_time=10; %[s]
%% Get csv files
filelist=dir(path_of_folder);
file_num=max(size(filelist));
csv_list=table({'none'},{'none'},{'none'},{'none'},{'none'});
csv_list.Properties.VariableNames=({'filename','filepath','data','charge','discharge'});
%% construct csv file list
for i=1:file_num
    if max(size(filelist(i).name))<4 %if the length of the filename is less than 4 it's not valid
    elseif true([filelist(i).name(end-2) filelist(i).name(end-1) filelist(i).name(end)]=='csv') %Check the extension of the file to be csv
        path={join([path_of_folder string(filelist(i).name)],'\')};
        csv_list(end+1,:)={filelist(i).name, path,csvread(string(path)),'',''};
    end
end
csv_list(1,:)=[]; %clear the first entry used to create the table
data=csv_list;
file_number=size(data); file_number=file_number(1); %How mant csv files in the folder
%% creating unified title to figures
figure_title=['Sample ' sample_name_ui.String ', ' time_of_deposition_ui.String ' hr, ' charge_potential_ui.String 'V'];
%% setting the variables for each file
if is_etac_checkbox.Value==1
    temp_times=inputdlg({'Enter charging time: [s]','Enter discharging time: [s]'},'E-TAC times',[1 35],{'',''})
    charge_time=str2num(temp_times{1});
    discharge_time=str2num(temp_times{2});
    for main_i=1:file_number
        temp=cell2mat(data.data(main_i));
        clear tt vv II
        tt=temp(:,1); II=temp(:,2); vv=temp(:,3);
        Q(main_i)=trapz(tt,II);
    end
        names={'charge_time','discharge_time'};
        for i=1:file_number
            names=[names {['Q_charged' num2str(i)]}];
        end
        main_i=1;      
        if main_i==1
            table_size=max(size(names));
            final_data=array2table(zeros(1,table_size),'VariableNames',names);
            final_data=[{''} final_data];
            final_data(main_i,end+1)=array2table(mean(Q(end-q_terms_to_avg+1:end)));
            final_data(main_i,end+1)=array2table(std(Q(end-q_terms_to_avg+1:end)));
            final_data=[final_data {''}];
            final_data.Properties.VariableNames=['filename' names 'Q_charge_avg' 'Q_stdev' 'h2_kg_day'];
        end
        final_data.charge_time(main_i)=charge_time;
        final_data.discharge_time(main_i)=discharge_time;
        final_data(main_i,4:4+file_number-1)=array2table(Q);
        final_data.Q_charge_avg(main_i)=mean(Q(end-q_terms_to_avg:end));
        final_data.Q_stdev(main_i)=std(Q(end-q_terms_to_avg:end));
        final_data.h2_kg_day=final_data.Q_charge_avg.*C_to_kg.*(60*60*24./(final_data.charge_time+final_data.discharge_time+10+10));
        final_data.filename(main_i)=data.filename(main_i);
end
    demixing_time=0;
    for main_i=1:file_number
    temp=data.data{main_i};
    clear tt vv II
    tt=temp(:,1); II=temp(:,2); vv=temp(:,3);
    clear temp
    dt=tt(2)-tt(1);
    % this weird loop is fixing bug in matlab import of hand made CSV from ivium
    for i=1:numel(tt)
        temp_tt=0:dt:(numel(II)-1)*dt;
        if tt(i)~=temp_tt(i)
           tt=temp_tt; clear temp_tt
           break
        end
    end
    clear local_max_ind local_max_tt 
%% checking for idf files
idf_filename=char(data.filepath{main_i,1});
idf_filename=[idf_filename(1:end-4) '.idf'];
if exist(idf_filename)~=0
    FID=fopen(idf_filename);
    idf_file=fscanf(FID,'%c');
    fclose(FID);
    number_of_stages=str2num(idf_file(strfind(idf_file,'Stages=')+size('Stages=',2)));
    for i=1:number_of_stages
    txtind=strfind(idf_file,['Stages.Properties[' num2str(i) '].Duration='])+size(['Stages.Properties[' num2str(i) '].Duration='],2);
    txtind_end=txtind+1;    
        while str2num(idf_file(txtind:txtind_end))>0
            txtind_end=txtind_end+1;
        end
        if i==2
            charge_time=str2num(idf_file(txtind:txtind_end-1));
        elseif i==4
            discharge_time=str2num(idf_file(txtind:txtind_end-1));
        else
            open_cell_time(i)=str2num(idf_file(txtind:txtind_end-1));
        end
        
    end
    %starting maximum & minimum
	local_max_ind(1)=open_cell_time(1)/dt;
    local_max_tt(1)=tt(local_max_ind(1));
    cycle_time=sum(open_cell_time)+charge_time+discharge_time;
    while local_max_ind(end)<numel(tt);
        local_max_ind(end+1)=local_max_ind(end)+cycle_time/dt;
        local_max_tt(end+1)=tt(local_max_ind(1));
    end
    number_of_peaks=size(local_max_ind,2)-1;
    open_cell_time=open_cell_time(1);
else
        %% setting parameters and getting the graphical input
    dist=tt(end)/number_of_peaks; %distance from each point
    pts=linspace(open_cell_time/dt,tt(end)*(0.7+.1*number_of_peaks/5),number_of_peaks); %50 is 10 seconds of open cell * interval between 
    x_pts=sort(pts); %get only the x values add (:,1) for ginput
    x_pts_ind=knnsearch(tt,x_pts');    
    %% findind the local maximum points
    threshold_for_first_max=1E-2; %mA
    threshold_for_first_max=define_treshold_I_for_maximum_num;
    clear temp_tt temp_II temp_tt_ind     
    i=1;
    search_range=0.05;
    temp_tt_ind=1:numel(tt)*search_range;%round(x_pts(i)+dist);
    temp_II=II(temp_tt_ind);
    good_temp_ind=find(min(abs(find(II==max(temp_II))-x_pts_ind(i))));
    temp_ind=find(temp_II>threshold_for_first_max);
    local_max_ind(i)=temp_ind(good_temp_ind);
    local_max_tt(i)=tt(local_max_ind(i));
    for i=2:number_of_peaks %looping through all points we chose
            clear temp_tt temp_II temp_tt_ind     
            if i==1
            else
                lower_limit=max(1,x_pts_ind(i)-dist);
                upper_limit=min(x_pts_ind(i)+dist,numel(II));
                temp_tt_ind=lower_limit+find(II(lower_limit:upper_limit)<threshold_for_first_max,1)-2:upper_limit;
                temp_II=II(temp_tt_ind);
                % getting the nearest index to the one now on focus
                good_temp_ind=find(min(abs(find(II==max(temp_II))-x_pts_ind(i))));
                temp_ind=find(II(temp_tt_ind)>threshold_for_first_max,1)+temp_tt_ind(1);
                true_ind=and(temp_ind>lower_limit,temp_ind<upper_limit);
                if isempty(find(min(abs(find(II==max(temp_II))-x_pts_ind(i))), 1))
                    true_ind=1;
                end
                local_max_ind(i)=min(temp_ind(true_ind)); %Taking the first temp index
                local_max_tt(i)=tt(local_max_ind(i));
            end
        end

    %% findind the charge & discharge times
        %for j=1:number_of_peaks
        minimal_threshold=define_treshold_I_for_maximum_num;
        j=1;
        first_below_zero=find(II(local_max_ind(j):end)<-minimal_threshold,1);
        first_below_zero_abs_ind=local_max_ind(j)+first_below_zero(1);
        charge_time_temp=tt(first_below_zero_abs_ind)-tt(local_max_ind(j));
        charge_time=round(charge_time_temp/100)*100;
        first_below_zero_dis=find(II(local_max_ind(j)+first_below_zero:end)<minimal_threshold);
        start_of_discharge=first_below_zero_abs_ind+first_below_zero_dis(1);
        first_above_zero=find(II(start_of_discharge:end)>minimal_threshold);
        end_of_dishcharge=start_of_discharge+first_above_zero(1);
        discharge_time=tt(end_of_dishcharge)-tt(start_of_discharge);
        discharge_time=floor(discharge_time/100)*100;
        dt=local_max_tt(i)/local_max_ind(i); 
        open_cell_time=find(II>minimal_threshold);
        open_cell_time=(open_cell_time(1)-1)*dt; %[s]
end
    %% writing the charge and discharge time to the table
    lower_measurement_time=50;
    if or(charge_time<lower_measurement_time,discharge_time<lower_measurement_time)
        figure('Name','define_times_figure');
        plot(tt,II);
        opts.WindowStyle = 'normal';
        manual_times_prompt={'Enter charging time: [s]','Enter discharging time: [s]'};
        manual_times_title='E-TAC times';
        dims=[1 35]; def_input={'',''};
        temp_times=inputdlg(manual_times_prompt,manual_times_title,dims,def_input,opts);
        charge_time=str2num(temp_times{1});     data.charge(main_i)={charge_time};
        discharge_time=str2num(temp_times{2});  data.discharge(main_i)={discharge_time};
        close define_times_figure
    else
        data.charge(main_i)={charge_time};
        data.discharge(main_i)={discharge_time};
    end
    %% finding Q charge
    clear t_to_int
    for i=1:number_of_peaks
        t_to_int(i,:)=local_max_ind(i)-2:local_max_ind(i)+charge_time/dt-1; %the last term gives the index
        t_to_int(i,:)=uint64(t_to_int(i,:));
        % just ot check the indices [num2str(i) ' ' num2str(t_to_int(i,1)) ' ' num2str(t_to_int(i,end)) ' ' num2str(t_to_int(i,end)-t_to_int(i,1))]
        Q(i)=trapz(tt(t_to_int(i,:)),II(t_to_int(i,:)));
    end
    %% findind Q discharge - the logic - the time to integrate is the indices of time to integrate of charging + 1, this is open 
	clear t_to_int_dis
    for i=1:number_of_peaks
        t_to_int_dis(i,:)=local_max_ind(i)+(charge_time+open_cell_time)/dt-2:local_max_ind(i)+(charge_time+open_cell_time+discharge_time)/dt-1;
        % just ot check the indices [num2str(i) ' ' num2str(t_to_int_dis(i,1)) ' ' num2str(t_to_int_dis(i,end)) ' ' num2str(t_to_int_dis(i,end)-t_to_int_dis(i,1))]
        t_to_int_dis(i,:)=uint64(t_to_int_dis(i,:));
        Q_dis(i)=trapz(tt(t_to_int_dis(i,:)),II(t_to_int_dis(i,:)));
    end
%% building the final table
    Q_names={''};
    warning off
    for i=1:number_of_peaks
        Q_names=[Q_names {['Q' num2str(i)]}];
    end
    Q_names(1)=[];
    Q_dis_names={''};
    for i=1:number_of_peaks
        Q_dis_names=[Q_dis_names {['Q_dis' num2str(i)]}];
    end
    Q_dis_names(1)=[];
    if main_i==1
        final_data=table({''});
        final_data(main_i,end+1)=array2table(charge_time,'VariableNames',{'charge_time'});
        final_data(main_i,end+1)=array2table(discharge_time,'VariableNames',{'discharge_time'});
        final_data(main_i,end+1)=array2table(mean(Q(end-q_terms_to_avg:end)),'VariableNames',{'Q_charge_avg'});
        final_data(main_i,end+1)=array2table(std(Q(end-q_terms_to_avg:end)),'VariableNames',{'Q_stdev'});
        final_data(main_i,end+1)=array2table(mean(Q_dis(end-q_terms_to_avg:end)),'VariableNames',{'Q_dis_avg'});
        final_data(main_i,end+1)=array2table(std(Q_dis(end-q_terms_to_avg:end)),'VariableNames',{'Q_dis_stdev'});
        Q1_column=size(final_data,2)+1;
        Qlast_column=Q1_column+number_of_peaks-1;
        Q_dis1_column=Qlast_column+1;
        Q_dislast_column=Q_dis1_column+number_of_peaks-1;
        final_data(main_i,Q1_column:Qlast_column)=array2table(Q,'VariableNames',Q_names);
        final_data(main_i,Q_dis1_column:Q_dislast_column)=array2table(Q_dis,'VariableNames',Q_dis_names);
        final_data(main_i,end+1)=array2table(0,'VariableNames',{'Q_dis_stdev'});
        final_data.Properties.VariableNames=['filename' 'charge_time' 'discharge_time' 'Q_charge_avg' 'Q_stdev' 'Q_dis_avg' 'Q_dis_stdev' 'h2_kg_day' Q_names Q_dis_names];
    end
    final_data.filename(main_i)=data.filename(main_i);
    final_data.charge_time(main_i)=charge_time;
    final_data.discharge_time(main_i)=discharge_time;
    final_data.Q_charge_avg(main_i)=mean(Q(end-q_terms_to_avg:end));
    final_data.Q_stdev(main_i)=std(Q(end-q_terms_to_avg:end));
    final_data.Q_dis_avg(main_i)=mean(Q_dis(end-q_terms_to_avg:end));
    final_data.Q_dis_stdev(main_i)=std(Q_dis(end-q_terms_to_avg:end));
    final_data(main_i,Q1_column+1:Qlast_column+1)=array2table(Q);
    final_data(main_i,Q_dis1_column+1:Q_dislast_column+1)=array2table(Q_dis);
    final_data.h2_kg_day=final_data.Q_charge_avg.*C_to_kg.*(60*60*24./(final_data.charge_time+final_data.discharge_time+10+10));
    %% define path names for saving figures
if main_i==1
    name_of_folder=find(path_of_folder=='\');
name_of_folder=path_of_folder(name_of_folder(end)+1:end);
if save_other_dir_checkbox.Value==1
    where_to_save_output=uigetdir('','Select folder to save the fitting parameters table and figures');
else
    where_to_save_output=path_of_folder;
end
if save_figures_in_subfolder_checkbox.Value==1
    figure_path=where_to_save_output;    
    where_to_save_figures=[where_to_save_output '\figures\'];
    where_to_save_images=[where_to_save_output '\pictures\'];
    mkdir([where_to_save_output '\figures'])
    mkdir([where_to_save_output '\pictures'])
    mkdir([where_to_save_output '\verification'])
else
    figure_path=pwd;
    where_to_save_figures=pwd;
    where_to_save_images=pwd;
end
end
%% plot the verification figures
    if verification_plot.Value==1
        verification_figure=figure('Name','I-V Verification plots');
        subplot(3,1,1)
        hold on
        for i=1:number_of_peaks
            I_plot=plot(tt,II,'DisplayName','I(t)');
            xlabel('time [s]')
            ylabel('Current [A]')
%            selected_plot=plot(tt(x_pts_ind),II(x_pts_ind),'o','DisplayName','Selected points');
            charge_area=area(tt(t_to_int(i,:)),II(t_to_int(i,:)),'FaceColor',[0.1460    0.6091    0.9079],'EdgeColor','none','DisplayName','Area integrated for charge');
            discharge_area=area(tt(t_to_int_dis(i,:)),II(t_to_int_dis(i,:)),'FaceColor',[0.8203    0.7498    0.1535],'EdgeColor','none','DisplayName','Area integrated for discharge');
            legend(I_plot.DisplayName, charge_area.DisplayName, discharge_area.DisplayName,'Location','eastoutside')
        end
        hold off
        title([figure_title ' Charge time ' num2str(charge_time) ' || discharge time ' num2str(discharge_time)])
        %Q charge
        subplot(3,1,2)
        hold on
        plot(Q,'o','DisplayName','Q charged [C]')
        xlabel('Cycle number')
        %ylim([0 max(Q)*1.1])
        title(['Charge time ' num2str(charge_time) ' || discharge time ' num2str(discharge_time)])
        %Q sidcharge
        plot(abs(Q_dis),'o','DisplayName','Q discharged [C], absolute value')
        xlabel('Cycle number')
        hold off
        legend('show','Location','best')
        ylabel('Q [C]')
        ylim([0 max([max(Q_dis) max(Q)])*1.1])
        title(['Charge time ' num2str(charge_time) ' || discharge time ' num2str(discharge_time)])
        subplot(3,1,3)
        hold on
        plot(Q+Q_dis,'DisplayName','Q_i^{charge}+Q_i^{discharge}')
        plot(2:numel(Q),Q(2:end)+Q_dis(1:end-1),'DisplayName','Q_{i+1}^{charge}+Q_i^{discharge}')
        percentage_line=plot([1 numel(Q)],0.05*[max([max(Q_dis) max(Q)]) max([max(Q_dis) max(Q)])],'LineStyle','--','DisplayName','5% of max value');
        plot([1 numel(Q)],-0.05*[max([max(Q_dis) max(Q)]) max([max(Q_dis) max(Q)])],'LineStyle','--','Color',percentage_line.Color,'DisplayName','5% of max value')
        plot([1 numel(Q)],[0 0],'--k','DisplayName','0')
        hold off
        legend('show','Location','best')
        xlabel('i')
        ylabel('Q [c]')
        set(gcf,'Units','normalized','Position',[0.25 0 0.5 .9])
        savefig(verification_figure,[where_to_save_output '\verification\' ' ' sample_name_ui.String ' verification' ' c' num2str(charge_time) ' d'  num2str(discharge_time) '.fig'])
        saveas(verification_figure,[where_to_save_output '\verification\' ' ' sample_name_ui.String ' verification' ' c' num2str(charge_time) ' d'  num2str(discharge_time)],'png')
    end
end
%end
%% writing the data to excel file
name_of_excel_data_file=[where_to_save_output '\' sample_name_ui.String ' ' charge_potential_ui.String 'V ' time_of_deposition_ui.String  ' hr ' 'data table.xlsx'];
writetable(final_data,name_of_excel_data_file,'Sheet','Data table')
where_to_save_output(find(where_to_save_output=='.'))='_';
%% building the heatmap data
charge_heat=unique(final_data.charge_time);
discharge_heat=unique(final_data.discharge_time);
[charge_mesh,discharge_mesh]=meshgrid(charge_heat,discharge_heat);
Q_charge_measured=zeros(numel(unique(final_data.charge_time)));
    if is_etac_checkbox.Value==0
    Q_discharge_measured=zeros(size(Q_charge_measured));
    end
for i=1:file_number
     for j1=1:numel(charge_heat) %going through all the x points and checking y point one by one to see i
         for j2=1:numel(discharge_heat)
             if and(charge_heat(j1)==final_data.charge_time(i),discharge_heat(j2)==final_data.discharge_time(i))
                 Q_charge_measured(j2,j1)=final_data.Q_charge_avg(i);
                 if is_etac_checkbox.Value==0
                     Q_discharge_measured(j2,j1)=final_data.Q_dis_avg(i);
                 end
                 h2_kg_day(j2,j1)=final_data.h2_kg_day(i);
             end
         end
     end
end

%  Q_charge_measured=Q_charge_measured';
%  Q_discharge_measured=Q_discharge_measured;
%  h2_kg_day=h2_kg_day';

%      find_x_ind=find(z1==x_mesh)
%      find_y_ind=find(z2==y_mesh)
%      second_level_ind=find(repmat(find_x_ind,1,4)==repmat(find_y_ind,1,4)')
%      first_level_ind=find_x_ind(second_level_ind)
%      z=final_data.Q_charge_avg(first_level_ind)

clear z1 z2 find_x_ind find_y_ind second_level_ind first_level_ind

size_z=size(Q_charge_measured);

%writing maximum Q value from z
check_file=exist([pwd '\max_q.xls']);
if check_file==2
    maxq=xlsread('max_q.xls');
    maxq(end+1)=max(max(Q_charge_measured));
    xlswrite('max_q.xls',maxq)
else
    maxq=max(max(Q_charge_measured));
    xlswrite('max_q.xls',maxq)
end

%% extrapulate by const discharge time
ntau_discharge=3;
Q_extrapulated=Q_charge_measured;
Q_measured_rows_number=size(Q_charge_measured,1);
Q_measured_columns_number=size(Q_charge_measured,2);
first_zero_row=find(Q_charge_measured(:,1)==0,1);
first_zero_column=find(Q_charge_measured(1,:)==0,1);
charge_times=unique(final_data.charge_time);
discharge_times=unique(final_data.discharge_time);
initial_tau_guess=max(charge_times)/4;
initial_Q_sat=max(max(Q_charge_measured));
fit_func_row=@(a,b,t) a*(1-exp(-(1/b)*t));
row_Q_sat=zeros(numel(charge_times),1)';
%row_tau=zeros(numel(charge_times),1)';
if extrapulate_by_rows_checkbox.Value
    end_of_rows_interpulation=Q_measured_rows_number ;
elseif extrapulate_by_rows_checkbox.Value==0
    end_of_rows_interpulation=first_zero_row;
end
    for row_number=1:end_of_rows_interpulation
        first_zero=find(Q_charge_measured(row_number,:)==0,1);
        % number_of_zeros=numel(first_zero:Q_measured_columns_number);
        %  Data for 'extrapulate by rows' fit:
        %      X Input : charge_times
        %      Y Output: maxq_extrapulated
        %  Output:
        %      fitresult : a fit object representing the fit.
        %      gof : structure with goodness-of fit info.
        warning off
        [xData_rows_extrapulate, yData_rows_extrapulate] = prepareCurveData( [0; charge_times], [0 Q_charge_measured(row_number,:)]);
        % Set up fittype and options.
        ft_rows_extrapulate = fittype( ['a*(1-exp(-(' num2str(ntau_discharge) '/b)*x))'], 'independent', 'x', 'dependent', 'y' );
        opts_rows_extrapulate = fitoptions( 'Method', 'NonlinearLeastSquares' );
        opts_rows_extrapulate.Display = 'Off';
        if exist('row_tau')
            low_tau_row=min(min(row_tau),charge_times(row_number));
        else
            low_tau_row=0;
        end
        opts_rows_extrapulate.Lower = [max(Q_charge_measured(row_number,:)) low_tau_row];
        opts_rows_extrapulate.StartPoint = [initial_Q_sat initial_tau_guess];
        if charge_times(row_number)<800
            opts_rows_extrapulate.Upper = [200 3200]; %upper values for Q_sat and tau    
        else
            opts_rows_extrapulate.Upper = [200 charge_times(row_number)*2]; %upper values for Q_sat and tau
        end
        weights=zeros(1,Q_measured_rows_number);
        weights(find(Q_charge_measured(row_number,:)))=1;
        excludedPoints = (yData_rows_extrapulate <= 0);
        excludedPoints(1)=0;
        opts_rows_extrapulate.Exclude = excludedPoints;
        % Fit model to data.
        [fitresult_rows_extrapulate, gof_rows_extrapulate] = fit( xData_rows_extrapulate, yData_rows_extrapulate, ft_rows_extrapulate, opts_rows_extrapulate );
        row_Q_sat(row_number)=fitresult_rows_extrapulate.a;
        row_tau(row_number)=fitresult_rows_extrapulate.b;
        for Q_measured_filling=first_zero:Q_measured_columns_number
            Q_measured_row_extrapulate(row_number,Q_measured_filling)=fit_func_row(row_Q_sat(row_number),row_tau(row_number),charge_times(Q_measured_filling)); %max(max(max(Q_measured(1:row_number,:)),
        end
        % plotting the fit
        if plot_extrapulate_by_rows_checkbox.Value
            figure
            hold on
            h = plot( fitresult_rows_extrapulate, xData_rows_extrapulate, yData_rows_extrapulate );
            annotation('textbox',[0.5 0.1 0.3 0.3],'FitBoxToText','on','BackgroundColor','w','String',{['Q_{saturated}=' num2str(fitresult_rows_extrapulate.a,2) ' C/cm^2'], ['\tau=' num2str(uint64(fitresult_rows_extrapulate.b),2) ' [s]'], ['R^2=' num2str(gof_rows_extrapulate.rsquare,4)]})
            hold off
            legend( h, 'Measured points', ['Q=' num2str(fitresult_rows_extrapulate.a,4) '*(1-exp(-' num2str(fitresult_rows_extrapulate.b,2) '*t)) , R^2=' num2str(gof_rows_extrapulate.rsquare,4)], 'Location', 'NorthEast' );
            % Label axes
            title([name_of_folder ' charging time: ' num2str(charge_times(row_number)) '[s]'])
            xlabel ('Discharge time [s]')
            ylabel ('charge [C]')
            grid on
        end
        Q_extrapulated(row_number,first_zero_column:end)=fit_func_row(row_Q_sat(row_number),row_tau(row_number),charge_times(first_zero_column:end));
    end

%% extrapulate by const discharge time
ntau_charge=2;
initial_Q_sat=50;
initial_tau_guess=1000;
fit_func_column=@(a,b,t) a*(1-exp(-(1/b)*t));
column_Q_sat=zeros(numel(charge_times),1)';
column_tau=zeros(numel(charge_times),1)';
if extrapulate_by_columns_checkbox.Value
    end_of_columns_interpulation=Q_measured_columns_number;
elseif extrapulate_by_columns_checkbox.Value==0
    end_of_columns_interpulation=first_zero_column-1;
end
    for column_number=1:end_of_columns_interpulation%Q_measured_columns_number
        % number_of_zeros=numel(first_zero:Q_measured_rows_number);
        %  Data for 'extrapulate by rows' fit:
        %      X Input : charge_times
        %      Y Output: maxq_extrapulated
        %  Output:
        %      fitresult : a fit object representing the fit.
        %      gof : structure with goodness-of fit info.
        %if Q_charge_measured(:,column_number)
        first_zero=find(Q_charge_measured(:,column_number)==0,1);
        [xData_columns_extrapulate, yData_columns_extrapulate] = prepareCurveData([0; charge_times],[0; Q_charge_measured(:,column_number)]);
        % Set up fittype and options.
        ft_columns_extrapulate = fittype([ 'a*(1-exp(-(' num2str(ntau_charge) '/b)*x))'], 'independent', 'x', 'dependent', 'y' );
        opts_columns_extrapulate = fitoptions( 'Method', 'NonlinearLeastSquares' );
        opts_columns_extrapulate.Display = 'Off';
        opts_columns_extrapulate.Lower = [0 0];
        opts_columns_extrapulate.StartPoint = [initial_Q_sat initial_tau_guess];
        weights=zeros(1,Q_measured_columns_number);
        weights(find(Q_charge_measured(:,column_number)))=1;
        %opts_rows_extrapulate.Weights =weights;
      %  if numel(find(Q_charge_measured(:,column_number)>0))>1
            excludedPoints = (yData_columns_extrapulate <= 0);
            excludedPoints(1)=0;
            opts_columns_extrapulate.Exclude = excludedPoints;
       % end
        % Fit model to data.
        [fitresult_columns_extrapulate, gof_columns_extrapulate] = fit( xData_columns_extrapulate,yData_columns_extrapulate, ft_columns_extrapulate, opts_columns_extrapulate );
        column_Q_sat(column_number)=fitresult_columns_extrapulate.a;
        column_tau(column_number)=fitresult_columns_extrapulate.b;
        
        % filling the empty cells in the line
%         for Q_measured_filling=first_zero:Q_measured_rows_number
%             Q_measured_column_extrapulate(column_number,Q_measured_filling)=fit_func_column(charge_times(Q_measured_filling));%max(max(max(Q_measured(:,1:column_number))
%         end
 
        % plotting the fit
        if plot_extrapulate_by_columns_checkbox.Value
            figure
            hold on
            h = plot( fitresult_columns_extrapulate, xData_columns_extrapulate, yData_columns_extrapulate );
            annotation('textbox',[0.5 0.1 0.3 0.3],'FitBoxToText','on','BackgroundColor','w','String',{['Q_{saturated}=' num2str(fitresult_columns_extrapulate.a,2) ' C/cm^2'], ['\tau=' num2str(uint64(fitresult_columns_extrapulate.b),2) ' [s]'], ['R^2=' num2str(gof_columns_extrapulate.rsquare,4)]})
            hold off
            legend( h, 'Measured points', ['Q=' num2str(fitresult_columns_extrapulate.a,4) '*(1-exp(- ' num2str(ntau_charge) ' /(' num2str(fitresult_columns_extrapulate.b,4) ' [s] )*t)) , R^2=' num2str(gof_columns_extrapulate.rsquare,4)], 'Location', 'NorthEast' );
            % Label axes
            title([name_of_folder ' ,discharge time: ' num2str(charge_times(column_number)) '[s]'])
            xlabel ('Charge time [s]')
            ylabel ('charge [C]')
            grid on
        end
        Q_extrapulated(first_zero_row:end,column_number)=fit_func_column(column_Q_sat(column_number),column_tau(column_number),charge_times(first_zero_row:end));
        %Q_extrapulated(end,column_number)=fit_func_column(column_Q_sat(column_number),column_tau(column_number),charge_times(column_number))
    end

%% preparing matrices for 3D fitting:
Q_charge_measured_fit=Q_charge_measured;
Q_charge_measured_fit(2:end+1,2:end+1)=Q_charge_measured_fit;
Q_charge_measured_fit(1,:)=0; Q_charge_measured_fit(:,1)=0;
Q_charge_measured_fit_exclude=zeros(size(Q_charge_measured_fit));
Q_charge_measured_fit_exclude(2:end,2:end)=Q_charge_measured==0;

Q_discharge_measured_fit=abs(Q_discharge_measured);
Q_discharge_measured_fit(2:end+1,2:end+1)=Q_discharge_measured_fit;
Q_discharge_measured_fit(1,:)=0; Q_discharge_measured_fit(:,1)=0;
Q_discharge_measured_fit_exclude=zeros(size(Q_discharge_measured_fit));
Q_discharge_measured_fit_exclude(2:end,2:end)=Q_discharge_measured==0;

Q_extrapulated_fit=Q_extrapulated;
Q_extrapulated_fit(2:end+1,2:end+1)=Q_extrapulated_fit;
Q_extrapulated_fit(1,:)=0; Q_extrapulated_fit(:,1)=0; 

charge_times_fit=[0;charge_times];

[x_Qc_extrapulated_fit_3D, y_Qc_extrapulated_fit_3D,z_Qc_extrapulated_fit_3D] = prepareSurfaceData( charge_times_fit, charge_times_fit, Q_extrapulated_fit );
fit_Qc_extrapulated_3D = fittype( 'Q_sat*(1-exp(-1/(tauc/(3*tc)+taud/(3*td))))', 'independent', {'tc', 'td'}, 'dependent', 'z' );
opts_Qc_extrapulated_3D = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts_Qc_extrapulated_3D.Display = 'Off';
opts_Qc_extrapulated_3D.Lower = [min(Q_charge_measured) 0 0];
opts_Qc_extrapulated_3D.StartPoint = [initial_Q_sat  initial_tau_guess initial_tau_guess];
opts_Qc_extrapulated_3D.Upper = [1000 5000 5000];
[fitresult_Qc_extrapulated_3D, gof_Qc_extrapulated_3D] = fit([x_Qc_extrapulated_fit_3D,y_Qc_extrapulated_fit_3D],z_Qc_extrapulated_fit_3D, fit_Qc_extrapulated_3D, opts_Qc_extrapulated_3D );

[x_Qc_fit_3D, y_Qc_fit_3D,z_Qc_fit_3D] = prepareSurfaceData( charge_times_fit, charge_times_fit, Q_charge_measured_fit );
fit_Qc_3D = fittype( 'Q_sat*(1-exp(-1/(tauc/(3*tc)+taud/(3*td))))', 'independent', {'tc', 'td'}, 'dependent', 'z' );
opts_Qc_3D = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts_Qc_3D.Display = 'Off';
opts_Qc_3D.Lower = [min(Q_charge_measured) 0 0];
opts_Qc_3D.StartPoint = [initial_Q_sat  initial_tau_guess initial_tau_guess];
opts_Qc_3D.Upper = [1000 5000 5000];
opts_Qc_3D.Exclude=excludedata(charge_times_fit, charge_times_fit,'indices',find(Q_charge_measured_fit_exclude));%Prepare excluded point for the format
[fitresult_Qc_3D, gof_Qc_3D] = fit([x_Qc_fit_3D,y_Qc_fit_3D],z_Qc_fit_3D, fit_Qc_3D, opts_Qc_3D );


if fit_3D_checkbox.Value==1
fit_3d_figure=figure;
fit_surf_plot=plot(fitresult_Qc_3D,[x_Qc_fit_3D,y_Qc_fit_3D],z_Qc_fit_3D,'Exclude',opts_Qc_3D.Exclude);
annotation('textbox','BackgroundColor','w','Position',[.8 .7 .2 .2],'String',{['Q_{sat}=' num2str(fitresult_Qc_3D.Q_sat) ' [C]'],['\tau_c=' num2str(fitresult_Qc_3D.tauc) ' [s]'],['\tau_d=' num2str(fitresult_Qc_3D.taud) ' [s]']},'FitBoxToText','on')
xlabel('Charging time [s]') ; ylabel('Discharging time [s]') ; zlabel('Charge [C]');
savefig(fit_3d_figure,[where_to_save_figures '' sample_name_ui.String ' 3d fit.fig'])
saveas(fit_3d_figure,[where_to_save_images ' ' sample_name_ui.String ' 3d fit'],'png')
end


tauc=fitresult_Qc_3D.tauc;
taud=fitresult_Qc_3D.taud;
Qsat=fitresult_Qc_3D.Q_sat;
fit_3d_function=@(t_c,t_d) Qsat*(1-exp(-1./(tauc./(3*t_c)+taud./(3*t_d))));
% preparation for Q discharge fit
% [x_Qd_fit_3D, y_Qd_fit_3D,z_Qd_fit_3D] = prepareSurfaceData( charge_times_fit, charge_times_fit, Q_discharge_measured_fit );
% fit_Qd_3D = fittype( 'Q_sat*(1-exp(-1/(tauc/tc+taud/td)))', 'independent', {'tc', 'td'}, 'dependent', 'z' );
% opts_Qd_3D = fitoptions( 'Method', 'NonlinearLeastSquares' );
% opts_Qd_3D.Display = 'Off';
% opts_Qd_3D.Lower = [min(Q_charge_measured) 0 0];
% opts_Qd_3D.StartPoint = [initial_Q_sat  initial_tau_guess initial_tau_guess];
% opts_Qd_3D.Upper = [1000 5000 5000];
% opts_Qd_3D.Exclude = Q_discharge_measured_fit_exclude;
% [fitresult_Qd_3D, gof_Qd_3D] = fit([x_Qd_fit_3D,y_Qd_fit_3D],z_Qd_fit_3D, fit_Qd_3D, opts_Qd_3D )

%% correcting the Q matrix
measured_charge_time_mesh=charge_mesh;
measured_discharge_time_mesh=discharge_mesh;
indices_to_extrapulate=find(Q_charge_measured==0);
Q_extrapulated=Q_charge_measured;
Q_extrapulated(indices_to_extrapulate)=fit_3d_function(measured_charge_time_mesh(indices_to_extrapulate),measured_discharge_time_mesh(indices_to_extrapulate));
Q_new=zeros(size(Q_extrapulated)+1);
Q_new(2:end,2:end)=Q_extrapulated;
% for correcting_Q_index=1:size(Q_charge_measured,1)
%     Q_new(correcting_Q_index+1,correcting_Q_index+1)=Q_charge_measured(correcting_Q_index,correcting_Q_index);
% end
% % find where are the zeros outside the main matrix.
% % first_index=size(Q_measured,1)*first_zero_column-2;
% % zero_indice=find(Q_measured==0)
% % [zero_indice_i,zero_indice_j]=ind2sub(size(Q_measured),zero_indice(find(find(Q_measured)>size(Q_measured,1)*first_zero_column-1)))
% zero_indice=[0 0];
% for ii=1:size(Q_charge_measured,1)
%     for jj=1:size(Q_charge_measured,2)
%         if Q_charge_measured(ii,jj)==0
%             zero_indice(end+1,1)=ii;
%             zero_indice(end,2)=jj;
%         end
%     end
% end
% zero_indice(1,:)=[];
% indice_to_delete=[];
% for ind=1:size(zero_indice,1)
%     if and(zero_indice(ind,1)>=first_zero_row,zero_indice(ind,2)>=first_zero_column) %this choose the 
%     else
%         indice_to_delete(end+1)=ind;
%     end
% end
% zero_indice(indice_to_delete,:)=[];

%% writing Q&tau to excel file
Q_tau_table=table(1,2,3,4,5,6,7,8,'VariableNames',{'times','Q_sat_by_charging_time','tau_by_charging_time','Q_sat_by_discharging_time','tau_by_discharging_time','deposition_time','sample_name','charge_potential'});
Q_tau_table.times(1:numel(charge_times))=charge_times;
Q_tau_table(1:end,2:5)=array2table([row_Q_sat; row_tau; column_Q_sat; column_tau]');
%Q_tau_table.sample_name=sample_name_ui.String;
Q_tau_table.deposition_time(1:end)=str2num(time_of_deposition_ui.String);
Q_tau_table.charge_potential(1:end)=str2num(charge_potential_ui.String);
writetable(Q_tau_table,[path_of_folder '\' sample_name_ui.String ' ' charge_potential_ui.String 'V ' time_of_deposition_ui.String  ' hr ' 'Q_tau_table.xlsx'])
%% plot the heat map
Q_figure=figure('Name','Q charged [C] - amount of charge facilitated for H2 production','Units','normalized','Position',[0.25 0.1 0.5 0.5]);
Q_tab=uipanel(Q_figure,'Position',[.9 .9 .1 .1]);
Q_main_axes=axes(Q_figure,'Position',[.05 .05 .85 .9]);

normalized_ui=uicontrol(Q_tab,'Style','checkbox','String','normalized','Units','normalized','Position',[0.1 0.1 0.8 0.8],'Value',1);
% adding 0
charge_heat=[0;unique(final_data.charge_time)];
discharge_heat=[0;unique(final_data.discharge_time)];
[charge_mesh,discharge_mesh]=meshgrid(charge_heat,discharge_heat); 
charge_time_matrix=charge_mesh(2:end,2:end);
discharge_time_matrix=discharge_mesh(2:end,2:end);
measured_x_points=charge_time_matrix(find(Q_charge_measured>0));
measured_y_points=discharge_time_matrix(find(Q_charge_measured>0));
hold on
if height_lines_checkbox.Value==1
    [q_heat_map_matrix,q_heat_map]=contourf(charge_mesh,discharge_mesh,Q_new,'Parent',Q_main_axes);
    clabel(q_heat_map_matrix,q_heat_map);
else
    contourf(charge_mesh,discharge_mesh,Q_new,'LineStyle','none','Parent',Q_main_axes);%,'LevelStep',round(max(max(Q_new)))*0.02);
end

scatter(measured_x_points,measured_y_points,'MarkerEdgeColor','w','Parent',Q_main_axes) %show the experimental points

qdata=Q_main_axes.Children(2).ZData;
if normalized_ui.Value==1
    Q_figure.Children(2).Children(2).ZData=Q_new/electrode_area;
end
hold off
charge_heat=unique(charge_heat);
discharge_heat=unique(discharge_heat);
title(figure_title)
xticks(charge_heat)
yticks(discharge_heat)
h = colorbar;
xlabel('Charge time [s]')
ylabel('Discharge time [s]')
xlabel(h, 'Charged Q [C]')
if plot_kg_day_checkbox.Value==1
    Q_figure.Children(3).Children(2).ZData(2:end,2:end)=h2_kg_day;
    %Q_figure.CurrentAxes.Children(2).ZData=Q_figure.CurrentAxes.Children(2).ZData(2:end,2:end)
    xlabel(h, 'Produced H_2 [Kg/day]')
    title([figure_title ' , H_2 production [Kg/day]'])
    Q_figure.Children(3).Children(2).XLim=[Q_figure.CurrentAxes.Children(2).XData(1,2) Q_figure.CurrentAxes.Children(2).XData(1,end)];
    Q_figure.Children(3).Children(2).YLim=[Q_figure.CurrentAxes.Children(2).YData(2,1) Q_figure.CurrentAxes.Children(2).YData(end,1)];
end
normalized_ui.Callback=['if normalized_ui.Value==1;','Q_figure.Children(3).Children(2).ZData=Q_new/electrode_area;h = colorbar;xlabel(h, ''Charged Q [C]'');','else;','Q_figure.Children(3).Children(2).ZData=Q_new;h = colorbar;xlabel(h, ''Charged Q [C]'');;end'];
%Q_figure.CurrentAxes.Children(2).LevelStep=str2num(num2str(max(max(Q_figure.CurrentAxes.Children(2).ZData)),2))*0.1;
%Q_figure.CurrentAxes.Children(2).LevelStep=1;
if save_Q_data.checkbox.Value==1
    save([path_of_folder '\' sample_name_ui.String ' Q_XData' '.mat'],'charge_mesh')
    save([path_of_folder '\' sample_name_ui.String ' Q_YData' '.mat'],'discharge_mesh')
    save([path_of_folder '\' sample_name_ui.String ' Q_ZDdata' '.mat'],'Q_new')
end

%% save the heat map figures
savefig(Q_figure,[where_to_save_figures ' ' sample_name_ui.String ' Q.fig'])
saveas(Q_figure,[where_to_save_images ' ' sample_name_ui.String ' Q'],'png')
%% plot the other heat maps
total_time_matrix=charge_time_matrix+discharge_time_matrix+demixing_time;
j=zeros(size_z(1)+1,size_z(2)+1);
j(2:end,2:end)=(Q_charge_measured./total_time_matrix)*1000;
j_charging=zeros(size_z(1)+1,size_z(2)+1);
j_charging(2:end,2:end)=(Q_charge_measured./charge_time_matrix)*1000;
if is_etac_checkbox.Value==0
    j_discharging=zeros(size_z(1)+1,size_z(2)+1);
    j_discharging(2:end,2:end)=(Q_discharge_measured./discharge_time_matrix*1000);    %mA
end
max_j=max(max(max(j),max(max(j_charging))));
%j=j'; j_charging=j_charging'; j_discharging=j_discharging'; %to correct the graphs!!!
    if plot_Js_checkbox.Value==1
    %Average J
    J_figure=figure('Name', 'Average J of charge and discharge cycles (H_2 and O_2 production)');
    if height_lines_checkbox.Value==1
        [j_heat_map_matrix,j_heat_map]=contourf(charge_mesh,discharge_mesh,j,'LevelStep',round(max(max(j)))*0.1);%,'LineStyle','none');
        clabel(j_heat_map_matrix,j_heat_map)
        title([figure_title ', Average J'])
        xticks(charge_heat)
        yticks(discharge_heat)
        xlabel('Charge time [s]')
        ylabel('Discharge time [s]')
        h_j = colorbar;
        h_j.Ticks=[0:round(max(max(j)))*0.1:floor(max(max(j))), max(max(j))];
        h_j.TickLabels=[0:round(max(max(j)))*0.1:floor(max(max(j))), max(max(j))];
        xlabel(h_j, 'Average current density [mA/cm^2]')
        set(gca,'XLim',[100 800],'YLim',[100 800])
    else
        [j_heat_map_matrix,j_heat_map]=contourf(charge_mesh,discharge_mesh,j,'LevelStep',round(max(max(j)))*0.02,'LineStyle','none');
        title([figure_title ', Average J'])        
        xticks(charge_heat)
        yticks(discharge_heat)
        xlabel('Charge time [s]')
        ylabel('Discharge time [s]')
        set(gca,'XLim',[100 800],'YLim',[100 800])
        h_j = colorbar;
        xlabel(h_j, 'Average current density [mA/cm^2]')
    end
    savefig(J_figure,[where_to_save_figures ' ' sample_name_ui.String ' J.fig'])
    saveas(J_figure,[where_to_save_images ' ' sample_name_ui.String ' J'],'png')
    J_figure.Position(1)=0.4;
    
    % J charging step
    J_charging_figure=figure('Name', 'Average J of charge cycles (H_2 production)');
    if height_lines_checkbox.Value==1
        hold on
        [j_charging_heat_map_matrix,j_charging_heat_map]=contourf(charge_mesh,discharge_mesh,j_charging,'LevelStep',round(max(max(j_charging)))*0.1);%,'LineStyle','none');
        clabel(j_charging_heat_map_matrix,j_charging_heat_map)
        hold off
        title([figure_title ', Average J, charging step'])
        xticks(charge_heat)
        yticks(discharge_heat)
        xlabel('Charge time [s]')
        ylabel('Discharge time [s]')
        h_j_h2 = colorbar;
        h_j_h2.Ticks=[0:round(max(max(j_charging)))*0.1:floor(max(max(j_charging))), max(max(j_charging))];
        xlabel(h_j_h2, 'Average current density at charging step [mA/cm^2]')
        set(gca,'XLim',[100 800],'YLim',[100 800])
        box on
    else
        [j_charging_heat_map_matrix,j_charging_heat_map]=contourf(charge_mesh,discharge_mesh,j_charging,'LevelStep',round(max(max(j_charging)))*0.02,'LineStyle','none');
        title([figure_title ', Average J, charging step'])
        xticks(charge_heat)
        yticks(discharge_heat)
        xlabel('Charge time [s]')
        ylabel('Discharge time [s]')
        h_j_h2 = colorbar;
        xlabel(h_j_h2, 'Average current density at charging step [mA/cm^2]')
        set(gca,'XLim',[100 800],'YLim',[100 800])
    end
    gcf.Position(1)=0.7;
    savefig(J_charging_figure,[where_to_save_figures ' ' sample_name_ui.String ' J charging step.fig'])
    saveas(J_charging_figure,[where_to_save_images ' ' sample_name_ui.String ' J charging step'],'png')

% J discharging step
    if is_etac_checkbox.Value==0
        J_discharging_figure=figure('Name', 'Average J of charge cycles (H_2 production)');
        if height_lines_checkbox.Value==1
            hold on
            [j_discharging_heat_map_matrix,j_discharging_heat_map]=contourf(charge_mesh,discharge_mesh,abs(j_discharging),'LevelStep',round(abs(min(min(j_discharging))))*0.1);%,'LineStyle','none');
            clabel(j_discharging_heat_map_matrix,j_discharging_heat_map)
            hold off
            title([figure_title ', Average J, discharging step'])
            xticks(charge_heat)
            yticks(discharge_heat)
            xlabel('Charge time [s]')
            ylabel('Discharge time [s]')
            h_j_h2 = colorbar;
            %h_j_h2.Ticks=[0:round(max(max(j_discharging)))*0.1:floor(max(max(j_discharging))), max(max(j_discharging))];
            xlabel(h_j_h2, 'Average current density at charging step [mA/cm^2]')
            set(gca,'XLim',[100 800],'YLim',[100 800])
            box on
        else
            [j_discharging_heat_map_matrix,j_discharging_heat_map]=contourf(charge_mesh,discharge_mesh,j_discharging,'LevelStep',round(max(max(j_discharging)))*0.02,'LineStyle','none');
            title([figure_title ', Average J, discharging step'])
            xticks(charge_heat)
            yticks(discharge_heat)
            xlabel('Charge time [s]')
            ylabel('Discharge time [s]')
            h_j_h2 = colorbar;
            xlabel(h_j_h2, 'Average current density at discharging step [mA/cm^2]')
            set(gca,'XLim',[100 800],'YLim',[100 800])
        end
        gcf.Position(1)=0.7;
        savefig(J_discharging_figure,[where_to_save_figures ' ' sample_name_ui.String ' J discharging step.fig'])
        saveas(J_discharging_figure,[where_to_save_images ' ' sample_name_ui.String ' J discharging step'],'png')
    end
    end
%% getting the diagonal
diago=[0 0];
for i=1:file_number
     if final_data.charge_time(i)==final_data.discharge_time(i)
         diago(end+1,1)=final_data.charge_time(i);
         diago(end,2)=final_data.Q_charge_avg(i);
     else
     end
end
xdiago=diago(:,1);
ydiago=diago(:,2);
diago=array2table(diago,'VariableNames',[{'time','Q'}]);

%% diagonal values fit
initial_tau_guess=max(charge_times)/4;
initial_Q_sat=max(max(Q_charge_measured));
    [xData_diag, yData_diag] = prepareCurveData( xdiago, ydiago );
    ft_diag = fittype( 'a*(1-exp(-(1/b)*x))', 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.Lower = [0 0];
    opts.StartPoint = [initial_Q_sat initial_tau_guess];
    opts.Upper = [1000 5000];
    % Fit model to data.
    [fitresult_diag, gof_diag] = fit( xData_diag, yData_diag, ft_diag, opts );
    Q_sat=fitresult_diag.a;
    % Plot fit with data.
    fit_func_diag=@(a,b,t) a*(1-exp(-(1/b)*t));
if fit_diag_checkbox.Value==1
    fit_figure=figure( 'Name', name_of_folder );
    hold on
    h = plot( fitresult_diag, xData_diag, yData_diag );
    annotation('textbox',[0.5 0.1 0.3 0.3],'FitBoxToText','on','BackgroundColor','w','String',{['Q_{saturated}=' num2str(fitresult_diag.a,'% .2f') ' C/cm^2'], ['\tau=' num2str(uint64(fitresult_diag.b),2) ' [s]'], ['R^2=' num2str(gof_diag.rsquare,4)]})
    hold off
    legend( h, 'Measured points', ['Q=' num2str(fitresult_diag.a,4) '*(1-exp(-' num2str(fitresult_diag.b,2) '*t)) , R^2=' num2str(gof_diag.rsquare,4)],'Location','NorthEast');
    % Label axes
    title(name_of_folder)
    xlabel ('dis\charge time [s]')
    ylabel ('charge [C]')
    xticks(charge_times)
    grid on
    if save_fit_figure.Value==1
    savefig(fit_figure,[where_to_save_figures ' ' sample_name_ui.String ' diagonal fit.fig'])
	saveas(fit_figure,[where_to_save_images ' ' sample_name_ui.String ' diagonal fit'],'png')
    end
end

%% Q normalized to Q sat
if plot_Q_norm_to_sat_checkbox.Value==1
    Q_normalized_to_Qsat=Q_new./Q_sat;
    Q_norm_to_sat_figure=figure('Name','Charge normalized to interpolated Q_saturation');
    hold on
    if height_lines_checkbox.Value==1
        [q_heat_map_matrix,q_heat_map]=contourf(charge_mesh,discharge_mesh,Q_normalized_to_Qsat);
        clabel(q_heat_map_matrix,q_heat_map);
    else
        contourf(charge_mesh,discharge_mesh,Q_normalized_to_Qsat,'LineStyle','none');
        shading interp
    end
    scatter(measured_x_points,measured_y_points,'MarkerEdgeColor','w');
    hold off
    charge_heat=unique(charge_heat);
    discharge_heat=unique(discharge_heat);
    title([figure_title ' Q normalized to Q saturation'])
    xticks(charge_heat)
    yticks(discharge_heat)
    xlabel('Charge time [s]')
    ylabel('Discharge time [s]')
    caxis([0 1])
    h_sat = colorbar;
    xlabel(h_sat, 'Charged Q [C]')
if save_Q_norm_to_Qsat_figure.Value==1
	savefig(Q_norm_to_sat_figure,[where_to_save_figures ' ' sample_name_ui.String ' Q normalized to Q sat.fig'])
	saveas(Q_norm_to_sat_figure,[where_to_save_images ' ' sample_name_ui.String ' Q normalized to Q sat'],'png')
end
end
%% Q normalized to Q max
if plot_Q_norm_to_max_checkbox.Value==1
Q_norm_to_max_figure=figure('Name','Charge normalized to interpolated Q_saturation');
Q_normalized_to_Qmax=Q_new./max(max(Q_new));
hold on
if height_lines_checkbox.Value==0
    contourf(charge_mesh,discharge_mesh,Q_normalized_to_Qmax,'LineStyle','none','LevelStep',round(max(max(Q_normalized_to_Qmax)))*0.02);
else
    [q_heat_map_matrix,q_heat_map]=contourf(charge_mesh,discharge_mesh,Q_normalized_to_Qmax,'LevelStep',round(max(max(Q_normalized_to_Qmax)))*0.1);
    clabel(q_heat_map_matrix,q_heat_map);
end
scatter(measured_x_points,measured_y_points,'MarkerEdgeColor','w')
hold off
charge_heat=unique(charge_heat);
discharge_heat=unique(discharge_heat);
title([figure_title ' Q normalized to Q maximum'])
xticks(charge_heat)
yticks(discharge_heat)
xlabel('Charge time [s]')
ylabel('Discharge time [s]')
h_max = colorbar;
xlabel(h_max, 'Charged Q [C]')
if save_Q_norm_to_Qsat_figure.Value==1
	savefig(Q_norm_to_max_figure,[where_to_save_figures ' ' sample_name_ui.String ' Q normalized to Q max.fig'])
	saveas(Q_norm_to_max_figure,[where_to_save_images ' ' sample_name_ui.String ' Q normalized to Q max'],'png')
end
end


%% open the data table
if show_final_data_checkbox.Value==1
    show_table_figure=uifigure;
    show_table_table=uitable('Parent',show_table_figure,'Data',final_data,'Position',get(show_table_figure,'Position'));
    show_table_table.Position(1:2)=0;
end
%% saving the data in organized way
Q_excel=array2table(Q_new);
R_parameter=Q_sat/tauc*60; %[C/min]
R_table=table(Qsat,tauc,R_parameter)
writetable(R_table,name_of_excel_data_file,'Sheet','R parameter');
if exist('RemoveSheet123')~=0
    RemoveSheet123(name_of_excel_data_file);
end
%% delete all the function files
delete apply_caxis.m caxis_tool.m get_last_gcf.m get_last_ui_position.m unify_figure_files.m vars.mat
%% show Q&tau for different measurements

% qtau_opts=fitoptions( 'Method', 'NonlinearLeastSquares' );
% qtau_opts.Display = 'Off';
% qtau_opts.Lower = [0 0];
% qtau_opts.StartPoint = [initial_Q_sat initial_tau_guess];
% qtau_opts.Upper = [1000 5000];
% ft_qtau_q = fittype( 'q_sat*(1-exp(-(1/tau)*x))', 'independent', 'x', 'dependent', 'y');
% ft_qtau_q_linear = fittype( 'a*x+b', 'independent', 'x', 'dependent', 'y');
% clear fit_qtau_qchrg fit_qtau_qdischrg fit_qtau_time
% fit_qtau_time=charge_times;
% fit_qtau_qchrg=Q_tau_table.Q_sat_by_charging_time;
% fit_qtau_qdischrg=Q_tau_table.Q_sat_by_discharging_time;
% 
% [fitresult_qtau_qchrg, gof_qtau_qchrg] = fit( fit_qtau_time, fit_qtau_qchrg, ft_qtau_q,qtau_opts);
% [fitresult_qtau_disqchrg, gof_qtau_disqchrg] = fit( fit_qtau_time, fit_qtau_qdischrg, ft_qtau_q,qtau_opts);
% 
% fit_qsat_figure=figure;
% fit_function=@(a,b,t) a*(1-exp(-t/b));
% t_for_calc_plots=linspace(0,Q_tau_table.times(end),1000);
% hold on
% q_sat_by_chrg_plot=plot(Q_tau_table.times,Q_tau_table.Q_sat_by_charging_time,'o-','DisplayName','Q_{sat} fitted by constant charging time calculated');
% q_sat_by_chrg_plot_calc=plot(t_for_calc_plots,fit_function(fitresult_qtau_qchrg.q_sat,fitresult_qtau_qchrg.tau,t_for_calc_plots),'--','DisplayName','Q_{sat} fitted by constant charging time','Color',q_sat_by_chrg_plot.Color);
% 
% q_sat_by_dischrg_plot=plot(Q_tau_table.times,Q_tau_table.Q_sat_by_discharging_time,'o-','DisplayName','Q_{sat} fitted by constant discharging time');
% q_sat_by_dischrg_plot_calc=plot(t_for_calc_plots,fit_function(fitresult_qtau_disqchrg.q_sat,fitresult_qtau_disqchrg.tau,t_for_calc_plots),'--','DisplayName','Q_{sat} fitted by constant discharging time - calculated','Color',q_sat_by_dischrg_plot.Color);
% 
% q_sat_by_diag_plot=plot(Q_tau_table.times,fit_func_diag(fitresult_diag.a,fitresult_diag.b,Q_tau_table.times),'o-','DisplayName','Q_{sat} fitted by the diagonal');
% q_sat_by_diag_plot_calc=plot(t_for_calc_plots,fit_function(fitresult_diag.a,fitresult_diag.b,t_for_calc_plots),'--','DisplayName','Q_{sat} fitted by gradient','Color',q_sat_by_diag_plot.Color);
% legend show
% xticks(Q_tau_table.times)
% xlabel 'time of charging [s]'
% ylabel 'Charge [C]'
% hold off
% savefig(fit_qsat_figure,[where_to_save_figures 'fitting figure.fig'])
% 
