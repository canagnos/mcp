\name{misclassCounts}
\alias{misclassCounts}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Computes misclassification counts and related statistics by contrasting predicted with true class labels.
}
\description{
Computes a set of classification performance metrics that rely on a set of predicted labels and a set of true labels as input. This is in contrast to the HMeasure function which operates directly on the classification scores. 
}
\usage{
misclassCounts(predicted.class,true.class)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{predicted.class}{
 a vector/array of predicted labels -- can be either a factor, or in numeric form 
}
  \item{true.class}{
 a vector/array of true labels -- can be either a factor, or in numeric form 
}

}
\details{

This function computes a set of classification performance metrics that rely on a set of predicted labels and a set of true labels as input. This is in contrast to the HMeasure function which operates directly on the classification scores - see help(HMeasure). All the measures computed here are scalar summaries of the confusion matrix, which consists of the number of True Positives (TPs), False Positives (FPs), True Negatives (TNs), and False Negatives (FNs).  The most common such summary is the Error Rate (ER). Additionally the following metrics are reported: the True Positive Rate (TPR) and the False Positive Rate (FPR), Sensitivity (same as TPR) versus Specificity (given by 1-FPR), and yet another such pair is Precision versus Recall (same as Sensitivity). Finally, the F measure and the Youden index are scalar measures that attempt to take a more balanced view of the two different objectives than ER does. The former is given by the harmonic mean of Precision and Recall, and the latter by Sens+Spec-1.

The function misclassCounts is essentially a sub-routine of the HMeasure function. In particular, the latter reports all the above metrics, plus several more. Moreover, whereas misclassCounts can only accept a single array of predicted labels, the HMeasure function can take as input the classification scores of several classifiers simultaneously. See the package vignette for more information.
}
\value{
 a list with two fields
\item{metrics }{A data frame with one row of performance metrics}
\item{conf.matrix }{The confusion matrix}
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


%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
plotROC, summary.hmeasure, relabel, HMeasure
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

  

}
\keyword{ ~classif}
