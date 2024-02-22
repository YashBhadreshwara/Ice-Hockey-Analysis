-- Goals scored by each team
select team, max(`Home Team Goals`) as home_goals, max(`Away Team Goals`) as away_goals
from bdc_2024_womens_data
group by team;

-- Calculate the average number of goals scored per period
select Period, avg(`Home Team Goals`) as Avg_Home_Team_Goals, avg(`Away Team Goals`) as Avg_Away_Team_Goals
from bdc_2024_womens_data
group by Period;

-- Player Contribution to Goals
select player, count(*) as goals_scored
from bdc_2024_womens_data
where event = 'Goal'
group by player
order by goals_scored desc;

-- Period with Highest Scoring
select period, max(`Home Team Goals` + `Away Team Goals`) as total_goals
from bdc_2024_womens_data
group by period
order by total_goals desc
limit 1;

-- Distribution of events by period
select period, count(*) as event_count
from bdc_2024_womens_data
group by period
order by period asc;

-- Event Frequency by Period
select period, event, count(*) as event_count
from bdc_2024_womens_data
group by period, event
order by period, event_count desc;

-- Analyzing the count of events by type
select event, count(*) as event_count
from bdc_2024_womens_data
group by event
order by event_count desc;

-- Players with the most plays
select player, count(*) as play_count
from bdc_2024_womens_data
where event = 'Play'
group by player
order by play_count desc;

-- Players with the most Puck Recovery
select player, count(*) as puck_recovery_count
from bdc_2024_womens_data
where event = 'Puck Recovery'
group by player
order by puck_recovery_count desc;

-- Players with the most Incomplete Play
select player, count(*) as incomplete_play_count
from bdc_2024_womens_data
where event = 'Incomplete Play'
group by player
order by incomplete_play_count desc;

-- Players with the most Dump In/Out
select player, count(*) as dump_in_out_count
from bdc_2024_womens_data
where event = 'Dump In/Out'
group by player
order by dump_in_out_count desc;

-- Players with the most Zone Entry
select player, count(*) as zone_entry_count
from bdc_2024_womens_data
where event = 'Zone Entry'
group by player
order by zone_entry_count desc;

-- Player Involvement Percentage per Event
select event, player, count(*) * 100.0 / sum(count(*)) over (partition by event) as involvement_percentage
from bdc_2024_womens_data
group by event, player
order by event, involvement_percentage desc;

-- Which Player was there per Event Type
select event, player, player_count
from ( select event, player, count(*) as player_count, row_number() over (partition by event order by count(*) desc) as row_num
       from bdc_2024_womens_data
       group by event, player) as a
where row_num = 1
order by player_count desc;

-- Players in Most Events
select player, count(*) as total_events
from bdc_2024_womens_data
group by player
order by total_events desc;

-- Analyzing Renata Fast performance
select event, count(*) as event_count
from bdc_2024_womens_data
where player = 'Renata Fast'
group by player, event
order by event_count desc;

-- Analyzing Haley Winn performance
select event, count(*) as event_count
from bdc_2024_womens_data
where player = 'Haley Winn'
group by player, event
order by event_count desc;

-- Analyzing Jocelyne Larocque performance
select event, count(*) as event_count
from bdc_2024_womens_data
where player = 'Jocelyne Larocque'
group by player, event
order by event_count desc;

-- Analyzing Marie-Philip Poulin performance
select event, count(*) as event_count
from bdc_2024_womens_data
where player = 'Marie-Philip Poulin'
group by player, event
order by event_count desc;

-- Analyzing Megan Keller performance
select event, count(*) as event_count
from bdc_2024_womens_data
where player = 'Megan Keller'
group by player, event
order by event_count desc;

-- Scoring Efficiency by Team
select team,
sum(case when event = 'Shot' then 1 else 0 end) as shots,
sum(case when event = 'Goal' then 1 else 0 end) as goals,
cast(sum(case when event = 'Goal' then 1 else 0 end) as float) / sum(case when event = 'Shot' then 1 else 0 end) as scoring_efficiency
from bdc_2024_womens_data
group by team;

-- Player Efficiency in Scoring
select player,
count(case when event = 'Shot' then 1 end) as total_shots,
count(case when event = 'Goal' then 1 end) as goals_scored,
(count(case when event = 'Goal' then 1 end) * 100.0) / nullif(count(case when event = 'Shot' then 1 end), 0) as shooting_percentage
from bdc_2024_womens_data
group by player
having goals_scored > 0
order by shooting_percentage desc;

-- Shot Locations Heatmap
select `X Coordinate`,`Y Coordinate`, count(*) as shot_count
from bdc_2024_womens_data
where event = 'Shot'
group by `X Coordinate`,`Y Coordinate`
order by shot_count desc

-- Common Type of Shots and Players Associated With Them
select `Detail 1` as shot_type, count(*) as shot_count, player
from bdc_2024_womens_data
where event = 'Shot'
group by  `Detail 1`, player
order by shot_count desc;

-- Shot Types Based On Event
select event, `Detail 1` as shot_type, count(*) as shot_count
from bdc_2024_womens_data
group by event, shot_type
order by event, shot_count desc;

-- Event Sequence Analysis
with EventSequence as ( select event, lead(event) over (order by date, clock) as next_event
                        from bdc_2024_womens_data)
                        
select event, next_event, count(*) as sequence_count
from EventSequence
where next_event IS NOT NULL
group by event, next_event
order by sequence_count desc;

-- Performance in Clutch Moments
select player, count(*) as clutch_event_count
from bdc_2024_womens_data
where player is not null
and (clock between '19:55' and '20:00' or clock between '14:55' and '15:00' or clock between '9:55' and '10:00')
group by player
order by clutch_event_count desc;

-- Player Duo Analysis
select player, `Player 2`, count(*) as event_count
from bdc_2024_womens_data
where `Player 2` != ''
group by player, `Player 2`
order by event_count desc;

-- Player Co-occurrence
select p1.player as player1, p2.player as player2, count(*) as co_occurrences
from bdc_2024_womens_data p1
join bdc_2024_womens_data p2
on p1.event = p2.event and p1.player < p2.player
group by p1.player, p2.player
order by co_occurrences desc;

-- Skater Distribution by Period
select period, avg(`Home Team Skaters`) as avg_home_team_skaters, avg(`Away Team Skaters`) as avg_away_team_skaters
from bdc_2024_womens_data
group by period;

-- Skater Utilization Efficiency
select team, avg(`Home Team Skaters` + `Away Team Skaters`) as avg_total_skaters,
count(case when event = 'Goal' then 1 end) as goals_scored,
(count(case when event = 'Goal' then 1 end) * 100.0) / nullif(avg(`Home Team Skaters` + `Away Team Skaters`), 0) as goals_per_skater
from bdc_2024_womens_data
group by team;






