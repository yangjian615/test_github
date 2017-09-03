FUNCTION magnetic_3D_model,data,time_INCREMENT=time_INCREMENT,add_earth=add_earth
  compile_opt idl2
  
  
  ;
  ;store_data,'pos',data=d1
  ;;tplot,'pos'
  if undefined(data) then RESTORE,'/Users/yangjian/IDLWorkspace82/MMSProject/MMS_TEST/mms_test_data/test_ mms_orbit_plot3D.sav'
  if ~undefined(data) then  d1=data
  if undefined(time_INCREMENT) then time_INCREMENT=120*2
  
  
  ; Create some data.
  t = d1.x
  x = (d1.y[*,0])
  y = (d1.y[*,1])
  z = (d1.y[*,2])
  
  p = PLOT3D(x, y, z,XRANGE=[20,-20],YRANGE=[-15,15],ZRANGE=[-15,15],$
    AXIS_STYLE=2, MARGIN=[0.2,0.3,0.1,0],$
    XMINOR=5, YMINOR=5, ZMINOR=5, $
    DEPTH_CUE=[0,2], /PERSPECTIVE, $
    ;RGB_TABLE=33, VERT_COLORS=VERT_COLORS,$
    SHADOW_COLOR="deep sky blue", $
    XY_SHADOW=1, YZ_SHADOW=1, XZ_SHADOW=1,$
    XTITLE='x', YTITLE='y')
    
    
  ; Hide the three axes in the front.
  ; Get the array of axes and hide
  ; them individually.
  ax=p.axes
  ax[0].tickfont_size = 7
  ax[1].tickfont_size = 7
  ax[8].showtext = 1
  ax[8].tickfont_size = 7
  ax[2].HIDE=1
  ax[4].HIDE=1
  ax[6].HIDE=1
  ax[7].HIDE=1
  p.THICK=2.0
  p.LINESTYLE=6
  
  ;找到最接近的起始整数时间
  
  Tstar=CEIL((time_struct(t[0])).hour+(time_struct(t[0])).min/60.0)
  index_star=(where((time_struct(t)).hour eq Tstar))[0]
  Tend=FLOOR((time_struct(t[N_ELEMENTS(t)-1])).hour+(time_struct(t[N_ELEMENTS(t)-1])).min/60.0)
  index_end=(where((time_struct(t)).hour eq Tend))[0]
  
  mark_number=UINT((Tend-Tstar+1)/(time_INCREMENT/120.0d))
  
  
  VERT_COLORS=cgScaleVector((time_struct(t)).hour,0,230,minvalue=0,MAXVALUE=23)
  
  LOADCT, 25, RGB_TABLE = rgb
  rgb = rgb[0 + 10*INDGEN(24), *]
  
  p2=plot3d(x[index_star:index_end],y[index_star:index_end],z[index_star:index_end],$
    RGB_TABLE=25, VERT_COLORS=VERT_COLORS,/overplot,sym_object = orb())
  p2.LINESTYLE=6
  p2.SYMBOL='o'
  p2.SYM_FILLED=1
  p2.SYM_INCREMENT=time_INCREMENT
  p2.SYM_SIZE=1.2
  
  
  
  C_ticknames = STRING(INDGEN(24), FORMAT='(I0)')
  cb = COLORBAR(TARGET=p2,POSITION=[0.25,0.91,0.8,0.95], RGB_TABLE=rgb, $
    TICKNAME=C_ticknames, BORDER=1)
  cb.FONT_SIZE=7
  cb.TITLE='UT'
  
  
  ;
  ;; =============================================
  ; trace 磁力线
  ;; =============================================
  
  ;  ;T96
  PARMOD=dblarr(10)
  PARMOD[0] =2.58  ;Solar Wind Ram Pressure, nPa
  PARMOD[1] = 9  ;Dst, nT  -22
  PARMOD[2] = 2.17;By, GSM, nT
  PARMOD[3] = 1.00;Bz, GSM, nT
  
  t=time_double('2015-12-31/01:00:00')
  geopacktime=t[0]
  year=(time_struct(geopacktime)).year
  month=(time_struct(geopacktime)).MONTH
  date=(time_struct(geopacktime)).DATE
  hour=(time_struct(geopacktime)).HOUR
  min=(time_struct(geopacktime)).min
  SEC=(time_struct(geopacktime)).SEC
  geopack_recalc_08,year,month,date,hour,min,sec,/date,TILT=TILT
  
  ;  ;球坐标系trace
  ;  geopack_recalc_08,year,month,date,hour,min,sec,/date,TILT=TILT
  ;
  ;
  ;  for i=0,90,10 do begin
  ;    for j=0,180,90 do begin
  ;      geopack_sphcar_08,1,i,j,x,y,z,/degree,/to_rect
  ;      geopack_trace_08,x,y,z,1,parmod,xf,yf,zf,fline=fline;,/noboundary,/T96,TILT=TILT,/IGRF
  ;
  ;      ;geopack_trace,x,y,z,1,7,xf,yf,zf,fline=fline,/noboundary,/T89,TILT=TILT,/IGRF   ;t89C   IOPT= 1       2        3        4        5        6      7
  ;      ;CORRESPOND TO:
  ;      ;        KP= 0,0+  1-,1,1+  2-,2,2+  3-,3,3+  4-,4,4+  5-,5,5+  > =6-
  ;      flineplot=PLOT3D(fline[*,0],fline[*,1],fline[*,2],/OVERPLOT)
  ;    endfor
  ;  endfor
  
  
  ;; =============================================
  ;  卫星位置trace磁力线
  ;; =============================================
  
  ;  选定卫星位置 GSM
  index_trace=index_star+INDGEN((index_end-index_star)/time_INCREMENT+1)*time_INCREMENT
  X_s_trace=X[index_trace]
  Y_s_trace=Y[index_trace]
  Z_s_trace=Z[index_trace]
  
  ;  geopack_recalc_08,year,month,date,hour,min,sec,/date,TILT=TILT
  ;
  ;
  ;  for i=0,85,5 do begin
  ;    for j=0,180,90 do begin
  ;      geopack_sphcar_08,1,i,j,x,y,z,/degree,/to_rect
  ;      geopack_trace_08,x,y,z,1,parmod,xf,yf,zf,fline=fline;,/noboundary,/T96,TILT=TILT,/IGRF
  ;
  ;      ;geopack_trace,x,y,z,1,7,xf,yf,zf,fline=fline,/noboundary,/T89,TILT=TILT,/IGRF   ;t89C   IOPT= 1       2        3        4        5        6      7
  ;      ;CORRESPOND TO:
  ;      ;        KP= 0,0+  1-,1,1+  2-,2,2+  3-,3,3+  4-,4,4+  5-,5,5+  > =6-
  ;      flineplot=PLOT3D(fline[*,0],fline[*,1],fline[*,2],/OVERPLOT)
  ;    endfor
  ;  endfor
  ;
  
  Bmagmin=1.2
  Bmagmax=5
  ;R0=6
  RLIM=15
 
  for i=0,N_ELEMENTS(index_trace)-1 do begin
    ;向地球trace
    geopack_trace_08,X_s_trace[i],Y_s_trace[i],Z_s_trace[i],1,parmod,xf,yf,zf,fline=fline,TILT=TILT,/T96,R0=R0,RLIM=RLIM;,/IGRF
    ;satellite_trace=PLOT3D(fline[*,0],fline[*,1],fline[*,2],/OVERPLOT)   
    
    ;计算磁场 内源IGRF 和 T96
    geopack_igrf_gsw_08,fline[*,0],fline[*,1],fline[*,2],bx_igrf,by_igrf, bz_igrf  
    geopack_t96,parmod,fline[*,0],fline[*,1],fline[*,2],bx, by, bz, tilt=tilt
    bx_all=bx+bx_igrf
    by_all=by+by_igrf
    bz_all=bz+bz_igrf
    Bmag=MAGNITUDE(transpose([[bx_all],[by_all], [bz_all]]))
    
    satellite_trace=PLOT3D(fline[*,0],fline[*,1],fline[*,2],/OVERPLOT,VERT_COLORS=BYTSCL(ALOG10(Bmag),MIN=Bmagmin,MAX=Bmagmax),RGB_TABLE=25)
    
    ;向磁尾trace
    geopack_trace_08,X_s_trace[i],Y_s_trace[i],Z_s_trace[i],-1,parmod,xf,yf,zf,fline=fline,TILT=TILT,/T96,R0=R0,RLIM=RLIM;,/IGRF
    ;    satellite_trace=PLOT3D(fline[*,0],fline[*,1],fline[*,2],/OVERPLOT)
        
    ;计算磁场 内源IGRF 和 T96
    geopack_igrf_gsw_08,fline[*,0],fline[*,1],fline[*,2],bx_igrf,by_igrf, bz_igrf  
    geopack_t96,parmod,fline[*,0],fline[*,1],fline[*,2],bx, by, bz, tilt=tilt
    bx_all=bx+bx_igrf
    by_all=by+by_igrf
    bz_all=bz+bz_igrf
    Bmag=MAGNITUDE(transpose([[bx_all],[by_all], [bz_all]]))
    
    
    satellite_trace=PLOT3D(fline[*,0],fline[*,1],fline[*,2],/OVERPLOT,VERT_COLORS=BYTSCL(ALOG10(Bmag),MIN=Bmagmin,MAX=Bmagmax),RGB_TABLE=25)
    
    
    
  endfor
  
  
  help,flineplot,satellite_trace
  
  ;  RETURN,{p:p,p2:p2,cb:cb,s:s,flineplot:flineplot}
  
  ;; =============================================
  ; 添加地球
  ;; =============================================
  add_earth=1
  if KEYWORD_SET(add_earth) then begin
    dir = FILEPATH('',SUBDIR=['examples', 'data'])
    z = READ_BINARY(dir+'elevbin.dat', DATA_DIMS=[64,64])
    
    
    ; Read the DEM data file.
    OPENR, lun, FILEPATH('worldelv.dat', $
      SUBDIR = ['examples', 'data']), /GET_LUN
    elev = BYTARR(360, 360)
    
    ; Read the unformatted binary file data into a variable.
    READU, lun, elev
    
    ; Deallocate file units associated with GET_LUN.
    FREE_LUN, lun
    elev = SHIFT(elev, 180)
    zscale = 0.05
    a = 360L
    b = 360L
    n = a * b
    spherical = MAKE_ARRAY(3, n, /DOUBLE)
    FOR i = 0L, a - 1 DO BEGIN
      FOR j = 0L, b - 1 DO BEGIN
        k = ( i * b ) + j
        spherical[0, k] = j * 360.0 / (a - 1) ; longitude [0.0, 360.0]
        spherical[1, k] = i * 180.0 / (b - 1) - 90.0 ; latitude [90.0, -90.0]
        spherical[2, k] = 1.0 + zscale * elev[k] / 255.0 ; radius
      ENDFOR
    ENDFOR
    
    ; Convert the spherical coordinates to rectangular coordinates.
    rectangular = CV_COORD(FROM_SPHERE = spherical, /TO_RECT, /DEGREES)
    z = REFORM( rectangular[2, *], a, b )
    x = REFORM( rectangular[0, *], a, b )
    y = REFORM( rectangular[1, *], a, b )
    ; Read the global map file data.
    im = read_png(FILEPATH('avhrr.png', SUBDIR = ['examples', 'data']), r, g, b)
    
    ; Create the array for use by the TEXTURE_IMAGE keyword for SURFACE.
    image = BYTARR(3, 720, 360)
    IMAGE[0, *, *] = r[im]
    IMAGE[1, *, *] = g[im]
    IMAGE[2, *, *] = b[im]
    
    ; Display the surface.
    s = SURFACE(z, x, y, TEXTURE_IMAGE = image, LOCATION = [0, 0], aspect_z=1.0,/OVERPLOT)
    
    p.ASPECT_RATIO=1
  ; RETURN,{p:p,cb:cb,s:s}
  endif else begin
  ; RETURN,{p:p,cb:cb}
  endelse
  
  
  
  
 
  
  
  TICKVALUES= CEIL(Bmagmin)+indgen(FLOOR(Bmagmax)-CEIL(Bmagmin)+1)
  C_ticknames =STRING(TICKVALUES, FORMAT='(''10!u'',I0)')
  
  ;;添加磁场colorbar
  cb2= COLORBAR(POSITION=[0.91,0.1,0.93,0.4], RGB_TABLE=25, $
    BORDER=1,ORIENTATION=1,TEXTPOS=1,RANGE=[Bmagmin,Bmagmax],TICKNAME=C_ticknames,TICKVALUES=TICKVALUES)
  cb2.FONT_SIZE=7
  cb2.TITLE='B[nT]'
  
end





plot = magnetic_3D_model(data,time_INCREMENT=120*4,/add_earth)


end
