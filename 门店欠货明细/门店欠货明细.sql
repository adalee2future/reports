SELECT
  date_sub('{dt}',interval 1 day) 日期,
  shop.`name` AS '门店名称',
  cDiv.div_name 一级品类,
  dept.dept_name 二级品类,
  cls.class_name 三级品类,
  scls.subclass_name 四级品类,
  sku.`sku_code` AS '商品编码',
  spu.`commodity_name` AS '商品名称',
CASE 
 WHEN ord.`type` =1 THEN '出库欠货'
  ELSE '验货欠货'
END AS '欠货类型',
det.`lack_count` AS '欠货数',
distri.order_count AS '订货数量',
distri.distributed_count AS '发货数量'
FROM `h_sto_store`.`store_insufficient_order_detail` det 
LEFT JOIN `h_sto_store`.`store_insufficient_order` ord ON det.`order_id`  = ord.`id` 
LEFT JOIN `h_sto_store`.`store_shop` shop ON ord.`shop_id` = shop.`id` 
LEFT JOIN `h_scm_commodity`.`commodity_sku` sku ON det.`sku_id`  = sku.`id` 
LEFT JOIN `h_scm_commodity`.`commodity_spu` spu ON sku.`spu_id` = spu.`id` 
LEFT JOIN `h_scm_commodity`.`commodity_div` cDiv ON spu.`div_id` = cDiv.`id` 
LEFT JOIN `h_scm_commodity`.`commodity_dept` dept ON spu.`dept_id` = dept.`id` 
LEFT JOIN `h_scm_commodity`.`commodity_class` cls ON spu.`class_id` = cls.`id` 
LEFT JOIN `h_scm_commodity`.`commodity_subclass` scls ON spu.`subclass_id` = scls.`id` 
LEFT JOIN 
(
SELECT ord.`sdo_id`, det.`sku_id` , det.`order_count` , det.distributed_count FROM `h_sto_store`.`store_distribution_order_detail` det 
LEFT JOIN `h_sto_store`.`store_distribution_order` ord ON det.`order_id` = ord.`id` where ord.send_type  <> 1
) distri 
ON ord.`sdo_id` = distri.sdo_id AND det.`sku_id` = distri.sku_id
WHERE ord.`type` =1 
and det.`create_time` >= (concat (DATE_FORMAT(date_sub('{dt}',interval 1 day) ,'%Y-%m-%d'), ' 10:00:00'))
and det.`create_time` <  '{dt} 10:00:00'
ORDER BY shop.`id`
;

SELECT
  date_sub('{dt}',interval 1 day) 日期,
  shop.`name` AS '门店名称',
  cDiv.div_name AS '一级品类',
  dept.dept_name 二级品类,
  cls.class_name 三级品类,
  scls.subclass_name 四级品类,
  sku.`sku_code` AS '商品编码',
  spu.`commodity_name` AS '商品名称', 
  CASE 
   WHEN ord.`type` =1 THEN '出库欠货'
    ELSE '验货欠货'
  END AS '欠货类型',
  det.`lack_count` AS '欠货数',
  distri.order_count AS '订货数量',
  distri.distributed_count AS '发货数量'
FROM `h_sto_store`.`store_insufficient_order_detail` det 
LEFT JOIN `h_sto_store`.`store_insufficient_order` ord ON det.`order_id`  = ord.`id` 
LEFT JOIN `h_sto_store`.`store_shop` shop ON ord.`shop_id` = shop.`id` 
LEFT JOIN `h_scm_commodity`.`commodity_sku` sku ON det.`sku_id`  = sku.`id` 
LEFT JOIN `h_scm_commodity`.`commodity_spu` spu ON sku.`spu_id` = spu.`id` 
LEFT JOIN `h_scm_commodity`.`commodity_div` cDiv ON spu.div_id = cDiv.id
LEFT JOIN `h_scm_commodity`.`commodity_dept` dept ON spu.`dept_id` = dept.`id` 
LEFT JOIN `h_scm_commodity`.`commodity_class` cls ON spu.`class_id` = cls.`id` 
LEFT JOIN `h_scm_commodity`.`commodity_subclass` scls ON spu.`subclass_id` = scls.`id` 
LEFT JOIN 
(SELECT ord.`sdo_id`, det.`sku_id` , det.`order_count` , det.distributed_count FROM `h_sto_store`.`store_distribution_order_detail` det 
LEFT JOIN `h_sto_store`.`store_distribution_order` ord ON det.`order_id` = ord.`id` where ord.send_type <> 1 ) distri ON ord.`sdo_id` = distri.sdo_id AND det.`sku_id` = distri.sku_id
WHERE cDiv.div_name NOT LIKE ('%香烟%') AND
ord.`type` =2 
and det.`create_time` >= (concat (DATE_FORMAT(date_sub('{dt}',interval 1 day) ,'%Y-%m-%d'), ' 10:00:00'))
and det.`create_time` < '{dt} 10:00:00'
ORDER BY shop.`id`;

SELECT
  date_sub('{dt}',interval 1 day) 日期,
  CASE 
   WHEN ord.`type` =1 THEN '出库欠货'
    ELSE '验货欠货'
  END AS '欠货类型',
  sum(det.`lack_count`) AS '欠货数',
  sum(distri.order_count) AS '订货数量',
  sum(distri.distributed_count) AS '发货数量'
FROM `h_sto_store`.`store_insufficient_order_detail` det 
LEFT JOIN `h_sto_store`.`store_insufficient_order` ord ON det.`order_id`  = ord.`id` 
LEFT JOIN `h_sto_store`.`store_shop` shop ON ord.`shop_id` = shop.`id` 
LEFT JOIN `h_scm_commodity`.`commodity_sku` sku ON det.`sku_id`  = sku.`id` 
LEFT JOIN `h_scm_commodity`.`commodity_spu` spu ON sku.`spu_id` = spu.`id` 
LEFT JOIN `h_scm_commodity`.`commodity_div` cDiv ON spu.div_id = cDiv.id
LEFT JOIN 
(SELECT ord.`sdo_id`, det.`sku_id` , det.`order_count` , det.distributed_count FROM `h_sto_store`.`store_distribution_order_detail` det 
LEFT JOIN `h_sto_store`.`store_distribution_order` ord ON det.`order_id` = ord.`id` where ord.send_type <> 1 ) distri ON ord.`sdo_id` = distri.sdo_id AND det.`sku_id` = distri.sku_id
WHERE cDiv.div_name NOT LIKE ('%香烟%') and det.`create_time` >= (concat (DATE_FORMAT(date_sub('{dt}',interval 1 day) ,'%Y-%m-%d'), ' 10:00:00'))
and det.`create_time` < '{dt} 10:00:00'
group by
  CASE 
   WHEN ord.`type` =1 THEN '出库欠货'
    ELSE '验货欠货'
  END
ORDER BY 欠货类型, 欠货数 desc
;

select
CONCAT(DATE_FORMAT(date_sub('{dt}',interval 1 day) ,'%Y-%m-%d'), ' 10:00:00') 开始时间,
'{dt} 10:00:00' 结束时间
