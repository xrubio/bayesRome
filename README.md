
Supplementary Information 2

Dataset and source code for the paper entitled 'Bayesian analysis suggests the existence of free market structures within the Roman Empire'

Structure is defined as follows:

- 'data' contains the raw data and the scripts implemented to generate final datasets, as explained in SI1 - Section 1:
    - 'raw' contains csv with stamps collected from published and unpublished excavations
    - 'parsed' contains temporary files
    - 'scripts' has the list of scripts used to generate all the analysis performed in the paper
    - 'singleRun.csv' provides an example of final dataset

- 'src' implements the Bayesian analysis
    - 'computeAll.R' executes the four models and stores results as R data files
    - 'cmd files' contain the Jags code of the four models ready for Bayesian inference


