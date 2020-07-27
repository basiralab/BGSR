# BGSR (Brain Graph Super-Resolution)

BGSR (Brain Graph Super Resolution) for a fast and accurate graph data classification code, by Islem Mhiri. Please contact islemmhiri1993@gmail.com for inquiries. Thanks.

While a few image super-resolution techniques have been proposed for MRI super-resolution, graph super-resolution techniques are currently absent. To this aim, we design the ﬁrst brain graph super-resolution using functional brain data with the aim to boost neurological disorder diagnosis. Our framework learns how to generate high-resolution (HR) graphs from low-resolution (LR) graphs without resorting to the computationally expensive image processing pipelines for connectome construction at high-resolution scales.


![BGSR pipeline](https://github.com/basiralab/BGSR/blob/master/Fig1.png)

# Detailed proposed BGSR pipeline

This work has been published in the journal. Brain Graph Super Resolution (BGSR) is the first brain graph super resolution. The proposed method consists of three steps to build a HR graph of a testing subject by non-linearly fusing the HR graphs in the training sample.(1) The first step is a multi-kernel manifold learning to cluster similar low-resolution (LR) graphs in the training sample using the weights for a set of Gaussian kernels. (2) The second step is building the brain template of LR graphs for each cluster using an iterative diffusion process with a kernel matrix P about the similarity between ROIs. (3) The last step is identifying the most K similar training LR graphs of a test subject using the multi-kernel manifold learning with three centrality metrics (degree centrality, closeness centrality, and betweenness centrality). Experimental results and comparisons with the state-of-the-art methods demonstrate that BGSR can achieve the best prediction performance, and remarkably boosted the classiﬁcation accuracy using predicted HR graphs in comparison to LR, and remarkably boosted the classiﬁcation accuracy using predicted HR graphs in comparison to LR graphs. We evaluated our proposed framework from ABIDE preprocessed dataset (http://preprocessed-connectomes-project.org/abide/).

More details can be found at: https://www.sciencedirect.com/science/article/pii/S1361841520301328 or https://www.researchgate.net/publication/342493237_Brain_Graph_Super-Resolution_for_Boosting_Neurological_Disorder_Diagnosis_using_Unsupervised_Multi-Topology_Connectional_Brain_Template_Learning

![BGSR pipeline](https://github.com/basiralab/BGSR/blob/master/Fig2.png)


# Demo

The code has been tested with MATLAB 2020a on Windows 10. GPU is not needed to run the code.

In this repo, we release the BGSR source code trained and tested on a simulated heterogeneous graph data from 2 Gaussian distributions as shown below:

**Data preparation**

We simulated random graph dataset from two Gaussian distributions using the function simulateData_LR_HR.m. The number of graphs in class 1, the number graphs in class 2, and the number of nodes (must be >20) are manually inputted by the user when starting the demo.

To train and evaluate BGSR code on other datasets, you need to provide:

• A tensor of size ((n-1) × m × m) stacking the symmetric matrices of the training subjects. n denotes the total number of subjects and m denotes the number of nodes.<br/>
• A vector of size (n-1) stacking the training labels.<br/>
• A matrix (n × (m × m)) stacking the source HR brain graph.<br/>
• A uumber of most similar LR training subjects Kn.<br/>

The BGSR outputs are:

• A vector of size (1 × (m × m)) vector stacking the predicted features of the testing subject.


**Train and test BGSR**

To evaluate our framework, we used leave-one-out cross validation strategy.

To try our code, you can use: BGSR_demo.m


# Acknowledgement

We used the following codes from others as follows:

SIMLR code from https://github.com/BatzoglouLabSU/SIMLR/tree/SIMLR/MATLAB. 

SNF code from http://compbio.cs.toronto.edu/SNF/SNF/Software.html.


# Related references

Similarity Network Fusion (SNF): Wang, B., Mezlini, A.M., Demir, F., Fiume, M., Tu, Z., Brudno, M., HaibeKains, B., Goldenberg, A., 2014. Similarity network fusion for aggregating data types on a genomic scale. [http://www.cogsci.ucsd.edu/media/publications/nmeth.2810.pdf] (2014) [https://github.com/maxconway/SNFtool].

Single‐cell Interpretation via Multi‐kernel LeaRning (SIMLR): Wang, B., Ramazzotti, D., De Sano, L., Zhu, J., Pierson, E., Batzoglou, S.: SIMLR: a tool for large-scale single-cell analysis by multi-kernel learning. [https://www.biorxiv.org/content/10.1101/052225v3] (2017) [https://github.com/bowang87/SIMLR_PY].

# Please cite the following paper when using NAG-FS:

@article{mhiri2020brain,
  title={Brain Graph Super-Resolution for Boosting Neurological Disorder Diagnosis using Unsupervised Multi-Topology Connectional Brain Template Learning},<br/>
  author={Mhiri, Islem and Khalifa, Anouar Ben and Mahjoub, Mohamed Ali and Rekik, Islem},<br/>
  journal={Medical Image Analysis},<br/>
  pages={101768},<br/>
  year={2020},<br/>
  publisher={Elsevier}<br/>
}<br/>

Paper link on Elsevier: 
https://www.sciencedirect.com/science/article/pii/S1361841520301328

Paper link on ResearchGate:
https://www.researchgate.net/publication/342493237_Brain_Graph_Super-Resolution_for_Boosting_Neurological_Disorder_Diagnosis_using_Unsupervised_Multi-Topology_Connectional_Brain_Template_Learning

# License
Our code is released under MIT License (see LICENSE file for details).

# Contributing
We always welcome contributions to help improve NAG-FS and evaluate our framework on other types of graph data. If you would like to contribute, please contact islemmhiri1993@gmail.com. Many thanks.







