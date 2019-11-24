select
  city_short_name `城市`,
  count(*) `在线货架数`
from rack.dw_machine
where release_status_name = '售卖中'
group by city_short_name
order by `在线货架数` desc
limit 10000;
select
  city_short_name `城市`,
  count(*) `订单量`
from rack.dw_order
where pay_status = 64 and to_char(pay_complete_time, 'yyyymmdd') = '{pt}'
group by city_short_name
order by `订单量` desc
limit 10000
