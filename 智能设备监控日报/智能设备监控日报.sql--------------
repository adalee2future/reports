--==============================================================================
--文件名: 智能设备监控日报.sql
--作者: 张亚波、李丽丽
--创建日期: 2018-05-28
--业务：门店
--描述: 智能设备监控日报，邮件报表
--故障解决：重跑
--当前负责人：张亚波

--修改历史
--日期          版本    修改人    修改信息
------------   -----  ------   --------
--2018-05-28    1.0    张亚波    第一版本
--2019-03-28    1.1    张亚波    删除修正字段
--2019-05-27    1.2    李丽丽    费用优化，原费用每个月882，优化后减少了98%的费用，原版本见邮件报表SQL
--==============================================================================
select * 
from
(
  select
    concat(l.week_year, '年第', l.week_of_year, '周') 周标识,
    a.day_id 日期,
    l.weekday_name_cn 星期,
    if(l.is_work_day = 'N', 'x', '') 是否工作日,
    a.beehive_name 蜂窝名称,
    a.customer_id 客户ID,
    a.corp_name 公司名称,
    a.total_people 公司人数,
    coalesce(j.user_num_accumulate, 0) `累计去重用户数`,
    f.set_date 安装日期,
    a.serial_number 设备编码,
    a.machine_name 设备名称,
    a.template_name 模板名称,
    coalesce(b.order_num, 0) 订单量,
    coalesce(i.scan_num, 0) 扫码次数,
    if(i.scan_num > 0, coalesce(b.order_num, 0) / i.scan_num, null) 转化率,
    coalesce(b.gmv, 0) gmv,
    round(coalesce(b.gmv, 0) - coalesce(k.purchase_amount, 0), 1) 毛利,
    coalesce(b.pcs, 0) 售卖pcs,
    coalesce(b.user_num, 0) 用户数,
    c.lost_pcs `货损pcs(人工盘点)`, 
    round(c.lost_amount, 1) `货损金额(人工盘点)`,
    if(b.gmv > 0, c.lost_amount / b.gmv, null) 货损率, 
    -- coalesce(h.lost_pcs_ck_rep, c.lost_pcs) `货损pcs(人工盘点)_修正`,
    -- coalesce(round(h.lost_amount_ck_rep, 1), round(c.lost_amount, 1)) `货损金额(人工盘点)_修正`,
    -- if(b.gmv > 0, coalesce(h.lost_amount_ck_rep, c.lost_amount) / b.gmv, null) 货损率_修正, 
    h.lost_pcs_ck_pick `货损pcs(门店分拣)`,
    round(h.lost_amount_ck_pick, 1) `货损金额(门店分拣)`,
    d.lost_pcs `货损pcs_视频审核(多拿-少拿)`,
    round(d.checklost_pur, 1) `货损金额_视频审核(按成本)`,
    d.checklost 发起追缴金额,
    d.payback 追缴回实收金额,
    round(d.lost_pay_back_pur_check, 1) 追缴回成本金额,
    d.fdrate 追缴完成率,
    coalesce(e.rep_num, 0) 补货次数,
    e.type 补货类型,
    e.expect_replenish_count 需求pcs,
    e.pick_count 拣货pcs,
    e.actual_replenish_count 补货pcs,
    g.actual_reject_count 退货pcs,
    round(g.actual_reject_amount, 1) 退货成本金额,
    g.broken_count 报废pcs,
    round(g.broken_amount, 1) 报废金额,
    e.picture_url 补货照片
  from 
  ( -- 基础信息
    select 
      to_char(to_date(a.pt, 'yyyymmdd'), 'yyyy-mm-dd') day_id,
      a.pt,
      c.beehive_name,
      cast(b.customer_id as string) customer_id,
      b.corp_name,
      b.total_people,
      a.machine_id,
      a.serial_number,
      a.machine_name,
      coalesce(d.rack_template_name, a.template_name) template_name
    from 
    (
      select a.* 
      from 
      (
        select * 
        from rack.dwd_rack_machine 
        where datetrunc(to_date(pt, 'yyyymmdd'), 'mm') = datetrunc('{dt} 00:00:00', 'mm') 
        and (release_status in (2, 3)
        or machine_id = '109388') -- 8/27添加machine_id = '109388'
      ) a 
      left join
      (
        select * 
        from owo_ods.h_rak_explore__smartrack_rack_device_his 
        where is_delete = 0
          and rack_id not in ('108964', '49231', '108963', '63037', '90616', '108959')
      ) b 
      on a.machine_id = b.rack_id 
      and a.pt = b.day_id
      where a.machine_id in ('108964', '49231', '108963', '63037', '90616', '108959') 
      or b.rack_id is not null
    ) a 
    join 
    (
      select * 
      from rack.dwd_rack_customer 
      where pt = '${bdp.system.bizdate}'
    ) b 
    on a.customer_id = b.customer_id
    left join owo_store.dwd_beehive_rack c
    on a.machine_id = c.machine_id 
    and a.pt = c.pt
    left join 
    (
      select *
      from owo_ods.h_sto_beehive__beehive_rack_template_his
      where datetrunc(to_date(day_id, 'yyyymmdd'), 'mm') = datetrunc('{dt} 00:00:00', 'mm') 
    ) d 
    on c.pt = d.day_id 
    and c.current_template_id = d.id
  ) a 
  left join 
  ( -- 交易信息
    select 
      to_char(pay_complete_time, 'yyyymmdd') day_id,
      machine_id,
      sum(origin_amount) gmv,
      count(order_id) order_num,
      count(distinct user_id) user_num,
      sum(quantity) pcs
    from rack.dwd_rack_order 
    where pt = '${bdp.system.bizdate}'
      and datetrunc(pay_complete_time, 'mm') = datetrunc('{dt} 00:00:00', 'mm') 
      and pay_status = 64
    group by to_char(pay_complete_time, 'yyyymmdd'), machine_id
  ) b 
  on a.machine_id = b.machine_id
  and a.pt = b.day_id
  left join 
  (-- 货损
    select
      to_char(a.complete_time, 'yyyymmdd') day_id,
      a.rack_id,
      sum((b.cur_stock - b.check_count)) lost_pcs, -- cur_stock/check_count 会为null
      sum((b.cur_stock - b.check_count) * coalesce(c.average_price, c.latest_purchase_price, 3)) lost_amount
    from 
    (
      select * 
      from owo_ods.h_sto_beehive__beehive_rack_check_order 
      where datetrunc(complete_time, 'mm') = datetrunc('{dt} 00:00:00', 'mm') 
      and valid=1
    ) a  
    join owo_ods.h_sto_beehive__beehive_rack_check_order_detail b   
    on a.id=b.check_order_id 
    left join 
    (
      select *
      from rack.dwd_comm_moving_price
      where datetrunc(to_date(pt, 'yyyymmdd'), 'mm') = datetrunc('{dt} 00:00:00', 'mm') 
      and project_group = 1
      and city_code = '310100'
    ) c
    on to_char(a.complete_time, 'yyyymmdd') = c.pt 
    and b.merch_id = c.sku_id
    group by to_char(a.complete_time, 'yyyymmdd'), a.rack_id
    union all 
    select 
      to_char(a.create_time, 'yyyymmdd') day_id,
      a.machine_id rack_id,
      - sum(a.amount) lost_pcs,
      - sum(a.amount * coalesce(d.average_price, d.latest_purchase_price, 3)) lost_amount
    from 
    (
      select *
      from owo_ods.kylin__hj_rack_inventoryoperation a 
      where datetrunc(to_date(day_id, 'yyyymmdd'), 'mm') = datetrunc('{dt} 00:00:00', 'mm') 
        and is_valid = 1
        and machine_id <> '12648' -- 猩便利设备
        and ref_id <> '2964835' -- 109288首次补货
        and ref_type in (4, 5)
    ) a 
    inner join 
    (
      select *
      from rack.dwd_rack_machine
      where datetrunc(to_date(pt, 'yyyymmdd'), 'mm') = datetrunc('{dt} 00:00:00', 'mm') 
    ) b 
    on a.machine_id = b.machine_id 
    and to_char(a.create_time, 'yyyymmdd') = b.pt 
    and b.business_belong = 0
    left join owo_ods.kylin__machine_commodity_info c
    on a.machine_commodity_id = c.id 
    left join 
    (
      select *
      from rack.dwd_comm_moving_price
      where datetrunc(to_date(pt, 'yyyymmdd'), 'mm') = datetrunc('{dt} 00:00:00', 'mm') 
        and project_group = 2
        and city_code = '310100'
    ) d
    on c.sku_id = d.sku_id 
    and to_char(a.create_time, 'yyyymmdd') = d.pt 
    group by to_char(a.create_time, 'yyyymmdd'), a.machine_id 
  ) c
  on a.machine_id = c.rack_id
  and a.pt = c.day_id
  left join 
  (
    -- 审核货损
    select 
      day_id,
      seller_id,
      sum(lost_pcs) lost_pcs,
      sum(checklost) checklost,
      sum(case when pay_status <> 64 then if(lost_pcs is null, checklost * 0.7, checklost_pur) else 0 end) lost_amount_pur_check_actual,
      sum(case when pay_status = 64 then if(lost_pcs is null, checklost * 0.7, checklost_pur) else 0 end) lost_pay_back_pur_check,
      sum(if(lost_pcs is null, checklost * 0.7, checklost_pur)) checklost_pur,
      sum(payback) payback,
      if(sum(checklost) > 0, sum(payback) / sum(checklost), null) fdrate
    from 
    (
      select
        to_char(a.steal_time, 'yyyymmdd') day_id,
        a.seller_id,
        a.id,
        max(a.pay_status) pay_status,
        sum(b.quantity) lost_pcs, -- 盗损pcs 多拿 + 少拿
        max(a.origin_amount) checklost, -- 追缴金额（发起追缴的金额）
        max(if(a.pay_status = 64, a.origin_amount, 0)) payback, --追缴回金额
        coalesce(sum(case when x.business_belong = 1 and b.commodity_type = 2 then b.quantity * coalesce(c.average_price, c.latest_purchase_price, 3) else 0 end), 0)
          + coalesce(sum(case when x.business_belong <> 1 and b.commodity_type = 2 then b.quantity * coalesce(d.average_price, d.latest_purchase_price, 3) else 0 end), 0)
          + coalesce(sum(case when x.business_belong = 1 and b.commodity_type = 1 then b.quantity * coalesce(c.average_price, c.latest_purchase_price, 3) else 0 end), 0)
          + coalesce(sum(case when x.business_belong <> 1 and b.commodity_type = 1 then b.quantity * coalesce(d.average_price, d.latest_purchase_price, 3) else 0 end), 0) checklost_pur --审核货损金额_成本 
      from 
      (
        select * 
        from owo_ods.h_rak_explore__zhima_order_order 
        where is_delete = 0 
        and pay_status <> 128 -- 误报
        and datetrunc(steal_time, 'mm') = datetrunc('{dt} 00:00:00', 'mm') 
      ) a 
      join 
      (
        select *
        from rack.dwd_rack_machine
        where datetrunc(to_date(pt, 'yyyymmdd'), 'mm') = datetrunc('{dt} 00:00:00', 'mm') 
      ) x 
      on a.seller_id = x.machine_id 
      and to_char(a.steal_time, 'yyyymmdd') = x.pt 
      left join 
      (
        select 
          coalesce(a.order_id, b.order_id) as order_id,
          coalesce(a.sku_id, b.sku_id) as sku_id,
          coalesce(a.commodity_type, b.take_back_type) as commodity_type,
          coalesce(a.quantity, b.quantity) as quantity
        from 
        (
          select *
          from owo_ods.h_rak_explore__zhima_order_reconciliation
          where commodity_type in (1, 2) -- 类型：0-正常；1-少拿；2-多拿
        ) a 
        full join 
        (
          select * 
          from 
          (
            select cdm.parse_commodity(order_id,details_info) as (order_id,sku_id,sku_name,quantity,sku_price,take_back_type)
            from owo_ods.h_rak_explore__zhima_order_rack_orderitem   
          ) a 
          where take_back_type in (1, 2)
        ) b 
        on a.order_id = b.order_id 
        and a.sku_id = b.sku_id
      ) b 
      on a.id = b.order_id 
      left join 
      (
        select *
        from rack.dwd_comm_moving_price
        where datetrunc(to_date(pt, 'yyyymmdd'), 'mm') = datetrunc('{dt} 00:00:00', 'mm') 

        and project_group = 1
        and city_code = '310100'
      ) c 
      on b.sku_id = c.sku_id 
      and to_char(a.steal_time, 'yyyymmdd') = c.pt
      left join 
      (
        select *
        from rack.dwd_comm_moving_price
        where datetrunc(to_date(pt, 'yyyymmdd'), 'mm') = datetrunc('{dt} 00:00:00', 'mm') 
        and project_group = 2
        and city_code = '310100'
      ) d
      on b.sku_id = d.sku_id 
      and to_char(a.steal_time, 'yyyymmdd') = d.pt
      group by to_char(a.steal_time, 'yyyymmdd'), a.seller_id, a.id
    ) a 
    group by
      day_id,
      seller_id
  ) d 
  on a.machine_id = d.seller_id
  and a.pt = d.day_id
  left join 
  ( 
    select 
      day_id,
      rack_id,
      count(distinct id) rep_num,
      wm_concat('；',a.type) type,
      wm_concat('；',a.picture_url) picture_url,
      sum(expect_replenish_count) expect_replenish_count,
      sum(pick_count) pick_count,
      sum(actual_replenish_count) actual_replenish_count,
      sum(check_replenish_count) check_replenish_count
    from 
    ( -- 补货/铺货pcs
      select 
        to_char(a.complete_time, 'yyyymmdd') day_id,
        a.id,
        a.rack_id,
        if(a.type = 1, '补货', '铺货') type,
        a.picture_url,
        sum(b.expect_replenish_count) expect_replenish_count,
        sum(b.pick_count) pick_count,
        sum(b.actual_replenish_count) actual_replenish_count,
        sum(b.actual_replenish_count) check_replenish_count
      from 
      (
        select * 
        from owo_ods.h_sto_beehive__beehive_rack_replenish_order
        where datetrunc(complete_time, 'mm') = datetrunc('{dt} 00:00:00', 'mm')
          and valid = 1 
          and status = 5
          and type in (1, 3)
      ) a
      join owo_ods.h_sto_beehive__beehive_rack_replenish_order_detail b
      on a.id = b.replenish_order_id
      group by to_char(a.complete_time, 'yyyymmdd'), a.id, a.rack_id, a.type, a.picture_url
      union all
      -- 上新pcs
      select 
        a.day_id,
        a.id,
        a.rack_id,
        a.type,
        a.picture_url,
        sum(a.expect_replenish_count) expect_replenish_count,
        sum(a.pick_count) pick_count,
        -- sum(coalesce(a.actual_replenish_count, 0) - coalesce(b.check_count, 0)) actual_replenish_count,
        sum(if(coalesce(a.actual_replenish_count, 0) - coalesce(b.check_count, 0) < 0, 0, coalesce(a.actual_replenish_count, 0) - coalesce(b.check_count, 0))) as actual_replenish_count,
        sum(if(coalesce(a.actual_replenish_count, 0) - coalesce(b.check_count, 0) < 0, a.pick_count, coalesce(a.actual_replenish_count, 0) - coalesce(b.check_count, 0))) as check_replenish_count
      from
      (
        select 
          to_char(a.complete_time, 'yyyymmdd') day_id,
          a.id,
          a.rack_id,
          a.picture_url,
          '上新' type,
          b.merch_id,
          sum(b.expect_replenish_count) expect_replenish_count,
          sum(b.pick_count) pick_count,
          sum(b.actual_replenish_count) actual_replenish_count
        from
        (
          select * 
          from owo_ods.h_sto_beehive__beehive_rack_replenish_order 
          where datetrunc(complete_time, 'mm') = datetrunc('{dt} 00:00:00', 'mm')
            and valid = 1 
            and status = 5
            and type = 2
        ) a 
        join owo_ods.h_sto_beehive__beehive_rack_replenish_order_detail b
        on a.id = b.replenish_order_id
        group by 
          to_char(a.complete_time, 'yyyymmdd'),
          a.id,
          a.rack_id,
          a.picture_url,
          b.merch_id
      ) a 
      left join 
      (
        select 
          a.replenish_order_id,
          b.merch_id,
          sum(b.check_count) check_count
        from owo_ods.h_sto_beehive__beehive_rack_check_order a 
        join owo_ods.h_sto_beehive__beehive_rack_check_order_detail b   
          on a.id=b.check_order_id
        where a.valid=1
          and a.replenish_order_id is not null
        group by 
          a.replenish_order_id,
          b.merch_id
      ) b 
      on a.id = b.replenish_order_id
      and a.merch_id = b.merch_id
      group by a.day_id, a.id, a.rack_id, a.type, a.picture_url
      union all 
      select
        to_char(a.update_time, 'yyyymmdd') day_id,
        a.id,
        a.machine_id rack_id,
        '蜂窝外货架补货' type,
        a.pic_url,
        b.order_pcs expect_replenish_count,
        b.pick_pcs pick_count,
        b.replenish_pcs actual_replenish_count,
        b.replenish_pcs check_replenish_count 
      from 
      (
        select * 
        from owo_ods.h_scm_tms__machine_replenish_record 
        where is_valid = 1 
        and status = 20
      ) a 
      inner join owo_ods.h_scm_tms__replenish_process_log b 
      on a.id = b.order_id 
      inner join 
      (
        select *
        from rack.dwd_rack_machine
        where datetrunc(to_date(pt, 'yyyymmdd'), 'mm') = datetrunc('{dt} 00:00:00', 'mm')
      ) c 
      on a.machine_id = c.machine_id 
      and to_char(a.update_time, 'yyyymmdd') = c.pt 
      and c.business_belong = 0
    ) a 
    group by day_id, rack_id
  ) e 
  on a.machine_id = e.rack_id
  and a.pt = e.day_id
  left join 
  (
    select 
      a.machine_id,
      case
        when a.machine_id = '49231' then '2018-05-17'
        when a.machine_id = '63037' then '2018-05-24'
        when a.machine_id = '90616' then '2018-05-18'
        when a.machine_id = '108959' then '2018-05-24'
        when a.machine_id = '108963' then '2018-05-16'
        when a.machine_id = '108964' then '2018-05-16'
        else to_char(greatest(b.create_time, coalesce(a.check_online_time, '2018-01-01 00:00:00')), 'yyyy-mm-dd')
      end set_date
    from 
    (
      select * 
      from rack.dwd_rack_machine 
      where pt = '${bdp.system.bizdate}'
    ) a 
    left join 
    (
      select * 
      from owo_ods.h_rak_explore__smartrack_rack_device 
      where rack_id not in ('108964', '49231', '108963', '63037', '90616', '108959')
    ) b 
    on a.machine_id = b.rack_id
    where a.machine_id in ('108964', '49231', '108963', '63037', '90616', '108959')
    or b.rack_id is not null
  ) f 
  on a.machine_id=f.machine_id
  left join 
  (
    select
      to_char(a.reject_time, 'yyyymmdd') day_id,
      a.rack_id,
      sum(b.expect_reject_count) expect_reject_count,
      sum(b.actual_reject_count) actual_reject_count,
      sum(b.actual_reject_count * coalesce(c.average_price, c.latest_purchase_price, 3)) actual_reject_amount,
      sum(b.broken_count) broken_count,
      sum(b.broken_count * coalesce(c.average_price, c.latest_purchase_price, 3)) broken_amount,
      sum(b.verify_count) verify_count
    from 
    (
      select *
      from owo_ods.h_sto_beehive__beehive_rack_reject_order
      where datetrunc(reject_time, 'mm') = datetrunc('{dt} 00:00:00', 'mm')
      and valid = 1
      and status = 4 
    ) a 
    join owo_ods.h_sto_beehive__beehive_rack_reject_order_detail b
    on a.id = b.reject_order_id
    left join 
    (
      select * 
      from rack.dwd_comm_moving_price 
      where datetrunc(to_date(pt, 'yyyymmdd'), 'mm') = datetrunc('{dt} 00:00:00', 'mm')
        and project_group = 1 
        and city_code = '310100'
    ) c
    on to_char(a.reject_time, 'yyyymmdd') = c.pt  
    and b.merch_id = c.sku_id
    group by 
      to_char(reject_time, 'yyyymmdd'), 
      a.rack_id
    union all 
    select 
      to_char(a.retreat_date, 'yyyymmdd') day_id,
      a.machine_id rack_id,
      sum(b.theoretical_retreat_amount) expect_reject_count,
      sum(b.auctual_retreat_amount) actual_reject_count,
      sum(b.auctual_retreat_amount * coalesce(d.average_price, d.latest_purchase_price, 3)) actual_reject_amount,
      sum(b.bad_count) broken_count,
      sum(b.bad_count * coalesce(d.average_price, d.latest_purchase_price, 3)) broken_amount,
      sum(0) verify_count
    from 
    (
      select * 
      from owo_ods.h_scm_tms__hj_rack_retreatrecord 
      where is_valid=1 
      and status = 20
    ) a 
    join owo_ods.h_scm_tms__hj_rack_retreatcommoditydetail b
    on a.id = b.retreat_record_id
    join 
    (
      select *
      from rack.dwd_rack_machine
      where datetrunc(to_date(pt, 'yyyymmdd'), 'mm') = datetrunc('{dt} 00:00:00', 'mm')
    ) c 
    on a.machine_id = c.machine_id 
    and to_char(a.retreat_date, 'yyyymmdd') = c.pt 
    and c.business_belong = 0
    left join 
    (
      select * 
      from rack.dwd_comm_moving_price 
      where datetrunc(to_date(pt, 'yyyymmdd'), 'mm') = datetrunc('{dt} 00:00:00', 'mm') 
        and project_group = 2
        and city_code = '310100'
    ) d
    on to_char(a.retreat_date, 'yyyymmdd') = d.pt  
    and b.sku_id = d.sku_id
    group by to_char(a.retreat_date, 'yyyymmdd'), a.machine_id
  ) g 
  on a.pt = g.day_id
  and a.machine_id = g.rack_id
  left join 
  (
    select 
      to_char(check_time, 'yyyymmdd') day_id,
      machine_id,
      sum(lost_pcs_check) as lost_pcs_check,
      sum(lost_amount_check) as lost_amount_check,
      sum(lost_pcs_ck_rep) as lost_pcs_ck_rep,
      sum(lost_amount_ck_rep) as lost_amount_ck_rep,
      sum(lost_pcs_ck_pick) as lost_pcs_ck_pick,
      sum(lost_amount_ck_pick) as lost_amount_ck_pick,
      sum(lost_pcs_ck_rep_actual_reject) as lost_pcs_ck_rep_actual_reject,
      sum(lost_amount_ck_rep_actual_reject) as lost_amount_ck_rep_actual_reject,
      sum(lost_pcs_ck_pick_actual_reject) as lost_pcs_ck_pick_actual_reject,
      sum(lost_amount_ck_pick_actual_reject) as lost_amount_ck_pick_actual_reject
    from kylin.tmp_zyb_beehive_rack_inventoryoperation
    where type in ('check_consumer', 'check_rep_new')
    group by to_char(check_time, 'yyyymmdd'), machine_id
  ) h
  on a.pt = h.day_id
  and a.machine_id = h.machine_id
  left join 
  (
    select
      to_char(create_time, 'yyyymmdd') day_id,
      rack_id,
      count(id) scan_num
    from owo_ods.h_rak_stat__user_buy_jump_log_his
    where day_id = '${bdp.system.bizdate}'
    and to_char(create_time, 'yyyymmdd') >= 20180603
    and is_delete = 0
    and type = 1
    group by to_char(create_time, 'yyyymmdd'), rack_id
  ) i 
  on a.pt = i.day_id
  and a.machine_id = i.rack_id
  left join 
  (
    select 
      a.day_id,
      b.customer_id,
      sum(c.user_count) over 
        (distribute by b.customer_id sort by a.day_id rows between 9999 preceding and 0 following)
        user_num_accumulate
    from
    (
      select *, 1 num
      from cdm.dim_calendar
      where datetrunc(to_date(day_id, 'yyyymmdd'), 'mm') = datetrunc('{dt} 00:00:00', 'mm') 
    ) a
    left join
    (
      select distinct customer_id, 1 num
      from kylin.customer_user_first_order
    ) b
    on a.num = b.num
    left join
    (
      select 
        customer_id, 
        if(day_id <= to_char(datetrunc('{dt} 00:00:00', 'mm'), 'yyyymmdd'),
          to_char(datetrunc('{dt} 00:00:00', 'mm'), 'yyyymmdd'),
          day_id) day_id,
        count(*) user_count
      from kylin.customer_user_first_order
      group by 
        customer_id,
        if(day_id <= to_char(datetrunc('{dt} 00:00:00', 'mm'), 'yyyymmdd'),
          to_char(datetrunc('{dt} 00:00:00', 'mm'), 'yyyymmdd'),
          day_id)
    ) c
    on a.day_id = c.day_id and b.customer_id = c.customer_id
  ) j
  on a.pt = j.day_id 
  and a.customer_id = j.customer_id 
  left join 
  (
    select 
      to_char(a.pay_complete_time, 'yyyymmdd') day_id, 
      a.machine_id,
      sum(
            case 
              when b.business_belong = 1 then a.quantity * coalesce(d.average_price, d.latest_purchase_price, 3)
              when b.business_belong <> 1 then a.quantity * coalesce(c.average_price, c.latest_purchase_price, 3)
            end
          ) purchase_amount
    from 
    (
      select * 
      from rack.dwd_rack_order_item
      where pt = '${bdp.system.bizdate}'
      and pay_status = 64 
    ) a 
    inner join 
    ( 
      select *
      from rack.dwd_rack_machine
      where datetrunc(to_date(pt, 'yyyymmdd'), 'mm') = datetrunc('{dt} 00:00:00', 'mm') 
    ) b 
    on to_char(a.pay_complete_time, 'yyyymmdd') = b.pt 
    and a.machine_id = b.machine_id 
    left join 
    (
      select * 
      from rack.dwd_comm_moving_price 
      where datetrunc(to_date(pt, 'yyyymmdd'), 'mm') = datetrunc('{dt} 00:00:00', 'mm') 
        and project_group = 2 
    ) c
    on to_char(a.pay_complete_time, 'yyyymmdd') = c.pt 
    and b.city_id = c.city_code
    and a.sku_id = c.sku_id 
    left join 
    (
      select * 
      from rack.dwd_comm_moving_price 
      where datetrunc(to_date(pt, 'yyyymmdd'), 'mm') = datetrunc('{dt} 00:00:00', 'mm') 
        and project_group = 1 -- 对应的只有上海
        and city_code = '310100'
    ) d
    on to_char(a.pay_complete_time, 'yyyymmdd') = d.pt  
    and a.sku_id = d.sku_id
    group by to_char(a.pay_complete_time, 'yyyymmdd'), a.machine_id
  ) k 
  on a.pt = k.day_id 
  and a.machine_id = k.machine_id 
  join cdm.dim_calendar l 
  on a.pt = l.day_id
  where a.pt >= replace(f.set_date, '-', '') 
  or f.set_date is null
) a 
order by `蜂窝名称` desc, `公司名称`,  `设备编码`, `日期` desc -- `客户ID`
limit 1000000
