# DDL
# USE powerwall
CREATE DATABASE powerwall
CREATE RETENTION POLICY raw ON powerwall duration 3d replication 1
ALTER RETENTION POLICY autogen ON powerwall duration 730d
CREATE RETENTION POLICY strings ON powerwall duration 730d replication 1
CREATE RETENTION POLICY pwtemps ON powerwall duration 730d replication 1
CREATE RETENTION POLICY kwh ON powerwall duration INF replication 1
CREATE RETENTION POLICY daily ON powerwall duration INF replication 1
CREATE RETENTION POLICY monthly ON powerwall duration INF replication 1
CREATE CONTINUOUS QUERY cq_autogen ON powerwall BEGIN SELECT mean(home) AS home, mean(solar) AS solar, mean(from_pw) AS from_pw, mean(to_pw) AS to_pw, mean(from_grid) AS from_grid, mean(to_grid) AS to_grid, last(percentage) AS percentage INTO powerwall.autogen.:MEASUREMENT FROM (SELECT load_instant_power AS home, solar_instant_power AS solar, abs((1+battery_instant_power/abs(battery_instant_power))*battery_instant_power/2) AS from_pw, abs((1-battery_instant_power/abs(battery_instant_power))*battery_instant_power/2) AS to_pw, abs((1+site_instant_power/abs(site_instant_power))*site_instant_power/2) AS from_grid, abs((1-site_instant_power/abs(site_instant_power))*site_instant_power/2) AS to_grid, percentage FROM raw.http) GROUP BY time(1m), month, year fill(linear) END
CREATE CONTINUOUS QUERY cq_kwh ON powerwall RESAMPLE EVERY 1m BEGIN SELECT integral(home)/1000/3600 AS home, integral(solar)/1000/3600 AS solar, integral(from_pw)/1000/3600 AS from_pw, integral(to_pw)/1000/3600 AS to_pw, integral(from_grid)/1000/3600 AS from_grid, integral(to_grid)/1000/3600 AS to_grid INTO powerwall.kwh.:MEASUREMENT FROM autogen.http GROUP BY time(1h), month, year tz('America/Los_Angeles') END
CREATE CONTINUOUS QUERY cq_daily ON powerwall RESAMPLE EVERY 1h BEGIN SELECT sum(home) AS home, sum(solar) AS solar, sum(from_pw) AS from_pw, sum(to_pw) AS to_pw, sum(from_grid) AS from_grid, sum(to_grid) AS to_grid INTO powerwall.daily.:MEASUREMENT FROM powerwall.kwh.http GROUP BY time(1d), month, year tz('America/Los_Angeles') END 
CREATE CONTINUOUS QUERY cq_monthly ON powerwall RESAMPLE EVERY 1h BEGIN SELECT sum(home) AS home, sum(solar) AS solar, sum(from_pw) AS from_pw, sum(to_pw) AS to_pw, sum(from_grid) AS from_grid, sum(to_grid) AS to_grid INTO powerwall.monthly.:MEASUREMENT FROM powerwall.daily.http GROUP BY time(365d), month, year END
CREATE CONTINUOUS QUERY cq_pw_temps ON powerwall BEGIN SELECT mean(PW1_temp) AS PW1_temp, mean(PW2_temp) AS PW2_temp, mean(PW3_temp) AS PW3_temp, mean(PW4_temp) AS PW4_temp, mean(PW5_temp) AS PW5_temp, mean(PW6_temp) AS PW6_temp INTO powerwall.pwtemps.:MEASUREMENT FROM (SELECT PW1_temp, PW2_temp, PW3_temp, PW4_temp, PW5_temp, PW6_temp FROM raw.http) GROUP BY time(1m), month, year fill(linear) END
CREATE CONTINUOUS QUERY cq_strings ON powerwall BEGIN SELECT mean(A_Current) AS A_Current, mean(A_Power) AS A_Power, mean(A_Voltage) AS A_Voltage, mean(B_Current) AS B_Current, mean(B_Power) AS B_Power, mean(B_Voltage) AS B_Voltage, mean(C_Current) AS C_Current, mean(C_Power) AS C_Power, mean(C_Voltage) AS C_Voltage, mean(D_Current) AS D_Current, mean(D_Power) AS D_Power, mean(D_Voltage) AS D_Voltage INTO powerwall.strings.:MEASUREMENT FROM (SELECT A_Current, A_Power, A_Voltage, B_Current, B_Power, B_Voltage, C_Current, C_Power, C_Voltage, D_Current, D_Power, D_Voltage FROM raw.http) GROUP BY time(1m), month, year fill(linear) END
CREATE CONTINUOUS QUERY cq_strings1 ON powerwall BEGIN SELECT mean(A1_Current) AS A1_Current, mean(A1_Power) AS A1_Power, mean(A1_Voltage) AS A1_Voltage, mean(B1_Current) AS B1_Current, mean(B1_Power) AS B1_Power, mean(B1_Voltage) AS B1_Voltage, mean(C1_Current) AS C1_Current, mean(C1_Power) AS C1_Power, mean(C1_Voltage) AS C1_Voltage, mean(D1_Current) AS D1_Current, mean(D1_Power) AS D1_Power, mean(D1_Voltage) AS D1_Voltage INTO powerwall.strings.:MEASUREMENT FROM (SELECT A1_Current, A1_Power, A1_Voltage, B1_Current, B1_Power, B1_Voltage, C1_Current, C1_Power, C1_Voltage, D1_Current, D1_Power, D1_Voltage FROM raw.http) GROUP BY time(1m), month, year fill(linear) END
CREATE CONTINUOUS QUERY cq_strings2 ON powerwall BEGIN SELECT mean(A2_Current) AS A2_Current, mean(A2_Power) AS A2_Power, mean(A2_Voltage) AS A2_Voltage, mean(B2_Current) AS B2_Current, mean(B2_Power) AS B2_Power, mean(B2_Voltage) AS B2_Voltage, mean(C2_Current) AS C2_Current, mean(C2_Power) AS C2_Power, mean(C2_Voltage) AS C2_Voltage, mean(D2_Current) AS D2_Current, mean(D2_Power) AS D2_Power, mean(D2_Voltage) AS D2_Voltage INTO powerwall.strings.:MEASUREMENT FROM (SELECT A2_Current, A2_Power, A2_Voltage, B2_Current, B2_Power, B2_Voltage, C2_Current, C2_Power, C2_Voltage, D2_Current, D2_Power, D2_Voltage FROM raw.http) GROUP BY time(1m), month, year fill(linear) END
CREATE CONTINUOUS QUERY cq_strings3 ON powerwall BEGIN SELECT mean(A3_Current) AS A3_Current, mean(A3_Power) AS A3_Power, mean(A3_Voltage) AS A3_Voltage, mean(B3_Current) AS B3_Current, mean(B3_Power) AS B3_Power, mean(B3_Voltage) AS B3_Voltage, mean(C3_Current) AS C3_Current, mean(C3_Power) AS C3_Power, mean(C3_Voltage) AS C3_Voltage, mean(D3_Current) AS D3_Current, mean(D3_Power) AS D3_Power, mean(D3_Voltage) AS D3_Voltage INTO powerwall.strings.:MEASUREMENT FROM (SELECT A3_Current, A3_Power, A3_Voltage, B3_Current, B3_Power, B3_Voltage, C3_Current, C3_Power, C3_Voltage, D3_Current, D3_Power, D3_Voltage FROM raw.http) GROUP BY time(1m), month, year fill(linear) END
CREATE CONTINUOUS QUERY cq_inverters ON powerwall BEGIN SELECT mean(Inverter1) AS Inverter1, mean(Inverter2) AS Inverter2, mean(Inverter3) AS Inverter3, mean(Inverter4) AS Inverter4 INTO powerwall.strings.:MEASUREMENT FROM (SELECT A_Power+B_Power+C_Power+D_Power AS Inverter1, A1_Power+B1_Power+C1_Power+D1_Power AS Inverter2, A2_Power+B2_Power+C2_Power+D2_Power AS Inverter3, A3_Power+B3_Power+C3_Power+D3_Power AS Inverter4 FROM raw.http) GROUP BY time(1m), month, year fill(linear) END