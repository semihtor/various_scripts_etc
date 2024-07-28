import urllib.request
import datetime
import gspread

new_external_ip = urllib.request.urlopen('https://v4.ident.me').read().decode('utf8')

sa = gspread.service_account()
sh = sa.open("Home PC Global IP Address")

wks = sh.worksheet("Sheet1")
old_external_ip = wks.acell('B2').value
old_update_time = wks.acell('A2').value

##print('Rows: ', wks.row_count)
##print('Columns: ', wks.col_count)

##print(wks.acell('A1').value)

if new_external_ip != old_external_ip:
    e = datetime.datetime.now()
    wks.update('C2', old_update_time)
    wks.update('A2', e.strftime("%Y-%m-%d %H:%M:%S"))
    wks.update('B2', new_external_ip)
    print('External IP changed. File updated with new external IP.')
else:
    print('New external IP is same as old external IP. File not changed. Last change was', wks.acell('A2').value)
