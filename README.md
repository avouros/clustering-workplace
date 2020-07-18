This code was written for quick experimentation on different clustering techniques. 

## TODO:

- Write a wiki!

- Create some tests.

- Release the full version.


## Notes

- To use this code the [Statistics and Machine Learning Toolbox](https://www.mathworks.com/products/statistics.html) for MATLAB is required. 

- For the Hartigan and Wong's K-Means the [NAG Toolbox for MATLAB](https://www.nag.co.uk/nag-toolbox-matlab) is required.

- Files contain further information about relevant studies and links to online material used for the various formulas.

- All the R packages/codes used for the MATLAB implementation are under the GPLv3 license.


## Contents

### Clustering initialization

- **Random points**, pick random datapoints.
- **First points**, pick the first datapoints of the dataset.
- **K-Means++**, pick datapoints away from each other.
- **ROBIN**, pick datapoints away from each other and also in dense regions of the feature space. Density is computed using the LOF score.
- **ROBIN-DETERM (or D-ROBIN)**, original determinitic version of ROBIN.
- **Kaufman**, pick datapoints away from each other close to dense regions of the feature space.
- **Density K-Means++**, same as ROBIN but deterministic and uses another statistic to find density based on minimum spanning trees.

### Clustering algorithms

- **K-Means (Lloyd)**, the common K-Means algorithm.
- **K-Means (Hartigan-Wong)**, available only with [NAG Toolbox for MATLAB](https://www.nag.co.uk/nag-toolbox-matlab).
- **K-Medians**, similar to K-Means but uses the median instead of the mean to update the centroids.
- **Sparse K-Means**, K-Means with feature selection and assessment mechanism

### External clustering validation

- **entropy**
- **purity**
- **F-score**
- **accuracy**
- **recall**
- **specificity**
- **precision**

### Internal clustering validation

- **DaviesBouldinIndex (DBi)**
- **BanfieldRafteryIndex (BRi)**
- **CalinskiHarabaszIndex (CHi)**
- **Silhouette (Silh2 and Silh)**, Silh2 is computed by taking the mean silhouette of the datapoints, Silh is computed by taking the mean silhouette of the clusters.

**Note**: In the case of Sparse K-Means, indexes with 'w' (e.g. wSilh2) have been computed using the weighted dataset. For the rest of the algorithms index with 'w' should have the same value as the ones without (e.g. wSilh2 = Silh2).

## Relevant publications

[Vouros, A., Langdell, S., Croucher, M., & Vasilaki, E. (2019). An empirical comparison between stochastic and deterministic centroid initialisation for K-Means variations. arXiv preprint arXiv:1908.09946.](https://arxiv.org/abs/1908.09946)

## Citations for software and datasets that we have used in this project

### Datasets

**Clustering basic benchmark:**

[Fränti, Pasi, and Sami Sieranoja. "K-means properties on six clustering benchmark datasets." Applied Intelligence 48.12 (2018): 4743-4759.](https://link.springer.com/article/10.1007/s10489-018-1238-7)

**Real datasets:**

[Dua, D. and Graff, C. (2019). UCI Machine Learning Repository [http://archive.ics.uci.edu/ml]. Irvine, CA: University of California, School of Information and Computer Science.](https://archive.ics.uci.edu/ml/index.php)

**Gap models:**

[Tibshirani, Robert, Guenther Walther, and Trevor Hastie. "Estimating the number of clusters in a data set via the gap statistic." Journal of the Royal Statistical Society: Series B (Statistical Methodology) 63.2 (2001): 411-423.](https://rss.onlinelibrary.wiley.com/doi/abs/10.1111/1467-9868.00293)

**Weighted Gap models (YanYe):**

[Yan, Mingjin, and Keying Ye. "Determining the number of clusters using the weighted gap statistic." Biometrics 63.4 (2007): 1031-1037.](https://onlinelibrary.wiley.com/doi/full/10.1111/j.1541-0420.2007.00784.x)

**Brodinova dataset generator:**

[Brodinová, Šárka, et al. "Robust and sparse k-means clustering for high-dimensional data." Advances in Data Analysis and Classification (2017): 1-28.](https://link.springer.com/article/10.1007/s11634-019-00356-9)

MATLAB code was based on the R implementation of the algorithm; package: [`wrsk`](https://github.com/brodsa/wrsk)

**Mixed dataset models:**

[Vouros, Avgoustinos, et al. "An empirical comparison between stochastic and deterministic centroid initialisation for K-Means variations." arXiv preprint arXiv:1908.09946 (2019).](https://arxiv.org/abs/1908.09946)


### Clustering Algorithms

**K-Means (Lloyd and Hartigan-Wong):**

MATLAB's and Python's default K-Means clustering is Lloyd's K-Means (initialized with the K-Means++ method) while R uses Hartigan-Wong' K-Means. For more information about these two algorithms refer to [Slonim, N., Aharoni, E., & Crammer, K. (2013, June). Hartigan's K-Means Versus Lloyd's K-Means—Is It Time for a Change?. In Twenty-Third International Joint Conference on Artificial Intelligence.](https://www.aaai.org/ocs/index.php/IJCAI/IJCAI13/paper/viewPaper/6780) and for a comparison to [Vouros, Avgoustinos, et al. "An empirical comparison between stochastic and deterministic centroid initialisation for K-Means variations." arXiv preprint arXiv:1908.09946 (2019).](https://arxiv.org/abs/1908.09946). Here we use [NAG Toolbox for MATLAB](https://www.nag.co.uk/nag-toolbox-matlab) Hartigan and Wong's K-Means implementation thus in order to use this algorithm the toolbox is required. 


**Sparse K-Means:**

[Witten, Daniela M., and Robert Tibshirani. "A framework for feature selection in clustering." Journal of the American Statistical Association 105.490 (2010): 713-726.](https://amstat.tandfonline.com/doi/abs/10.1198/jasa.2010.tm09415)

MATLAB code was based on the R implementation of the algorithm; package: [`sparcl`](https://cran.r-project.org/web/packages/sparcl/index.html)


### Clustering Initialization

**Random points and First points:**

These old K-Means initialization methods are described in [MacQueen, J. (1967, June). Some methods for classification and analysis of multivariate observations. In Proceedings of the fifth Berkeley symposium on mathematical statistics and probability (Vol. 1, No. 14, pp. 281-297)](https://books.google.co.uk/books?hl=en&lr=&id=IC4Ku_7dBFUC&oi=fnd&pg=PA281&dq=MacQueen,+James.+%22Some+methods+for+classification+and+analysis+of++%25+++++multivariate+observations.%22+Proceedings+of+the+fifth+Berkeley++%25+++++symposium+on+mathematical+statistics+and+probability.+Vol.+1.+No.++%25+++++14.+1967.&ots=nOYjJ1IguR&sig=2KaXt9BVq72T0m5571G-W758q1M&redir_esc=y#v=onepage&q&f=false). Random points just picks K random points of the dataset as initial centroids; First points just selects the first K points of the dataset as initial centroids.

**K-Means++:**

MATLAB implementation was based on the instructions of the [MSDN Magazine Blog: Test Run - K-Means++ Data Clustering](https://msdn.microsoft.com/en-us/magazine/mt185575.aspx)

**ROBIN:**

MATLAB code was originally based on the R implementation of the algorithm; package: [`wrsk`](https://github.com/brodsa/wrsk)

**Kaufman:**

MATLAB implementation was based on the pseudocode of [Pena, J. M., Lozano, J. A., & Larranaga, P. (1999). An empirical comparison of four initialization methods for the k-means algorithm. Pattern recognition letters, 20(10), 1027-1040.](https://www.sciencedirect.com/science/article/pii/S0167865599000690)

**Density K-Means++:**

[Nidheesh, N., KA Abdul Nazeer, and P. M. Ameer. "An enhanced deterministic K-Means clustering algorithm for cancer subtype prediction from gene expression data." Computers in biology and medicine 91 (2017): 213-221.](https://www.sciencedirect.com/science/article/pii/S0010482517303402)

MATLAB code was based on the R implementation of the algorithm; code: [`dkmpp_0.1.0`](https://github.com/nidheesh-n/dkmpp)
