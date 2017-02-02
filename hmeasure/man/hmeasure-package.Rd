\name{hmeasure-package}
\alias{hmeasure-package}
\alias{hmeasure}
\docType{package}
\title{
The H-measure and other classification performance metrics
}
\description{
Computes the ROC curves and several related scalar performance metrics, including the H-measure, the AUC, Sensitivity while holding Specificity fixed, the Area Under the Convex Hull, and others, for several classifiers applied on a given dataset.
}
\details{
\tabular{ll}{
Package: \tab hmeasure\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2012-04-30\cr
License: \tab GPL (>=2) \cr
}

The hmeasure package is intended as a complete solution for classification performance. Its main advantage over existing implementations is the inclusion of the H-measure for classification performance (Hand, 2009,2010), which is gradually becoming accepted in the classification literature as a coherent alternative to the AUC. Other advantages include a comprehensive list of performance metrics alongside the H-measure and AUC, plotting routines for Receiver Operating Characteristic analyses of multiple classifiers, and computational optimisation to handle large datasets.

The package contains five main functions. The function misclassCounts() takes as input a set of predicted labels and their respective true labels (presumably obtained from a test dataset), and computes the confusion matrix of misclassification counts (False Positive, False Negatives, etc.) as well as a set of commonly employed scalar summaries thereof (Sensitivity, Specificity, etc.). See help(misclassCounts) for details. 

The function HMeasure() extends this functionality significantly by additionally implementing measures that do not require the user to specify a classification threshold, but rather operating on the classification scores themselves (see package vignette for an explanation of the distinction between classification scores and predicted labels). Such aggregate metrics of classification performance include the H-measure, and the AUC, as well as several others. The output of HMeasure is an object of class "hmeasure".

The function plotROC() is a plotting routine for objects of class "hmeasure", with four different options designed to give insights into the differences between the H-measure and the AUC. These include the ROC curves and their convex hulls, as well as kernel density estimators of the scoring distributions. The function relabel() is an auxillary tool which converts class labels into numeric 0s and 1s in accordance to certain conventions. Finally, the summary method for objects of class "hmeasure" report a convenient summary of the most important performance metrics in matrix format.

The package vignette provides a very detailed description of all the metrics computed by the hmeasure package, by way of a tutorial in classification performance using a real example. The most notable feature of the H-measure in particular is the possibility for the user to fix the distribution of relative misclassification severities to a classifier-independent setting on a given problem. In the absence of domain knowledge, we propose using the default prior described in [Hand and Anagnostopoulos, 2012], which takes a balanced view of misclassification costs even when faced with heavily unbalanced datasets. However, the user may freely set a prior belief for the relative cost of the two types of misclassification -- see help(HMeasure) for more details. 
}
\author{
Christoforos Anagnostopoulos <canagnos@imperial.ac.uk> and David J. Hand <d.j.hand@imperial.ac.uk>

Maintainer: Christoforos Anagnostopoulos <canagnos@imperial.ac.uk>
}
\references{

Hand, D.J. 2009. Measuring classifier performance: a coherent alternative to the area under the ROC curve. \emph{Machine Learning}, \bold{77}, 103--123.

Hand, D.J. 2010. Evaluating diagnostic tests: the area under the ROC curve and the balance of errors. \emph{Statistics in Medicine}, \bold{29}, 1502--1510.

Hand, D.J. and Anagnostopoulos, C. 2012. A better Beta for the H measure of classification performance. Preprint, arXiv:1202.2564v1.

}

\keyword{ ~classif}
\seealso{
plotROC, summary.hmeasure, misclassCounts, relabel, HMeasure
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
class.lda <- out.lda$class
scores.lda <- out.lda$posterior[,2]

# compute misclassification counts and related statistics
lda.counts <- misclassCounts(class.lda,true.class)
lda.counts$conf.matrix
print(lda.counts$metrics,digits=3)


# repeat for different value of the classification threshold
lda.counts.T03 <- misclassCounts(scores.lda>0.3,true.class)
lda.counts.T03$conf.matrix
lda.counts.T03$metrics[c('Sens','Spec')]


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
