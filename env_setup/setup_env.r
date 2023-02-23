library(remotes)
library(devtools)
library(BiocManager)

remotes::install_github('groupname/pkgname@<commit_id>', upgrade=F) 
devtools::install_github('groupname/pkgname@<commit_id>', upgrade=F) 

BiocManager::install(c('pkg1', 'pkg2'), 
                     version = c('v1', 'v2'),
                     update = F)