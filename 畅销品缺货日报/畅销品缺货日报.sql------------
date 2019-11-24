
--table1 二级分类统计
--日期、 二级分类、 缺货sku种类数、 缺货sku种类占比、 缺货率、 缺货商品损失的GMV、GMV 、 缺货商品损失的GMV率、 缺货原因_大仓缺货或未发货、 缺货原因_门店未订货、 缺货原因_日配商品和香烟缺货
select data_time_wide                                                    as 日期
     , max(div_name)                                                     as 一级分类
     , dept_name                                                         as 二级分类
     , count(distinct if(is_short_inventory = 1, sku_id, null))          as 缺货sku种类数
     , if(count(distinct sku_id)>0, count(distinct if(
        is_short_inventory = 1, sku_id, null))/count(distinct 
        sku_id), 0)                                                      as 缺货sku种类占比
     , if(sum(1) > 0, sum(if(is_short_inventory = 1, 1, 0))/sum(1), 0)   as 缺货率
     , sum(short_day_lost_gmv)                                           as 缺货商品损失的GMV
     , sum(gmv)                                                          as GMV
     , if(sum(gmv)>0, sum(short_day_lost_gmv)/sum(gmv), 0)               as 缺货商品损失的GMV率
     , if(sum(if(is_short_inventory = 1, 1, 0))>0, sum(if(
        is_short_inventory = 1 and is_store_ordered = 0 and ((
            is_daily_dist = 1) or (is_wms_stock = 1 and 
            is_daily_dist != 1)), 1, 0))/sum(if(is_short_inventory 
        = 1, 1, 0)), 0)                                                 as 缺货原因_门店未订货
--     , if(sum(if(is_short_inventory = 1, 1, 0))>0, sum(if(
--        is_short_inventory = 1 and is_daily_dist != 1 and (
--        is_store_ordered = 1 or (is_store_ordered = 0 and 
--        is_wms_stock = 0)), 1, 0))/sum(if(is_short_inventory = 
--        1, 1, 0)), 0)                                                   as 缺货原因_大仓缺货或未发货
     , if(sum(if(is_short_inventory = 1, 1, 0))>0, sum(if(
        is_short_inventory = 1 and is_daily_dist != 1 and (
        is_wms_stock = 0 or is_warehouse_stock_verify = 0), 1, 0))
        /sum(if(is_short_inventory = 1, 1, 0)), 0)                      as 缺货原因_大仓缺货
     , if(sum(if(is_short_inventory = 1, 1, 0))>0, sum(if(
        is_short_inventory = 1 and is_daily_dist != 1 and (
        is_store_ordered = 1 and (is_wms_stock = 1 or 
        is_warehouse_stock_verify = 1)), 1, 0))/
        sum(if(is_short_inventory = 1, 1, 0)), 0)                       as 缺货原因_大仓未发货
     , if(sum(if(is_short_inventory = 1, 1, 0))>0, sum(if(
        is_short_inventory = 1 and is_daily_dist = 1 and 
        is_store_ordered = 1, 1, 0))/sum(if(is_short_inventory = 
        1, 1, 0)), 0)                                                   as 缺货原因_日配商品和香烟缺货
from phoenix.bi_store_sku_bestseller_stat_by_store_sku_daily
where data_time = '{pt}'
    and is_top = 1
group by data_time_wide, dept_name
having count(distinct if(is_short_inventory = 1, sku_id, null)) > 0 
order by 二级分类 limit 1000000
;

--table2 门店维度统计
--日期、 门店、 缺货sku种类数、 缺货率、 缺货商品损失的GMV、GMV 、 缺货商品损失的GMV率、 缺货原因_大仓缺货或未发货、 缺货原因_门店未订货、 缺货原因_日配商品和香烟缺货
select data_time_wide                                                    as 日期
     , store_id                                                          as 门店id
     , max(store_name)                                                   as 门店
     , count(distinct if(is_short_inventory = 1, sku_id, null))          as 缺货sku种类数
     , if(sum(1) > 0, sum(if(is_short_inventory = 1, 1, 0))/sum(1), 0)   as 缺货率
     , sum(short_day_lost_gmv)                                           as 缺货商品损失的GMV
     , sum(gmv)                                                          as GMV
     , if(sum(gmv)>0, sum(short_day_lost_gmv)/sum(gmv), 0)               as 缺货商品损失的GMV率
     , if(sum(if(is_short_inventory = 1, 1, 0))>0, sum(if(
        is_short_inventory = 1 and is_store_ordered = 0 and ((
            is_daily_dist = 1) or (is_wms_stock = 1 and 
            is_daily_dist != 1)), 1, 0))/sum(if(is_short_inventory 
        = 1, 1, 0)), 0)                                                 as 缺货原因_门店未订货
     , if(sum(if(is_short_inventory = 1, 1, 0))>0, sum(if(
        is_short_inventory = 1 and is_daily_dist != 1 and (
        is_wms_stock = 0 or is_warehouse_stock_verify = 0), 1, 0))
        /sum(if(is_short_inventory = 1, 1, 0)), 0)                      as 缺货原因_大仓缺货
     , if(sum(if(is_short_inventory = 1, 1, 0))>0, sum(if(
        is_short_inventory = 1 and is_daily_dist != 1 and (
        is_store_ordered = 1 and (is_wms_stock = 1 or 
        is_warehouse_stock_verify = 1)), 1, 0))/
        sum(if(is_short_inventory = 1, 1, 0)), 0)                       as 缺货原因_大仓未发货
     , if(sum(if(is_short_inventory = 1, 1, 0))>0, sum(if(
        is_short_inventory = 1 and is_daily_dist = 1 and 
        is_store_ordered = 1, 1, 0))/sum(if(is_short_inventory = 
        1, 1, 0)), 0)                                                   as 缺货原因_日配商品和香烟缺货
from phoenix.bi_store_sku_bestseller_stat_by_store_sku_daily
where data_time = '{pt}'
    and is_top = 1
group by data_time_wide, store_id
order by 门店id limit 1000000
;


--table3 日配供应商未发货商品明细
--日期、 sku_id、 缺货商品数量、 缺货商品损失的GMV

select data_time_wide                        as 日期
     , sku_id                                as sku_id
     , max(commodity_name)                   as 商品名称
     , max(div_name)                         as 一级分类
     , max(dept_name)                        as 二级分类        
     , sum(short_day_lost_sales_num)         as 缺货商品数量
     , sum(short_day_lost_gmv)               as 缺货商品损失的GMV
     , max(wms_inventory_today)              as 大仓库存
     , sum(sdo_order_count_last3days)        as 门店最近3天订货数量
     , max(turnover_days_wms)                as 大仓周转天数
     , max(sku_manager)                      as 采购负责人
from phoenix.bi_store_sku_bestseller_stat_by_store_sku_daily
where data_time = '{pt}'
    and is_top = 1
    and div_id != 24--香烟
    and is_short_inventory = 1 and is_daily_dist = 1 and 
        is_store_ordered = 1
    and short_day_lost_gmv > 0
group by data_time_wide, sku_id
having sum(short_day_lost_sales_num) >= 1
order by 缺货商品损失的GMV desc limit 1000000
;

--table4 大仓缺货商品明细
--日期、 sku_id、 缺货商品数量、 缺货商品损失的GMV
select data_time_wide                        as 日期
     , sku_id                                as sku_id
     , max(commodity_name)                   as 商品名称
     , max(div_name)                         as 一级分类
     , max(dept_name)                        as 二级分类
     , sum(short_day_lost_sales_num)         as 缺货商品数量
     , sum(short_day_lost_gmv)               as 缺货商品损失的GMV
     , max(wms_inventory_today)              as 大仓库存
     , sum(sdo_order_count_last3days)        as 门店最近3天订货数量
     , max(turnover_days_wms)                as 大仓周转天数
     , max(sku_manager)                      as 采购负责人
from phoenix.bi_store_sku_bestseller_stat_by_store_sku_daily
where data_time = '{pt}'
    and is_top = 1
    and is_short_inventory = 1 and is_daily_dist != 1
    and is_store_ordered = 1 
    and short_day_lost_gmv > 0
    and (is_wms_stock = 0 or is_warehouse_stock_verify = 0) --大仓当天库存为0，或者2天前存货不够
group by data_time_wide, sku_id
having sum(short_day_lost_sales_num) >= 1
order by 缺货商品损失的GMV desc limit 1000000
;


--table5 门店未订的商品明细
--日期、 sku_id、 商品名称、 门店名称、 缺货商品数量、 缺货商品损失的GMV

select data_time_wide                   as 日期
     , sku_id                           as sku_id
     , commodity_name                   as 商品名称
     , div_name                         as 一级分类
     , dept_name                        as 二级分类            
     , store_name                       as 门店名称
     , short_day_lost_sales_num         as 缺货商品数量
     , short_day_lost_gmv               as 缺货商品损失的GMV
     , wms_inventory_today              as 大仓库存
     , sdo_order_count_last3days        as 门店最近3天订货数量
     , turnover_days_wms                as 大仓周转天数
     , sku_manager                      as 采购负责人
from phoenix.bi_store_sku_bestseller_stat_by_store_sku_daily
where data_time = '{pt}'
    and is_top = 1
    and is_short_inventory = 1 
    and is_store_ordered = 0 
    and ((is_daily_dist = 1) or (is_wms_stock = 1 and 
            is_daily_dist != 1))
    and short_day_lost_gmv > 0
    and short_day_lost_sales_num >= 1
order by 缺货商品损失的GMV desc limit 1000000
;


--table6 香烟
--日期、 sku_id、 缺货商品数量、 缺货商品损失的GMV

select data_time_wide                        as 日期
     , sku_id                                as sku_id
     , max(commodity_name)                   as 商品名称
     , max(div_name)                         as 一级分类
     , max(dept_name)                        as 二级分类        
     , sum(short_day_lost_sales_num)         as 缺货商品数量
     , sum(short_day_lost_gmv)               as 缺货商品损失的GMV
     , max(wms_inventory_today)              as 大仓库存
     , sum(sdo_order_count_last3days)        as 门店最近3天订货数量
     , max(turnover_days_wms)                as 大仓周转天数
     , max(sku_manager)                      as 采购负责人
from phoenix.bi_store_sku_bestseller_stat_by_store_sku_daily
where data_time = '{pt}'
    and is_top = 1
    and div_id = 24--香烟
    and is_short_inventory = 1 and is_daily_dist = 1 and 
        is_store_ordered = 1
    and short_day_lost_gmv > 0
group by data_time_wide, sku_id
having sum(short_day_lost_sales_num) >= 1
order by 缺货商品损失的GMV desc limit 1000000
;


--table7 sku维度统计
--日期、 sku_id、 商品名称、 是否缺货、 缺货门店数、 缺货商品损失的GMV、GMV 、 缺货商品损失的GMV率、 缺货原因_大仓缺货或未发货、 缺货原因_门店未订货、 缺货原因_日配商品和香烟缺货
select data_time_wide                                                    as 日期
     , sku_id                                                            as sku_id
     , max(commodity_name)                                               as 商品名称
     , max(div_name)                                                     as 一级分类
     , max(dept_name)                                                    as 二级分类
     , count(distinct if(is_short_inventory = 1, store_id, null))        as 缺货门店数
     , if(max(is_short_inventory) = 1, '是', '否')                        as 是否有门店缺货
     , sum(short_day_lost_gmv)                                           as 缺货商品损失的gmv
     , sum(gmv)                                                          as gmv
     , if(sum(gmv)>0, sum(short_day_lost_gmv)/sum(gmv), 0)               as 缺货商品损失的GMV率
     , if(sum(if(is_short_inventory = 1, 1, 0))>0, sum(if(
        is_short_inventory = 1 and is_store_ordered = 0 and ((
            is_daily_dist = 1) or (is_wms_stock = 1 and 
            is_daily_dist != 1)), 1, 0))/sum(if(is_short_inventory 
        = 1, 1, 0)), 0)                                                 as 缺货原因_门店未订货
     , if(sum(if(is_short_inventory = 1, 1, 0))>0, sum(if(
        is_short_inventory = 1 and is_daily_dist != 1 and (
        is_wms_stock = 0 or is_warehouse_stock_verify = 0), 1, 0))
        /sum(if(is_short_inventory = 1, 1, 0)), 0)                      as 缺货原因_大仓缺货
     , if(sum(if(is_short_inventory = 1, 1, 0))>0, sum(if(
        is_short_inventory = 1 and is_daily_dist != 1 and (
        is_store_ordered = 1 and (is_wms_stock = 1 or 
        is_warehouse_stock_verify = 1)), 1, 0))/
        sum(if(is_short_inventory = 1, 1, 0)), 0)                       as 缺货原因_大仓未发货
     , if(sum(if(is_short_inventory = 1, 1, 0))>0, sum(if(
        is_short_inventory = 1 and is_daily_dist = 1 and 
        is_store_ordered = 1, 1, 0))/sum(if(is_short_inventory = 
        1, 1, 0)), 0)                                                   as 缺货原因_日配商品和香烟缺货
     , max(wms_inventory_today)                                         as 大仓库存
     , sum(sdo_order_count_last3days)                                   as 门店最近3天订货数量
     , max(turnover_days_wms)                                           as 大仓周转天数
     , max(sku_manager)                                                 as 采购负责人
from phoenix.bi_store_sku_bestseller_stat_by_store_sku_daily
where data_time = '{pt}'
    and is_top = 1
group by data_time_wide, sku_id
order by 缺货商品损失的GMV desc limit 1000000
;



--table8 口径说明
select *
from
(
select '缺货定义：当天库存一直为0（即当天无商品验收）, 或门店2天前的订货数量大仓没有足量送货' as 口径说明 union all
select '缺货sku种类数: 当天一个sku在所有门店中的任意一家门店缺货则记为缺货' as 口径说明 union all
select '缺货sku种类占比: 缺货sku种类数/总的畅销品sku种类数' as 口径说明 union all
select '缺货率: 缺货的门店sku数/总的门店sku数量' as 口径说明 union all
select '缺货商品损失的gmv: 采用最近30天该门店该商品不缺货天的日均GMV计算' as 口径说明 union all
select '缺货商品损失的gmv率: 缺货商品损失的gmv/gmv' as 口径说明 union all
select '缺货原因_门店未订货: 缺货当天的之前两天内门店没有订货' as 口径说明 union all
select '缺货原因_大仓缺货: 非日配商品, 大仓最近3天无货或者大仓库存少于门店订货数量' as 口径说明 union all
select '缺货原因_大仓未发货: 非日配商品, 大仓最近3天有货, 但是没有发货或者发货数量少于门店订货数量' as 口径说明 union all
select '缺货原因_日配商品和香烟缺货: 日配商品&香烟, 门店有订货但供应商未发货' as 口径说明 union all
select '大仓库存: 大仓当天的期末库存' as 口径说明 union all
select '门店最近3天订货数量: 门店最近3天的订货数量' as 口径说明 
) x;


