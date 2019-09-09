## Notes

- To use this code the [Statistics and Machine Learning Toolbox](https://www.mathworks.com/products/statistics.html) for MATLAB is required. 

- For the Hartigan and Wong's K-Means the [NAG Toolbox for MATLAB](https://www.nag.co.uk/nag-toolbox-matlab) is required. An open source version of the algorithm can be found [here](https://people.sc.fsu.edu/~jburkardt/m_src/matlab_kmeans/matlab_kmeans.html).

- Files contain further information about relevant studies and links to online material used for the various formulas.

- All the R packages/codes used for the MATLAB implementation are under the GPLv3 license.

## Citations for software and datasets that we have used in this project

### Datasets

**Clustering basic benchmark:**

[Fränti, Pasi, and Sami Sieranoja. "K-means properties on six clustering benchmark datasets." Applied Intelligence 48.12 (2018): 4743-4759.](https://link.springer.com/article/10.1007/s10489-018-1238-7)

**Real datasets:**

[Dua, D. and Graff, C. (2019). UCI Machine Learning Repository [http://archive.ics.uci.edu/ml]. Irvine, CA: University of California, School of Information and Computer Science.](https://archive.ics.uci.edu/ml/index.php)

**Gap models:**

[Tibshirani, Robert, Guenther Walther, and Trevor Hastie. "Estimating the number of clusters in a data set via the gap statistic." Journal of the Royal Statistical Society: Series B (Statistical Methodology) 63.2 (2001): 411-423.](https://rss.onlinelibrary.wiley.com/doi/abs/10.1111/1467-9868.00293)

**Weighted Gap models:**

[Yan, Mingjin, and Keying Ye. "Determining the number of clusters using the weighted gap statistic." Biometrics 63.4 (2007): 1031-1037.](https://onlinelibrary.wiley.com/doi/full/10.1111/j.1541-0420.2007.00784.x)

**Brodinova dataset generator:**

[Brodinová, Šárka, et al. "Robust and sparse k-means clustering for high-dimensional data." Advances in Data Analysis and Classification (2017): 1-28.](https://link.springer.com/article/10.1007/s11634-019-00356-9)

MATLAB code was based on the R implementation of the algorithm; package: [`wrsk`](https://github.com/brodsa/wrsk)


**Mixed dataset models:**

[Vouros, Avgoustinos, et al. "An empirical comparison between stochastic and deterministic centroid initialisation for K-Means variations." arXiv preprint arXiv:1908.09946 (2019).](https://arxiv.org/abs/1908.09946)


### Algorithms

**Sparse K-Means:**

[Witten, Daniela M., and Robert Tibshirani. "A framework for feature selection in clustering." Journal of the American Statistical Association 105.490 (2010): 713-726.](https://amstat.tandfonline.com/doi/abs/10.1198/jasa.2010.tm09415)

MATLAB code was based on the R implementation of the algorithm; package: [`sparcl`](https://cran.r-project.org/web/packages/sparcl/index.html)

**Density K-Means++:**

[Nidheesh, N., KA Abdul Nazeer, and P. M. Ameer. "An enhanced deterministic K-Means clustering algorithm for cancer subtype prediction from gene expression data." Computers in biology and medicine 91 (2017): 213-221.](https://www.sciencedirect.com/science/article/pii/S0010482517303402)

MATLAB code was based on the R implementation of the algorithm; code: [`dkmpp_0.1.0`](https://github.com/nidheesh-n/dkmpp)

**ROBIN:**

MATLAB code was originally based on the R implementation of the algorithm; package: [`wrsk`](https://github.com/brodsa/wrsk)

**K-Means++:**

MATLAB implementation was based on the instructions of the [MSDN Magazine Blog: Test Run - K-Means++ Data Clustering](https://msdn.microsoft.com/en-us/magazine/mt185575.aspx)
