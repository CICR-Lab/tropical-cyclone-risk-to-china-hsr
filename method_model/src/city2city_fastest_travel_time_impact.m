function city_city_time=city2city_fastest_travel_time_impact(rail_city,rail_node,rail_edge,unaffect_city,norm_city_city_time)

% function: calculate the travel time matrix among cities given the network
% rail_city: city_id of each rail station
% rail_node: node_id, station_id, train_id, type
% rail_edge: fnode_id, tnode_id, travel_time
% city_city_time: time matrix from one city center to another city center

city_set=unique(rail_city(:,1));
city_city_time=zeros(length(city_set),length(city_set));
stop_time=rail_node(:,5)-rail_node(:,4); %the stop time at a staton=the departure time-arrival time
for c=1:length(city_set)
%     c
    if unaffect_city(city_set(c))==1
        city_city_time(c,:)=norm_city_city_time(c,:);
    else
        station_temp=find(rail_city(:,1)==city_set(c));
        snode=rail_node(ismember(rail_node(:,2),station_temp),:);
        rail_city_time=-stop_time(snode(:,1))+1e-8;
        rail_edge_temp=[rail_edge; ones(size(snode,1),1)+size(rail_node,1) snode(:,1) rail_city_time];
        net=sparse(rail_edge_temp(:,1),rail_edge_temp(:,2),rail_edge_temp(:,3),size(rail_node,1)+1,size(rail_node,1)+1);
        D_temp=shortest_paths(net,size(rail_node,1)+1);
        clear net;
        node_dist=sortrows([rail_city(rail_node(:,2),1) D_temp(1:end-1)]);
        [~,loc]=unique(node_dist(:,1));
        city_city_time(c,:)=node_dist(loc,2)';
    end
end
city_city_time(logical(eye(size(city_city_time))))=0;


