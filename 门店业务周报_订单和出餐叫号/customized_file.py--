import pandas as pd
import numpy as np
import datetime
import re
import os
from fetch_data import odps_obj

run_sql = odps_obj.run_sql
pt = odps_obj._pt


default_fmt_json = {'font_name': 'Arial', 'font_size': 11, 'text_h_align': 2, 'text_v_align': 2}
default_legend_fmt_json = {'position': 'bottom', 'font': {'color': '#595959'}}
default_axis_fmt_json = {
    'min': 0,
    'num_font': {'name': '微软雅黑 (正文)', 'size': 9, 'color': '#595959'},
    'name_font': {'name': '微软雅黑 (正文)', 'size': 9, 'color': '#595959'},
    'major_tick_mark': 'none',
    'minor_tick_mark': 'none',
    'line': {'none': True}
}
default_title_fmt_json = {
    'bold': True,
    'name_font': {'name': '微软雅黑 (正文)', 'size': 14}
}
default_column_chart_fmt_json = {'type': 'column', 'subtype': 'stacked'}


def percent(x, digits=1, sign_labels=['', '', '-']):
    if x == 0:
        sign_label = sign_labels[0]
    elif x > 0:
        sign_label = sign_labels[1]
    else:
        sign_label = sign_labels[2]

    if np.isnan(x):
        return x
    else:
        return '{}{}%'.format(sign_label, round(abs(x) * 100, digits))

def dict2excel(data_dict, filename):
    with pd.ExcelWriter(filename, engine='xlsxwriter', options={'strings_to_urls': False}) as writer:
        for df_name, df in data_dict.items():
            df.to_excel(writer, sheet_name=df_name, index=False)

def search_fields(pattern, df):
    return sorted(list(set(filter(lambda x: re.search(pattern, x), df))))

def names2index(col_names, df):
    index_array = [[index for index, value in enumerate(df) if value == col_name] for col_name in col_names]
    return [index for x in index_array for index in x]

def percent_format(workbook, digits=1):
    fmt_json = default_fmt_json
    fmt_json.update({'num_format': '0.%s%%' % ('0' * digits)})
    fmt = workbook.add_format(fmt_json)
    return fmt

def big_format(workbook, digits=0):
    fmt_json = default_fmt_json
    fmt_json.update({'num_format': '#,##0'})
    fmt = workbook.add_format(fmt_json)
    return fmt

def round_format(workbook, digits=1):
    fmt_json = default_fmt_json
    fmt_json.update({'num_format': '#,##0.%s' % ('0' * digits)})
    fmt = workbook.add_format(fmt_json)
    return fmt



def main():
    order_stat_origin = run_sql('''
    select *
    from tmp_ada_order_weekly_summary
    where week_num <= 4
    order by week_date
    limit 4
    ''', print_log=False)


    order_stat = order_stat_origin.copy()
    order_stat

    self_take_order_stat_origin = run_sql('''
    select *
    from tmp_ada_self_take_order_weekly_stat_combine
    where week_num = 1
    order by num, gmv desc
    limit 10000
    ''', print_log=False)

    self_take_order_stat = self_take_order_stat_origin.copy()
    self_take_order_stat

    order_queue_stat_row_origin = run_sql('''
    select
      week_range,
      store_name,
      equipment_name,
      equipment_name_with_on_site_info,
      avg_food_prepare_seconds
    from bi_store_order_queue_weekly_stat
    where day_count = 7 and custom_week_end_date >= dateadd(getdate(), -7, 'dd')
    ''', print_log=False)

    order_queue_stat_row = order_queue_stat_row_origin.copy()
    order_queue_stat_row['num'] = order_queue_stat_row['store_name'].apply(lambda x: 0 if x == '合计' else 1)
    order_queue_stat = order_queue_stat_row.pivot_table('avg_food_prepare_seconds', ['num', 'store_name'],
                                 'equipment_name_with_on_site_info').reset_index().sort_values(['num', '平均出餐时长'])
    order_queue_stat = order_queue_stat[['store_name', '平均出餐时长', 'A窗口（现制现售)', 'A窗口（不含现制现售)',
                                         'B窗口（现制现售)', 'B窗口（不含现制现售)']].\
      rename({'store_name': '门店', '平均出餐时长': '平均出餐时长（分）'}, axis=1)\
      .set_index('门店').applymap(lambda x: x / 60).reset_index()




    order_stat.rename({
        'week_range': '日期范围',
        'gmv': 'GMV',
        'gmv_inside_store': '店内购物GMV',
        'order_count_inside_store': '店内购物订单量',
        'avg_origin_amount_inside_store': '店内购物客单价',
        'gmv_self_take': '自提GMV',
        'order_count_self_take': '自提订单量',
        'avg_origin_amount_self_take': '自提客单价',
        'gmv_proportion_self_take': '自提GMV占比',
        'order_count_proportion_self_take': '自提订单量占比',
        'gmv_app': 'App GMV',
        'order_count_app': 'App订单量',
        'avg_origin_amount_app': 'App客单价',
        'gmv_not_app': '非App GMV',
        'order_count_not_app': '非App订单量',
        'avg_origin_amount_not_app': '非App客单价',
        'gmv_proportion_app': 'App GMV占比',
        'order_count_proportion_app': 'App订单量占比',
        'gmv_offline': '线下GMV',
        'order_count_offline': '线下订单量',
        'avg_origin_amount_offline': '线下客单价',
        'gmv_has_mini_program': '小程序GMV',
        'order_count_has_mini_program': '小程序订单量',
        'avg_origin_amount_has_mini_program': '小程序客单价',
        'gmv_proportion_has_mini_program': '小程序GMV占比',
        'order_count_proportion_has_mini_program': '小程序订单量占比',
        'gmv_machine_self_service': '自助收银GMV',
        'order_count_machine_self_service': '自助收银订单量',
        'avg_origin_amount_machine_self_service': '自助收银客单价',
        'gmv_proportion_machine_self_service': '自助收银GMV占比',
        'order_count_proportion_machine_self_service': '自助收银订单量占比',
        'gmv_mini_program': '微信扫码小程序GMV',
        'order_count_mini_program': '微信扫码小程序订单量',
        'avg_origin_amount_mini_program': '微信扫码小程序客单价',
        'order_count_wechat_pay': '微信订单量',
        'wow_order_count_wechat_pay': '微信订单量周环比',
        'order_count_proportion_wechat_pay': '微信订单占比',
        'order_count_alipay': '支付宝订单量',
        'wow_order_count_alipay': '支付宝订单量周环比',
        'order_count_proportion_alipay': '支付宝订单占比',
        'order_count_offline_pay': '现金订单量',
        'wow_order_count_offline_pay': '现金订单量周环比',
        'order_count_proportion_offline_pay': '现金订单量占比',
        'order_count_balance_pay': '余额支付订单量',
        'wow_order_count_balance_pay': '余额支付订单量周环比',
        'order_count_proportion_balance_pay': '余额订单占比'
    }, axis=1, inplace=True)


# ### 购物方式

    sheet_vs_df = {}
    df1 = order_stat[['日期范围', 'GMV', 'wow_gmv', '店内购物GMV', 'wow_gmv_inside_store',
                'contribute_rate_gmv_inside_store', '店内购物订单量', '店内购物客单价',
                '自提GMV', 'wow_gmv_self_take', 'contribute_rate_gmv_self_take',
                '自提订单量', '自提客单价', '自提GMV占比', '自提订单量占比']]\
    .rename({
        'wow_gmv': '周环比',
        'wow_gmv_inside_store': '周环比',
        'contribute_rate_gmv_inside_store': 'GMV增长贡献率',
        'wow_gmv_self_take': '周环比',
        'contribute_rate_gmv_self_take': 'GMV增长贡献率'}, axis=1)

    sheet_vs_df['购物方式'] = df1
    df1


# ### 购物方式-自提

    df1_1 = self_take_order_stat
    df1_1 = df1_1.drop(['num', 'week_range', 'week_date', 'week_num'], axis=1)
    df1_1.rename({
        'store_name': '门店',
        'gmv': 'GMV',
        'wow_gmv': '周环比',
        'order_count': '订单量',
        'wow_order_count': '周环比',
        'avg_origin_amount': '客单价',
        'wow_avg_origin_amount': '周环比',
        'discount_rate': '补贴率',
        'wow_discount_rate': '周环比',
        'first_order_count': '新用户订单量',
        'wow_first_order_count': '周环比',
        'old_order_count': '老用户订单量',
        'wow_old_order_count': '周环比'
    }, axis=1, inplace=True)
    sheet_vs_df['购物方式_自提'] = df1_1
    df1_1


# ### 下单方式

    df2 = order_stat[['日期范围', 'GMV', 'wow_gmv', 'App GMV', 'wow_gmv_app', 'contribute_rate_gmv_app',
                'App订单量', 'App客单价', '非App GMV', 'wow_gmv_not_app', 'contribute_rate_gmv_not_app',
                '非App订单量', '非App客单价', 'App GMV占比', 'App订单量占比']]\
    .rename({
        'wow_gmv': '周环比',
        'wow_gmv_app': '周环比',
        'contribute_rate_gmv_app': 'GMV增长贡献率',
        'wow_gmv_not_app': '周环比',
        'contribute_rate_gmv_not_app': 'GMV增长贡献率'}, axis=1)

    sheet_vs_df['下单方式'] = df2
    df2


# ### 下单方式-非App


    df3 = order_stat[['日期范围', '非App GMV', 'wow_gmv_not_app', '线下GMV', 'wow_gmv_offline', 'contribute_rate_gmv_offline',
                '线下订单量', '线下客单价', '小程序GMV', 'wow_has_mini_program', 'contribute_rate_gmv_has_mini_program',
                '小程序订单量', '小程序客单价', '小程序GMV占比', '小程序订单量占比']]\
    .rename({
        'wow_gmv_not_app': '周环比',
        'wow_gmv_offline': '周环比',
        'contribute_rate_gmv_offline': 'GMV贡献率',
        'wow_has_mini_program': '周环比',
        'contribute_rate_gmv_has_mini_program': 'GMV贡献率'
    }, axis=1)

    sheet_vs_df['下单方式_非App'] = df3
    df3


# ### 下单方式-非App-小程序

    df4 = order_stat[['日期范围', '小程序GMV', 'wow_has_mini_program', '自助收银GMV',
                 'wow_gmv_machine_self_service', 'contribute_rate_gmv_self_service',
                '自助收银订单量', '自助收银客单价', '微信扫码小程序GMV', 'wow_gmv_mini_program',
                'contribute_rate_gmv_mini_program', '微信扫码小程序订单量', '微信扫码小程序客单价',
                '自助收银GMV占比', '自助收银订单量占比']]\
    .rename({
        'wow_has_mini_program': '周环比',
        'wow_gmv_machine_self_service': '周环比',
        'contribute_rate_gmv_self_service': 'GMV贡献率',
        'wow_gmv_mini_program': '周环比',
        'contribute_rate_gmv_mini_program': 'GMV贡献率'}, axis=1)

    sheet_vs_df['下单方式_非App_小程序'] = df4
    df4


# ### 支付方式

    df5 = order_stat[['日期范围', '微信订单量', '微信订单量周环比', '微信订单占比', '支付宝订单量', '支付宝订单量周环比',
                '支付宝订单占比', '现金订单量', '现金订单量周环比', '现金订单量占比', '余额支付订单量', '余额支付订单量周环比',
                '余额订单占比']]
    sheet_vs_df['支付方式'] = df5
    df5

# ### 出餐叫号
    sheet_vs_df['出餐叫号'] = order_queue_stat

    filename = '门店业务周报_订单和出餐叫号_%s.xlsx' % order_stat_origin['week_date'].max().strftime('%Y%m%d')
    filename = os.path.join('data', filename)
    print(filename)
    with pd.ExcelWriter(filename, engine='xlsxwriter') as writer:
        workbook = writer.book

        # 购物方式
        sheet_name = '购物方式'
        df = sheet_vs_df[sheet_name]
        df.to_excel(writer, index=False, sheet_name=sheet_name)

        worksheet = writer.sheets[sheet_name]

        fmt = big_format(workbook)
        for col in names2index(search_fields('[GMV|订单量]$', df), df):
            worksheet.set_column(col, col, None, fmt)

        fmt = percent_format(workbook)
        for col in names2index(search_fields('环比|贡献率|占比', df), df):
            worksheet.set_column(col, col, None, fmt)

        fmt = round_format(workbook)
        for col in names2index(search_fields('客单价', df), df):
            worksheet.set_column(col, col, None, fmt)

        for col in names2index(['日期范围'], df):
            worksheet.set_column(col, col, None, workbook.add_format(default_fmt_json))


        column_chart = workbook.add_chart(default_column_chart_fmt_json)
        column_chart.set_legend(default_legend_fmt_json)
        y_axis_fmt_json = dict(default_axis_fmt_json)
        y_axis_fmt_json['num_format'] = '0,"K"'
        y_axis_fmt_json['major_gridlines'] = {'visible': True, 'line': {'color': '#D9D9D9'}}
        column_chart.set_y_axis(y_axis_fmt_json)
        column_chart.set_x_axis(default_axis_fmt_json)
        title_fmt_json = default_title_fmt_json
        title_fmt_json['name'] = 'GMV-购物方式'
        column_chart.set_title(title_fmt_json)
        column_chart.add_series({'categories': '=%s!$A$2:$A$5' % sheet_name,
                          'values': '=%s!$D$2:$D$5' % sheet_name,
                          'fill': {'color': '#FFC000'},
                          'name': '店内购物GMV',
                          'data_labels': {'value': True, 'num_format': '0,"K"'}})
        column_chart.add_series({'categories': '=%s!$A$2:$A$5' % sheet_name,
                          'values': '=%s!$I$2:$I$5' % sheet_name,
                          'fill': {'color': '#00B0F0'},
                          'name': '自提GMV',
                          'data_labels': {'value': True, 'num_format': '0,"K"'}})
        line_chart = workbook.add_chart({'type': 'line'})
        y2_axis_fmt = dict(default_axis_fmt_json)
        y2_axis_fmt['num_format'] = '0%'
        line_chart.set_y2_axis(y2_axis_fmt)
        line_chart.add_series({'categories': '=%s!$A$2:$A$5' % sheet_name,
                               'values': '=%s!$N$2:$N$5' % sheet_name,
                               'y2_axis': True,
                               'line': {'color': '#FF0000'},
                               'name': '自提GMV占比',
                               'data_labels': {'value': True, 'num_format': '0.0%'}})

        column_chart.combine(line_chart)
        worksheet.insert_chart('C10', column_chart)


        # 购物方式-自提
        sheet_name = '购物方式_自提'
        df = sheet_vs_df[sheet_name]
        df.to_excel(writer, index=False, sheet_name=sheet_name)

        worksheet = writer.sheets[sheet_name]

        fmt = percent_format(workbook)
        for col in names2index(search_fields('周环比|率', df), df):
            worksheet.set_column(col, col, None, fmt)

        fmt = big_format(workbook)
        for col in names2index(search_fields('[GMV|订单量]$', df), df):
            worksheet.set_column(col, col, None, fmt)

        fmt = round_format(workbook)
        for col in names2index(search_fields('客单价', df), df):
            worksheet.set_column(col, col, None, fmt)

        for col in names2index(search_fields('门店', df), df):
            worksheet.set_column(col, col, None, workbook.add_format(default_fmt_json))



        # 下单方式
        sheet_name = '下单方式'
        df = sheet_vs_df[sheet_name]
        df.to_excel(writer, index=False, sheet_name=sheet_name)

        worksheet = writer.sheets[sheet_name]

        fmt = big_format(workbook)
        for col in names2index(search_fields('[GMV|订单量]$', df), df):
            worksheet.set_column(col, col, None, fmt)

        fmt = percent_format(workbook)
        for col in names2index(search_fields('环比|贡献率|占比', df), df):
            worksheet.set_column(col, col, None, fmt)

        fmt = round_format(workbook)
        for col in names2index(search_fields('客单价', df), df):
            worksheet.set_column(col, col, None, fmt)

        for col in names2index(['日期范围'], df):
            worksheet.set_column(col, col, None, workbook.add_format(default_fmt_json))

        column_chart = workbook.add_chart(default_column_chart_fmt_json)
        column_chart.set_legend(default_legend_fmt_json)
        y_axis_fmt_json = dict(default_axis_fmt_json)
        y_axis_fmt_json['num_format'] = '0,"K"'
        y_axis_fmt_json['major_gridlines'] = {'visible': True, 'line': {'color': '#D9D9D9'}}
        column_chart.set_y_axis(y_axis_fmt_json)
        column_chart.set_x_axis(default_axis_fmt_json)
        title_fmt_json = default_title_fmt_json
        title_fmt_json['name'] = 'GMV-下单方式'
        column_chart.set_title(title_fmt_json)
        column_chart.add_series({'categories': '=%s!$A$2:$A$5' % sheet_name,
                          'values': '=%s!$D$2:$D$5' % sheet_name,
                          'fill': {'color': '#FFC000'},
                          'name': 'App GMV',
                          'data_labels': {'value': True, 'num_format': '0,"K"'}})
        column_chart.add_series({'categories': '=%s!$A$2:$A$5' % sheet_name,
                          'values': '=%s!$I$2:$I$5' % sheet_name,
                          'fill': {'color': '#00B0F0'},
                          'name': '非App GMV',
                          'data_labels': {'value': True, 'num_format': '0,"K"'}})
        line_chart = workbook.add_chart({'type': 'line'})
        y2_axis_fmt = dict(default_axis_fmt_json)
        y2_axis_fmt['num_format'] = '0%'
        line_chart.set_y2_axis(y2_axis_fmt)
        line_chart.add_series({'categories': '=%s!$A$2:$A$5' % sheet_name,
                               'values': '=%s!$N$2:$N$5' % sheet_name,
                               'y2_axis': True,
                               'line': {'color': '#FF0000'},
                               'name': 'App GMV占比',
                               'data_labels': {'value': True, 'num_format': '0.0%'}})

        column_chart.combine(line_chart)
        worksheet.insert_chart('C10', column_chart)

        #下单方式-非APP

        sheet_name = '下单方式_非App'
        df = sheet_vs_df[sheet_name]
        df.to_excel(writer, index=False, sheet_name=sheet_name)

        worksheet = writer.sheets[sheet_name]



        fmt = big_format(workbook)
        for col in names2index(search_fields('[GMV|订单量]$', df), df):
            worksheet.set_column(col, col, None, fmt)

        fmt = percent_format(workbook)
        for col in names2index(search_fields('环比|贡献率|占比', df), df):
            worksheet.set_column(col, col, None, fmt)

        fmt = round_format(workbook)
        for col in names2index(search_fields('客单价', df), df):
            worksheet.set_column(col, col, None, fmt)

        for col in names2index(['日期范围'], df):
            worksheet.set_column(col, col, None, workbook.add_format(default_fmt_json))

        column_chart = workbook.add_chart(default_column_chart_fmt_json)
        column_chart.set_legend(default_legend_fmt_json)
        y_axis_fmt_json = dict(default_axis_fmt_json)
        y_axis_fmt_json['num_format'] = '0,"K"'
        y_axis_fmt_json['major_gridlines'] = {'visible': True, 'line': {'color': '#D9D9D9'}}
        column_chart.set_y_axis(y_axis_fmt_json)
        column_chart.set_x_axis(default_axis_fmt_json)
        title_fmt_json = default_title_fmt_json
        title_fmt_json['name'] = 'GMV-下单方式-非App'
        column_chart.set_title(title_fmt_json)
        column_chart.add_series({'categories': '=%s!$A$2:$A$5' % sheet_name,
                          'values': '=%s!$D$2:$D$5' % sheet_name,
                          'fill': {'color': '#FFC000'},
                          'name': '线下GMV',
                          'data_labels': {'value': True, 'num_format': '0,"K"'}})
        column_chart.add_series({'categories': '=%s!$A$2:$A$5' % sheet_name,
                          'values': '=%s!$I$2:$I$5' % sheet_name,
                          'fill': {'color': '#00B0F0'},
                          'name': '小程序GMV',
                          'data_labels': {'value': True, 'num_format': '0,"K"'}})
        line_chart = workbook.add_chart({'type': 'line'})
        y2_axis_fmt = dict(default_axis_fmt_json)
        y2_axis_fmt['num_format'] = '0%'
        line_chart.set_y2_axis(y2_axis_fmt)
        line_chart.add_series({'categories': '=%s!$A$2:$A$5' % sheet_name,
                               'values': '=%s!$N$2:$N$5' % sheet_name,
                               'y2_axis': True,
                               'line': {'color': '#FF0000'},
                               'name': '小程序GMV占比',
                               'data_labels': {'value': True, 'num_format': '0.0%'}})

        column_chart.combine(line_chart)
        worksheet.insert_chart('C10', column_chart)

        sheet_name = '下单方式_非App_小程序'
        df = sheet_vs_df[sheet_name]
        df.to_excel(writer, index=False, sheet_name=sheet_name)

        worksheet = writer.sheets[sheet_name]

        fmt = big_format(workbook)
        for col in names2index(search_fields('[GMV|订单量]$', df), df):
            worksheet.set_column(col, col, None, fmt)

        fmt = percent_format(workbook)
        for col in names2index(search_fields('环比|贡献率|占比', df), df):
            worksheet.set_column(col, col, None, fmt)

        fmt = round_format(workbook)
        for col in names2index(search_fields('客单价', df), df):
            worksheet.set_column(col, col, None, fmt)

        for col in names2index(['日期范围'], df):
            worksheet.set_column(col, col, None, workbook.add_format(default_fmt_json))


        column_chart = workbook.add_chart(default_column_chart_fmt_json)
        column_chart.set_legend(default_legend_fmt_json)
        y_axis_fmt_json = dict(default_axis_fmt_json)
        y_axis_fmt_json['num_format'] = '0,"K"'
        y_axis_fmt_json['major_gridlines'] = {'visible': True, 'line': {'color': '#D9D9D9'}}
        column_chart.set_y_axis(y_axis_fmt_json)
        column_chart.set_x_axis(default_axis_fmt_json)
        title_fmt_json = default_title_fmt_json
        title_fmt_json['name'] = 'GMV-下单方式-非App-小程序'
        column_chart.set_title(title_fmt_json)
        column_chart.add_series({'categories': '=%s!$A$2:$A$5' % sheet_name,
                          'values': '=%s!$D$2:$D$5' % sheet_name,
                          'fill': {'color': '#FFC000'},
                          'name': '自助收银GMV',
                          'data_labels': {'value': True, 'num_format': '0,"K"'}})
        column_chart.add_series({'categories': '=%s!$A$2:$A$5' % sheet_name,
                          'values': '=%s!$I$2:$I$5' % sheet_name,
                          'fill': {'color': '#00B0F0'},
                          'name': '微信扫码小程序GMV',
                          'data_labels': {'value': True, 'num_format': '0,"K"'}})
        line_chart = workbook.add_chart({'type': 'line'})
        y2_axis_fmt = dict(default_axis_fmt_json)
        y2_axis_fmt['num_format'] = '0%'
        line_chart.set_y2_axis(y2_axis_fmt)
        line_chart.add_series({'categories': '=%s!$A$2:$A$5' % sheet_name,
                               'values': '=%s!$N$2:$N$5' % sheet_name,
                               'y2_axis': True,
                               'line': {'color': '#FF0000'},
                               'name': '自助收银GMV占比',
                               'data_labels': {'value': True, 'num_format': '0.0%'}})

        column_chart.combine(line_chart)
        worksheet.insert_chart('C10', column_chart)

        sheet_name = '支付方式'
        df = sheet_vs_df[sheet_name]
        df.to_excel(writer, index=False, sheet_name=sheet_name)

        worksheet = writer.sheets[sheet_name]

        fmt = big_format(workbook)
        for col in names2index(search_fields('[GMV|订单量]$', df), df):
            worksheet.set_column(col, col, None, fmt)

        fmt = percent_format(workbook)
        for col in names2index(search_fields('环比|贡献率|占比', df), df):
            worksheet.set_column(col, col, None, fmt)

        fmt = round_format(workbook)
        for col in names2index(search_fields('客单价', df), df):
            worksheet.set_column(col, col, None, fmt)

        for col in names2index(['日期范围'], df):
            worksheet.set_column(col, col, None, workbook.add_format(default_fmt_json))

        column_chart = workbook.add_chart(default_column_chart_fmt_json)
        column_chart.set_legend(default_legend_fmt_json)
        y_axis_fmt_json = dict(default_axis_fmt_json)
        y_axis_fmt_json['num_format'] = '0,"K"'
        y_axis_fmt_json['major_gridlines'] = {'visible': True, 'line': {'color': '#D9D9D9'}}
        column_chart.set_y_axis(y_axis_fmt_json)
        column_chart.set_x_axis(default_axis_fmt_json)
        title_fmt_json = default_title_fmt_json
        title_fmt_json['name'] = '订单量-支付方式'
        column_chart.set_title(title_fmt_json)

        column_chart.add_series({'categories': '=%s!$A$2:$A$5' % sheet_name,
                          'values': '=%s!$B$2:$B$5' % sheet_name,
                          'fill': {'color': '#FFC000'},
                          'name': '微信订单量',
                          'data_labels': {'value': True, 'num_format': '0.0,"K"'}})
        column_chart.add_series({'categories': '=%s!$A$2:$A$5' % sheet_name,
                          'values': '=%s!$E$2:$E$5' % sheet_name,
                          'fill': {'color': '#00B0F0'},
                          'name': '支付宝订单量',
                          'data_labels': {'value': True, 'num_format': '0.0,"K"'}})
        column_chart.add_series({'categories': '=%s!$A$2:$A$5' % sheet_name,
                          'values': '=%s!$H$2:$H$5' % sheet_name,
                          'fill': {'color': '#00B050'},
                          'name': '现金订单量',
                          'data_labels': {'value': True, 'num_format': '0.0,"K"'}})
        column_chart.add_series({'categories': '=%s!$A$2:$A$5' % sheet_name,
                          'values': '=%s!$K$2:$K$5' % sheet_name,
                          'fill': {'color': '#FF0000'},
                          'name': '余额支付订单量',
                          'data_labels': {'value': True, 'num_format': '0.0,"K"'}})
        worksheet.insert_chart('C10', column_chart)

        # 出餐叫号
        sheet_name = '出餐叫号'
        df = sheet_vs_df[sheet_name]
        df.to_excel(writer, index=False, sheet_name=sheet_name)

        worksheet = writer.sheets[sheet_name]

        fmt = round_format(workbook)
        for col in names2index(search_fields('[^门店]', df), df):
            worksheet.set_column(col, col, None, fmt)
        for col in names2index(search_fields('门店', df), df):
            worksheet.set_column(col, col, None, workbook.add_format(default_fmt_json))

        return {'filename': filename}
