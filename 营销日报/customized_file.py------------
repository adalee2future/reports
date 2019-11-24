import json
import pandas as pd
import numpy as np
import os
from fetch_data import odps_obj
from file_to_mail import STYLES

def main():
    report_id = "营销日报"
    mail_cfg = json.loads(open("%s.cfg" % report_id).read())
    df_names = mail_cfg.get("df_names")
    merge = mail_cfg.get("merge", False)
    customized_styles = mail_cfg.get("customized_styles", "")
    html_filename = os.path.join("data", "%s_%s.html" % (report_id, odps_obj._pt))
    excel_filename = os.path.join("data", "%s_%s.xlsx" % (report_id, odps_obj._pt))
    sql_text = open("%s.sql" % report_id).read()
    data_meta = odps_obj.sql_to_html(sql_text, html_filename, df_names=df_names, merge=merge, customized_styles=customized_styles)[0][0]
    print("data_meta:", data_meta)
    odps_obj.sql_to_excel(sql_text, excel_filename, df_names=df_names)
    body_prepend = open(html_filename).read()

    return { "filename": excel_filename, "body_prepend": body_prepend , "data_meta": data_meta }

