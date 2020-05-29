getwd()
setwd('C://Users//hp//Desktop')
remotes::install_github("tylermorganwall/rayshader")
install.packages("httpuv")
install.packages("readr")
install.packages('rgdal')
install.packages('rayrender')
install.packages('magick')
library(ggplot2)
library(viridis)
library(rayrender)
library(rayshader)
library(magick)

ggdiamonds = ggplot(diamonds, aes(x, depth)) +
  stat_density_2d(aes(fill = stat(nlevel)), geom = "polygon", n = 100, bins = 10,contour = TRUE) +
  facet_wrap(clarity~.) +
  scale_fill_viridis_c(option = "A")


# \donttest{
plot_gg(ggdiamonds,multicore=TRUE,width=5,height=5,scale=250,windowsize=c(1400,866),
        zoom = 0.55, phi = 30)
render_snapshot()



death = read.csv("https://www.tylermw.com/data/death.csv", skip = 1)
meltdeath = reshape2::melt(death, id.vars = "Year")

meltdeath$age = as.numeric(meltdeath$variable)

deathgg = ggplot(meltdeath) +
  geom_raster(aes(x=Year,y=age,fill=value)) +
  scale_x_continuous("Year",expand=c(0,0),breaks=seq(1900,2010,10)) +
  scale_y_continuous("Age",expand=c(0,0),breaks=seq(0,100,10),limits=c(0,100)) +
  scale_fill_viridis("Death\nProbability\nPer Year",trans = "log10",breaks=c(1,0.1,0.01,0.001,0.0001), labels = c("1","1/10","1/100","1/1000","1/10000")) +
  ggtitle("Death Probability vs Age and Year for the USA") +
  labs(caption = "Data Source: US Dept. of Social Security")

plot_gg(deathgg, multicore=TRUE,height=5,width=6,scale=500)




#Here, I load a map with the raster package.
loadzip = tempfile() 
download.file("https://tylermw.com/data/dem_01.tif.zip", loadzip)
localtif = raster::raster(unzip(loadzip, "dem_01.tif"))
unlink(loadzip)

#And convert it to a matrix:
elmat = raster_to_matrix(localtif)

#We use another one of rayshader's built-in textures:
elmat %>%
  sphere_shade(texture = "desert") %>%
  plot_map()


#And we can add a raytraced layer from that sun direction as well:
  elmat %>%
  sphere_shade(texture = "desert") %>%
  add_water(detect_water(elmat), color = "desert") %>%
  add_shadow(ray_shade(elmat), 0.5) %>%
  plot_map()

#sphere_shade can shift the sun direction:
elmat %>%
  sphere_shade(sunangle = 60, texture = "desert") %>%
  plot_map()


#detect_water and add_water adds a water layer to the map:
elmat %>%
  sphere_shade(texture = "desert") %>%
  add_water(detect_water(elmat), color = "desert") %>%
  plot_map()

#And we can add a raytraced layer from that sun direction as well:
elmat %>%
  sphere_shade(texture = "") %>%
  add_water(detect_water(elmat), color = "desert") %>%
  add_shadow(ray_shade(elmat), 0.2) %>%
  plot_map()



#Rayshader also supports 3D mapping by passing a texture map (either external or one produced by rayshader) into the plot_3d function.

elmat %>%
  sphere_shade(texture = "desert") %>%
  add_water(detect_water(elmat), color = "desert") %>%
  add_shadow(ray_shade(elmat, zscale = 3), 0.3) %>%
  add_shadow(ambient_shade(elmat), 0) %>%   #ambient shadow 
  plot_3d(elmat, zscale = 10, fov = 0, theta = 135, zoom = 0.75, phi = 45, windowsize = c(1000, 800))
Sys.sleep(0.2)
render_snapshot()


#You can add a scale bar, as well as a compass using render_scalebar() and render_compass()

render_camera(fov = 0, theta = 60, zoom = 0.75, phi = 45)
render_scalebar(limits=c(2,4,6,8,10,12,14,16,18,20),label_unit = "km",position = "W", y=50,
                scale_length = c(0.4,1))
render_compass(position = "E")
render_snapshot(clear=TRUE)


#you can also render using the built-in pathtracer, powered by rayrender. 
#Simply replace render_snapshot() with render_highquality(). 
#When render_highquality() is called, there's no need to pre-compute the shadows with any of the _shade() functions, 
##so we remove those:
  
  elmat %>%
  sphere_shade(texture = "desert") %>%
  add_water(detect_water(elmat), color = "desert") %>%
  plot_3d(elmat, zscale = 10, fov = 0, theta = 60, zoom = 0.75, phi = 45, windowsize = c(1000, 800))

render_scalebar(limits=c(0, 5, 10),label_unit = "km",position = "W", y=50,
                scale_length = c(0.33,1))

render_compass(position = "E")
Sys.sleep(0.2)
render_highquality(samples=200, scale_text_size = 24,clear=TRUE)




#by using random dataset:---

a = data.frame(x = rnorm(20000, 10, 1.9), y = rnorm(20000, 10, 1.2))
b = data.frame(x = rnorm(20000, 14.5, 1.9), y = rnorm(20000, 14.5, 1.9))
c = data.frame(x = rnorm(20000, 9.5, 1.9), y = rnorm(20000, 15.5, 1.9))
data = rbind(a, b, c)

#Lines
pp = ggplot(data, aes(x = x, y = y)) +
  geom_hex(bins = 20, size = 0.5, color = "black") +
  scale_fill_viridis_c(option = "C")

par(mfrow = c(1, 2))
plot_gg(pp, width = 5, height = 4, scale = 300, raytrace = FALSE, preview = TRUE)
plot_gg(pp, width = 5, height = 4, scale = 300, multicore = TRUE, windowsize = c(1000, 800))
render_camera(fov = 70, zoom = 0.5, theta = 130, phi = 35)
Sys.sleep(0.2)
render_snapshot(clear = TRUE)


par(mfrow = c(1, 1))
plot_gg(pp, width = 5, height = 4, scale = 300, raytrace = FALSE, windowsize = c(1200, 960),
        fov = 70, zoom = 0.4, theta = 330, phi = 20,  max_error = 0.01, verbose = TRUE)
## 98.8% reduction: Number of triangles reduced from 3600000 to 41446. Error: 0.009996
Sys.sleep(0.2)
render_highquality(samples = 400, aperture=30, light = FALSE, ambient = TRUE,focal_distance = 1700,
                   obj_material = rayrender::dielectric(attenuation = c(1,1,0.3)/200), 
                   ground_material = rayrender::diffuse(checkercolor = "grey80",sigma=90,checkerperiod = 100))


