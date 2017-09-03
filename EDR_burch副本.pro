init_crib_colors
time_stamp,/off
tplot_restore,FILENAMES='/Users/yangjian/Desktop/heat flux figure/EDR_Burch.tplot'


tplot_restore,FILENAMES='/Users/yangjian/Desktop/mms_test_all/saved.tplot'
tplot,'*'

tplot_rename,'mms1_dis_heatx_dbcs_fast','mms1_dis_heatflu_dbcs_fast_x'
tplot_rename,'mms1_dis_heaty_dbcs_fast','mms1_dis_heatflu_dbcs_fast_y'
tplot_rename,'mms1_dis_heatz_dbcs_fast','mms1_dis_heatflu_dbcs_fast_z'

join_vec,'mms1_dis_heatflu_dbcs_fast'+['_x','_y','_z'],'mms1_dis_heatflux'
tplot,'mms1_dis_heatflux_mom H1 H2 H3 mms1_dis_dist_fast_eflux_rmscpot'

calc,'"Q"="H2"+"H3"+"mms1_dis_heatflux_tclip"',/INTERPOLATE
tplot,'Q H2 H3 mms1_dis_heatflux_tclip'

end