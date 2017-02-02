\name{HMeasure}
\alias{HMeasure}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Computes the H-measure, AUC, and several other scalar classification performance metrics. 
}
\description{
Computes the H-measure and other scalar classification performance metrics. 
}
\usage{
HMeasure(true.class, scores, severity.ratio = NA, threshold=0.5, level=0.95)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{true.class}{
 a vector/array of true labels -- can be either a factor, or in numeric form. It is converted to the right format using function relabel(). Must contain at most two classes, at least one instance of each class, and no missing values.
}
  \item{scores}{
a matrix/vector/data frame of scores, each column corresponding to one classifier. Any missing score in any classifier will cause the respective row (i.e., the respective scores for all classifiers) to be disregarded, and produce a warning. 
}
  \item{severity.ratio}{
an optional scalar parameter representing how much more severe misclassifying a class 0 instance is than misclassifying a class 1 instance for the computation of the H-measure and the weighted loss. See Details and/or the package vignette for an explanation of the default value for this parameter. 
}
  \item{threshold}{
  a vector containing one threshold value per classifier, or a scalar representing a common threshold for all classifiers, for use in performance metrics based on misclassification counts. It is set to 0.5 by default.
}
  \item{level}{
  normally a scalar x that is employed in computing Sens.Spec-x (resp. Spec.Sens-x), which represents the value of sensitivity (resp. specificity) when specificity (resp. sensitivity) is held fixed at x\%. If the user inputs a vector, both metrics will be computed and reported for each element in the vector. 
}
}
\details{

This the main function of the hmeasure package. It takes as input the vector of true class labels, as well as a matrix or data frame consisting of (column) vectors of scores obtained from deploying each of possibly several classifiers to a given dataset. It computes several scalar performance metrics, including the H-measure [Hand, 2009,2010] and the AUC.

To avoid confusion, class labels are switched to 0s (representing "negatives") and 1s (representing "positives"), according to the conventions of relabel(). It is generally understood that scores are such that class 0 objects tend to receive lower scores than class 1 objects, and, whenever AUC < 0.5, the signs of the scores of that classifier are reversed, as is customary in the literature. Any such switches produce a warning.

The HMeasure function outputs an object of class "hmeasure", with one field named "metrics" that reports several performance metrics in the form of a data frame with one row per classifier, and an attribute named "data" which preserves useful information (such as the empirical scoring distributions) for plotting purposes. 

The H-measure naturally requires as input a severity ratio, which represents how much more severe misclassifying a class 0 instance is than misclassifying a class 1 instance. Formally, this determines the mode of the prior over costs that underlies the H-measure (see package vignette or references for more information). We may write SR = c_0/c_1, where c_0 > 0 is the cost of misclassifying a class 0 datapoint as class 1. It is sometimes more convenient to consider instead the normalised cost c = c_0/(c_0 + c_1), so that SR = c/(1-c) where c is in [0,1]. For instance, severity.ratio = 2 implies that a False Positive costs twice as much as a False Negative. By default the severity ratio is set to be reciprocal of relative class frequency, i.e., severity.ratio = pi1/pi0, so that misclassifying the rare class is considered a graver mistake. See Hand 2012 for a more detailed motivation of this default.

The metrics reported can be broken down into two types. The first type consists of metrics that measure the match between a set of predicted labels and the true labels. We obtain these predictions using the scores provided and employing a user-specified threshold (or thresholds, one per classifier), if provided, otherwise a default of 0.5. See help(misclassCounts) for a list of the metrics computed. The second type of measures are aggregate measures of performance that do not rely on the user to specify the threshold, and instead operate directly on the classification scores themselves. In this sense, they are more useful for performance comparisons across classifiers and datasets. The aggregate metrics currently reported include: the Area under the ROC Curve (AUC), the H-measure, the Area under the Convex Hull of the ROC Curve (AUCH), the Gini coefficient, the Kolmogorov-Smirnoff (KS) statistic, the Minimum Weighted Loss (MWL), the Minimum Total Loss (MTL), as well as the Sensitivity at 95\% Specificity ("Sens95"), and the Specificity at 95\% Sensitivity ("Spec95"). For these latter measures, a 95\% level is the default, but alternative or additional values may be specified using the "level" argument.  

The package vignette contains a very a detailed explanation of each of the above metrics, and their relationships with each other.  
}
\value{
 an object of class "hmeasure", implemented as a list with a single field "metrics", and an additional attribute "data"
\item{stats }{A field containing a data frame of measures, where each row is a classifier}
\item{data }{An attribute implemented as an array of lists, each containing scoring distributions and other computed quantities for each classifier to be used for further analysis, or by the plotting routine.}
}
\references{

Hand, D.J. 2009. Measuring classifier performance: a coherent alternative to the area under the ROC curve. \emph{Machine Learning}, \bold{77}, 103--123.

Hand, D.J. 2010. Evaluating diagnostic tests: the area under the ROC curve and the balance of errors. \emph{Statistics in Medicine}, \bold{29}, 1502--1510.

Hand, D.J. and Anagnostopoulos, C. 2012. A better Beta for the H measure of classification performance. Preprint, arXiv:1202.2564v1

}
\author{
Christoforos Anagnostopoulos <canagnos@imperial.ac.uk> and David J. Hand <d.j.hand@imperial.ac.uk>

Maintainer: Christoforos Anagnostopoulos <canagnos@imperial.ac.uk>
}



\seealso{
plotROC, summary.hmeasure, misclassCounts, relabel
}
\examples{


# load the data
library(MASS) 
library(class) 
data(Pima.te) 

# split it into training and test
n <- dim(Pima.te)[1] 
ntrain <- floor(2*n/3) 
ntest <- n-ntrain
pima.train <- Pima.te[seq(1,n,3),]
pima.test <- Pima.te[-seq(1,n,3),]
true.class<-pima.test[,8]

# train an LDA classifier
pima.lda <- lda(formula=type~., data=pima.train)
out.lda <- predict(pima.lda,newdata=pima.test) 

# obtain the predicted labels and classification scores
scores.lda <- out.lda$posterior[,2]

# train k-NN classifier
class.knn <- knn(train=pima.train[,-8], test=pima.test[,-8],
  cl=pima.train$type, k=9, prob=TRUE, use.all=TRUE)
scores.knn <- attr(class.knn,"prob")
# this is necessary because k-NN by default outputs
# the posterior probability of the winning class
scores.knn[class.knn=="No"] <- 1-scores.knn[class.knn=="No"] 

# run the HMeasure function on the data frame of scores
scores <- data.frame(LDA=scores.lda,kNN=scores.knn)
results <- HMeasure(true.class,scores)

# report aggregate metrics
summary(results)
# additionally report threshold-specific metrics
summary(results,show.all=TRUE)


# produce the four different types of available plots
par(mfrow=c(2,2))
plotROC(results,which=1)
plotROC(results,which=2)
plotROC(results,which=3)
plotROC(results,which=4)


# experiment with different classification thresholds
HMeasure(true.class,scores,threshold=0.3)$metrics[c('Sens','Spec')]
HMeasure(true.class,scores,threshold=c(0.3,0.3))$metrics[c('Sens','Spec')]
HMeasure(true.class,scores,threshold=c(0.5,0.3))$metrics[c('Sens','Spec')]

# experiment with fixing the sensitivity (resp. specificity)
summary(HMeasure(true.class,scores,level=c(0.95,0.99)))

# experiment with non-default severity ratios
results.SR1 <- HMeasure(
  true.class, data.frame(LDA=scores.lda,kNN=scores.knn),severity.ratio=1)
results.SR1$metrics[c('H','KS','ER','FP','FN')]

}
\keyword{ ~classif}
