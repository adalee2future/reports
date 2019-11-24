select 
  shop_id `门店id`,
  shop_name `门店`
from owo_store.dwd_shop
where pt = {pt}
  and is_online = 1
  and shop_name not rlike '外送'
order by shop_id
limit 1000000
;

select
  a.day_date`日期`,
  a.weekday_name_cn `星期`,
  b.shop_name `门店`,
  coalesce(c.gmv, 0) gmv,
  coalesce(c.order_num, 0) `订单量`,
  coalesce(c.new_user_num, 0) `新客数`,
  coalesce(c.user_num - c.new_user_num, 0) `老客数`,
  round(coalesce(c.amount_per_order, 0), 2) `客单价`,
  coalesce(c.scrap_amount_sell, 0) `报废售价`,
  if(coalesce(c.scrap_amount_sell, 0) = 0, 0, cdm.divide(coalesce(c.scrap_amount_sell,0), gmv)) `报废率`
from
(
   select *, 1 num
   from cdm.dim_calendar
  where day_date in (to_date('{dt}', 'yyyy-mm-dd'), dateadd('{dt} 00:00:00', -364, 'dd'))
) a
left join
(
  select *, 1 num
  from owo_store.dwd_shop
  where pt = {pt}
    and is_online = 1
    and shop_name not rlike '外送'
) b
on a.num = b.num
left join
phoenix.bi_store_key_metrics c
on a.day_date = c.order_date
  and b.shop_id = c.shop_id
order by `日期` desc limit 1000000
;

select
  a.day_date `日期`,
  a.weekday_name_cn `星期`,
  b.shop_name `门店`,
  c.dept_name `二级品类`,
  coalesce(sum(d.sale_amount), 0) `GMV`,
  coalesce(sum(d.sale_quantity), 0) `销量`
from
(
  select *, 1 num
  from cdm.dim_calendar
  where day_date in (to_date('{dt}', 'yyyy-mm-dd'), dateadd('{dt} 00:00:00', -364, 'dd'))
) a
inner join
(
  select *, 1 num
  from owo_store.dwd_shop
  where pt = {pt}
    and is_online = 1
    and shop_name not rlike '外送'
) b
on a.num = b.num
inner join
(
  select distinct
    store_id,
    dept_name
  from phoenix.bi_store_sku_key_metrics
  where pay_date in (to_date('{dt}', 'yyyy-mm-dd'), dateadd('{dt} 00:00:00', -364, 'dd'))
) c
on b.shop_id = c.store_id
left join
phoenix.bi_store_sku_key_metrics d
on a.day_date = d.pay_date
  and b.shop_id = d.store_id
  and c.dept_name = d.dept_name
group by b.shop_name, a.day_date, c.dept_name, a.weekday_name_cn
;

select /*+mapjoin(a)*/
  concat(min(day_id), '-', max(day_id)) `日期`,
  '日均' `星期`,
  b.shop_name `门店`,
  avg(c.gmv) gmv,
  avg(c.order_num) `订单量`,
  avg(c.new_user_num) `新客数`,
  avg(c.user_num - c.new_user_num) `老客数`,
  cdm.divide(sum(c.gmv), sum(c.order_num)) `客单价`,
  avg(c.scrap_amount_sell) `报废售价`,
  cdm.divide(sum(c.scrap_amount_sell), sum(c.gmv)) `报废率`
from
(
  select 
    a1.rownum map_num,
    a1.weekday_name_cn,
    a2.day_date,
    to_char(a2.day_date, 'yyyymmdd') day_id,
    row_number() over(distribute by a1.rownum sort by a2.day_date desc) compare_num
  from
  (
    select 
    day_date, 
    dateadd(day_date, -364, 'dd') compare_date,
    array(day_date, dateadd(day_date, -364, 'dd')) dates,
    row_number() over (sort by day_date desc) rownum,
    weekday_name_cn
  from cdm.dim_calendar
  where day_date between datetrunc('{dt} 00:00:00', 'mm') and '{dt} 00:00:00'
  ) a1
  lateral view explode(dates) a2 as day_date
) a
inner join
(
  select *
  from owo_store.dwd_shop
  where pt = '{pt}'
    and is_online = 1
    and shop_name not rlike '外送'
) b
left join
phoenix.bi_store_key_metrics c
on a.day_date = c.order_date
  and b.shop_id = c.shop_id
group by 
  a.compare_num,
  b.shop_name
;

select /*+mapjoin(a)*/
  concat(min(day_id), '-', max(day_id)) `日期`,
  '合计' `星期`,
  b.shop_name `门店`,
  c.dept_name `二级品类`,
  coalesce(sum(d.sale_amount), 0) `GMV`,
  coalesce(sum(d.sale_quantity), 0) `销量`
from
(
  select 
    a1.rownum map_num,
    a1.weekday_name_cn,
    a2.day_date,
    to_char(a2.day_date, 'yyyymmdd') day_id,
    row_number() over(distribute by a1.rownum sort by a2.day_date desc) compare_num
  from
  (
    select 
    day_date, 
    dateadd(day_date, -364, 'dd') compare_date,
    array(day_date, dateadd(day_date, -364, 'dd')) dates,
    row_number() over (sort by day_date desc) rownum,
    weekday_name_cn
  from cdm.dim_calendar
  where day_date between datetrunc('{dt} 00:00:00', 'mm') and '{dt} 00:00:00'
  ) a1
  lateral view explode(dates) a2 as day_date
) a
inner join
(
  select *
  from owo_store.dwd_shop
  where pt = '{pt}'
    and is_online = 1
    and shop_name not rlike '外送'
) b
inner join
(
  select distinct
    store_id,
    dept_name
  from phoenix.bi_store_sku_key_metrics
  where pay_date in (to_date('{dt}', 'yyyy-mm-dd'), dateadd('{dt} 00:00:00', -364, 'dd'))
) c
on b.shop_id = c.store_id
left join
phoenix.bi_store_sku_key_metrics d
on a.day_date = d.pay_date
  and b.shop_id = d.store_id
  and c.dept_name = d.dept_name
group by b.shop_name, a.compare_num, c.dept_name
;
