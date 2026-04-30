README.txt
============================================================
Project Title: Calculation of Intercity Railway Travel-Time Impacts and Resilience Losses under Typhoon Scenarios
Programming Language: MATLAB

1. Project Overview
------------------------------------------------------------
This code package is used to calculate changes in the fastest city-to-city railway travel time under typhoon-induced train service interruptions. It further evaluates affacted passenger proportions and delays  at the system, city, provincial, and economic-zone scales.

2. Code Files
------------------------------------------------------------
1. main_calculate_railway_resilience_under_typhoon.m
   Main script. Different computational tasks are controlled by the variable fun_type, including:
   - Calculating city-to-city travel time under current typhoon scenarios;
   - Calculating city-to-city travel time under future typhoon scenarios;
   - Calculating affacted passenger proportions and delays  at the system, city, provincial, and economic-zone scales under current and future scenarios;

2. rail_city2city_time_given_disruption_impact.m
   Calculates the fastest city-to-city travel-time matrix under a given train outage vector dam_train.
   This function assumes that affected trains are fully suspended. All timetable edges corresponding to disrupted trains are removed from the railway functionality network.

3. rail_city2city_time_given_disruption_impact_partial_outage.m
   Calculates the fastest city-to-city travel-time matrix under a given train outage vector dam_train and the affected starting station vector dam_station.
   This function represents partial outages, where a train is suspended only from a specific station onward rather than along the entire route.

4. city2city_fastest_travel_time_impact.m
   Core shortest-path calculation function. Based on rail nodes, railway edges, and the city-station mapping, it calculates the fastest travel time from each city to all other cities.
   For cities whose routes are not affected by the disruption, the function directly uses the baseline city-to-city travel time to reduce repeated computation.
