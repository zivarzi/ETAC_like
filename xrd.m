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
offset=500;
[allpl alpha_slid y_slider ax pl a_check boh2_check booh_check gooh_check ni_check]=plot_offset(offset,xrd_data,number_of_files,file_name);
function names=disappear(names,vis);
names=findobj('DisplayName',names);
    for i=1:size(names,1)
        if vis==1
            names(i).Visible='on';
        else
            names(i).Visible='off';
    end
    end
end
%% functions

function [allpl alpha_slid y_slider ax pl a_check boh2_check booh_check gooh_check ni_check]=plot_offset(offset,xrd_data,number_of_files,file_name)
fig=figure;
ax=axes(fig,'Units','normalized','Position',[.07 .07 0.7 0.82],'Title','axes');
hold on
for i=1:number_of_files
    pl(i)=plot(xrd_data(:,1,i),smooth(xrd_data(:,2,i))-min(xrd_data(:,2,1))+(i-1)*offset,'DisplayName',file_name{i}(1:end-4));
    xrd_names(i)={pl(i).DisplayName};
end
set(gca,'YTickLabel',{})
xlabel('\theta')
ylabel('intensity [A.U.]')
y_callback=['yval=y_slider.Value;' newline...
            'n=size(allpl.Children,1)-number_of_files;' newline...
            'for i=1:n' newline...
            'allpl.Children(i).YData(2)=yval;end;' newline...
            ''];
y_slider=uicontrol(fig,'Style','slider','Min',0,'Max',max(max(xrd_data(:,2,:)))*1.5,'Value',max(max(xrd_data(:,2,:))),'units','normalized','Position',[0.05 0.94 0.4 0.05],'Callback',y_callback);
alph=0.5;
alpha_callback=['alph=alpha_slid.Value;'...
                'n=size(allpl.Children,1)-number_of_files;' newline...
                'for i=1:n' newline...
                'allpl.Children(i).Color(4)=alph;end'];
alpha_slid=uicontrol(fig,'Style','slider','Min',0,'Max',1,'Value',0.5,'units','normalized','Position',[0.55 0.94 0.4 0.05],'Callback',alpha_callback);
allpl=plot_jcpds(alph,max(xrd_data(:,2)));
hold on
autummn=autumn(number_of_files);
for i=1:number_of_files
    pl(i)=plot(xrd_data(:,1,i),smooth(xrd_data(:,2,i))-min(xrd_data(:,2,1))+(i-1)*offset,'DisplayName',file_name{i}(1:end-4),'Color',autummn(i,:));
    xrd_names(i)={pl(i).DisplayName};
end
comap=lines(5);
phase_panel=uipanel(fig,'units','normalized','Position',[0.8 0.2 0.18 0.6]);
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


% function refresh_alpha(alph)
%     pl_a_oh2.Color(4)=alph;
%     pl_b_oh2.Color(4)=alph;
%     pl_b_ooh.Color(4)=alph;
%     pl_g_ooh.Color(4)=alph;
%     pl_ni.Color(4)=alph;
% end

function gcaa=plot_jcpds(alpha_val,max_I,nameofcurve,cmap,plotx,ploty)
a_oh2_line='-.';
b_oh2_line=':';
b_ooh_line='--';
g_ooh_line='-';
ni_line='-';

if nargin==1
    cmap=colormap(lines);
    %[plotx,ploty]=import_xray(nameofcurve);
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

