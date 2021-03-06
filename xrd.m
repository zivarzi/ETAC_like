clear xrd_data xrd_data_raw

FID = fopen('disappear.m','w');
fprintf(FID,'%s\n',...
['function names=disappear(names,vis);' ...
"names=findobj('DisplayName',names);"  ...
"    for i=1:size(names,1)"  ...
"        if vis==1"  ...
"            names(i).Visible='on';"  ...
"        else"  ...
"            names(i).Visible='off';"  ...
"        end"  ...
"    end"  ...
"    end"]);
fclose(FID);

if exist('disappear')==0
    msgbox('Make sure disappear.m file is in your folder')
end
clear
[file_name file_path]=uigetfile('*.ras','MultiSelect','on');
if iscell(file_name)==0
    number_of_files=1;
else
   number_of_files=size(file_name,2); 
end
for i=1:number_of_files
    if number_of_files>1
    FID=fopen([file_path file_name{i}]);
    else
    FID=fopen([file_path file_name]);
    end
    xrd_raw_data=fscanf(FID,'%c');
    fclose(FID);
    txtind=strfind(xrd_raw_data,'*RAS_INT_START')+size('*RAS_INT_START',2);
        while isempty(str2num(xrd_raw_data(txtind)))
            txtind=txtind+1;
        end
	txtind_end=strfind(xrd_raw_data,'*RAS_INT_END')-1;
	xrd_temp=str2num(xrd_raw_data(txtind:txtind_end));
    xrd_data(i).file_number=i;
    xrd_data(i).theta=xrd_temp(2:end,1);
    xrd_data(i).intensity=xrd_temp(2:end,2);
    clear xrd_temp
end
offset=500;
%% k
[allpl alpha_slid y_slider ax pl a_check boh2_check booh_check gooh_check ni_check...
    offset_slider max_slider min_slider this max_text min_text]=plot_offset(offset,xrd_data,number_of_files,file_name);

%% functions

function [allpl alpha_slid y_slider ax pl a_check boh2_check booh_check gooh_check ni_check offset_slider max_slider min_slider this max_text min_text]=plot_offset(offset,xrd_data,number_of_files,file_name)
fig=figure;%('CloseRequestFcn',"delete 'disappear.m'");
ax=axes(fig,'Units','normalized','Position',[.07 .07 0.7 0.82],'Title','axes');
hold on
for i=1:number_of_files
    if number_of_files>1
    pl(i)=plot(xrd_data(i).theta,smooth(xrd_data(i).intensity)-min(xrd_data(i).intensity)+(i-1)*offset,'DisplayName',file_name{i}(1:end-4));
    else
    pl(i)=plot(xrd_data(i).theta,smooth(xrd_data(i).intensity)-min(xrd_data(i).intensity)+(i-1)*offset,'DisplayName',file_name(1:end-4));
    end
    xrd_names(i)={pl(i).DisplayName};
    max_intensity(i)=max(xrd_data(i).intensity);
    pl(i).Visible='off';
    mintheta=xrd_data(i).theta(find(sort(xrd_data(i).theta)>0,1));
    maxtheta=sort(xrd_data(i).theta(end));
end
mintheta=min(mintheta);
maxtheta=max(maxtheta);
max_intensity=max(max_intensity);
set(gca,'YTickLabel',{})
xlabel('\theta')
ylabel('intensity [A.U.]')

all_btn_callback=['disappear(''\alpha phase Ni{(OH)}_2'',1);a_check.Value=1;' newline ...
                 'disappear(''\beta phase Ni{(OH)}_2'',1);boh2_check.Value=1;' newline ...
                 'disappear(''\beta phase NiOOH'',1);booh_check.Value=1;' newline ...
                 'disappear(''\gamma phase NiOOH'',1);gooh_check.Value=1;' newline ...
                 'disappear(''Ni'',1);ni_check.Value=1;'];

none_btn_callback=['disappear(''\alpha phase Ni{(OH)}_2'',0);a_check.Value=0;' newline ...
                 'disappear(''\beta phase Ni{(OH)}_2'',0);boh2_check.Value=0;' newline ...
                 'disappear(''\beta phase NiOOH'',0);booh_check.Value=0;' newline ...
                 'disappear(''\gamma phase NiOOH'',0);gooh_check.Value=0;' newline ...
                 'disappear(''Ni'',0);ni_check.Value=0;'];
clear gca; this=gca;             
all_btn=uicontrol(fig,'Units','normalized','Style','pushbutton','String','All','Position',[0.8 0.8 0.1 0.1],'Callback',all_btn_callback);
none_btn=uicontrol(fig,'Units','normalized','Style','pushbutton','String','None','Position',[0.9 0.8 0.1 0.1],'Callback',none_btn_callback);

maxi=maxtheta;mini=mintheta;

max_text=uicontrol(fig,'Style','text','String',num2str(maxtheta),'units','normalized','Position',[0.8 0.2 0.19 0.05]);
max_slider=uicontrol(fig,'Style','slider','Min',mini,'Max',maxtheta,'Value',maxtheta,'units','normalized','Position',[0.8 0.15 0.19 0.05],'Callback','maxi=max_slider.Value; this.XLim(2)=maxi;max_text.String=num2str(maxi);');%min_slider.Max=maxi;');
min_text=uicontrol(fig,'Style','text','String',num2str(mintheta),'units','normalized','Position',[0.8 0.1 0.19 0.05],'Callback','min_slider.Value=str2num(inputdlg)');
min_slider=uicontrol(fig,'Style','slider','Min',mintheta,'Max',maxi,'Value',mintheta,'units','normalized','Position',[0.8 0.05 0.19 0.05],'Callback','mini=min_slider.Value; this.XLim(1)=mini;min_text.String=num2str(mini);');%max_slider.Min=mini');

offset_callback=['  n=size(allpl.Children,1)-number_of_files;' newline...
            '  for i=n+2:size(allpl.Children,1)' newline...
            '    allpl.Children(i).YData=allpl.Children(i).YData-(i-n-1)*offset;' newline...
            '  end' newline...
            'offset=offset_slider.Value;' newline...
            '  for i=n+2:size(allpl.Children,1)' newline...
            '    allpl.Children(i).YData=allpl.Children(i).YData+(i-n-1)*offset;' newline...
            '  end' newline...
            ''];
offset_slider=uicontrol(fig,'Style','slider','Min',0,'Max',max_intensity*1.5,'Value',500,'units','normalized','Position',[0.05 0.9 0.3 0.05],'Callback',offset_callback);
offset_text=uicontrol(fig,'Units','normalized','Position',[0 0.95 0.4 0.05],'Style','text','String','XRD patterns offset');

y_callback=['yval=y_slider.Value;' newline...
            'n=size(allpl.Children,1)-number_of_files;' newline...
            'for i=1:n' newline...
            'allpl.Children(i).YData(2)=yval;end' newline...
            ''];
y_slider=uicontrol(fig,'Style','slider','Min',0,'Max',max_intensity*1.5,'Value',max_intensity,'units','normalized','Position',[0.4 0.9 0.3 0.05],'Callback',y_callback);
y_text=uicontrol(fig,'Units','normalized','Position',[0.4 0.95 0.3 0.05],'Style','text','String','phases lines height');

alph=0.5;
alpha_callback=['alph=alpha_slid.Value;'...
                'n=size(allpl.Children,1)-number_of_files;' newline...
                'for i=number_of_files+1:n' newline...
                'allpl.Children(i).Color(4)=alph;' newline....
                'end'];
alpha_slid=uicontrol(fig,'Style','slider','Min',0,'Max',1,'Value',0.5,'units','normalized','Position',[0.8 0.9 0.2 0.05],'Callback',alpha_callback);
alpha_text=uicontrol(fig,'Units','normalized','Position',[0.7 0.95 0.4 0.05],'Style','text','String','phases lines opacity');
allpl=plot_jcpds(alph,max(xrd_data(i).intensity));
hold on
autummn=autumn(number_of_files);
for i=1:number_of_files
    if number_of_files>1
    pl(i)=plot(xrd_data(i).theta,smooth(xrd_data(i).intensity)-min(xrd_data(i).intensity)+(i-1)*offset,'DisplayName',file_name{i}(1:end-4));
    else
    pl(i)=plot(xrd_data(i).theta,smooth(xrd_data(i).intensity)-min(xrd_data(i).intensity)+(i-1)*offset,'DisplayName',file_name(1:end-4));
    end
    xrd_names(i)={pl(i).DisplayName};
end

comap=lines(5);
phase_panel=uipanel(fig,'units','normalized','Position',[0.8 0.3 0.18 0.5]);
%a_check_cb=["acv=a_check.Value; disappear('\alpha phase Ni{(OH)}_2',acv)"];
a_check=uicontrol(phase_panel,'Units','normalized','Position',[0.05 0.9 0.9 0.1],'Style','checkbox','String','alpha OH2 phase','Value',1);
a_check.Callback="acv=a_check.Value; disappear('\alpha phase Ni{(OH)}_2',acv);";
boh2_check=uicontrol(phase_panel,'Units','normalized','Position',[0.05 0.7 0.9 0.1],'Style','checkbox','String','b OH2 phase','Value',1);
boh2_check.Callback="boh2v=boh2_check.Value; disappear('\beta phase Ni{(OH)}_2',boh2v);";
booh_check=uicontrol(phase_panel,'Units','normalized','Position',[0.05 0.5 0.9 0.1],'Style','checkbox','String','b OOH phase','Value',1);
booh_check.Callback="boohv=booh_check.Value; disappear('\beta phase NiOOH',boohv);";
gooh_check=uicontrol(phase_panel,'Units','normalized','Position',[0.05 0.3 0.9 0.1],'Style','checkbox','String','g OOH phase','Value',1);
gooh_check.Callback="goohv=gooh_check.Value; disappear('\gamma phase NiOOH',goohv);";
ni_check=uicontrol(phase_panel,'Units','normalized','Position',[0.05 0.1 0.9 0.1],'Style','checkbox','String','Ni phase','Value',1);
ni_check.Callback="niv=ni_check.Value; disappear('Ni',niv);";
end

function gcaa=plot_jcpds(alpha_val,max_I,nameofcurve,cmap,plotx,ploty)
a_oh2_line='-.';
b_oh2_line=':';
b_ooh_line='--';
g_ooh_line='-';
ni_line='-';

if nargin==1
    cmap=colormap(lines);
    max_I=500;
    load('jcpds.mat')
    hold on
    num_a_oh_2=numel(jcpds.alpha_OH_2.twotheta);
    num_b_oh_2=numel(jcpds.beta_OH_2.twotheta);
    num_b_ooh=numel(jcpds.beta_OOH_.twotheta);
    num_g_ooh=numel(jcpds.gamma_OOH_.twotheta);
    for i=1:num_a_oh_2
        x=jcpds.alpha_OH_2.twotheta(i); 
        pl_a_oh2(i)=plot([x x],[0 max_I],a_oh2_line,'Color',cmap(1,:),'DisplayName','\alpha phase Ni{(OH)}_2');
        pl_a_oh2(i).Color(4)=alpha_val;
    end
    alpha(alpha_val)
    for i=1:num_b_oh_2
        x=jcpds.beta_OH_2.twotheta(i);
        pl_b_oh2(i)=plot([x x],[0 max_I],b_oh2_line,'Color',cmap(2,:),'DisplayName','\beta phase Ni{(OH)}_2');
        pl_b_oh2(i).Color(4)=alpha_val;
    end
    alpha(alpha_val)
    for i=1:num_b_ooh
        x=jcpds.beta_OOH_.twotheta(i);
        pl_b_ooh(i)=plot([x x],[0 max_I],b_ooh_line,'Color',cmap(3,:),'DisplayName','\beta phase NiOOH');
        pl_b_ooh(i).Color(4)=alpha_val;
    end
    alpha(alpha_val)
        for i=1:num_g_ooh
        x=jcpds.gamma_OOH_.twotheta(i);
        pl_g_ooh(i)=plot([x x],[0 max_I],g_ooh_line,'Color',cmap(4,:),'DisplayName','\gamma phase NiOOH');
        pl_g_ooh(i).Color(4)=alpha_val;
        end
    
    for i=1:numel(jcpds.ni.twotheta)
    pl_ni=plot([jcpds.ni.twotheta(i) jcpds.ni.twotheta(i)],[0 max_I],ni_line,'Color',cmap(5,:),'DisplayName','Ni');
    end
    pl_ni.Color(4)=alpha_val;
    leg_jcpds=legendlegend([pl_a_oh2(1) pl_b_oh2(1) pl_b_ooh(1) pl_g_ooh(1) pl_ni],pl_a_oh2(1).DisplayName...
        ,pl_b_oh2(2).DisplayName,pl_b_ooh(3).DisplayName,pl_g_ooh(4).DisplayName,pl_ni.DisplayName);
    
   % plot(plotx,ploty,'DisplayName',nameofcurve)
    hold off
elseif nargin==2
    %[plotx,ploty]=import_xray();
    %max_I=max(ploty)*0.9;
    cmap=colormap(lines(9));
    load('jcpds.mat')
    hold on
    num_a_oh_2=numel(jcpds.alpha_OH_2.twotheta);
    num_b_oh_2=numel(jcpds.beta_OH_2.twotheta);
    num_b_ooh=numel(jcpds.beta_OOH_.twotheta);
    num_g_ooh=numel(jcpds.gamma_OOH_.twotheta);
    for i=1:num_a_oh_2
        x=jcpds.alpha_OH_2.twotheta(i);
        pl_a_oh2(i)=plot([x x],[0 max_I],a_oh2_line,'Color',cmap(1,:),'DisplayName','\alpha phase Ni{(OH)}_2');
        pl_a_oh2(i).Color(4)=alpha_val;
    end
    alpha(alpha_val)
    for i=1:num_b_oh_2
        x=jcpds.beta_OH_2.twotheta(i);
        pl_b_oh2(i)=plot([x x],[0 max_I],b_oh2_line,'Color',cmap(2,:),'DisplayName','\beta phase Ni{(OH)}_2');
        pl_b_oh2(i).Color(4)=alpha_val;
    end
    alpha(alpha_val)
    for i=1:num_b_ooh
        x=jcpds.beta_OOH_.twotheta(i);
        pl_b_ooh(i)=plot([x x],[0 max_I],b_ooh_line,'Color',cmap(3,:),'DisplayName','\beta phase NiOOH');
        pl_b_ooh(i).Color(4)=alpha_val;
    end
        for i=1:num_g_ooh
        x=jcpds.gamma_OOH_.twotheta(i);
        pl_g_ooh(i)=plot([x x],[0 max_I],g_ooh_line,'Color',cmap(4,:),'DisplayName','\gamma phase NiOOH');
        pl_g_ooh(i).Color(4)=alpha_val;
        end
    alpha(alpha_val)
    for i=1:numel(jcpds.ni.twotheta)
    pl_ni=plot([jcpds.ni.twotheta(i) jcpds.ni.twotheta(i)],[0 max_I],ni_line,'Color',cmap(5,:),'DisplayName','Ni');
    pl_ni.Color(4)=alpha_val;
    end
    leg_jcpds=legend([pl_a_oh2(1) pl_b_oh2(1) pl_b_ooh(1) pl_g_ooh(1) pl_ni],pl_a_oh2(1).DisplayName...
        ,pl_b_oh2(2).DisplayName,pl_b_ooh(3).DisplayName,pl_g_ooh(4).DisplayName,pl_ni.DisplayName);

   % plot(plotx,ploty,'DisplayName',nameofcurve)
    hold off
elseif nargin==3
    cmap=colormap(lines(6));
    %max_I=max(ploty)*0.9;
    load('jcpds.mat')
    hold on
    num_a_oh_2=numel(jcpds.alpha_OH_2.twotheta);
    num_b_oh_2=numel(jcpds.beta_OH_2.twotheta);
    num_b_ooh=numel(jcpds.beta_OOH_.twotheta);
    num_g_ooh=numel(jcpds.gamma_OOH_.twotheta);
    for i=1:num_a_oh_2
        x=jcpds.alpha_OH_2.twotheta(i);
        pl_a_oh2(i)=plot([x x],[0 max_I],a_oh2_line,'Color',cmap(1,:),'DisplayName','\alpha phase Ni{(OH)}_2');
        pl_a_oh2(i).Color(4)=alpha_val;
    end
    for i=1:num_b_oh_2
        x=jcpds.beta_OH_2.twotheta(i);
        pl_b_oh2(i)=plot([x x],[0 max_I],b_oh2_line,'Color',cmap(2,:),'DisplayName','\beta phase Ni{(OH)}_2');
        pl_b_oh2(i).Color(4)=alpha_val;
    end
    for i=1:num_b_ooh
        x=jcpds.beta_OOH_.twotheta(i);
        pl_b_ooh(i)=plot([x x],[0 max_I],b_ooh_line,'Color',cmap(3,:),'DisplayName','\beta phase NiOOH');
        pl_b_ooh(i).Color(4)=alpha_val;
    end
        for i=1:num_g_ooh
        x=jcpds.gamma_OOH_.twotheta(i);
        pl_g_oog(i)=plot([x x],[0 max_I],g_ooh_line,'Color',cmap(4,:),'DisplayName','\gamma phase NiOOH');
        pl_g_ooh(i).Color(4)=alpha_val;
        end

    for i=1:numel(jcpds.ni.twotheta)
    pl_ni=plot([jcpds.ni.twotheta(i) jcpds.ni.twotheta(i)],[0 max_I],ni_line,'Color',cmap(5,:),'DisplayName','Ni');
    pl_ni.Color(4)=alpha_val;
    end
    leg_jcpds=legend([pl_a_oh2(1) pl_b_oh2(1) pl_b_ooh(1) pl_g_oog(1) pl_ni],pl_a_oh2(1).DisplayName...
        ,pl_b_oh2(2).DisplayName,pl_b_ooh(3).DisplayName,pl_g_oog(4).DisplayName,pl_ni.DisplayName);
    %plot(plotx,ploty,"--",'DisplayName',nameofcurve)
    hold off
end
gcaa=gca;
end