clc;
clearvars -except fun_type;
if ~exist('fun_type', 'var')
    error('main_calculate_railway_resilience_under_typhoon:MissingFunType', ...
        'Set the scalar variable fun_type before running this script.');
end

%% load source data
script_dir = fileparts(mfilename('fullpath'));
package_root = fileparts(script_dir);
source_path = [fullfile(package_root, 'source_data') filesep];
result_path = [fullfile(package_root, 'result_data') filesep];
load(strcat(source_path,'pro_railway_system.mat'),'railway_system');
load(strcat(source_path,'model_para.mat'),'model_para');
load(strcat(source_path,'rail_net_time.mat'),'rail_net_time');
load(strcat(source_path,'rail_city.mat'),'rail_city');

% calculate city to city travel time under each train outage scenario
%% use original method
if fun_type==1
    load(strcat(source_path,'typhoon_train_outage.mat'),'typhoon_train_outage');
    for k=1:size(typhoon_train_outage,1)
        train_outage=typhoon_train_outage{k,1};
        for d=1:length(train_outage(1,:))
            dam_train=train_outage(:,d);
            if sum(dam_train)>0
                real_city_city_time=rail_city2city_time_given_disruption(rail_net_time,rail_city,train_outage(:,d));
                save(strcat(result_path,'current_typhoon/org_city_city_time_t',num2str(k),'_d',num2str(d),'.mat'),'city_city_time');
            end
        end
    end
end

%% use simplified method
if fun_type==201
    load(strcat(source_path,'current_typhoon_train_outage.mat'),'typhoon_train_outage');
    load(strcat(source_path,'current_sim_TC_id.mat'),'sim_TC_id');
    typhoon_train_outage=typhoon_train_outage(sim_TC_id);
    load(strcat(result_path,'norm_city_city_time.mat'),'city_city_time');norm_city_city_time=city_city_time;
    load(strcat(result_path,'norm_city_route_pass.mat'),'city_route_pass');
    for k=1:200%size(typhoon_train_outage,1)
        k
        train_outage=typhoon_train_outage{k,1};
        if ~isempty(train_outage)
            for d=1:length(train_outage(1,:))
                dam_train=train_outage(:,d);
                if sum(dam_train)>0
                    real_city_city_time=rail_city2city_time_given_disruption_impact(model_para,rail_net_time,rail_city,dam_train,city_route_pass,norm_city_city_time);
                    save(strcat(result_path,'current_typhoon_rule/city_city_time_t',num2str(k),'_d',num2str(d),'.mat'),'real_city_city_time');
                end
            end
        end
    end
end

if fun_type==202
    load(strcat(source_path,'future_typhoon_train_outage_ssp585_7010_sim.mat'),'typhoon_train_outage');
%     load(strcat(source_path,'current_sim_TC_id.mat'),'sim_TC_id');
%     typhoon_train_outage=typhoon_train_outage(sim_TC_id);
    load(strcat(result_path,'norm_city_city_time.mat'),'city_city_time');norm_city_city_time=city_city_time;
    load(strcat(result_path,'norm_city_route_pass.mat'),'city_route_pass');
    for k=1931:2000%size(typhoon_train_outage,1)
        k
        train_outage=typhoon_train_outage{k,1};
        if ~isempty(train_outage)
            for d=1:length(train_outage(1,:))
                dam_train=train_outage(:,d);
                if sum(dam_train)>0
                    real_city_city_time=rail_city2city_time_given_disruption_impact(model_para,rail_net_time,rail_city,dam_train,city_route_pass,norm_city_city_time);
                    save(strcat(result_path,'future_typhoon_ssp585_7010_sim/city_city_time_t',num2str(k),'_d',num2str(d),'.mat'),'real_city_city_time');
                end
            end
        end
    end
end

if fun_type==203
    load(strcat(source_path,'future_typhoon_train_outage.mat'),'typhoon_train_outage');
    load(strcat(source_path,'future_sim_TC_id.mat'),'sim_TC_id');
    typhoon_train_outage=typhoon_train_outage(sim_TC_id);
    load(strcat(source_path,'future_typhoon_station_outage_sim.mat'),'typhoon_station_outage');
    load(strcat(result_path,'norm_city_city_time.mat'),'city_city_time');norm_city_city_time=city_city_time;
    load(strcat(result_path,'norm_city_route_pass.mat'),'city_route_pass');
    for k=1:200%size(typhoon_train_outage,1)
        k
        train_outage=typhoon_train_outage{k,1};
        station_outage=typhoon_station_outage{k,1};
        if ~isempty(train_outage)
            for d=1:length(train_outage(1,:))
                dam_train=train_outage(:,d);
                dam_station=station_outage(:,d);
                if sum(dam_train)>0
                    real_city_city_time=rail_city2city_time_given_disruption_impact_partial_outage(model_para,rail_net_time,rail_city,dam_train,dam_station,city_route_pass,norm_city_city_time);
                    save(strcat(result_path,'future_typhoon_rule_2/city_city_time_t',num2str(k),'_d',num2str(d),'.mat'),'real_city_city_time');
                end
            end
        end
    end
end

if fun_type==204
    load(strcat(source_path,'current_typhoon_train_outage.mat'),'typhoon_train_outage');
    load(strcat(source_path,'current_sim_TC_id.mat'),'sim_TC_id');
    typhoon_train_outage=typhoon_train_outage(sim_TC_id);
    load(strcat(source_path,'current_typhoon_station_outage_sim.mat'),'typhoon_station_outage');
    load(strcat(result_path,'norm_city_city_time.mat'),'city_city_time');norm_city_city_time=city_city_time;
    load(strcat(result_path,'norm_city_route_pass.mat'),'city_route_pass');
    for k=1:200%size(typhoon_train_outage,1)
        k
        train_outage=typhoon_train_outage{k,1};
        station_outage=typhoon_station_outage{k,1};
        if ~isempty(train_outage)
            for d=1:length(train_outage(1,:))
                dam_train=train_outage(:,d);
                dam_station=station_outage(:,d);
                if sum(dam_train)>0
                    real_city_city_time=rail_city2city_time_given_disruption_impact_partial_outage(model_para,rail_net_time,rail_city,dam_train,dam_station,city_route_pass,norm_city_city_time);
                    save(strcat(result_path,'current_typhoon_rule_2/city_city_time_t',num2str(k),'_d',num2str(d),'.mat'),'real_city_city_time');
                end
            end
        end
    end
end


%% use simplified method for future typhoon
if fun_type==3
    load(strcat(source_path,'future_typhoon_train_outage_sim.mat'),'typhoon_train_outage');
    load(strcat(result_path,'norm_city_city_time.mat'),'city_city_time');norm_city_city_time=city_city_time;
    load(strcat(result_path,'norm_city_route_pass.mat'),'city_route_pass');
    for k=1:size(typhoon_train_outage,1)
        k
        train_outage=typhoon_train_outage{k,1};
        if ~isempty(train_outage)
            for d=1:length(train_outage(1,:))
                dam_train=train_outage(:,d);
                if sum(dam_train)>0
                    real_city_city_time=rail_city2city_time_given_disruption_impact(model_para,rail_net_time,rail_city,dam_train,city_route_pass,norm_city_city_time);
                    save(strcat(result_path,'future_typhoon/city_city_time_t',num2str(k),'_d',num2str(d),'.mat'),'real_city_city_time');
                end
            end
        end
    end
end

%% estimate the error at city-scale and system-scale for current typhoon
% Note: no unreachable OD pair under current typhoon
if fun_type==4
    load(strcat(source_path,'current_typhoon_train_outage_sim.mat'),'typhoon_train_outage');
    load(strcat(source_path,'city_center.mat'),'city_center');
    load(strcat(result_path,'norm_city_city_time.mat'),'city_city_time');norm_city_city_time=city_city_time;
    load(strcat(source_path,'city_TF_mat.mat'),'city_TF_mat');
    city_set=unique(rail_city(:,1));
    city_TF_mat=city_TF_mat(city_set,city_set);
    city_center=city_center(city_set,:);
    dam_fun=cell(length(typhoon_train_outage(1,:)),6); %average travel time; proportion of affected OD pairs, average travel time delay of affected OD pairs; (system,city_scale)
    for k=1:size(typhoon_train_outage,1)
        k
        train_outage=typhoon_train_outage{k,1};
        if ~isempty(train_outage)
            %  calculate functionality
            dam_sys_fun=zeros(length(train_outage(1,:)),1);
            dam_city_fun=zeros(length(city_set),length(train_outage(1,:)));
            dam_sys_OD=zeros(length(train_outage(1,:)),1);
            dam_city_OD=zeros(length(city_set),length(train_outage(1,:)));
            dam_sys_OD_time=zeros(length(train_outage(1,:)),1);
            dam_city_OD_time=zeros(length(city_set),length(train_outage(1,:)));
            for d=1:length(train_outage(1,:))
                dam_train=train_outage(:,d);
                if sum(dam_train)>0
                    load(strcat(result_path,'current_typhoon/city_city_time_t',num2str(k),'_d',num2str(d),'.mat'),'real_city_city_time');
                    %                     real_city_city_time=real_city_city_time;
                else
                    real_city_city_time=norm_city_city_time;
                end
                % calculate sys_fun, city_fun, province_fun, and ecomonic_fun
                dam_sys_fun(d)=sum(real_city_city_time(norm_city_city_time~=inf).*city_TF_mat(norm_city_city_time~=inf))/sum(city_TF_mat(norm_city_city_time~=inf));
                for c=1:length(city_set)
                    dam_city_fun(c,d)=sum(real_city_city_time(c,norm_city_city_time(c,:)~=inf).*city_TF_mat(c,norm_city_city_time(c,:)~=inf))/sum(city_TF_mat(c,norm_city_city_time(c,:)~=inf));
                end
                delay_time=real_city_city_time-norm_city_city_time;
                dam_sys_OD(d)=sum(city_TF_mat(delay_time>0))/sum(sum(city_TF_mat));
                if sum(city_TF_mat(delay_time>0))==0
                    dam_sys_OD_time(d)=0;
                else
                    dam_sys_OD_time(d)=sum(city_TF_mat(delay_time>0).*delay_time(delay_time>0))/sum(city_TF_mat(delay_time>0));
                end
                for c=1:length(city_set)
                    dam_city_OD(c,d)=sum(city_TF_mat(c,delay_time(c,:)>0))/sum(city_TF_mat(c,:));
                    if sum(city_TF_mat(c,delay_time(c,:)>0))==0
                        dam_city_OD_time(c,d)=0;
                    else
                        dam_city_OD_time(c,d)=sum(city_TF_mat(c,delay_time(c,:)>0).*delay_time(c,delay_time(c,:)>0))/sum(city_TF_mat(c,delay_time(c,:)>0));
                    end
                end
            end
            dam_fun{k,1}=dam_sys_fun;
            if isnan(dam_sys_fun)
                [k d dam_sys_fun]
                break;
            end
            dam_fun{k,2}=dam_city_fun;
            dam_fun{k,3}=dam_sys_OD;
            dam_fun{k,4}=dam_sys_OD_time;
            dam_fun{k,5}=dam_city_OD;
            dam_fun{k,6}=dam_city_OD_time;
        end
    end
    save(strcat(result_path,'current_dam_fun_OD.mat'),'dam_fun');
    
    % calculate normal functionality
    norm_city_fun=zeros(length(city_set),1);
    norm_pro_fun=zeros(max(city_center(:,8)),1);
    norm_eco_fun=zeros(max(city_center(:,7)),1);
    norm_sys_fun=sum(norm_city_city_time(norm_city_city_time~=inf).*city_TF_mat(norm_city_city_time~=inf))/sum(city_TF_mat(norm_city_city_time~=inf));
    for c=1:length(city_set)
        norm_city_fun(c)=sum(norm_city_city_time(c,norm_city_city_time(c,:)~=inf).*city_TF_mat(c,norm_city_city_time(c,:)~=inf))/sum(city_TF_mat(c,norm_city_city_time(c,:)~=inf));
    end
    for c=1:max(city_center(:,8))
        norm_province_time=norm_city_city_time(city_center(:,8)==c,:);
        province_TF_mat=city_TF_mat(city_center(:,8)==c,:);
        norm_pro_fun(c)=sum(norm_province_time(norm_province_time~=inf).*province_TF_mat(norm_province_time~=inf))/sum(province_TF_mat(norm_province_time~=inf));
    end
    for c=1:max(city_center(:,7))
        norm_province_time=norm_city_city_time(city_center(:,7)==c,:);
        province_TF_mat=city_TF_mat(city_center(:,7)==c,:);
        norm_eco_fun(c)=sum(norm_province_time(norm_province_time~=inf).*province_TF_mat(norm_province_time~=inf))/sum(province_TF_mat(norm_province_time~=inf));
    end
    save(strcat(result_path,'norm_sys_fun.mat'),'norm_sys_fun');
    save(strcat(result_path,'norm_city_fun.mat'),'norm_city_fun');
    save(strcat(result_path,'norm_pro_fun.mat'),'norm_pro_fun');
    save(strcat(result_path,'norm_eco_fun.mat'),'norm_eco_fun');
    
    % calculate resilience loss
    sys_RL=0;
    city_RL=zeros(length(city_set),1);
    province_RL=zeros(max(city_center(:,8)),1);
    ecozone_RL=zeros(max(city_center(:,7)),1);
    for k=1:size(typhoon_train_outage,1)
        train_outage=typhoon_train_outage{k,1};
        if ~isempty(train_outage)
            dam_sys_fun=dam_fun{k,1};
            dam_city_fun=dam_fun{k,2};
            dam_pro_time=dam_fun{k,3};
            dam_eco_time=dam_fun{k,4};
            sys_RL=sum(dam_sys_fun-norm_sys_fun)+sys_RL;
            if isnan(sys_RL)
                break;
            end            
            city_RL=sum(dam_city_fun-repmat(norm_city_fun,1,length(train_outage(1,:))),2)+city_RL;
        end
    end
end

%% estimate the error at city-scale and system-scale for future typhoon
if fun_type==5
    load(strcat(source_path,'future_typhoon_train_outage_ssp245_7010_sim.mat'),'typhoon_train_outage');
%     load(strcat(source_path,'future_sim_TC_id.mat'),'sim_TC_id');
%     typhoon_train_outage=typhoon_train_outage(sim_TC_id);
    load(strcat(source_path,'city_center.mat'),'city_center');
    load(strcat(source_path,'city_TF_mat.mat'),'city_TF_mat');
    load(strcat(result_path,'norm_city_city_time.mat'),'city_city_time');norm_city_city_time=city_city_time;
    load(strcat(result_path,'norm_sys_fun.mat'),'norm_sys_fun');
    load(strcat(result_path,'norm_city_fun.mat'),'norm_city_fun');
    load(strcat(result_path,'norm_pro_fun.mat'),'norm_pro_fun');
    load(strcat(result_path,'norm_eco_fun.mat'),'norm_eco_fun');
    city_set=unique(rail_city(:,1));
    city_TF_mat=city_TF_mat(city_set,city_set);
    city_center=city_center(city_set,:);
    dam_sys_fun=cell(length(typhoon_train_outage(1,:)),3);
    dam_city_fun=cell(length(typhoon_train_outage(1,:)),12);
    dam_pro_fun=cell(length(typhoon_train_outage(1,:)),12);
    dam_eco_fun=cell(length(typhoon_train_outage(1,:)),12);
    mark_delay_OD=city_TF_mat*0;
    for k=1:2000
        k
        train_outage=typhoon_train_outage{k,1};
        if ~isempty(train_outage)
            dam_city_city_time=cell(length(train_outage(1,:)),1);
            for d=1:length(train_outage(1,:))
                dam_train=train_outage(:,d);
                if sum(dam_train)>0
                    load(strcat(result_path,'future_typhoon_ssp585_7010_sim/city_city_time_t',num2str(k),'_d',num2str(d),'.mat'),'real_city_city_time');
                    dam_city_city_time{d}=real_city_city_time;
                else
                    dam_city_city_time{d}=norm_city_city_time;
                end
            end
            % get the unreachale day for each OD pair
            unreach_start=zeros(length(city_set),length(city_set));
            unreach_end=zeros(length(city_set),length(city_set));
            for m=1:length(city_set)
                for n=1:length(city_set)
                    if (m~=n)&&norm_city_city_time(m,n)~=inf
                        reach_temp=zeros(length(train_outage(1,:)),1);
                        for d=1:length(train_outage(1,:))
                            real_city_city_time=dam_city_city_time{d};
                            if real_city_city_time(m,n)==inf
                                reach_temp(d)=1;
                            end
                        end
                        if ~isempty(find(reach_temp==1, 1))
                            unreach_start(m,n)=find(reach_temp==1, 1 );
                            unreach_end(m,n)=find(reach_temp==1, 1, 'last' );
                        end
                    end
                end
            end
            % add the unreachale day to the city_city_time and calculate fun
            dam_sys_time=zeros(length(train_outage(1,:)),1);
            dam_city_time=zeros(length(city_set),length(train_outage(1,:)));
            dam_pro_time=zeros(max(city_center(:,8)),length(train_outage(1,:)));
            dam_eco_time=zeros(max(city_center(:,7)),length(train_outage(1,:)));
            dam_sys_OD=zeros(length(train_outage(1,:)),1);
            dam_city_OD=zeros(length(city_set),length(train_outage(1,:)));
            dam_city_OD_30=zeros(length(city_set),length(train_outage(1,:)));
            dam_city_OD_60=zeros(length(city_set),length(train_outage(1,:)));
            dam_city_OD_120=zeros(length(city_set),length(train_outage(1,:)));
            dam_city_OD_180=zeros(length(city_set),length(train_outage(1,:)));
            dam_city_OD_240=zeros(length(city_set),length(train_outage(1,:)));
            dam_city_OD_300=zeros(length(city_set),length(train_outage(1,:)));
            dam_city_OD_360=zeros(length(city_set),length(train_outage(1,:)));
            dam_sys_OD_time=zeros(length(train_outage(1,:)),1);
            dam_city_OD_time=zeros(length(city_set),length(train_outage(1,:)));
            dam_city_OD_time_2=zeros(length(city_set),length(train_outage(1,:)));
            dam_city_OD_time_3=zeros(length(city_set),length(train_outage(1,:)));
            
            dam_pro_OD=zeros(max(city_center(:,8)),length(train_outage(1,:)));
            dam_pro_OD_30=zeros(max(city_center(:,8)),length(train_outage(1,:)));
            dam_pro_OD_60=zeros(max(city_center(:,8)),length(train_outage(1,:)));
            dam_pro_OD_120=zeros(max(city_center(:,8)),length(train_outage(1,:)));
            dam_pro_OD_180=zeros(max(city_center(:,8)),length(train_outage(1,:)));
            dam_pro_OD_240=zeros(max(city_center(:,8)),length(train_outage(1,:)));
            dam_pro_OD_300=zeros(max(city_center(:,8)),length(train_outage(1,:)));
            dam_pro_OD_360=zeros(max(city_center(:,8)),length(train_outage(1,:)));
            dam_pro_OD_time=zeros(max(city_center(:,8)),length(train_outage(1,:)));
            dam_pro_OD_time_2=zeros(max(city_center(:,8)),length(train_outage(1,:)));
            dam_pro_OD_time_3=zeros(max(city_center(:,8)),length(train_outage(1,:)));
            
            dam_eco_OD=zeros(max(city_center(:,7)),length(train_outage(1,:)));
            dam_eco_OD_30=zeros(max(city_center(:,7)),length(train_outage(1,:)));
            dam_eco_OD_60=zeros(max(city_center(:,7)),length(train_outage(1,:)));
            dam_eco_OD_120=zeros(max(city_center(:,7)),length(train_outage(1,:)));
            dam_eco_OD_180=zeros(max(city_center(:,7)),length(train_outage(1,:)));
            dam_eco_OD_240=zeros(max(city_center(:,7)),length(train_outage(1,:)));
            dam_eco_OD_300=zeros(max(city_center(:,7)),length(train_outage(1,:)));
            dam_eco_OD_360=zeros(max(city_center(:,7)),length(train_outage(1,:)));
            dam_eco_OD_time=zeros(max(city_center(:,7)),length(train_outage(1,:)));
            dam_eco_OD_time_2=zeros(max(city_center(:,7)),length(train_outage(1,:)));
            dam_eco_OD_time_3=zeros(max(city_center(:,7)),length(train_outage(1,:)));
            
            delay_temp(k)=length(find(unreach_start>0));
            for d=1:length(train_outage(1,:))
                real_city_city_time=dam_city_city_time{d};
                [a,b]=find(unreach_start>0&unreach_start<=d&unreach_end>=d);
                for n=1:length(a)
                    day_temp=unreach_end(a(n),b(n))-d+1;
                    real_city_city_time(a(n),b(n))=norm_city_city_time(a(n),b(n))+day_temp*1440;
                end
                % calculate sys_fun, city_fun, province_fun, and ecomonic_fun
                delay_time=real_city_city_time-norm_city_city_time;
                mark_delay_OD(delay_time>0)=1;
                dam_sys_OD(d)=sum(city_TF_mat(delay_time>0))/sum(sum(city_TF_mat));
                if sum(city_TF_mat(delay_time>0))==0
                    dam_sys_OD_time(d)=0;
                else
                    dam_sys_OD_time(d)=sum(city_TF_mat(delay_time>0).*delay_time(delay_time>0))/sum(city_TF_mat(delay_time>0));
                end
                dam_sys_time(d)=sum(real_city_city_time(norm_city_city_time~=inf).*city_TF_mat(norm_city_city_time~=inf))/sum(city_TF_mat(norm_city_city_time~=inf));
                
                for c=1:length(city_set)
                    dam_city_time(c,d)=sum(real_city_city_time(c,norm_city_city_time(c,:)~=inf).*city_TF_mat(c,norm_city_city_time(c,:)~=inf))/sum(city_TF_mat(c,norm_city_city_time(c,:)~=inf));
                    
                    dam_city_OD(c,d)=sum(city_TF_mat(c,delay_time(c,:)>0))/sum(city_TF_mat(c,:));
                    dam_city_OD_30(c,d)=sum(city_TF_mat(c,delay_time(c,:)>=30))/sum(city_TF_mat(c,:));
                    dam_city_OD_60(c,d)=sum(city_TF_mat(c,delay_time(c,:)>=60))/sum(city_TF_mat(c,:));
                    dam_city_OD_120(c,d)=sum(city_TF_mat(c,delay_time(c,:)>=120))/sum(city_TF_mat(c,:));
                    dam_city_OD_180(c,d)=sum(city_TF_mat(c,delay_time(c,:)>=180))/sum(city_TF_mat(c,:));
                    dam_city_OD_240(c,d)=sum(city_TF_mat(c,delay_time(c,:)>=240))/sum(city_TF_mat(c,:));
                    dam_city_OD_300(c,d)=sum(city_TF_mat(c,delay_time(c,:)>=300))/sum(city_TF_mat(c,:));
                    dam_city_OD_360(c,d)=sum(city_TF_mat(c,delay_time(c,:)>=360))/sum(city_TF_mat(c,:));
                    if sum(city_TF_mat(c,delay_time(c,:)>0))==0
                        dam_city_OD_time(c,d)=0;
                        dam_city_OD_time_2(c,d)=0;
                        dam_city_OD_time_3(c,d)=0;
                    else
                        dam_city_OD_time(c,d)=sum(city_TF_mat(c,delay_time(c,:)>0).*delay_time(c,delay_time(c,:)>0))/sum(city_TF_mat(c,delay_time(c,:)>0));
                        dam_city_OD_time_2(c,d)=sum(city_TF_mat(c,delay_time(c,:)>0).*delay_time(c,delay_time(c,:)>0));
                        dam_city_OD_time_3(c,d)=sum(city_TF_mat(c,delay_time(c,:)>0).*delay_time(c,delay_time(c,:)>0))/sum(city_TF_mat(c,:));
                    end
                end
                
                
                for c=1:max(city_center(:,8))
                    real_province_time=real_city_city_time(city_center(:,8)==c,:);
                    norm_province_time=norm_city_city_time(city_center(:,8)==c,:);
                    province_TF_mat=city_TF_mat(city_center(:,8)==c,:);
                    province_delay_time=delay_time(city_center(:,8)==c,:);
                    dam_pro_time(c,d)=sum(real_province_time(norm_province_time~=inf).*province_TF_mat(norm_province_time~=inf))/sum(province_TF_mat(norm_province_time~=inf));
                    
                    dam_pro_OD(c,d)=sum(province_TF_mat(province_delay_time>0))/sum(sum(province_TF_mat));
                    dam_pro_OD_30(c,d)=sum(province_TF_mat(province_delay_time>30))/sum(sum(province_TF_mat));
                    dam_pro_OD_60(c,d)=sum(province_TF_mat(province_delay_time>60))/sum(sum(province_TF_mat));
                    dam_pro_OD_120(c,d)=sum(province_TF_mat(province_delay_time>120))/sum(sum(province_TF_mat));
                    dam_pro_OD_180(c,d)=sum(province_TF_mat(province_delay_time>180))/sum(sum(province_TF_mat));
                    dam_pro_OD_240(c,d)=sum(province_TF_mat(province_delay_time>240))/sum(sum(province_TF_mat));
                    dam_pro_OD_300(c,d)=sum(province_TF_mat(province_delay_time>300))/sum(sum(province_TF_mat));
                    dam_pro_OD_360(c,d)=sum(province_TF_mat(province_delay_time>360))/sum(sum(province_TF_mat));
                    if sum(province_TF_mat(province_delay_time>0))==0
                        dam_pro_OD_time(c,d)=0;
                        dam_pro_OD_time_2(c,d)=0;
                        dam_pro_OD_time_3(c,d)=0;
                    else
                        dam_pro_OD_time(c,d)=sum(province_TF_mat(province_delay_time>0).*province_delay_time(province_delay_time>0))/sum(province_TF_mat(province_delay_time>0));
                        dam_pro_OD_time_2(c,d)=sum(province_TF_mat(province_delay_time>0).*province_delay_time(province_delay_time>0));
                        dam_pro_OD_time_3(c,d)=sum(province_TF_mat(province_delay_time>0).*province_delay_time(province_delay_time>0))/sum(sum(province_TF_mat));
                    end
                end
                
                
                for c=1:max(city_center(:,7))
                    real_eco_time=real_city_city_time(city_center(:,7)==c,:);
                    norm_eco_time=norm_city_city_time(city_center(:,7)==c,:);
                    eco_TF_mat=city_TF_mat(city_center(:,7)==c,:);
                    eco_delay_time=delay_time(city_center(:,7)==c,:);
                    dam_eco_time(c,d)=sum(real_eco_time(norm_eco_time~=inf).*eco_TF_mat(norm_eco_time~=inf))/sum(eco_TF_mat(norm_eco_time~=inf));
                    
                    dam_eco_OD(c,d)=sum(eco_TF_mat(eco_delay_time>0))/sum(sum(eco_TF_mat));
                    dam_eco_OD_30(c,d)=sum(eco_TF_mat(eco_delay_time>30))/sum(sum(eco_TF_mat));
                    dam_eco_OD_60(c,d)=sum(eco_TF_mat(eco_delay_time>60))/sum(sum(eco_TF_mat));
                    dam_eco_OD_120(c,d)=sum(eco_TF_mat(eco_delay_time>120))/sum(sum(eco_TF_mat));
                    dam_eco_OD_180(c,d)=sum(eco_TF_mat(eco_delay_time>180))/sum(sum(eco_TF_mat));
                    dam_eco_OD_240(c,d)=sum(eco_TF_mat(eco_delay_time>240))/sum(sum(eco_TF_mat));
                    dam_eco_OD_300(c,d)=sum(eco_TF_mat(eco_delay_time>300))/sum(sum(eco_TF_mat));
                    dam_eco_OD_360(c,d)=sum(eco_TF_mat(eco_delay_time>360))/sum(sum(eco_TF_mat));
                    if sum(eco_TF_mat(eco_delay_time>0))==0
                        dam_eco_OD_time(c,d)=0;
                        dam_eco_OD_time_2(c,d)=0;
                        dam_eco_OD_time_3(c,d)=0;
                    else
                        dam_eco_OD_time(c,d)=sum(eco_TF_mat(eco_delay_time>0).*eco_delay_time(eco_delay_time>0))/sum(eco_TF_mat(eco_delay_time>0));
                        dam_eco_OD_time_2(c,d)=sum(eco_TF_mat(eco_delay_time>0).*eco_delay_time(eco_delay_time>0));
                        dam_eco_OD_time_3(c,d)=sum(eco_TF_mat(eco_delay_time>0).*eco_delay_time(eco_delay_time>0))/sum(sum(eco_TF_mat));
                    end
                end
            end
            dam_sys_fun{k,1}=dam_sys_time;
            dam_sys_fun{k,2}=dam_sys_OD;
            dam_sys_fun{k,3}=dam_sys_OD_time;
            
            dam_city_fun{k,1}=dam_city_time;
            dam_city_fun{k,2}=dam_city_OD;
            dam_city_fun{k,3}=dam_city_OD_time;
            dam_city_fun{k,4}=dam_city_OD_30;
            dam_city_fun{k,5}=dam_city_OD_60;
            dam_city_fun{k,6}=dam_city_OD_120;
            dam_city_fun{k,7}=dam_city_OD_180;
            dam_city_fun{k,8}=dam_city_OD_240;
            dam_city_fun{k,9}=dam_city_OD_300;
            dam_city_fun{k,10}=dam_city_OD_360;
            dam_city_fun{k,11}=dam_city_OD_time_2;
            dam_city_fun{k,12}=dam_city_OD_time_3;
            
            dam_pro_fun{k,1}=dam_pro_time;
            dam_pro_fun{k,2}=dam_pro_OD;
            dam_pro_fun{k,3}=dam_pro_OD_time;
            dam_pro_fun{k,4}=dam_pro_OD_30;
            dam_pro_fun{k,5}=dam_pro_OD_60;
            dam_pro_fun{k,6}=dam_pro_OD_120;
            dam_pro_fun{k,7}=dam_pro_OD_180;
            dam_pro_fun{k,8}=dam_pro_OD_240;
            dam_pro_fun{k,9}=dam_pro_OD_300;
            dam_pro_fun{k,10}=dam_pro_OD_360;
            dam_pro_fun{k,11}=dam_pro_OD_time_2;
            dam_pro_fun{k,12}=dam_pro_OD_time_3;
            
            
            dam_eco_fun{k,1}=dam_eco_time;
            dam_eco_fun{k,2}=dam_eco_OD;
            dam_eco_fun{k,3}=dam_eco_OD_time;
            dam_eco_fun{k,4}=dam_eco_OD_30;
            dam_eco_fun{k,5}=dam_eco_OD_60;
            dam_eco_fun{k,6}=dam_eco_OD_120;
            dam_eco_fun{k,7}=dam_eco_OD_180;
            dam_eco_fun{k,8}=dam_eco_OD_240;
            dam_eco_fun{k,9}=dam_eco_OD_300;
            dam_eco_fun{k,10}=dam_eco_OD_360;
            dam_eco_fun{k,11}=dam_eco_OD_time_2;
            dam_eco_fun{k,12}=dam_eco_OD_time_3;
        end
    end
    save(strcat(result_path,'future_dam_sys_fun_585_7010_sim_2000.mat'),'dam_sys_fun');
    save(strcat(result_path,'future_dam_city_fun_585_7010_sim_2000.mat'),'dam_city_fun');
    save(strcat(result_path,'future_dam_pro_fun_585_7010_sim_2000.mat'),'dam_pro_fun');
    save(strcat(result_path,'future_dam_eco_fun_585_7010_sim_2000.mat'),'dam_eco_fun');
    
    % calculate resilience loss
    load(strcat(source_path,'future_typhoon_train_outage_ssp245_7010_sim.mat'),'typhoon_train_outage');
    load(strcat(result_path,'future_dam_sys_fun_245_7010_sim_rule1.mat'),'dam_sys_fun');
    load(strcat(result_path,'future_dam_city_fun_245_7010_sim_rule1.mat'),'dam_city_fun');
    load(strcat(result_path,'future_dam_pro_fun_245_7010_sim_rule1.mat'),'dam_pro_fun');
    load(strcat(result_path,'future_dam_eco_fun_245_7010_sim_rule1.mat'),'dam_eco_fun');
%     load(strcat(source_path,'current_typhoon_train_outage_sim.mat'),'typhoon_train_outage');
%     load(strcat(result_path,'current_dam_sys_fun.mat'),'dam_sys_fun');
%     load(strcat(result_path,'current_dam_city_fun.mat'),'dam_city_fun');
%     load(strcat(result_path,'current_dam_pro_fun.mat'),'dam_pro_fun');
%     load(strcat(result_path,'current_dam_eco_fun.mat'),'dam_eco_fun');
    sys_RL=[0 0 0 0];
    TC_sys_RL=zeros(size(typhoon_train_outage,1),4);
    city_RL=zeros(length(city_set),10);
    province_RL=zeros(max(city_center(:,8)),1);
    ecozone_RL=zeros(max(city_center(:,7)),1);
    for k=1:200%size(typhoon_train_outage,1)
        train_outage=typhoon_train_outage{k,1};
        if ~isempty(train_outage)
            dam_sys_time=dam_sys_fun{k,1};TC_sys_time=mean(dam_sys_time);
            dam_sys_OD=dam_sys_fun{k,2};TC_sys_OD=mean(dam_sys_OD(dam_sys_OD>0));
            dam_sys_OD_time=dam_sys_fun{k,3};
            TC_dam_sys_OD_time=sum(dam_sys_OD.*dam_sys_OD_time)/sum(dam_sys_OD);
            TC_dam_sys_OD_time2=sum(dam_sys_OD.*dam_sys_OD_time);
            TC_dam_sys_OD_time(isnan(TC_dam_sys_OD_time))=0;
            
            TC_sys_RL(k,:)=[TC_sys_time TC_sys_OD sum(dam_sys_OD) TC_dam_sys_OD_time];
            sys_RL=[sum(dam_sys_time-norm_sys_fun) sum(dam_sys_OD) TC_dam_sys_OD_time TC_dam_sys_OD_time2]+sys_RL;
            
            dam_city_time=dam_city_fun{k,1};
            dam_city_OD=dam_city_fun{k,2};
            dam_city_OD_time=dam_city_fun{k,3};
            dam_city_OD_30=dam_city_fun{k,4};
            dam_city_OD_60=dam_city_fun{k,5};
            dam_city_OD_120=dam_city_fun{k,6};
            dam_city_OD_180=dam_city_fun{k,7};
            dam_city_OD_240=dam_city_fun{k,8};
            dam_city_OD_300=dam_city_fun{k,9};
            dam_city_OD_360=dam_city_fun{k,10};
            TC_city_OD_time=sum(dam_city_OD.*dam_city_OD_time,2)./sum(dam_city_OD,2);
            TC_city_OD_time(isnan(TC_city_OD_time))=0;
            city_RL=[sum(dam_city_time-repmat(norm_city_fun,1,length(train_outage(1,:))),2) sum(dam_city_OD,2) sum(dam_city_OD_30,2) sum(dam_city_OD_60,2) sum(dam_city_OD_120,2)...
                sum(dam_city_OD_180,2) sum(dam_city_OD_240,2) sum(dam_city_OD_300,2) sum(dam_city_OD_360,2) TC_city_OD_time]+city_RL;
            
            dam_pro_time=dam_pro_fun{k,1};
            dam_pro_OD=dam_pro_fun{k,2};
            dam_pro_OD_time=dam_pro_fun{k,3};
            dam_pro_OD_30=dam_pro_fun{k,4};
            dam_pro_OD_60=dam_pro_fun{k,5};
            dam_pro_OD_120=dam_pro_fun{k,6};
            dam_pro_OD_180=dam_pro_fun{k,7};
            dam_pro_OD_240=dam_pro_fun{k,8};
            dam_pro_OD_300=dam_pro_fun{k,9};
            dam_pro_OD_360=dam_pro_fun{k,10};
            TC_pro_OD_time=sum(dam_pro_OD.*dam_pro_OD_time,2)./sum(dam_pro_OD,2);
            TC_pro_OD_time(isnan(TC_pro_OD_time))=0;
            province_RL=[sum(dam_pro_time-repmat(norm_pro_fun,1,length(train_outage(1,:))),2) sum(dam_pro_OD,2) sum(dam_pro_OD_30,2) sum(dam_pro_OD_60,2) sum(dam_pro_OD_120,2)...
                sum(dam_pro_OD_180,2) sum(dam_pro_OD_240,2) sum(dam_pro_OD_300,2) sum(dam_pro_OD_360,2) TC_pro_OD_time]+province_RL;
            
            dam_eco_time=dam_eco_fun{k,1};
            dam_eco_OD=dam_eco_fun{k,2};
            dam_eco_OD_time=dam_eco_fun{k,3};
            dam_eco_OD_30=dam_eco_fun{k,4};
            dam_eco_OD_60=dam_eco_fun{k,5};
            dam_eco_OD_120=dam_eco_fun{k,6};
            dam_eco_OD_180=dam_eco_fun{k,7};
            dam_eco_OD_240=dam_eco_fun{k,8};
            dam_eco_OD_300=dam_eco_fun{k,9};
            dam_eco_OD_360=dam_eco_fun{k,10};
            TC_eco_OD_time=sum(dam_eco_OD.*dam_eco_OD_time,2)./sum(dam_eco_OD,2);
            TC_eco_OD_time(isnan(TC_eco_OD_time))=0;
            ecozone_RL=[sum(dam_eco_time-repmat(norm_eco_fun,1,length(train_outage(1,:))),2) sum(dam_eco_OD,2) sum(dam_eco_OD_30,2) sum(dam_eco_OD_60,2) sum(dam_eco_OD_120,2)...
                sum(dam_eco_OD_180,2) sum(dam_eco_OD_240,2) sum(dam_eco_OD_300,2) sum(dam_eco_OD_360,2) TC_eco_OD_time]+ecozone_RL;
        end
    end
    
    load(strcat(source_path,'ssp245_2070_2100_climate.mat'),'freq');
%     freq=5.5;
    N_sim=200;
    sys_RL(4)=sys_RL(4)/sys_RL(2);
    sys_RL(1:3)=sys_RL(1:3)/N_sim;
    sys_RL(1:2)=sys_RL(1:2)*freq/363;
    sys_RL(2)=sys_RL(2)*100;
    city_RL(:,1:9)=city_RL(:,1:9)/N_sim*freq/363;
    city_RL(:,10)=city_RL(:,10)/N_sim;
    city_RL(:,2:9)=city_RL(:,2:9)*100;
    province_RL(:,1:9)=province_RL(:,1:9)/N_sim*freq/363;
    province_RL(:,10)=province_RL(:,10)/N_sim;
    province_RL(:,2:9)=province_RL(:,2:9)*100;
    ecozone_RL(:,1:9)=ecozone_RL(:,1:9)/N_sim*freq/363;
    ecozone_RL(:,10)=ecozone_RL(:,10)/N_sim;
    ecozone_RL(:,2:9)=ecozone_RL(:,2:9)*100;
    
    save(strcat(result_path,'future_sys_RL_OD_585_7010_sim_2000.mat'),'sys_RL');
    save(strcat(result_path,'future_city_RL_OD_585_7010_sim_2000.mat'),'city_RL');
    save(strcat(result_path,'future_province_RL_OD_585_7010_sim_2000.mat'),'province_RL');
    save(strcat(result_path,'future_ecozone_RL_OD_585_7010_sim_2000.mat'),'ecozone_RL');
    save(strcat(result_path,'future_TC_sys_RL_585_7010_sim_2000.mat'),'TC_sys_RL');    
end


%% calculate annual resilience loss
if fun_type==6
    % generate annual TC number
    load(strcat(result_path,'norm_sys_fun.mat'),'norm_sys_fun');
    load(strcat(result_path,'norm_city_fun.mat'),'norm_city_fun');
    load(strcat(result_path,'norm_pro_fun.mat'),'norm_pro_fun');
    load(strcat(result_path,'norm_eco_fun.mat'),'norm_eco_fun');
    load(strcat(source_path,'city_center.mat'),'city_center');
    load(strcat(result_path,'norm_city_city_time.mat'),'city_city_time');norm_city_city_time=city_city_time;
    load(strcat(source_path,'city_TF_mat.mat'),'city_TF_mat');
    city_set=unique(rail_city(:,1));
    city_TF_mat=city_TF_mat(city_set,city_set);
    
    % calculate current resilience loss
    load(strcat(result_path,'current_dam_fun_OD.mat'),'dam_fun');
    load(strcat(source_path,'current_typhoon_train_outage_sim.mat'),'typhoon_train_outage');
    load(strcat(source_path,'future_climate_era5.mat'),'freq');
    load(strcat(result_path,'current_dam_fun_OD.mat'),'dam_fun');
    r = freq %poissrnd(freq);   % 7
    sys_RL=0;
    city_RL=zeros(length(city_set),1);
    % province_RL=zeros(max(city_center(:,8)),1);
    % ecozone_RL=zeros(max(city_center(:,7)),1);
    
    sys_RL=[0 0 0];
    city_RL=zeros(length(city_set),12);
    for k=1:size(typhoon_train_outage,1)
        train_outage=typhoon_train_outage{k,1};
        if ~isempty(train_outage)
            dam_sys_fun=dam_fun{k,1};
            dam_city_fun=dam_fun{k,2};
            dam_sys_OD=dam_fun{k,3};
            dam_sys_OD_time=dam_fun{k,4};dam_sys_OD_time=dam_sys_OD_time(dam_sys_OD_time>0);
            dam_city_OD=dam_fun{k,5};
            dam_city_OD_time=dam_fun{k,6};
            dam_city_OD_3=dam_fun{k,7};
            dam_city_OD_5=dam_fun{k,8};
            dam_city_OD_10=dam_fun{k,9};
            dam_city_OD_15=dam_fun{k,10};
            dam_city_OD_20=dam_fun{k,11};
            dam_city_OD_30=dam_fun{k,12};
            dam_city_OD_60=dam_fun{k,13};
            dam_city_OD_time_2=dam_fun{k,14};
            dam_city_OD_time_3=dam_fun{k,15};
            sys_RL=[sum(dam_sys_fun-norm_sys_fun) sum(dam_sys_OD) sum(dam_sys_OD_time)]+sys_RL;
            city_RL=[sum(dam_city_fun-repmat(norm_city_fun,1,length(train_outage(1,:))),2) sum(dam_city_OD,2) sum(dam_city_OD_3,2) sum(dam_city_OD_5,2) sum(dam_city_OD_10,2)...
                sum(dam_city_OD_15,2) sum(dam_city_OD_20,2) sum(dam_city_OD_30,2) sum(dam_city_OD_60,2) sum(dam_city_OD_time,2) sum(dam_city_OD_time_2,2) sum(dam_city_OD_time_3,2)]+city_RL;
        end
    end
    
    delay_OD=[];
    for k=1:size(typhoon_train_outage,1)
        train_outage=typhoon_train_outage{k,1};
        dam_sys_OD=dam_fun{k,4};dam_sys_OD=dam_sys_OD(dam_sys_OD>0);
        if ~isempty(dam_sys_OD)
            delay_OD=[delay_OD;dam_sys_OD];
        end
    end
    delay_OD(:,2)=1;
    
    sys_RL=sys_RL/2000*r;
    city_RL=city_RL/2000*r;
    province_RL=province_RL/2000*r;
    ecozone_RL=ecozone_RL/2000*r;
    save(strcat(result_path,'current_sys_RL_OD.mat'),'sys_RL');
    save(strcat(result_path,'current_city_RL_OD.mat'),'city_RL');
    save(strcat(result_path,'current_province_RL.mat'),'province_RL');
    save(strcat(result_path,'current_ecozone_RL.mat'),'ecozone_RL');
    
    
    % calculate current resilience loss
    load(strcat(result_path,'future_dam_fun_OD.mat'),'dam_fun');
    load(strcat(source_path,'future_typhoon_train_outage_sim.mat'),'typhoon_train_outage');
    load(strcat(source_path,'future_climate_mix_gcms.mat'),'freq');
    r = freq % poissrnd(freq)  % 7
    sys_RL=0;
    city_RL=zeros(length(city_set),1);
    province_RL=zeros(max(city_center(:,8)),1);
    ecozone_RL=zeros(max(city_center(:,7)),1);
    for k=1:size(typhoon_train_outage,1)
        train_outage=typhoon_train_outage{k,1};
        if ~isempty(train_outage)
            dam_sys_fun=dam_fun{k,1};
            dam_city_fun=dam_fun{k,2};
            dam_pro_time=dam_fun{k,3};
            dam_eco_time=dam_fun{k,4};
            sys_RL=sum(dam_sys_fun-norm_sys_fun)+sys_RL;
            city_RL=sum(dam_city_fun-repmat(norm_city_fun,1,length(train_outage(1,:))),2)+city_RL;
            province_RL=sum(dam_pro_time-repmat(norm_pro_fun,1,length(train_outage(1,:))),2)+province_RL;
            ecozone_RL=sum(dam_eco_time-repmat(norm_eco_fun,1,length(train_outage(1,:))),2)+ecozone_RL;
        end
    end
    sys_RL=sys_RL/2000*r;
    city_RL=city_RL/2000*r;
    province_RL=province_RL/2000*r;
    ecozone_RL=ecozone_RL/2000*r;
    save(strcat(result_path,'future_sys_RL.mat'),'sys_RL');
    save(strcat(result_path,'future_city_RL.mat'),'city_RL');
    save(strcat(result_path,'future_province_RL.mat'),'province_RL');
    save(strcat(result_path,'future_ecozone_RL.mat'),'ecozone_RL');
    
    city_temp=zeros(363,1);
    city_temp(city_set)=a;
    
    %
    CC=corr([city_RL city_pop(city_set) city_gdp(city_set) city_attributes(city_set,[2 3]) city_train_flow((city_set),2)],'Type','Spearman')
    [CC,p]=corrcoef([city_RL city_pop(city_set) city_gdp(city_set) city_attributes(city_set,[2 3]) city_train_flow((city_set),2)])
    
    [CC(1,[3 2 4 5 6]);p(1,[3 2 4 5 6])]
    
    % coast_city=[];
    city_set=unique(rail_city(:,1));
    city_temp=zeros(363,1);
    city_temp(city_set)=city_RL;
    [CC,p]=corrcoef([city_temp(coast_city) city_pop(coast_city) city_gdp(coast_city) city_attributes(coast_city,[2 3]) city_train_flow((coast_city),2)])
    [CC,p]=corr([city_temp(coast_city) city_pop(coast_city) city_gdp(coast_city) city_attributes(coast_city,[2 3]) city_train_flow((coast_city),2)],'Type','Spearman')
    
    for d=1:2000
        pro_fun=dam_fun{d,3};
        if ~isempty(pro_fun)
            err(d)=pro_fun(29,1)-norm_pro_fun(29);
        end
    end
    
end
