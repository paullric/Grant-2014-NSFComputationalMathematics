;***********************************************
; u2-plot.ncl
;***********************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"  

;************************************************
begin

;************************************************
; read in netCDF file
;************************************************
  fomega4x25xdiv = addfile("f.e11.FAMIPC5.ne30_ne30.topo.006.cam.h0.2005-avg-remap.nc","r")
  fomega16x50xdiv = addfile("f.e11.FAMIPC5.ne30_ne30.topo.003.cam.h0.2005-avg-remap.nc","r")

;************************************************
; read omega
;************************************************
  omega4x25xdiv = fomega4x25xdiv->OMEGA(0,15,:,:)
  omega16x50xdiv = fomega16x50xdiv->OMEGA(0,15,:,:)

  latv = fspan(-89.5, 89.5, 180)
  lonv = fspan(0.5, 355.5, 360)

  latv@units = "degrees_north"
  lonv@units = "degrees_east"

  omega4x25xdiv!0 = "lat"
  omega4x25xdiv!1 = "lon"
  omega4x25xdiv&lat = latv
  omega4x25xdiv&lon = lonv

  omega16x50xdiv!0 = "lat"
  omega16x50xdiv!1 = "lon"
  omega16x50xdiv&lat = latv
  omega16x50xdiv&lon = lonv

;************************************************
; plot resources [options]
;************************************************
  plot = new(2,graphic)                ; define a panel plot

; Resources:
  res                     = True

  res@gsnDraw             = False
  res@gsnFrame            = False

  res@vpKeepAspect        = True
  res@vpWidthF            = 0.8
  res@vpHeightF           = 0.6
  res@gsnSpreadColors     = True
;  res@gsnMaximize         = True
;  res@gsnPaperOrientation = "portrait"

  wks = gsn_open_wks("eps","OmegaNoise")   

; choose color table:
;  gsn_define_colormap(wks,"cosam12")             ; not enough colors
;  gsn_define_colormap(wks,"gui_default")
;  gsn_define_colormap(wks,"BlAqGrYeOrReVi200")   ; favorite right now
;  gsn_define_colormap(wks,"BlGrYeOrReVi200")
;  gsn_define_colormap(wks,"BlueRed")              ; mid-light blue to red
;  gsn_define_colormap(wks,"BlRe")                ; too dark
;  gsn_define_colormap(wks,"wh-bl-gr-ye-re")
;  gsn_define_colormap(wks,"WhBlGrYeRe")
  gsn_define_colormap(wks,"BlueDarkRed18")

  res@cnFillOn          = True
  res@cnLinesOn         = True
  res@cnLineLabelsOn    = False
  res@lbLabelAutoStride = True
  res@cnInfoLabelOn     = False
  res@tmXBLabelsOn      = True
  res@tmXBOn            = True

  res@gsnContourZeroLineThicknessF = 2
  res@gsnContourNegLineDashPattern = 6

  res@cnLevelSelectionMode = "ManualLevels"
  res@cnLevelSpacingF = 0.1
  res@cnMinLevelValF = -1.0
  res@cnMaxLevelValF =  1.0

  res@mpCenterLonF = 180.0
  res@mpMinLonF = 50.0
  res@mpMaxLonF = 130.0

  res@mpMinLatF = -10.0
  res@mpMaxLatF = 50.0

  res@tiMainString = "(a) 4 x 2.5 div (rough topography)"
  plot(0) = gsn_csm_contour_map(wks, omega4x25xdiv, res)

  res@tiMainString = "(b) 16 x 5.0 div (smooth topography)"
  plot(1) = gsn_csm_contour_map(wks, omega16x50xdiv, res)

  gsres = True
  gsres@gsLineThicknessF = 0.5
  gsres@gsLineColor = 1
  gsres@gsLineDashPattern = 2

  pres = True

  gsn_panel(wks, plot, (/1,2/), pres)

end
