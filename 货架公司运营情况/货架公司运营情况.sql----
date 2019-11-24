select b.city_name ,
       a.area,
       a.corp_name,
       a.detail_address,
       a.contact_names,
       a.telephones,
       b.machine_cnt,
       b.earliest_online_date,
       d.machines,
       round(c.avg_30days_order_cnt_wday,1) avg_30days_order_cnt_wday, 
       round(c.avg_30days_order_cnt_wend,1) avg_30days_order_cnt_wend, 
       round(c.avg_30days_origin_amount_wday) avg_30days_origin_amount_wday,
       round(c.avg_30days_origin_amount_wend) avg_30days_origin_amount_wend,
       round(c.avg_30days_actual_amount_wday) avg_30days_actual_amount_wday,
       round(c.avg_30days_actual_amount_wend) avg_30days_actual_amount_wend,
       round(c.avg_7days_order_cnt_wday,1) avg_7days_order_cnt_wday, 
       round(c.avg_7days_order_cnt_wend,1) avg_7days_order_cnt_wend, 
       round(c.avg_7days_origin_amount_wday) avg_7days_origin_amount_wday,
       round(c.avg_7days_origin_amount_wend) avg_7days_origin_amount_wend,
       round(c.avg_7days_actual_amount_wday) avg_7days_actual_amount_wday,
       round(c.avg_7days_actual_amount_wend) avg_7days_actual_amount_wend
from
kylin.ada_customer_info a
left outer join kylin.ada_customer_machine_overall b
on a.customer_id = b.customer_id
left outer join kylin.ada_customer_recent_sales_overall c
on b.customer_id = c.customer_id
left join
(
select customer_id,wm_concat(',',CONCAT(machine_sub_type_name,':',serial_num)) machines from
  (select customer_id,machine_sub_type_name,WM_CONCAT('/',serial_number) serial_num from rack.dw_machine group by customer_id,machine_sub_type_name) a
group by customer_id
) d on a.customer_id = d.customer_id
where b.machine_cnt > 0
