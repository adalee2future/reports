import glob
import json
import pandas as pd
from fetch_data import odps_obj
import os
import numpy as np

def main():
    pd.set_option('display.max_colwidth', -1)
    report_cfg_files = glob.glob('../*/*cfg')
    mail_cfgs = [json.loads(open(cfg_file).read()) for cfg_file in report_cfg_files]

    mail_df = pd.DataFrame.from_dict(mail_cfgs)
    mail_df.is_online = mail_df.is_online.fillna(True)
    mail_df.db_type = mail_df.db_type.fillna("odps")
    mail_df = mail_df[mail_df.is_online]
    mail_df = mail_df[['report_name', 'owner', 'to', 'cc', 'db_type', 'file_type', 'frequency']]
    #mail_df.sort_values(['db_type', 'file_type'], inplace=True)
    mail_df.index = np.arange(1, mail_df.shape[0] + 1)
    filename = os.path.join('data', '邮件报表列表_%s.xlsx' % odps_obj._pt)
    print(filename)
    mail_df.to_excel(filename)
    mail_df.head()

    return {'filename': filename}
