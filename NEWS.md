# cercospoRa (development version)
  - Four functions have been added to deal with spatial heterogeneity:
    - `read_sb_growth_parameter`: read in and format raster images to allow 
     further computation.
    - `calc_r_x0`: fit logistic growth curve to the date.
    - `calc_c_closure`: to deduct canopy closure dates from the fitted curves.
    - `calc_epidemic_onset_from_image`: builds on the existing `calc_epidemic_onset` 
    function to compute a value for each pixel.
  - Example datasets have been provided to check the functions. 
  It consists of a folder containing two LAI maps computed from UAV images.  


# cercospoRa 0.0.0.9001
 - Change package name  
 - Add pkgdown site  
 - Reduce functions to only those described by Wolf and Verreet (2005)  

# cercosporaR 0.0.0.9000
