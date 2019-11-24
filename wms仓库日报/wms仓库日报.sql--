SELECT * FROM (SELECT po.`warehouse_code`AS '仓库编码',
       ware.`warehouse_name` AS '仓库名',
       ware.`city_name` AS '城市名',
       COUNT(DISTINCT(CASE WHEN header.`po_type` in(10, 20) THEN header.`po_no` ELSE null END)) AS '采购单数',
       COUNT(CASE WHEN header.`po_type` in(10, 20) THEN po.`id` ELSE null END) AS '采购sku数',
       cast(SUM(CASE WHEN header.`po_type` in(10, 20) THEN po.`purchase_qty` ELSE 0 END) as decimal(10,1)) AS '采购需求pieces',
       cast(SUM(CASE WHEN header.`po_type` in(10, 20) THEN po.`receive_qty` ELSE 0 END) as decimal(10,1)) AS '采购实际pieces',
       concat(round(100*SUM(CASE WHEN header.`po_type` in(10, 20) THEN po.`receive_qty` ELSE 0 END) /SUM(CASE WHEN header.`po_type` in(10, 20) THEN po.`purchase_qty` ELSE 0 END), 2),'%') AS '采购pieces实际/需求',
       COUNT(DISTINCT(CASE WHEN header.`po_type` IN(50) THEN header.`po_no`ELSE null END)) AS '货架退仓单数',
       COUNT(CASE WHEN header.`po_type` in(50) THEN po.`id` ELSE null END) AS '货架退仓sku数',
       cast(SUM(CASE WHEN header.`po_type` in(50) THEN po.`receive_qty` ELSE 0 END) as decimal(10,1)) AS '货架退仓实际pieces',
           
       COUNT(DISTINCT(CASE WHEN header.`po_type` IN(51) THEN header.`po_no`ELSE null END)) AS '线路退仓单数',
       COUNT(CASE WHEN header.`po_type` in(51) THEN po.`id` ELSE null END) AS '线路退仓sku数',
       cast(SUM(CASE WHEN header.`po_type` in(51) THEN po.`receive_qty` ELSE 0 END) as decimal(10,1)) AS '线路退仓实际pieces'
  FROM `h_scm_wms`.`inb_po_detail` po
  LEFT JOIN `h_scm_wms`.`inb_po_header` header ON po.`po_no`= header.`po_no`
  LEFT JOIN `h_scm_wms`.`bas_warehouse` ware ON po.`warehouse_id`= ware.`id`
 WHERE po.`create_time`> DATE_ADD(DATE(now()), INTERVAL -1 DAY)
   and po.`create_time`< DATE(now())
   and po.`is_delete`= 0
 GROUP BY po. warehouse_code
 ORDER BY cast(SUM(CASE WHEN header.`po_type` in(10, 20) THEN po.`receive_qty` ELSE 0 END) as decimal(10,1) ) DESC) as a
UNION ALL 
SELECT * FROM  (SELECT  '合计',
       '仓库名',
       '城市名',
       COUNT(DISTINCT(CASE WHEN header.`po_type` in(10, 20) THEN header.`po_no` ELSE null END)) AS '采购单数',
       COUNT(CASE WHEN header.`po_type` in(10, 20) THEN po.`id` ELSE null END) AS '采购sku数',
       cast(SUM(CASE WHEN header.`po_type` in(10, 20) THEN po.`purchase_qty` ELSE 0 END) as decimal(10,1)) AS '采购需求pieces',
       cast(SUM(CASE WHEN header.`po_type` in(10, 20) THEN po.`receive_qty` ELSE 0 END) as decimal(10,1)) AS '采购实际pieces',
       '采购pieces实际/需求',
        COUNT(DISTINCT(CASE WHEN header.`po_type` IN(50) THEN header.`po_no`ELSE null END)) AS '货架退仓单数',
       COUNT(CASE WHEN header.`po_type` in(50) THEN po.`id` ELSE null END) AS '货架退仓sku数',
       cast(SUM(CASE WHEN header.`po_type` in(50) THEN po.`receive_qty` ELSE 0 END) as decimal(10,1)) AS '货架退仓实际pieces',
               
       COUNT(DISTINCT(CASE WHEN header.`po_type` IN(51) THEN header.`po_no`ELSE null END)) AS '线路退仓单数',
       COUNT(CASE WHEN header.`po_type` in(51) THEN po.`id` ELSE null END) AS '线路退仓sku数',
       cast(SUM(CASE WHEN header.`po_type` in(51) THEN po.`receive_qty` ELSE 0 END) as decimal(10,1)) AS '线路退仓实际pieces'
  FROM `h_scm_wms`.`inb_po_detail` po
  LEFT JOIN `h_scm_wms`.`inb_po_header` header ON po.`po_no`= header.`po_no`
  LEFT JOIN `h_scm_wms`.`bas_warehouse` ware ON po.`warehouse_id`= ware.`id`
 WHERE po.`create_time`> DATE_ADD(DATE(now()), INTERVAL -1 DAY)
   and po.`create_time`< DATE(now())
   and po.`is_delete`= 0) as b;
   
   
   
    
    SELECT  * FROM  (SELECT so.`warehouse_code` AS '仓库编码',
       ware.`warehouse_name` AS '仓库名',
       ware.`city_name` AS '城市名',
       (case when header.so_type =10 then COUNT(DISTINCT(so.`so_no`)) else 0 end) AS '铺货需求单数目',
       (case when header.so_type =10 then count(DISTINCT(ship.`so_no`)) else 0 end) AS '铺货实际单数目',
       cast(floor(SUM(CASE WHEN header.`so_type`=10 THEN so.`demand_qty` ELSE 0 END)) as char(256))  AS '铺货需求piece数目',
       cast(floor(SUM(CASE WHEN header.`so_type`=10 THEN ship.`ship_qty` ELSE 0 END)) as char(256)) AS '铺货实际出库piece数目',
       concat(round(100*(cast(floor(SUM(CASE WHEN header.`so_type`=10 THEN ship.`ship_qty` ELSE 0 END)) as char(256))) /(cast(floor(SUM(CASE WHEN header.`so_type`=10 THEN so.`demand_qty` ELSE 0 END)) as char(256))), 2),'%') AS '铺货实际/需求piece比例',
       COUNT(distinct(case when header.so_type =11 then so.`so_no` else 0 end))AS '补货需求单数目',
       COUNT(distinct(case when header.so_type =11 then ship.`so_no` else 0 end)) AS '补货实际单数目',
       cast(floor(SUM(CASE WHEN header.`so_type`=11 THEN so.`demand_qty` ELSE 0 END)) as char(256))  AS '补货需求piece数目',
       cast(floor(SUM(CASE WHEN header.`so_type`=11 THEN ship.`ship_qty` ELSE 0 END)) as char(256)) AS '补货实际出库piece数目',
       concat(round(100*(cast(floor(SUM(CASE WHEN header.`so_type`=11 THEN ship.`ship_qty` ELSE 0 END)) as char(256))) /(cast(floor(SUM(CASE WHEN header.`so_type`=11 THEN so.`demand_qty` ELSE 0 END)) as char(256))), 2),'%') AS '补货实际/需求piece比例'
  FROM h_scm_wms.v_oub_so_detail so
  LEFT JOIN(
SELECT `so_no`, `sku_id`, cast(SUM(`ship_qty`) as decimal(10,1)) AS ship_qty
  FROM h_scm_wms.oub_ship_detail
 WHERE `create_time`> DATE_ADD(DATE(now()), INTERVAL -1 DAY)
 GROUP BY `so_no`, `sku_id`) ship ON so.`so_no`= ship.`so_no`
   and so.`sku_id`= ship.`sku_id`
  LEFT JOIN `h_scm_wms`.`bas_warehouse` ware ON so.`warehouse_id`= ware.`id`
  LEFT JOIN `h_scm_wms`.v_oub_so_header header on so.so_no = header.so_no 
 WHERE so.`create_time`> DATE_ADD(DATE(now()), INTERVAL -1 DAY)
   and so.`create_time`< DATE(now())
   and so.`is_delete`= 0
 GROUP BY so. warehouse_code 
 ORDER BY SUM(so.`demand_qty`) DESC ) a 
 UNION ALL 
 SELECT * FROM  (SELECT '合计',
       '仓库名',
       '城市名',
       (case when header.so_type =10 then COUNT(DISTINCT(so.`so_no`)) else 0 end) AS '铺货需求单数目',
       (case when header.so_type =10 then count(DISTINCT(ship.`so_no`)) else 0 end) AS '铺货实际单数目',
       cast(floor(SUM(CASE WHEN header.`so_type`=10 THEN so.`demand_qty` ELSE 0 END)) as char(256))  AS '铺货需求piece数目',
       cast(floor(SUM(CASE WHEN header.`so_type`=10 THEN ship.`ship_qty` ELSE 0 END)) as char(256)) AS '铺货实际出库piece数目',
       '铺货实际/需求piece比例',
       COUNT(distinct(case when header.so_type =11 then so.`so_no` else 0 end))AS '补货需求单数目',
       COUNT(distinct(case when header.so_type =11 then ship.`so_no` else 0 end)) AS '补货实际单数目',
       cast(floor(SUM(CASE WHEN header.`so_type`=11 THEN so.`demand_qty` ELSE 0 END)) as char(256))  AS '补货需求piece数目',
       cast(floor(SUM(CASE WHEN header.`so_type`=11 THEN ship.`ship_qty` ELSE 0 END)) as char(256)) AS '补货实际出库piece数目',
       '补货实际/需求piece比例'
  FROM h_scm_wms.v_oub_so_detail so
  LEFT JOIN(
SELECT `so_no`, `sku_id`, cast(SUM(`ship_qty`) as decimal(10,1)) AS ship_qty
  FROM h_scm_wms.oub_ship_detail
 WHERE `create_time`> DATE_ADD(DATE(now()), INTERVAL -1 DAY)
 GROUP BY `so_no`, `sku_id`) ship ON so.`so_no`= ship.`so_no`
   and so.`sku_id`= ship.`sku_id`
  LEFT JOIN `h_scm_wms`.`bas_warehouse` ware ON so.`warehouse_id`= ware.`id`
  LEFT JOIN `h_scm_wms`.v_oub_so_header header on so.so_no = header.so_no 
 WHERE so.`create_time`> DATE_ADD(DATE(now()), INTERVAL -1 DAY)
   and so.`create_time`< DATE(now())
   and so.`is_delete`= 0 ) b;

 

 
SELECT * FROM ( select inv. warehouse_code AS '仓库编码',
       ware.`warehouse_name` AS '仓库名',
       ware.`city_name` AS '城市名',
       cast(sum(inv.`available_qty`) as decimal(10,1)) AS '可用库存pieces',
       cast(sum(inv.`inventory_qty`) as decimal(10,1)) AS '实际库存pieces',
       count(DISTINCT(inv.sku_id)) AS 'SKU种类数'
  FROM `h_scm_wms`.`inv_inventory` inv
  LEFT JOIN `h_scm_wms`.`bas_warehouse` ware ON inv.`warehouse_id`= ware.`id`
 where inv.`is_delete`= 0
 GROUP BY inv. warehouse_code
 ORDER BY cast(sum(inv.`available_qty`) as decimal(10,1)) DESC) as a 
UNION ALL 
SELECT * FROM (select '合计',
       '仓库名',
       '城市名',
       cast(sum(inv.`available_qty`) as decimal(10,1)) AS '可用库存pieces',
       cast(sum(inv.`inventory_qty`) as decimal(10,1)) AS '实物库存pieces',
       count(DISTINCT(inv.sku_id)) AS 'SKU种类数'
  FROM `h_scm_wms`.`inv_inventory` inv
  LEFT JOIN `h_scm_wms`.`bas_warehouse` ware ON inv.`warehouse_id`= ware.`id`
 where inv.`is_delete`= 0) as b 
 
