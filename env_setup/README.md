Create reproducible conda environments that contain both R and python with this script. 

Directory should also contain a .yml file, recommended to generate from: $ conda env export --no-builds --from-history > env.yml
Recommended remove: notebook, kernels, and other jupyter associated packages. 

Only needed for conda environments that contain R packages that are not conda isntallable. This will be installed via an R-script names.
