## Overview
<p align="justify"> gen.morphol.disparity is a generalization of the morphol.disparity function in the R package geomorph for estimating morphological disparity (quantified through Procrustes variance) and performing pairwise comparisons among groups capable of accounting for both linear and non-linear relationship between shape and covariates of interest. </p>

<p align="justify"> morphol.disparity requires specifying a formula describing the linear model used. Procrustes variance is then estimated based on residuals of the linear model. The function cannot be used when shape data is modeled non-linearly. </p>

<p align="justify"> gen.morphol.disparity overcomes this limitation of morphol.disparity by requiring input of both raw shape data and model-predicted shape data, calclating residuals, and estimating Procrustes variance. The model-predicted shape data can be obtained from whichever model of interest, whehter linear or non-linear. This makes gen.morphol.disparity more generally applicable for morphological disparity estimation. </p>

## How to use
<p align="justify"> A tutorial of using gen.morphol.disparity is available from Appendix Text 4 of the study cited.  </p>

## Citation
<p align="justify"> Zhong YJ, Cui D, Wen PYF*, Wong HM* (2024). Facial growth and development trajectories based on three-dimensional images: geometric morphometrics with a deformation perspective. R Soc Open Sci 11(1):231438. [https://doi.org/10.1098/rsos.231438](https://doi.org/10.1098/rsos.231438) </p>
