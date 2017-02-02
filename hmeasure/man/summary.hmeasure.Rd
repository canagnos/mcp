\name{summary.hmeasure}
\alias{summary.hmeasure}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Report performance measures using an object of class "hmeasure"
}
\description{
This function retrieves a convenient numeric summary of the output of the HMeasure function. 
}
\usage{
\method{summary}{hmeasure}(object, show.all, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{
  an object of class hmeasure
}
  \item{show.all}{
  when this is FALSE only aggregate metrics are reported, whereas when TRUE, threshold-specific metrics are additionally reported -- see the package vignette for more details. By default this is set to FALSE. 
}
  \item{...}{ 
  additional arguments affecting the summary produced
}
}
\details{
Objects of class "hmeasure" have a field called "metrics", which reports several performance metrics in the form of a data frame with one row per classifier. Please refer to help(HMeasure) or the package vignette to find out more information about the measures reported. The summary method for hmeasure objects retrieves and prints this field. By default only the most important aggregate metrics are reported. Additionally setting show.all=TRUE will report all available metrics. 
}
\value{
The summary method returns the "metrics" field of the original hmeasure object: i.e., a data frame where each row is a classifier, and each column a performance metric. 
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
plotROC, misclassCounts, relabel, HMeasure
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

# experiment with fixing the sensitivity (resp. specificity)
summary(HMeasure(true.class,scores,level=c(0.95,0.99)))



}
\keyword{ ~classif}
