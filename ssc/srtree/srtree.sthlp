{smcl}
{* 06May2020}{...}
{cmd:help srtree}
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col:{hi:srtree}{hline 1}}Implementing regression trees via optimal pruning, bagging, random forests, and boosting methods{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{hi:srtree}
{it:outcome} 
[{it:varlist}]
{ifin}
{cmd:model}{cmd:(}{it:{help srtree##modeltype:modeltype}}{cmd:)}
{cmd:rversion}{cmd:(}{it:R_version}{cmd:)}
[{cmd:prune}{cmd:(}{it:integer}{cmd:)}
{cmd:cv_tree}
{cmd:prediction}{cmd:(}{it:new_data_filename}{cmd:)}
{cmd:in_samp_data}{cmd:(}{it:filename}{cmd:)}
{cmd:out_samp_data}{cmd:(}{it:filename}{cmd:)}
{cmd:ntree}{cmd:(}{it:integer}{cmd:)}
{cmd:mtry}{cmd:(}{it:integer}{cmd:)}
{cmd:inter_depth}{cmd:(}{it:integer}{cmd:)}
{cmd:shrinkage}{cmd:(}{it:number}{cmd:)}
{cmd:pdp}{cmd:(}{it:string}{cmd:)}
{cmd:seed}{cmd:(}{it:integer}{cmd:)}]


{title:Description}

{pstd} {cmd:srtree} is a Stata wrapper for the R functions "tree()", "randomForest()", and "gbm()".
It allows to implement the following regression tree models: (1) regression tree with optimal pruning, 
(2) bagging, (3) random forests, and (4) boosting.   

     
{title:Options}
    
{phang} {cmd:model}{cmd:(}{it:{help srtree##modeltype:modeltype}}{cmd:)} specifies the model
to be estimated.   

{phang} {cmd:rversion}{cmd:(}{it:R_version}{cmd:)} specifies the R version intalled in the operating system. A typical value is: "3.6.0".

{phang} {cmd:prune}{cmd:(}{it:integer}{cmd:)} specifies the the size M of the optimal M-pruned tree.

{phang} {cmd:cv_tree} requests to use cross-validation to find the optimal tree size (i.e., optimal pruning).

{phang} {cmd:prediction}{cmd:(}{it:new_data_filename}{cmd:)} requests to generate the prediction of the outcome variable. 
The user must specify the {it:new_data_filename}, i.e. the name of a dataset containing new observations 
having the same variables' name of the original dataset, but with the dependent variable filled in with 
all missing values.

{phang} {cmd:in_samp_data}{cmd:(}{it:filename}{cmd:)} allows to save into {it:filename} the in-sample predictions of the model.
Within {it:filename}, the user can find: "y_train"=the original outcome variable in the training dataset; "yhat_train"=the prediction of the outcome variable generated by the model in the training dataset; "Train_MSE"=the training dataset's mean square error.    

{phang} {cmd:out_samp_data}{cmd:(}{it:filename}{cmd:)} allows to save into {it:filename} the out-of-sample predictions of the model. Within {it:filename}, the user can find: "y_test"=the original outcome variable in the test dataset; "yhat_test"=the prediction of the outcome variable generated by the model in the test dataset; "Test_MSE"=the test dataset's mean square error. 

{phang} {cmd:ntree}{cmd:(}{it:integer}{cmd:)} specifies the number of bootstrapped trees to use in the bagging model.

{phang} {cmd:mtry}{cmd:(}{it:integer}{cmd:)} specifies the size of the subset of covariates to randomly choose when implemeting the random forest model. 

{phang} {cmd:inter_depth}{cmd:(}{it:integer}{cmd:)} specifies the complexity of the boosted ensemble. Often inter_depth = 1 works well, 
in which case each tree is a stump, consisting of a single split and resulting in an additive model. 
More generally the value of inter_depth is the interaction depth, and controls the interaction order of the boosted model, since a number of "inter_depth" splits can involve at most a number of "inter_depth" variables. This option matters only for "boosting".

{phang} {cmd:shrinkage}{cmd:(}{it:number}{cmd:)} specifies the parameter controlling for the rate at which boosting learns. 
Typical values are 0.01 or 0.001, and the right choice can depend on the problem. Very small values can require using a very 
large value of the number of bootstrapped trees in order to achieve good performance. This option matters only for
"boosting".

{phang} {cmd:pdp}{cmd:(}{it:covariate}{cmd:)} produces A "partial dependence plot" for the specified covariate. This plot
illustrates the marginal effect of the selected variable on the response after integrating out the other variables. This option matters only for
"boosting".

{phang} {cmd:seed}{cmd:(}{it:integer}{cmd:)} sets the seed number allowing for reproducing the same results.

{marker modeltype}{...}
{synopthdr:modeltype_options}
{synoptline}
{syntab:Model}
{p2coldent : {opt tree}}Simple regression tree model{p_end}
{p2coldent : {opt randomforests}}bagging and random forest models{p_end}
{p2coldent : {opt boosting}}Bossting model{p_end}
{synoptline}


{title:Remarks}

{phang} -> For R to correctly read them, categorical (or factor) variables in Stata need to have "literal string values" and not "numerical string values" (for example, y=("A","B","C") is fine, but y=("1","2","3") is not fine as R will interpret these values as numbers in any case). 
	 
{phang} -> Before running this program, remember to have the most recent up-to-date version installed.


{title:Example}

******************************************************************************************************
* LOAD THE "boston.dta" DATASET
******************************************************************************************************

   . use boston , clear

******************************************************************************************************
 * SET THE OUTCOME, THE COVARIATES, AND THE TREE SIZE ("M")
******************************************************************************************************

   . global y "medv"

   . global xvars "crim zn indus chas nox rm age dis rad tax ptratio black lstat"

   . global M=5

******************************************************************************************************
 * ESTIMATE VARIOUS REGRESSION TREE MODELS
******************************************************************************************************

   ***************************************************************************************************
   * Unpruned regression tree + train-MSE
   ***************************************************************************************************

     . srtree $y $xvars , model(tree) rversion("3.6.0") in_samp_data(IN) out_samp_data(OUT) 

   ***************************************************************************************************
   * Optimal pruned regression tree of size M + train-MSE + test-MSE 
   ***************************************************************************************************
     
     . srtree $y $xvars , model(tree) rversion("3.6.0") prune($M) in_samp_data(IN) out_samp_data(OUT)

   ***************************************************************************************************
   * Cross-validation with optimal regression tree size 
   ***************************************************************************************************
     
     . srtree $y $xvars , model(tree) rversion("3.6.0") cv_tree in_samp_data(IN) out_samp_data(OUT)

   ***************************************************************************************************
   * Bagging & random-forests, based on N=50 bootstrapped trees.
   ***************************************************************************************************
   *  If "mtry(K = number of the entire set of model covariates)" ===> estimation is made by "bagging"
   *  If "mtry(K = S < K)" ===> estimation is made by "random forests"
   ***************************************************************************************************

     . srtree $y $xvars , model(randomforests) rversion("3.6.0") mtry(13) ntree(50) ///
       in_samp_data(IN) out_samp_data(OUT)   

   ***************************************************************************************************
   * Boosting (with a "partial dependence plot" for the covariate "rm")
   ***************************************************************************************************
     . srtree $y $xvars , model(boosting) rversion("3.6.0") inter_depth(4) ntree(5000) ///
       shrinkage(0.2) pdp("rm") in_samp_data(IN) out_samp_data(OUT)
   *************************************************************************************************** 

******************************************************************************************************


{title:Reference}

{phang}
Gareth, J., Witten, Hastie, D.T., Tibshirani. 2013. {it:An Introduction to Statistical Learning : with Applications in R}. New York, Springer.
{p_end}


{title:Author}

{phang}Giovanni Cerulli{p_end}
{phang}IRCrES-CNR{p_end}
{phang}Research Institute for Sustainable Economic Growth, National Research Council of Italy{p_end}
{phang}E-mail: {browse "mailto:giovanni.cerulli@ircres.cnr.it":giovanni.cerulli@ircres.cnr.it}{p_end}


{title:Also see}

{psee}
Online: {helpb sctree}, {helpb subset}
{p_end}
