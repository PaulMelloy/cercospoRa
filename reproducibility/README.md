### Analysis pipeline:

- 00_RTM_LAI_estimation.R **Input** = raw uas, s2 and s2s multispectral raster data; **Output** = lai maps
- 01_Spatial_cercospoRa_LAI_to_EO.R **Input** = lai maps, sigmoid parameters, weather data (part of cercospoRa); **Output** = epidemic onset maps
- 02A_Plot_sigmoid.R **Input** = lai maps; **Output** = lai progression curves (sigmoid parameters)
- 02B **Input** = lai maps; **Output** = cc maps
- 02 Input = raw uas, s2 and s2s multispectral raster data; Output =
- 02 Input = raw uas, s2 and s2s multispectral raster data; Output =
- 02 Input = raw uas, s2 and s2s multispectral raster data; Output =
- 02 Input = raw uas, s2 and s2s multispectral raster data; Output = 
