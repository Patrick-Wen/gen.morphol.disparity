# gen.morphol.disparity
Estimating and comparing Procrustes variance for linearly and non-linearly modelled shape data
The morphol.disparity function in the geomorph package in R quantifies morphological disparity through Procrustes variance and compares the groups in a pairwise manner through permutation tests. This function assumes that shape is modelled linearly and it requires a linear model formula as its first argument.

In the present study, shape development was modelled non-linearly with age, which impeded the use of morphol.disparity. We therefore developed a statistical routine named gen.morphol.disparity to address this issue by generalising the morphol.disparity function. The key difference from the morphol.disparity function is that instead of requiring an argument specifying a linear formula, gen.morphol.disparity requires input of a matrix of observed shape data and another matrix of model predicted shape. Procrustes variance is then estimated per group based on residuals from the two input matrices. The sum of squared residuals divided by group size yields estimates of Procrustes variance.

The gen.morphol.disparity function imposes no constraint on the type of models used. When shape is modelled linearly, gen.morphol.disparity will provide identical results to morphol.disparity. The source code for gen.morphol.disparity is available from https://github.com/Patrick-Wen/gen.morphol.disparity.

An example illustrating the use of gen.morphol.disparity is provide below using the plethodon dataset in the geomorph package in R.

```
source("<PATH>\\gen.morphol.disparity.R")
library(geomorph)
data(plethodon)
Y.gpa<-gpagen(plethodon$land, print.progress = FALSE) #GPA-alignment
gdf <- geomorph.data.frame(shape = two.d.array(Y.gpa$coords),
                           species = plethodon$species,
                           site = plethodon$site)

fit <- lm.rrpp(shape ~ species*site, 
               data = gdf, print.progress = FALSE, iter = 299)

groups <- paste(gdf$species, gdf$site, sep = ".")
groups <- as.factor(groups)
disp <- gen.morphol.disparity(obsShp = gdf$shape, expShp = fit$LM$fitted, 
                              groups = groups, iter = 299)

# Identical to results from morphol.disparity since a linear model is used.
morphol.disparity(shape ~ species*site, groups= ~species*site,
                  data = gdf, iter = 299, print.progress = FALSE)
```
