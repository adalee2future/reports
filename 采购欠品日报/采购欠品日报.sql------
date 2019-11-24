select 
  concat(purchase_no) 采购单号,
  concat('https://scm.abc.com/purchase/view/',purchase_no) 采购单号链接,
  sku_code 商品编码,
  sp_commodity_name 商品名称,
  sp_name 供应商名称,
  case when create_by = 'system' then '日配' else create_by end 创建人,
  to_char(delivery_date,'yyyy-mm-dd') 截止日期,
  rell_price 采购单价,
  order_num  采购数量,
  round(order_amount, 2) 采购金额,
  round(receipt_amount_on_time ,2) 截止到货金额,
  coalesce(receipt_qty_on_time, 0)   截止到货数量,
  round(lack_amount ,2 ) 欠品金额,
  lack_qty 欠品数量
from 
	rack.dwd_pms_lack_order_detail
where 
	pt='{pt}'
and 
	day_id='{pt}'
and 
	is_lack=1
and 
	-- 剔除直配到店
	purchase_type<>5
order by 
	欠品金额 desc limit 99999
