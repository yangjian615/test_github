
;+
; :Description:
;    Describe the procedure.
;     calculate anomalous_resistivity
; :Params:
;    TIME_E_wave   ;EFW time      s
;    E_WAVE        ;[*,4] [[EX_WAVE],[EY_WAVE],[EZ_WAVE],[ETOTAL_WAVE]]   mV/m
;    B_wave        ;as E_WAVE    nT
;    n_e           ;cm-3
;    v_e           ;km/s
;    n_e_Width     ;density smooth window width
;    nv_e_Width    ;velocity smooth
;    average_time  ;s
;
; :Keywords:
;    E_resistivity     [*,4]
;    B_resistivity     [*,4]
;    anomalous_resistivity   [*,4]
; :Returns:
;
; :Author: dell-yangjian
;-
; :Bugs:
;
;  written at 21:10:09 2016-5-16
;  Email:yangjian615@buaa.edu.cn
;
pro anomalous_resistivity,TIME_E_wave,E_WAVE,B_wave,n_e,v_e,n_e_Width,nv_e_Width,average_time,$
E_resistivity=E_resistivity,B_resistivity=B_resistivity,anomalous_resistivity=anomalous_resistivity
  compile_opt idl2
 
  ;; =============================================
  ;caculate_anomalous_resistivity
  ;E_resistivity=-1/n<¦ÄE¦Än>   B_resistivity=-1/n(¦Ä<nVe>x¦ÄB>
  ;; =============================================
  TIME_E_wave=DINDGEN(100)   ;s
  E_WAVE=[[SIN(TIME_E_wave)],[SIN(TIME_E_wave)],[SIN(TIME_E_wave)],[SIN(TIME_E_wave)]]    ;mv/m
  B_wave=[[cos(TIME_E_wave)],[cos(TIME_E_wave)],[SIN(TIME_E_wave)],[SIN(TIME_E_wave)]]    ;nT
  
  n_e=DINDGEN(100)           ;cm-3
  v_e=[[DINDGEN(100)*100],[DINDGEN(100)*100],[DINDGEN(100)*100]]
  v_e_total= magnitude_vec(TRANSPOSE(v_e))
  v_e=[[v_e],[v_e_total]]
  
  n_e_Width=20
  nv_e_Width=20
  average_time=1.0      ;the averaging time (in seconds)
  
  
  
  smooth_N_E=smooth(n_e,n_e_Width,/edge_truncate,/NAN)
  wave_N_E=n_e-smooth_N_E
  
  
  ;; =============================================
  ;;E_resistivity
  
  E_n_average_x=smooth_in_time(E_WAVE[*,0]*wave_N_E,TIME_E_wave,average_time)
  E_n_average_y=smooth_in_time(E_WAVE[*,1]*wave_N_E,TIME_E_wave,average_time)
  E_n_average_z=smooth_in_time(E_WAVE[*,2]*wave_N_E,TIME_E_wave,average_time)
  E_n_average_total=smooth_in_time(E_WAVE[*,3]*wave_N_E,TIME_E_wave,average_time)
  
  
  E_n_average=[[E_n_average_x],[E_n_average_y],[E_n_average_z],[E_n_average_total]]
  
  E_resistivity_x=-1/n_e*E_n_average[*,0]
  E_resistivity_y=-1/n_e*E_n_average[*,1]
  E_resistivity_z=-1/n_e*E_n_average[*,2]
  E_resistivity_total=-1/n_e*E_n_average[*,3]
  
  
  E_resistivity=[[E_resistivity_x],[E_resistivity_y],[E_resistivity_z],[E_resistivity_total]]
  
  ;; =============================================
  ;B_resistivity=-1/n(¦Ä<nVe>x¦ÄB>
  ;; =============================================
  ;
  Ne_ve=[[n_e],[n_e],[n_e],[n_e]]*v_e
  wave_Ne_ve_x=Ne_ve[*,0]-smooth(Ne_ve[*,0],nv_e_Width,/edge_truncate,/NAN)
  wave_Ne_ve_y=Ne_ve[*,1]-smooth(Ne_ve[*,1],nv_e_Width,/edge_truncate,/NAN)
  wave_Ne_ve_z=Ne_ve[*,2]-smooth(Ne_ve[*,2],nv_e_Width,/edge_truncate,/NAN)
  wave_Ne_ve_total=Ne_ve[*,3]-smooth(Ne_ve[*,3],nv_e_Width,/edge_truncate,/NAN)
  
  wave_Ne_ve=[[wave_Ne_ve_x],[wave_Ne_ve_y],[wave_Ne_ve_z],[wave_Ne_ve_total]]
  
  
  ;¦Ä<nVe>x¦ÄB
  
  wave_Ne_ve_cross_wave_B=cross_product(wave_Ne_ve[*,0:2],B_wave[*,0:2])
  
  wave_Ne_ve_wave_B_total=wave_Ne_ve[*,3]*B_wave[*,3]
  
  wave_Ne_ve_cross_wave_B_average_x=smooth_in_time(wave_Ne_ve_cross_wave_B[*,0],TIME_E_wave,average_time)
  wave_Ne_ve_cross_wave_B_average_y=smooth_in_time(wave_Ne_ve_cross_wave_B[*,1],TIME_E_wave,average_time)
  wave_Ne_ve_cross_wave_B_average_z=smooth_in_time(wave_Ne_ve_cross_wave_B[*,2],TIME_E_wave,average_time)
  wave_Ne_ve_wave_B_average_total=smooth_in_time(wave_Ne_ve_wave_B_total,TIME_E_wave,average_time)
  
  wave_Ne_ve_cross_wave_B_average=[[wave_Ne_ve_cross_wave_B_average_x],$
    [wave_Ne_ve_cross_wave_B_average_y],[wave_Ne_ve_cross_wave_B_average_z],[wave_Ne_ve_wave_B_average_total]]
    
  B_resistivity_x=-1/n_e*wave_Ne_ve_cross_wave_B_average[*,0]
  B_resistivity_y=-1/n_e*wave_Ne_ve_cross_wave_B_average[*,1]
  B_resistivity_z=-1/n_e*wave_Ne_ve_cross_wave_B_average[*,2]
  B_resistivity_total=-1/n_e*wave_Ne_ve_cross_wave_B_average[*,3]
  
  B_resistivity=[[B_resistivity_x],[B_resistivity_y],[B_resistivity_z],[B_resistivity_total]]
  
  
  anomalous_resistivity=E_resistivity+B_resistivity
  
  
  
end