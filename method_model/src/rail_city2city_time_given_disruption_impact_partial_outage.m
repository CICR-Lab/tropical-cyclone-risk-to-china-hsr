function city_city_time=rail_city2city_time_given_disruption_impact_partial_outage(model_para,rail_net_time,rail_city,dam_train,dam_station,city_route_pass,norm_city_city_time)

% function: calculate rail network based city_city_time given_disruption
% rail_net_time:the original rail functionality network
% rail_net_time.station_node:node_id station_id train_id arrival_time departure_time type
% rail_net_time.timetable_edge:fnode_id tnode_id trave_time train_id
% rail_net_time.transfer_edge:fnode_id, tnode_id, travel_time, station_id
% rail_city: station_id, city_id 
% dam_set: the damage state of each train, 1 for damage

rail_node=rail_net_time.station_node;
timetable_edge=rail_net_time.timetable_edge;
transfer_edge=rail_net_time.transfer_edge;

timetable_edge(:,5)=(1:length(timetable_edge(:,1)))';
dam_temp=zeros(length(timetable_edge(:,1)),1);
for t=1:13160
    if dam_train(t)==1
       tedge_id=timetable_edge(timetable_edge(:,4)==t,5);
       dam_temp(tedge_id(max(1,dam_station(t)-1):end))=1;
    end
end
timetable_edge(dam_temp==1,:)=[];
rail_edge=[timetable_edge(:,1:3);transfer_edge(:,1:3)];

% find cities whose travel path not affected by the disruption
unaffect_city=zeros(model_para.N_city,1);
for c=1:model_para.N_city
    pass_train=city_route_pass{c,2};
    if sum(dam_train(pass_train))==0
        unaffect_city(c)=1;
    end
end

city_city_time=city2city_fastest_travel_time_impact(rail_city,rail_node,rail_edge,unaffect_city,norm_city_city_time);

