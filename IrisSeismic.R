# Irisseismic package

#https://cran.r-project.org/web/packages/IRISSeismic/vignettes/IRISSeismic-intro.html
# install.packages('IRISSeismic')

#library(IRISSeismic)

mseed <- '/SDS_2015/BL/ldase_test/BL.LDASE..HHZ.D.2023.320'

#a <- readMiniseedFile(mseed)
#starttime <- as.POSIXct("2023-11-16 14:54:30", tz="GMT")
#endtime   <- as.POSIXct("2023-11-16 15:05:00", tz="GMT")
#result <- try(st <- getDataselect(a,  network = "BL", station = "LDASE", 
#                                  location = "", channel = "HHZ", starttime, endtime))


# iris <- new('IrisClient')
# 
# starttime <- as.POSIXct("2002-04-20", tz="GMT")
# endtime   <- as.POSIXct("2002-04-21", tz="GMT")
# result <- try(st <- getDataselect(iris,"US","OXF","","BHZ",starttime,endtime))
# if (inherits(result,"try-error")) {
#   message(geterrmessage())
# } else {
#   length(st@traces)
#   plotUpDownTimes(st, min_signal=1, min_gap=1)
# }
# if (exists("tr")){
#   plot(tr)
# }
# if (exists("st")){
#   tr <- st@traces[[3]]
#   tr@stats
# }

#===================================================
# https://d-nb.info/1165229145/34
# eseis package

#install.packages('eseis')
library(eseis)

a <- read_mseed(mseed)

