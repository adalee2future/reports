from helper import BASE_DIR
from fetch_data import odps_obj
import pandas as pd
import os.path
import json

def main():
    report_id = os.path.dirname(__file__).split('/')[-1]
    mail_cfg = json.loads(open("%s.cfg" % report_id).read())
    filename = os.path.join("data", "%s_%s.xlsx" % (report_id, odps_obj._pt))
    sql_text = open("%s.sql" % report_id).read()
    df_names = ["store", "overall", "commodity_dept", "overall_monthly", "commodity_dept_monthly"]
    data_dict = odps_obj.sql_to_data(sql_text, df_names=df_names)

    stores = data_dict['store']['门店']
    # 汇总
    key_metrics_origin = data_dict["overall"].set_index('门店')
    # 二级品类
    sku_metrics_origin = data_dict["commodity_dept"].set_index('门店')
    # 汇总（月）
    key_metrics_monthly_origin = data_dict["overall_monthly"].set_index('门店')
    # 二级品类（月）
    sku_metrics_monthly_origin = data_dict["commodity_dept_monthly"].set_index('门店')

    with pd.ExcelWriter(filename, engine='xlsxwriter', options={'nan_inf_to_errors': True}) as writer:
        book = writer.book
        fmt_wrap = book.add_format({'text_wrap': True})
        fmt_int = book.add_format({'num_format': '#,##0'})
        fmt_float = book.add_format({'num_format': '#,##0.0'})
        fmt_percent = book.add_format({'num_format': '0.0%'})

        for store in stores:
            sheet = book.add_worksheet(store)

            key_metrics = key_metrics_origin.loc[store].copy()
            key_metrics = key_metrics.rename({'gmv': 'GMV'}, axis=1)
            key_metrics['日期'] = key_metrics['日期'].apply(lambda x: x.strftime('%Y-%m-%d')) + '\n' + key_metrics['星期']
            key_metrics = key_metrics.drop('星期', axis=1)
            key_metrics = key_metrics.set_index('日期')
            key_metrics.loc['Diff(%)'] = key_metrics.sort_index().pct_change().iloc[-1]

            key_res = key_metrics.copy().T

            columns = list(key_res.columns)
            n_columns = len(key_res.columns)
            indexs = list(key_res.index)
            n_index = len(key_res.index)
            # 关键指标
            int_indexs = ['GMV','订单量','新客数','老客数','报废售价']
            float_indexes = ['客单价']
            percent_indexes = ['报废率']

            for j, col in enumerate(columns):
                sheet.write(0, j + 1, col, fmt_wrap)
            for i, index in enumerate(indexs):
                sheet.write(i + 1, 0, index)
            for index in int_indexs:
                i = indexs.index(index) + 1
                for j in range(1, n_columns):
                    sheet.write(i, j, key_res.values[i-1][j-1], fmt_int)
            for index in float_indexes:
                i = indexs.index(index) + 1
                for j in range(1, n_columns):
                    sheet.write(i, j, key_res.values[i-1][j-1], fmt_float)
            for index in percent_indexes:
                i = indexs.index(index) + 1
                for j in range(1, n_columns):
                    sheet.write(i, j, key_res.values[i-1][j-1], fmt_percent)
            for i in range(1, n_index + 1):
                sheet.write(i, n_columns, key_res.values[i-1][-1], fmt_percent)

            sheet.add_table(1, 0, n_index, n_columns, {'header_row':0})


            key_metrics_monthly = key_metrics_monthly_origin.loc[store].copy()
            key_metrics_monthly = key_metrics_monthly.rename({'gmv': 'GMV'}, axis=1)
            key_metrics_monthly['日期'] = key_metrics_monthly['日期'] + '\n' + key_metrics_monthly['星期']
            key_metrics_monthly = key_metrics_monthly.drop('星期', axis=1)
            key_metrics_monthly = key_metrics_monthly.set_index('日期')
            key_metrics_monthly.loc['Diff(%)'] = key_metrics_monthly.sort_index().pct_change().iloc[-1]

            key_monthly_res = key_metrics_monthly.copy().T

            columns = list(key_monthly_res.columns)
            n_columns = len(key_monthly_res.columns)
            indexs = list(key_monthly_res.index)
            n_index = len(key_monthly_res.index)

            for j, col in enumerate(columns):
                sheet.write(0, j + 14, col, fmt_wrap)
            for i, index in enumerate(indexs):
                sheet.write(i + 1, 13, index)
            for index in int_indexs:
                i = indexs.index(index) + 1
                for j in range(1, n_columns):
                    sheet.write(i, j + 13, key_monthly_res.values[i-1][j-1], fmt_int)
            for index in float_indexes:
                i = indexs.index(index) + 1
                for j in range(1, n_columns):
                    sheet.write(i, j + 13, key_monthly_res.values[i-1][j-1], fmt_float)
            for index in percent_indexes:
                i = indexs.index(index) + 1
                for j in range(1, n_columns):
                    sheet.write(i, j + 13, key_monthly_res.values[i-1][j-1], fmt_percent)
            for i in range(1, n_index + 1):
                sheet.write(i, n_columns + 13, key_monthly_res.values[i-1][-1], fmt_percent)

            sheet.add_table(1, 13, n_index, n_columns + 13, {'header_row':0})

            if store in sku_metrics_origin.index:
                sku_metrics = sku_metrics_origin.loc[store].copy()
                sku_metrics = sku_metrics.rename({'gmv':'GMV'}, axis=1)
                sku_metrics['日期'] = sku_metrics['日期'].apply(lambda x: x.strftime('%Y-%m-%d')) + '\n' + sku_metrics['星期']
                sku_metrics = sku_metrics.drop('星期', axis=1)
                sku_metrics = sku_metrics.pivot_table(['GMV','销量'],'日期','二级品类').fillna(0).stack().reset_index()
                sku_metrics['销量'] = sku_metrics['销量'].apply(int)
                sku_metrics.head()

                sku_diff = sku_metrics.pivot_table(['GMV','销量'],  '日期', '二级品类').pct_change().iloc[-1].unstack().T.reset_index()
                sku_diff['日期'] = 'Diff（%）'

                sku_metrics = pd.concat([sku_metrics,sku_diff], sort=True)

                sku_res = sku_metrics.pivot_table(['GMV','销量'],'二级品类','日期')
                sku_res.columns = sku_res.columns.swaplevel()
                sku_res = sku_res.sort_values(sku_res.columns[1], ascending=False)
                idx = pd.MultiIndex(levels=sku_res.columns.levels,
                           labels=[[1,1,0,0,2,2], [0,1,0,1,0,1]],
                           names=sku_res.columns.names)
                sku_res = sku_res[idx]

                sku_res[sku_res.columns[1]] = sku_res[sku_res.columns[1]].apply(int)
                sku_res[sku_res.columns[3]] = sku_res[sku_res.columns[3]].apply(int)

                start_col = 5
                n_index = sku_res.index.size
                n_columns = sku_res.columns.size
                for j, top_level in enumerate(sku_res.columns.levels[0][[1,0,2]]):
                    sheet.merge_range(0, start_col+1+j*2, 0, start_col+1+j*2+1, top_level, fmt_wrap)

                    for i, field in enumerate(sku_res.columns.levels[1]):
                        sheet.write(1, start_col+1+j*2+i, field)

                sheet.write(1, start_col, sku_res.index.name)

                for i, index in enumerate(sku_res.index):
                    sheet.write(i + 2, start_col, index)

                    s_row = sku_res.loc[index]
                    for j, val in enumerate(s_row):
                        if j < len(s_row) - 2:
                            sheet.write(i + 2, start_col+1+j, val, fmt_int)
                        else:
                            sheet.write(i + 2, start_col+1+j, val, fmt_percent)

                sheet.add_table(1, start_col, n_index+1, start_col+n_columns,{'header_row':0})


                sku_metrics_monthly = sku_metrics_monthly_origin.loc[store].copy()
                sku_metrics_monthly = sku_metrics_monthly.rename({'gmv':'GMV'}, axis=1)
                sku_metrics_monthly['日期'] = sku_metrics_monthly['日期'] + '\n' + sku_metrics_monthly['星期']
                sku_metrics_monthly = sku_metrics_monthly.drop('星期', axis=1)
                sku_metrics_monthly = sku_metrics_monthly.pivot_table(['GMV','销量'],'日期','二级品类').fillna(0).stack().reset_index()
                sku_metrics_monthly['销量'] = sku_metrics_monthly['销量'].apply(int)
                sku_metrics_monthly.head()

                sku_diff = sku_metrics_monthly.pivot_table(['GMV','销量'],  '日期', '二级品类').pct_change().iloc[-1].unstack().T.reset_index()
                sku_diff['日期'] = 'Diff（%）'

                sku_metrics_monthly = pd.concat([sku_metrics_monthly,sku_diff], sort=True)

                sku_res = sku_metrics_monthly.pivot_table(['GMV','销量'],'二级品类','日期')
                sku_res.columns = sku_res.columns.swaplevel()
                sku_res = sku_res.sort_values(sku_res.columns[1], ascending=False)
                idx = pd.MultiIndex(levels=sku_res.columns.levels,
                           labels=[[1,1,0,0,2,2], [0,1,0,1,0,1]],
                           names=sku_res.columns.names)
                sku_res = sku_res[idx]

                sku_res[sku_res.columns[1]] = sku_res[sku_res.columns[1]].apply(int)
                sku_res[sku_res.columns[3]] = sku_res[sku_res.columns[3]].apply(int)

                start_col = 18
                n_index = sku_res.index.size
                n_columns = sku_res.columns.size
                for j, top_level in enumerate(sku_res.columns.levels[0][[1,0,2]]):
                    sheet.merge_range(0, start_col+1+j*2, 0, start_col+1+j*2+1, top_level, fmt_wrap)

                    for i, field in enumerate(sku_res.columns.levels[1]):
                        sheet.write(1, start_col+1+j*2+i, field)

                sheet.write(1, start_col, sku_res.index.name)

                for i, index in enumerate(sku_res.index):
                    sheet.write(i + 2, start_col, index)

                    s_row = sku_res.loc[index]
                    for j, val in enumerate(s_row):
                        if j < len(s_row) - 2:
                            sheet.write(i + 2, start_col+1+j, val, fmt_int)
                        else:
                            sheet.write(i + 2, start_col+1+j, val, fmt_percent)

                sheet.add_table(1, start_col, n_index+1, start_col+n_columns,{'header_row':0})


    return {"filename": filename}
