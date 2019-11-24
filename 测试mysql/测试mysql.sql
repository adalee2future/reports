SELECT 
-- count(*), min(`create_time` )
 *,  FROM_UNIXTIME(time_out/1000) end_time, round((time_out/1000 - UNIX_TIMESTAMP(`create_time`)) / 60 / 60 / 24) delta_days
FROM `h_cen_account`.ls_account_token 
where `create_time` >= '2019-09-04'
-- where `create_time` >= '2019-06-01' and  FROM_UNIXTIME(time_out/1000) >= '2019-09-01'
-- order by id desc 
