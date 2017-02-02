\name{plotROC}
\alias{plotROC}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Plotting function illustrating the H-measure of classification performance.
}
\description{
Plots ROC curves, weight distributions according to the H-measure and the AUC, and smoothed scoring distributions.
}
\usage{
plotROC(results, which = 1, bw="nrd0")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{results}{
An object of class "hmeasure", which will be the output of the "HMeasure" function applied on the scores of one or more classifiers on the same test dataset, and the true class labels of the test dataset. 
}
  \item{which}{
The type of plot to be produced. Option 1 yields the ROC curves and their convex hulls; option 2 shows the weights employed by the H-measure; option 3 displays the weights over costs that are implicitly employed by the AUC in this example for each classifier; and option 4 yields the smoothed density plots of the scoring distributions per class.
} 
  \item{bw}{
The type of bandwidth to be used for the smoothed scoring distribution plot. See help(density) for more detail on possible settings of the "bw" parameter. We employ the same default setting as 'density()', namely "nrd0". 
 }
}
\details{
This plotting routine is meant to help users perform graphical comparisons of several classifiers, and to illustrate the difference between the H-measure and the AUC as aggregate measures of classification performance. Four types of plots are available:

Option 1 plots the Receiver Operating Characteristic curves of each classifier in a continuous colored line, as well as their respective convex hulls in dotted lines. Additionally the ROC curve of the trivial, random classifier is reported, which is a diagonal line. 

Option 2 plots the prior over misclassification costs employed by the H-measure. The mode of this prior, controlled by the severity ratio parameter, is indicated by a vertical line.

Option 3 plots, for each classifier, the prior over misclassification costs implicitly employed by the AUC measure, when this latter is interpreted as an averaging operation over different choices of relative misclassification severity.

Finally, option 4 plots, for each classifier, the (smoothed) empirical probability densities of the score conditional on either class label, i.e., p(s(x) | x = 0), where x is the feature vector and s(x) the score of that feature by a given classifier. Class 0 is plotted using a continuous line, and class 1 using a dotted line. 
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
\note{
  This plotting function is provided to help illustrate the H-measure, and to serve as a stepping stone in a user's development of further custom plotting functions using the "data" attribute of hmeasure objects.
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
summary.hmeasure, misclassCounts, relabel, HMeasure
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


# produce the four different types of available plots
par(mfrow=c(2,2))
plotROC(results,which=1)
plotROC(results,which=2)
plotROC(results,which=3)
plotROC(results,which=4)


}
\keyword{ ~classif}
