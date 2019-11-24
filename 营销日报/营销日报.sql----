---货架预算号
select
c.部门,c.预算号,c.预算号名称,c.当天优惠总金额,c.优惠名称,c.优惠信息,c.优惠id,c.优惠使用次数,c.优惠金额,c.优惠涉及订单数,c.优惠涉及交易额,c.优惠涉及用户数
from
(
select 
b.*
from 
(
select 
1 as row,
'汇总' as `部门`,
null as `预算号名称`,
null as `部门总金额`,
null as `优惠名称总金额`,
ys.pay_date,
null as `预算号`,
round(sum(ys.优惠金额),2) as `当天优惠总金额`,
null as `优惠名称`,
null as `优惠信息`,
null as `优惠id`,
sum(ys.优惠使用次数) as `优惠使用次数`,
round(sum(ys.优惠金额),2) as `优惠金额`,
to_char(b.order_qyt) as `优惠涉及订单数`,
to_char(round(b.ori,2)) as `优惠涉及交易额`,
to_char(b.user_qyt) as `优惠涉及用户数`
from kylin.bi_rack_mail_budget_detail ys 
left join 
(
  select 
  a. pay_date,
  count(distinct a.order_id) order_qyt,
  count(distinct a.user_id) user_qyt,
  sum(a.origin_amount) ori
  from 
  (
  select
  to_char(o.pay_complete_time,'yyyymmdd') pay_date,
  o.order_id,
  o.user_id,
  o.origin_amount
  from rack.dwd_rack_order o inner join owo_ods.h_rak_order__ls_order_ordercoupon  c on o.order_id=c.order_id
  and to_char(o.pay_complete_time,'yyyymmdd')='{pt}' and o.pt = '{pt}'
  where c.coupon_type in(1,2)
  group by
  to_char(o.pay_complete_time,'yyyymmdd'),
  o.order_id,
  o.user_id,
  o.origin_amount
  )a
  group by a. pay_date
)b  on ys.pay_date=b.pay_date
where ys.pay_date='{pt}'
group by
ys.pay_date,
to_char(b.order_qyt),
to_char(round(b.ori,2)),
to_char(b.user_qyt)

union all

select 2 as row,
a.*
from kylin.bi_rack_mail_budget_detail a where a.pay_date='{pt}'
)b
order  by
b.row asc,b.部门总金额 desc,b.当天优惠总金额  desc,b.预算号,b.优惠名称 desc,b.优惠金额 desc,b.优惠id asc limit 10000
)c
;





--优惠前端报表v2.0
--预算定时邮件
--优惠前端报表v2.0
--预算定时邮件



--门店优惠_预算号维度汇总
select *
from 
(
select 
	t1.department_name `部门`,
	t1.budget_code `预算号`,
	t1.budget_project_name `预算号名称`,
	t1.discount_amount `当天优惠总金额`,
	t1.discount_count `优惠使用次数`,
	t1.order_num_reference `优惠涉及订单数`,
	t2.gmv_reference `优惠涉及交易额`,
	t1.user_num_reference `优惠涉及用户数`
from 
(	
	select 
		a.date_id,
		b.department_name,
		coalesce(a.budget_code,'无') as budget_code,
		b.budget_project_name ,
		round(sum(a.discount_amount),1) as  discount_amount,
		sum(a.discount_count) as discount_count,
		count(distinct a.order_id) as order_num_reference,
		count(distinct a.user_id) as user_num_reference
	from 	
	(
		select *
		from owo_store.dwd_store_youhui_order_wide 
		where day_id='{pt}'            --最新分区
		and date_id='{pt}' --昨天优惠订单
	) a 
	left outer join 
	(
		select *
		from rack.dwd_budget_project
		where pt='{pt}'
	) b 
	on a.budget_code=b.budget_project_code
	group by 
		a.date_id,
		b.department_name,
		coalesce(a.budget_code,'无'),
		b.budget_project_name
) t1
left outer join 
(
	select  
		a.budget_code,
		round(sum(b.origin_amount),1) as gmv_reference			
	from 
		(
			select distinct order_id,budget_code from owo_store.dwd_store_youhui_order_wide 
			where day_id='{pt}'           --最新分区
			and date_id='{pt}'             --昨天优惠订单
		) a 
		left outer join
		(
			select *
			from owo_store.dwd_store_order
			where pt='{pt}'
			and pay_status=10
		) b 
	on a.order_id=b.order_id
	group by a.budget_code
) t2	
on t1.budget_code=t2.budget_code

union all
select   
	`部门`,
    `预算号`,
	`预算号名称`,
	`当天优惠总金额`,
	`优惠使用次数`,
	`优惠涉及订单数`,
	`优惠涉及交易额`,
	`优惠涉及用户数`
from 		  
(
	select   
		1 as num,
		'汇 总' as `部门`,
         null as `预算号`,
		 null as `预算号名称`,
         round(sum(a.discount_amount),2) `当天优惠总金额`,
		 sum(a.discount_count)  `优惠使用次数`,
		 count(distinct a.order_id) `优惠涉及订单数`,
		 count(distinct a.user_id) `优惠涉及用户数`
	from      
    (
		select * from owo_store.dwd_store_youhui_order_wide 
		where day_id='{pt}'           --最新分区
		and date_id='{pt}'            --昨天优惠订单
	) a 
) t1 
left outer join
(
	select  round(sum(b.origin_amount),2) as `优惠涉及交易额`,1 as num
	from 
		(
			select distinct order_id from owo_store.dwd_store_youhui_order_wide 
			where day_id='{pt}'           --最新分区
			and date_id='{pt}'            --昨天优惠订单
		) a 
		left outer join
		(
			select *
			from owo_ods.sto_order__store_order_his
			where day_id='{pt}' 
		) b 
	on a.order_id=b.id
	
) t2 
on t1.num=t2.num
) x
order by `当天优惠总金额` desc limit 10000

;


--门店优惠明细
select    `部门`,
          `预算号`,
		  `预算号名称`,
		  `当天优惠总金额`,
		  `活动名称`,
		  `优惠名称`,
		  `优惠信息`,
		  `优惠id`,
		  `优惠使用次数`,
		  `优惠金额`,
		  `优惠涉及订单数`,
		  `优惠涉及交易额`,
		  `优惠涉及用户数`
from 
(
select *
from 
(
select    1 as row,
		  `部门`,
		  999999999 as `部门优惠总金额`,
		  99999999 as `优惠名称总金额`,
          `预算号`,
		  `预算号名称`,
		  `当天优惠总金额`,
		   `活动名称`,
		  `优惠名称`,
		  `优惠信息`,
		  `优惠id`,
		  `优惠使用次数`,
		  `优惠金额`,
		  `优惠涉及订单数`,
		  `优惠涉及交易额`,
		  `优惠涉及用户数`
from 		  
(
	select   '汇 总' as `部门`,
         null as `预算号`,
		 null as `预算号名称`,
         round(sum(a.discount_amount),2) `当天优惠总金额`,
		 null `活动名称`,
		 null as `优惠名称`,
		 null as `优惠信息`,
		 null as `优惠id`,
		 sum(a.discount_count)  `优惠使用次数`,
		 round(sum(a.discount_amount),2) `优惠金额`,
		 count(distinct a.order_id) `优惠涉及订单数`,
		 count(distinct a.user_id) `优惠涉及用户数`,
		 '1' as num
	from      
    (
		select * from owo_store.dwd_store_youhui_order_wide 
		where day_id='{pt}'           --最新分区
		and date_id='{pt}'            --昨天优惠订单
	) a 
) t1 
left outer join
(
	select  round(sum(b.origin_amount),2) as `优惠涉及交易额`,
				'1' as num
	from 
		(
		select distinct order_id from owo_store.dwd_store_youhui_order_wide 
		where day_id='{pt}'            --最新分区
		and date_id='{pt}'             --昨天优惠订单
		) a 
		left outer join
		(
		select *
		from owo_ods.sto_order__store_order_his
		where day_id='{pt}'
		) b 
	on a.order_id=b.id
	
) t2 
on t1.num=t2.num



union all 
    select row,
		  `部门`,
		  sum(`优惠金额`) over(partition by `部门` ) as `部门优惠总金额`,
		  sum(`优惠金额`) over(partition by `部门`,`预算号`,`优惠名称`) as `优惠名称总金额`,
          `预算号`,
		  `预算号名称`,
		  `当天优惠总金额`,
		  `活动名称`,
		  `优惠名称`,
		  `优惠信息`,
		  `优惠id`,
		  `优惠使用次数`,
		  `优惠金额`,
		  `优惠涉及订单数`, 
		  `优惠涉及交易额`,
		  `优惠涉及用户数`
	from	
    (
		select  2  as row,
			coalesce(t5.department_name,'无') `部门`,
			coalesce(t1.budget_code,'无') `预算号`,
			coalesce(t3.budget_project_name,'无') `预算号名称`,
			round(t2.youhui_total,2) `当天优惠总金额`,
			--t6.template_id `活动id`,
			cast(t7.name as string) as `活动名称`,
			cast(t1.coupon_title as string) `优惠名称`,
			cast(t1.coupon_info as string) `优惠信息`,
			
			
			cast(t1.coupon_id as string) `优惠id`,
			sum(t1.discount_count)  `优惠使用次数`,
			round(sum(t1.discount_amount),2)  `优惠金额`,
			count(distinct t1.order_id) `优惠涉及订单数`,
			round(sum(t1.origin_amount),2)  `优惠涉及交易额`,
			count(distinct t1.user_id) `优惠涉及用户数`
	from		
	(
		select a.*,b.origin_amount,c.coupon_info
		from
		(
			select order_id,
				   user_id,
				   order_date,
				   date_id,
				   shop_id,
				   shop_name,
				   coupon_id,
				   coupon_title,
				   coalesce(budget_code,'无') as budget_code,
				   discount_count,
				   discount_amount	   
			from owo_store.dwd_store_youhui_order_wide 
			where day_id= '{pt}'            --最新分区
			and date_id= '{pt}'             --昨天优惠订单
		) a 
		left outer join
		(
			select *
			from owo_ods.sto_order__store_order_his
			where day_id='{pt}' 
		) b 
		on a.order_id=b.id
		left outer join store_bi_coupon_info_detail c 
		on a.coupon_id=c.id
		) t1

	left outer join
	(
		select coalesce(budget_code,'无')  as  budget_code,sum(discount_amount) as youhui_total from owo_store.dwd_store_youhui_order_wide 
		where day_id='{pt}'            --最新分区
		and date_id='{pt}'             --昨天优惠订单
		group by coalesce(budget_code,'无')
	) t2
	on t1.budget_code=t2.budget_code
	left outer join owo_ods.h_cen_marketing_budget__budget_project t3 
	on t2.budget_code=t3.budget_project_code
	left outer join owo_ods.h_cen_marketing_budget__financial_budget t4 
	on t3.finance_budget_id=t4.id
	left outer join owo_ods.h_cen_marketing_budget__department t5
	on t4.department_id=t5.id
	left outer join 
	(
		select *
		from owo_ods.h_cen_coupon_sku__coupon_info  
		where day_id='{pt}'
		and is_valid=1
		and status=10
	) t6
	on t1.coupon_id=t6.id
	left outer join
	(
		select *
		from owo_ods.h_cen_coupon_sku__template_coupon 
		where day_id='{pt}'
		and (biz_codes like '%20%' or biz_codes like '%30%')                    --适用门店业务
		and to_char(end_date,'yyyymmdd')>='{pt}'
		and is_valid=1
		and status=10
	) t7
	on t6.template_id=t7.id
	group by coalesce(t5.department_name,'无'),
			coalesce(t1.budget_code,'无'),
			coalesce(t3.budget_project_name,'无'),
			t1.coupon_id,
			t1.coupon_title,
			t2.youhui_total,
			--t6.template_id,
			t7.name,
			cast(t1.coupon_info as string)
	) aa


) x		
order by row,`部门优惠总金额` desc,`部门`,`当天优惠总金额` desc ,`预算号`,`优惠名称总金额` desc,`活动名称`,`优惠名称`,`优惠id`
limit 10000
) z




;



--门店商品优惠涉及sku_明细
select 
	t1.department_name `部门`,
	t1.budget_code `预算号`,
	t1.budget_project_name `预算号名称`,
	t1.template_id  `活动id`,
	t1.template_desc `活动备注`,
	t1.coupon_id `优惠id`,
	t1.coupon_title `优惠名称` ,
	t1.sku_id  ,
	t1.commodity_name `商品名称`,
	t2.coupon_quantity `优惠使用次数`,
	round(t2.total_discount_amount,2) `优惠金额`,
	t2.order_num `优惠涉及订单数`,
	t3.gmv_reference `优惠涉及交易额`,
	t3.user_num_reference `优惠涉及用户数`	
from 
(
	select 
		c.department_name,
		c.budget_code,
		c.budget_project_name,
		c.coupon_id ,
		c.coupon_title ,
		c.template_id ,
		c.template_desc,
		b.sku_id ,
		b.commodity_name
	from 
	(
		select *
		from owo_ods.h_cen_coupon_sku__coupon_using_range
		where day_id='{pt}'
		and is_valid=1
		--and type=20   --item_id对应sku_id，10对应spu_id
	) a 
	left outer join 
	(
		select *
		from rack.dwd_comm_commodity 
		where pt='{pt}'
	) b 
	on a.item_id=b.sku_id
	inner join 
	(
		select 
				t1.id as coupon_id,
				t1.old_coupon_id,
				t1.coupon_title,
				t1.coupon_type,
				t1.compute_type,
				t1.compute_json,
				t1.template_id,
				t2.name as template_name,
				t2.template_desc,
				t2.template_type,
				t2.budget_code,
				t4.budget_project_name,
				t4.department_name
			from 	
			(
				select *
				from owo_ods.h_cen_coupon_sku__coupon_info  
				where day_id='{pt}'
				and is_valid=1
				and status=10
			) t1
			inner join 
			(
				select *
				from owo_ods.h_cen_coupon_sku__template_coupon 
				where day_id='{pt}'
				and (biz_codes like '%20%' or biz_codes like '%30%')                    --适用门店业务
				and to_char(end_date,'yyyymmdd')>='{pt}'
				and is_valid=1
				and status=10
			) t2
			on t1.template_id=t2.id
			inner join 
			(
				select distinct coupon_id from owo_store.dwd_store_youhui_order_wide 
				where day_id='{pt}'            --最新分区
				and date_id='{pt}' 
			) t3
			on t1.id=t3.coupon_id
			left outer join 
			(
				select *
				from rack.dwd_budget_project
				where pt='{pt}'
			) t4 
			on t2.budget_code=t4.budget_project_code			
	) c 
	on a.coupon_id=c.coupon_id
) t1 
--
left outer join 
(
	select 
		a.coupon_id,
		aa.merch_id as sku_id,
		count(distinct a.order_id) as order_num,
		sum(a.coupon_quantity) as coupon_quantity,
		sum(a.total_discount_amount) as total_discount_amount
	from 
	(
		select *
		from owo_ods.sto_order__store_order_item_coupon_his
		where day_id='{pt}' 
	) a 
	left outer join owo_ods.sto_center__store_shop_sku aa
	on a.sku_id=aa.id
	inner join 
	(
		select *
		from owo_store.dwd_store_order 
		where pt='{pt}' 
		and pay_status=10
		and order_date='{pt}' 
	) b 
	on a.order_id=b.order_id
	where a.coupon_type not in (110,100)
	group by coupon_id,aa.merch_id
	union all 	
	select 
		b.group_id as coupon_id,
		a.sku_id,
		count(distinct a.order_id) as order_num,
		sum(a.store_unit_group_quantity) as coupon_quantity,
		sum(a.total_discount_amount_commodity_group) as total_discount_amount	
	from 	
	(
		select *
		from bi_dwd_beehive_order_item
		where pt='{pt}'
		and business_type in ('store')
		and order_date='{pt}'
		and store_item_group_id>0
	) a 
	left outer join owo_ods.sto_order__store_order_item_group b 
	on a.store_item_group_id=b.id
	group by b.group_id,a.sku_id
) t2 
on t1.coupon_id=t2.coupon_id and t1.sku_id=t2.sku_id
--
left outer join 
(
	select 
		coupon_id,
		sum(b.origin_amount) as gmv_reference,
		count(distinct b.user_id) as user_num_reference
	from 
	(
		select distinct coupon_id,order_id 
		from owo_store.dwd_store_youhui_order_wide 
		where day_id='{pt}' 
		and date_id='{pt}'
	) a 
	left outer join 
	(
		select *
		from owo_store.dwd_store_order 
		where pt='{pt}' 
		and pay_status=10
		and order_date='{pt}' 
	) b 
	on a.order_id=b.order_id
	group by coupon_id	
) t3 
on t1.coupon_id=t3.coupon_id
where t2.coupon_quantity is not null
order by `部门`,`预算号`,`活动id`,`优惠id`,sku_id limit 10000
;
