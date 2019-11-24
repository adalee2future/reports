select 
	day_id `日期`,
	-- a.monday_id,
	-- a.month_id,
	shop_id `门店id`,
	name `门店名称`,
	coffee_sale_num `咖啡销量`,
	coffee_made_num `咖啡制作量`,
	new_user_coffee_quantity `新人1分购销量`,
	avg_quantity_this_week_coffee_made_num `本周平均制作量`,
	avg_quantity_coffee_made_num_last_week `上周平均制作量`,
    avg_quantity_this_month_coffee_made_num `本月平均制作量`,
	avg_quantity_coffee_made_num_last_month `上月平均制作量`
from store_bi_coffee_sale_daily_2
where day_id='{pt}'
and shop_id in (21,22,23,24,25,27,28,35,39)
order by `门店id` limit 1000
;

--门店咖啡销售明细

select 
	shop_id `门店id`,
	shop_name `门店名称`,
	order_date `日期`,
	order_id `订单id`,
	user_id `用户id`,
	user_phone `用户手机`,
	pay_time `支付时间`,
	sku_id `sku_id`,
	sku_code `商品编码`,
	commodity_name `商品名称`,
	attr_tag_info `商品标签`,
	div_name `一级名称`,
	dept_name `二级名称`,
	class_name `三级名称`,
	subclass_name `四级名称`,
	actual_quantity `咖啡销量`,
	new_user_coffee_tag `是否新人1分购`
from store_bi_coffee_sale_detail_daily
where order_date='{pt}'
and shop_id in (21,22,23,24,25,27,28,35,39)
and actual_quantity>0
order by `门店id`, `咖啡销量` desc limit 10000
;


--门店咖啡卡券销量
select 
    day_id `日期`,
    card_name `咖啡卡券名称`,
    original_price `原价`,
    sale_price `售价`,
    order_num `当天销量`,
    order_num_this_week `本周总销量`,
    quantity_last_week `上周总销量`,
    order_num_so_far `历史总销量`
  
from store_bi_coffee_card_sale_condition_2
where day_id='{pt}'


;
--外卖咖啡销量汇总

select 
	day_id `日期`,
	--monday_id ``,
	--month_id ``,
	cast (shop_id as string) `门店id`,
	name `门店名称`,
	quantity `咖啡销量`,
	avg_quantity_this_week `本周平均销量`,
	avg_quantity_last_week `上周平均销量`,
	avg_quantity_this_month `本月平均销量`,
	avg_quantity_last_month `上月平均销量`
from store_bi_takeout_coffee_sale_daily_2
where day_id='{pt}'
and shop_id in (21,22,23,24,25,27,28,35,39)
order by `门店id` limit 10000
;



--外卖销售明细
select 
		order_date `日期`,
	    name `门店名称`,
	    pay_time `支付时间`,
	    user_id `用户id`,
	    user_phone `用户手机`,
	    sku_id `sku_id`,
	    sku_code `商品编码`,
	    commodity_name `商品名称`,
	    attr_tag_info `商品标签`,
	    div_name `一级名称`,
	    dept_name `二级名称`,
	    class_name `三级名称`,
	    subclass_name `四级名称`,
	    total_quantity `咖啡销量`	
from store_bi_takeout_coffee_sale_detail_daily
where order_date='{pt}'
and name in ('长宁路店','福山路店','桂林路店','番禺路店','殷行路店','南泉北路店','西康路店','江场路店','古美路店')
;
