test_that("example works", {
  spores <-
    sapply(1:100,FUN = function(x){
      cercospora_dk(0,0, 0.1,3)
      })

  spores
})
