# Random Forest

**Description**: The following is a GenePattern module that performs [random forest classification](/docs/randomforest.md), an _ensemble_ machine learning algorithm which utilizes the outputs from a collection of decision trees (hence, "forest") to answer a classification problem. In essence, after providing several samples, each with a corresponding class and set of feature values, the algorithm tells you what class a new sample "X" likely belongs to. The module runs either <ins>cross-validation</ins> (takes one dataset as input, done through LOOCV, [leave-one-out cross validation](/docs/randomforest.md#leave-one-out-cross-validation)) or <ins>test-train prediction</ins> (takes two datasets, test and train). Each dataset consists of two file inputs, one for feature data (.gct), and one for target data (.cls). Also includes several optional parameters for specifying the classification algorithm process as well as options for importing and exporting trained models.

**Author**: Omar Halawa, GenePattern Team @ Mesirov Lab - UCSD

**Contact**: [Email](mailto:ohalawa@ucsd.edu)

## Summary

The module processes files and performs random forest classification (uses LOOCV (leave-one-out cross validation) in the case of one dataset rather than test-train prediction used for two datasets) on them, generating a prediction results file (.pred.odf) that compares the "true" class to the model's prediction, and a feature importance file in the case of test-train prediction that uses a training dataset. It also includes options for importing and exporting trained model files as well as various parameters for the algorithm itself. Created for GenePattern module usage through optional arguments for classifier parameters.

## Source Links
* [The GenePattern RandomForest-GPU source repository](/../../)
* The module is written in [Python 3](https://www.python.org/download/releases/3.0/) and uses rapidsAI cuML's [RandomForestClassifier](https://docs.rapids.ai/api/cuml/stable/api/#cuml.ensemble.RandomForestClassifier) (v22.08).
* RandomForest uses the following [Singularity image](https://github.com/genepattern/nmf-gpu/blob/master/docker/Singularity.def). 

## Usage
For <ins>cross-validation</ins>, the module only requires one feature data file (.gct) and one target  data file (.cls). For <ins>test-train prediction</ins>, the module requires a testing dataset in the form of a testing feature (.gct) and testing target (.cls) data file **<ins>and</ins> either one of:** a fitted model pickle file or a training dataset (with a training feature (.gct) and training target (.cls) data file). Other parameters for classifier specifications are optional, maintaining default values if left unchanged (see below).

## Modes of Usage
| Parameter Name | Cross-Validation | Test-Train Prediction (without model input) | Test-Train Prediction (with model input)
---------|--------------|----------------|----------------
| train data file | ✔ | ✔ |  |
| train class file | ✔ | ✔ |  |
| model input file |  |  | ✔ |
| test data file |  | ✔ | ✔ |
| test class file |  | ✔ | ✔ |



## Parameters

| Name | Description | Default Value |
---------|--------------|----------------
| train data file | Training feature data file to be read from user (.gct) (can be substituted by model input in test-train prediction case) | No default value |
| train class file | Training target data file to be read from user (.cls) (can be substituted by model input in test-train prediction case) | No default value |
| model input file | model file input (.pkl, similar to model.output file) to serve as a substitute for the training dataset, and **<ins>if both are provided, is used</ins>**.| No default value |
| test data file | Testing feature data file to be read from user (.gct) (only provide when doing test-train prediction)  | No default value |
| test class file | Testing target data file to be read from user (.cls) (only provide when doing test-train prediction)  | No default value |
| model output | Optional boolean to export model trained on the dataset input in "Training Data" as a compressed pickle file (.pkl). Note: This model will **<ins>always</ins>** be fitted using all samples of train.data.file regardless of if LOOCV is carried out for prediction. **<ins>In the case of only a model being provided</ins>**, there will be **<ins>no model output</ins>** | False |
| model output filename | Optional string to name the model output file if model.output is True | <train.data.file_basename>.pkl |
| prediction results filename | Optional prediction results filename (.pred.odf, follows [GP ODF format](https://www.genepattern.org/file-formats-guide#ODF)) | results.pred.odf |
| feature importance filename | Optional Gain-based (see "Output Files") feature importance results filename - **<ins>only outputted for test-train prediction that uses a training dataset and NOT a model input file (training dataset required due to package limitations) </ins>** (.feat.odf, follows [GP ODF format](https://www.genepattern.org/file-formats-guide#ODF)) | model.feat.odf |
| bootstrap | Optional boolean to turn on classifier bootstrapping | True |
| ccp alpha | Optional float for complexity parameter of min cost-complexity pruning (>= 0.0) | 0.0 |
| class weight | Optional string for class weight specification of either of: {"balanced," "balanced_subsample"}, also takes None ; (**future implementation:** to handle input of dictionary/list of); Note: "balanced" or "balanced_subsample" are not recommended for warm start if the fitted data differs from the full dataset | None |
| criterion | Optional string for node-splitting criterion of one of the following: {“gini”, “entropy”, “log_loss”} | "gini" |
| max depth | Optional int for maximum tree depth (>= 1), also takes None | None |
| max features | Optional string for number of features per split of either one of the following: {"sqrt," "log2"} ("auto" to be removed in Scikit 1.3), (**future implementation:** handle input of float/int) | "sqrt" |
| max leaf nodes | Optional int for maximum leaf nodes per tree (>= 2), also takes None | None |
| max samples | Optional float for ratio of datasets to use per tree (between 0.0 and 1.0, inclusive for both), also takes None; if bootstrap is False, can only be None | None |
| min impurity decrease | Optional float for minimum impurity decrease needed per node split (>= 0.0) | 0.0 |
| min samples leaf | Optional int for minimum number of samples required at leaf node (>= 1) | 1 |
| min samples split | Optional int for minimum sample number to split node (>= 2) | 2 |
| min weight fraction leaf | Optional float for min weighted fraction of weight sum total to be leaf (between 0.0 and 0.5, inclusive for both) | 0.0 |
| n estimators | Optional int for number of trees in forest (>= 1) | 100 |
| oob score | Optional boolean for if out-of-bag samples used for generalization score; if bootstrap is False, can only be False | False |
| random seed | Optional int for seed of random number generator (nonnegative, caps at 4294967295, 2<sup>32</sup> - 1), also takes None. Note: Setting this to a specific integer, like 0 for example, for a specific dataset, will always yield the same prediction results file as this argument controls how bagging and random feature selection for a specific dataset occur.| None |
| debug | Optional boolean for program debugging | False |
| verbose | Optional int (0 = no verbose, 1 = base verbosity) to increase classifier verbosity (non-negative), [more info](https://scikit-learn.org/stable/glossary.html#term-verbose) (for other input values) | 0 |


## Input Files (see table above for which to input for a specific mode)

1. Train Data File   
    This is the input file of classifier training feature data which is used to create the random forest model (for the case of test-train prediction, the training dataset can be substituted by a model pickle file input). For cross-validation, this is the only feature data input which also has prediction done against it via LOOCV. The parameter expects a GCT file (.gct) that follows the [GenePattern GCT](https://www.genepattern.org/file-formats-guide#GCT) file standard.
      
2. Train Class File   
    This is the input file of classifier training target data which is used to create the random forest model (for the case of test-train prediction, the training dataset can be substituted by a model pickle file input). For cross-validation, this is the only target data input whose values are considered as "true." The parameter expects a CLS file (.cls) that follows the [GenePattern CLS](https://www.genepattern.org/file-formats-guide#CLS) file standard.

3. Model Input File   
    This is the input file of a fitted rapidsAI cuML RandomForestClassifier model as a compressed pickel (.pkl) file. It can serve as a substitute for the training dataset in the case of test-train prediction, and if both are provided, the model input file takes precedence and is used.
    
4. Test Data File   
    This is the input file of classifier testing feature data which the random forest model will predict the class values of (only passed in for test-train prediction). The parameter expects a GCT file (.gct) that follows the [GenePattern GCT](https://www.genepattern.org/file-formats-guide#GCT) file standard.
      
5. Test Class File   
    This is the input file of classifier testing target data whose values are considered as "true" (only passed in for test-train prediction). The parameter expects a CLS file (.cls) that follows the [GenePattern CLS](https://www.genepattern.org/file-formats-guide#CLS) file standard.

        
## Output Files

Outputs prediction results (.pred.odf) and feature importance files (.feat.odf, only for test-train prediction with a dataset input) that follows the [GenePattern ODF (Output Description Format)](https://www.genepattern.org/file-formats-guide#ODF) file standard. They contain a specific set of descriptive headers followed by a main data block comparing the random forest classification's predictions on the entire feature dataset against the true values with confidence scores (using rapidsAI cuML's RandomForestClassifier [_predict_proba_](https://docs.rapids.ai/api/cuml/stable/api/#cuml.RandomForestClassifier.predict_proba)) for the pred.odf file and a main data block of all the features and their importance scores (sum of all is 1; calculated as Gain-based impurity similarly to Scikit's built-in method [here](https://datascience.stackexchange.com/questions/66280/how-is-the-feature-importance-value-calculated-in-sklearn-random-forest-regre)) in the case of the feat.odf file. In addition, an optional model pickle (.pkl) file could be outputted if the user provides a training dataset (.gct and .cls) to be trained in its entirety.


## Test-Train Example Data

ALL_AML Dataset Inputs (**<ins>Without</ins>** Model Input):
[all_aml_train.gct](/data/all_aml_train.gct), [all_aml_train.cls](/data/all_aml_train.cls), [all_aml_test.gct](/data/all_aml_train.gct), and [all_aml_test.cls](/data/all_aml_train.cls)  
ALL_AML Example Outputs:
[all_aml_tt_dataset.pred.odf](/data/example_output/all_aml_tt_dataset.pred.odf), [all_aml_tt_dataset.feat.odf](/data/example_output/all_aml_tt_dataset.feat.odf), and [all_aml_train.pkl](/data/example_output/all_aml_train.pkl)

ALL_AML Dataset Inputs (**<ins>With</ins>** Model Input):
[all_aml_train.pkl](/data/example_output/all_aml_train.pkl), [all_aml_test.gct](/data/all_aml_train.gct), and [all_aml_test.cls](/data/all_aml_train.cls)  
ALL_AML Example Outputs:
[all_aml_tt_model_no_dataset.pred.odf](/data/example_output/all_aml_tt_model_no_dataset.pred.odf) (no feature importance _feat.odf_ file output as this is only outputted for test-train prediction with a dataset input and not a model input) (only if model.output is True and the training dataset is provided, which it is not in this case, will there be an output pickle file of training data)


## Cross-Validation Example Data

ALL_AML Dataset Inputs:
[all_aml_train.gct](/data/all_aml_train.gct) and [all_aml_train.cls](/data/all_aml_train.cls)
ALL_AML Example Outputs:
[all_aml_xval.pred.odf](/data/example_output/all_aml_xval.pred.odf) and [all_aml_train.pkl](/data/example_output/all_aml_train.pkl)

BRCA_HUGO Dataset Inputs:
[DP_4_BRCA_HUGO_symbols.preprocessed.gct](/data/DP_4_BRCA_HUGO_symbols.preprocessed.gct) and [Pred_2_BRCA_HUGO_symbols.preprocessed.cls](/data/Pred_2_BRCA_HUGO_symbols.preprocessed.cls)  
BRCA_HUGO Example Outputs:
[BRCA_xval.pred.odf](/data/example_output/BRCA_xval.pred.odf) and [BRCA.pkl](/data/example_output/BRCA.pkl)

Iris Dataset Inputs:
[iris.gct](/data/iris.gct) and [iris.cls](/data/iris.cls)  
Iris Example Outputs:
[iris_xval.pred.odf](/data/example_output/iris_xval.pred.odf) and [iris.pkl](/data/example_output/iris.pkl)

## Requirements

Requires the following [Singularity image](https://github.com/genepattern/nmf-gpu/blob/master/docker/Singularity.def). 

## License

`RandomForest-GPU` is distributed under a modified BSD license available [here](/LICENSE.txt)

## Version Comments

| Version | Release Date | Description                                 |
----------|--------------|---------------------------------------------|
| 1.0.0 | Jan 8th, 2024 | Initial version for team use. |
