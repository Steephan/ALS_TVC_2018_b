# plots for ALS metadata 2018
# by stephan.lange@awi.de
# see document:
# last editing: 2021-03-15
# last modification:
#
library("sp")
library("raster")
library("sf")
library("leaflet")
library("tmap")
library("tmaptools")
library("mapmisc")
library("grid")
library("gridExtra")
path.p <- "/home/stlange/Desktop/ALS_TVC_2018_Meta/"

#setwd("/home/stlange/Desktop/ALS_TVC_Meta/")

# figure 1 overview ----------------------------------------------------
# 
# study.area.f <- st_read(paste0(path.p,"gis/shp_files/region_ALS2016.shp"))
# tvc.p <-st_as_sf(data.frame(ID = "TVC",x = 560814, y = 7626307), coords = c("x", "y"), crs = 32608)
# basemap_tiles <- openmap(study.area.f, path='https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/',
#                            maxTiles=20,  verbose=TRUE,   crs = 32608)
# 
# nz_region <- bb(cx = 558500, cy = 7621800, width = 25000, height = 23000)
# fig.1 <- tm_shape(basemap_tiles, bbox = nz_region, projection = 32608) + tm_rgb()  +
#              tm_graticules(n.x=4,n.y=3,col = "#ffd46b", lwd = 1.5,labels.size = 1,labels.rot=c(0,90))#+labels.inside.frame=T,
# fig.1 <- fig.1 + tm_shape(study.area.f) +
#              tm_scale_bar(breaks = c(0,1,2,3,5), text.size = 1, text.col = "#ffd46b",
#                           position = c("left","bottom")) +
#              tm_borders("#00c36f", lwd = 3)
# tvc.fig1 <-  tm_shape(tvc.p) +
#   tm_dots(col = "ID",legend.show = F) +
#   tm_text("ID", col = "#00c36f",just=c("left", "top"))
# fig.1 <- fig.1 + tvc.fig1
# #fig.1
# data("World")
# p1<-rbind(c(nz_region$xmin,nz_region$ymin),
#           c(nz_region$xmin,nz_region$ymax),
#           c(nz_region$xmax,nz_region$ymax),
#           c(nz_region$xmax,nz_region$ymin),
#           c(nz_region$xmin,nz_region$ymin))
# pol <-st_sfc(st_polygon(list(p1)))
# st_crs(pol) <- "+proj=utm +zone=8 +datum=WGS84 +units=m +no_defs"
# 
# locl.p <-st_as_sf(data.frame(ID = c("Canada","Alaska"),
#                              x = c(808500,1),
#                              y = c(7321800,7621800)), coords = c("x", "y"), crs = 32608)
# 
# locl <- tm_shape(World$geometry[World$continent == "North America"],
#                  projection = 32608, #6703
#                  bbox = bb(cx = -130, cy = 70, width = 40, height = 12)) +
#   tm_borders() + tm_fill(col = "#d0a1a1") +
#   tm_graticules(n.x=6,n.y=3,col = "#ffd46b", lwd = .5,labels.show = F,
#                 labels.size = 1,labels.rot=c(0,90), labels.col = c("#ffd46b"))
# 
# locl <-  locl + tm_shape(locl.p) +
#   tm_dots(col = "#d0a1a1",legend.show = F) +
#   tm_text("ID", col = "black",size = .8,just = c("bottom"))
# 
# locl <- locl + tm_shape(pol) + tm_borders("#00c36f", lwd = 3)
# #print(locl, vp = grid::viewport(0.75, 0.2, width = 0.3, height = 0.3))
# 
# tmap_save(fig.1,insets_tm = locl,insets_vp=viewport(0.83, 0.15, width = 0.3, height = 0.3),
#           paste0(path.p,"figures/figure1.png"))
# 

# figure 2 flight lines --------------------------------------------------
# study.area.2 <- st_read(paste0(path.p,"gis/shp_files/region_ALS2016.shp"))
# study.area.core <- st_read(paste0(path.p,"gis/shp_files/extent_core_area.shp"))
# 
# nz_region <- bb(cx = 558500, cy = 7621800, width = 40000, height = 35000)
# 
# strip.extents <- list.files(paste0(path.p,"gis/02_strip_extents/"),pattern = ".shp")
# strip.extents.l <- list(length(strip.extents))
# for(i in 1:30){
#   strip.extents.l[[i]]<-st_read(paste0(path.p,"gis/02_strip_extents/",strip.extents[i]))
#   st_crs(strip.extents.l[[i]])<-"+proj=utm +zone=8 +datum=WGS84 +units=m +no_defs"
# }
# fig.2 <- tm_shape(study.area.2, bbox = nz_region) + tm_borders("#787878", lwd = 1) +
#   tm_graticules(n.x=4,n.y=3,col = "#ffd46b", lwd = 1.5,labels.size = 1,labels.rot=c(0,90))
# for(i in 1:30){
#   fig.2 <- fig.2 + tm_shape(strip.extents.l[[i]]) + tm_borders("#787878", lwd = 1)
# }
# fig.2 <- fig.2 + tm_shape(study.area.2, bbox = nz_region) + tm_borders("#00b8ff", lwd = 3)
# fig.2 <- fig.2 + tm_shape(study.area.core, bbox = nz_region) + tm_borders("#1a4177", lwd = 3) +
#   tm_add_legend("line",
#                 col = c("#1a4177","#00b8ff","#787878"),
#                 border.col = "grey40",
#                 lwd = c(3,3,1),
#                 legend.format = list(bg.color="white"),
#                 labels = c('TVC core area','ALS data extent','ALS flight strips'),
#                 title=" ")
# fig.2
# tmap_save(fig.2,paste0(path.p,"figure2.png"))

# figure 3 point density --------------------------------------------------

# p.count <- raster(paste0(path.p,"gis/DEMs/ALS1_all_echotypes_SOR_pcount.tif"))
# crs(p.count) <- "+proj=utm +zone=8 +datum=WGS84 +units=m +no_defs"
# #nz_region <- bb(cx = 560500, cy = 7626500, width = 15000, height = 15000)
# pal8 <- c("white" , "#99B898" ,  "#FECEAB",   "#FF847C" ,  "#E84A5F" ,  "#2A363B" )
# 
# breaks <- c(0,0.5,3.5,5.5, 7.5,10.5,500)
# fig.3 <- tm_shape(p.count) +
#   tm_raster(style = "fixed",  breaks = breaks, palette = pal8,title = "Points / m²",
#             labels = c( "0","1-3","4-5","6-7", "8-10",">10")) +
#   tm_style("col_blind") +
#   tm_scale_bar(breaks = c(0,0.5, 1,1.5, 2), text.size = 0.8) +
#   tm_layout(legend.position=c("right", "bottom"),
#                          legend.bg.color="white") +
#   tm_graticules(n.x=4,n.y=3,col = "#ffd46b", lwd = 1.5,labels.size = 1,labels.rot=c(0,90))
# fig.3
# tmap_save(fig.3,paste0(path.p,"figures/figure3.png"))

# figure 4 terrain probs -------------------------------------------------
# is done by terrainProbability.py
#
# figure 5 DTM + diffs --------------------------------------------------
# dem <- raster(paste0(path.p,"gis/DEMs/ALS1_all_echotypes_SOR_terrain_RobF_robMovPlanes_1m_filled.tif"))
# crs(dem) <- "+proj=utm +zone=8 +datum=WGS84 +units=m +no_defs"
# shd <- raster(paste0(path.p,"gis/DEMs/shd_ALS1_all_echotypes_SOR_terrain_RobF_robMovPlanes_1m_filled.tif"))
# crs(shd) <- "+proj=utm +zone=8 +datum=WGS84 +units=m +no_defs"
# gnss.p <- st_read(paste0(path.p,"gis/GNSS/TVC_GNSS_diff_v3.shp"))
# #gnss.p <- st_read(paste0(path.p,"gis/GNSS/TVC_GNSS_diff_v1.shp"))
# #nz_region<- bb(cx = 560500, cy = 7626500, width = 3500, height = 3500)
# nz_region<- bb(cx = 560700, cy = 7626900, width = 3500, height = 2400)
# p1<-rbind(c(nz_region$xmin,nz_region$ymin),
#           c(nz_region$xmin,nz_region$ymax),
#           c(nz_region$xmax,nz_region$ymax),
#           c(nz_region$xmax,nz_region$ymin),
#           c(nz_region$xmin,nz_region$ymin))
# pol <-st_sfc(st_polygon(list(p1)))
# st_crs(pol) <- "+proj=utm +zone=8 +datum=WGS84 +units=m +no_defs"
# shd.zoom<-crop(shd,nz_region)
# breaks <- c(0.2,0.6,1,1.4,1.85) * 100
# 
# fig.5.1 <- tm_shape(dem,  projection = 32608) +
#   tm_raster(style = "cont",palette="-Greys", breaks = breaks, title = "Elevation [m]")+
#   #tm_style("col_blind") +
# #  tm_scale_bar(breaks = c(0,0.5, 1,1.5, 2), text.size = 0.8) +
#   tm_layout(legend.position=c("right", "bottom")) +
#   tm_graticules(n.x=4,n.y=3,col = "#ffd46b", lwd = 1.5,labels.size = 1,labels.rot=c(0,90))
# fig.5.1 <- fig.5.1 + tm_shape(pol)+tm_borders("#00b8ff", lwd = 3)
# 
# 
# fig.5.2 <- tm_shape(shd.zoom,  projection = 32608, bbox = nz_region) +
#   tm_raster(style = "cont",palette="-Greys", breaks = breaks,legend.show = FALSE)+
#   tm_scale_bar(breaks = c(0,0.5, 1), text.size = 0.8) +
#   tm_layout(panel.label.color = "red",
#             legend.position=c("left", "bottom"),
#             legend.bg.alpha=.50,
#             legend.bg.color="white")
# 
# fig.5.2 <- fig.5.2 + tm_shape(gnss.p) + tm_dots(col = "diff_DTM",title = "Vertical \ndifference [m]",size = 0.1,
#                                             breaks=c(-1.5,-0.5,-0.25,-0.1,-0.05,0.05,0.1,0.25,0.5,1.5))
# fig.5.2 <- fig.5.2 + tm_shape(pol) + tm_borders("#00b8ff", lwd = 3)
# 
# fig.5 <- tmap_arrange(fig.5.1,fig.5.2,ncol=1,heights = c(1,0.68))
# tmap_save(fig.5,paste0(path.p,"figures/figure5.png"),width=2100,height=(2100*1.68))

# figure 6 histogram -----------------------------------------------------

# gnss.p <- st_read(paste0(path.p,"gis/GNSS/TVC_GNSS_diff_v3.shp"))
# hist.p <- gnss.p$diff_DTM
# 
# png(paste0(path.p,"figures/figure6.png"),width = 800,height = 800)
# par(mar=c(6,6,2,2))
# hist(hist.p,breaks=c(seq(-1,1,by=0.1)),freq=FALSE,ylim=c(0,5),xlim=c(-.7,.7),
#      col="grey50", border="grey50", main=NULL,xlab="vertical difference [m]",ylab="Frequency [DN]",
#      cex.lab = 2,cex.axis=2)
# lines(density(hist.p, adjust=3), col="grey20", lwd=3)
# dev.off()

# figure 7 vegetation + zoom -------------------------------------------

# veg <- raster(paste0(path.p,"gis/DEMs/ALS_all_echotypes_SOR_nZ_mean_1m_smooth.tif"))
# crs(veg) <- "+proj=utm +zone=8 +datum=WGS84 +units=m +no_defs"
# pal8 <- c("white" , "#99B898" ,  "#FECEAB",   "#FF847C" ,  "#E84A5F" ,  "#2A363B" )
# nz_region<- bb(cx = 560400, cy = 7626000, width = 3500, height = 1800)
# p1<-rbind(c(nz_region$xmin,nz_region$ymin),
#           c(nz_region$xmin,nz_region$ymax),
#           c(nz_region$xmax,nz_region$ymax),
#           c(nz_region$xmax,nz_region$ymin),
#           c(nz_region$xmin,nz_region$ymin))
# pol <-st_sfc(st_polygon(list(p1)))
# st_crs(pol) <- "+proj=utm +zone=8 +datum=WGS84 +units=m +no_defs"
# 
# veg.zoom<-crop(veg,nz_region)
# breaks <- c(0,0.2,0.5,1.5,2,5)
# 
# fig.7.1 <- tm_shape(veg,  projection = 32608) +
#   tm_raster(style = "cont", palette = pal8, breaks = breaks,
#             title = "Vegetation \nheight [m]",
#             labels = c( "0.0 - 0.2","0.2 - 0.5","0.5 - 1.5","1.5 - 2.0", "2.0 - 5.0","> 5.0"))+
#   tm_layout(legend.position=c("right", "bottom"),
#             legend.bg.color="white") +
#   tm_graticules(n.x=4,n.y=3,col = "#ffd46b", lwd = 1.5,labels.size = 1,labels.rot=c(0,90))
# fig.7.1 <- fig.7.1 + tm_shape(pol)+tm_borders("#00b8ff", lwd = 3)
# #fig.7.1
# 
# fig.7.2 <- tm_shape(veg.zoom,  projection = 32608, bbox = nz_region) +
#   tm_raster(style = "cont",palette=pal8, breaks = breaks, legend.show = FALSE) +
#   tm_scale_bar(breaks = c(0,0.5, 1), text.size = 0.8)
# fig.7.2 <- fig.7.2 + tm_shape(pol) + tm_borders("#00b8ff", lwd = 3)
# #fig.7.2
# 
# fig.7 <- tmap_arrange(fig.7.1,fig.7.2,ncol=1,heights = c(1,0.645))
# tmap_save(fig.7,paste0(path.p,"figures/figure7.png"),width=2100,height=(2100*1.3))

# figure 8 number of strips -----------------------------------------------
# ## 1.) in qgis merge and union of all stripes 
# ## 2.) count overlaps (https://github.com/kgjenkins/qgis-count-polygon-overlap)
# ## 3.) convert to raster

# count <- raster(paste0(path.p,"gis/DEMs/TVC_ALS_stripe_counts.tif"))
# crs(count) <- "+proj=utm +zone=8 +datum=WGS84 +units=m +no_defs"
# pal8 <- c( "#99B898" ,  "#FECEAB",   "#FF847C" ,  "#E84A5F" ,  "#2A363B" )
# breaks <- c(0:4+0.5)
# 
# fig.8 <- tm_shape(count,  projection = 32608) +
#   tm_raster(style = "fixed", palette = "YlGnBu", breaks = breaks,
#             title = "Number \nof strips",
#             labels = c( "1","2","3","4")) +
#   tm_layout(legend.position=c("right", "bottom"),
#             legend.bg.color="white") +
#   tm_graticules(n.x=4,n.y=3,col = "#ffd46b", lwd = 1.5,labels.size = 1,labels.rot=c(0,90))
# 
# tmap_save(fig.8,paste0(path.p,"figure8.png"))


# table 3 statistics -----------------------------------------------

# gnss.p <- st_read(paste0(path.p,"gis/GNSS/TVC_GNSS_diff_v3.shp"))
# ## 1.) in qgis sample raster points of DTM ...
# ## 2.) DTM sample heights minus points alt(wgs) --> diff_2018
# #                                                                # v1    v2     v3
# cat(paste("Min: ",min(gnss.p$diff_DTM),"\n" ))               #-0.146 -0.146  -0.159
# cat(paste("Max: ",max(gnss.p$diff_DTM),"\n" ))               # 0.589 0.364  0.364
# cat(paste("Mean: ",mean(gnss.p$diff_DTM),"\n" ))          # 0.0323726 0.033013  0.038
# cat(paste("Median: ",median(gnss.p$diff_DTM),"\n" ))      # 0.021 0.022 0.022
# cat(paste("Standard deviation : ",sd(gnss.p$diff_DTM),"\n" ))          # 0.07904292 0.07597181  0.086
# cat(paste("Root-mean-square (RMS): ",sqrt(mean(gnss.p$diff_DTM^2)),"\n" ))# 0.08531502 0.082739  0.094
# 


