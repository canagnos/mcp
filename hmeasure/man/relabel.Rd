\name{relabel}
\alias{relabel}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Converts class labels to the default choice of numeric 0s and 1s
}
\description{
Converts class labels to the default choice of numeric 0s and 1s according to a specific set of conventions.
}

\usage{
relabel(labels)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{labels}{
 a vector/array of labels, with two levels
}
}
\details{
This function turns a vector of class labels into the default format: a numeric array with levels 0 and 1. It accepts numeric, logical, and factor arrays, and performs the conversion in accordance with the following conventions. For a numeric vector with values a and b, the minimum of (a,b) will be mapped to 0 and their maximum to 1. For a logical vector with values TRUE and FALSE, TRUE is mapped to 1 and FALSE to 0. Levels of a factor are interpreted as character strings and then mapped to 0s and 1s in alphabetical order, e.g., "male" is mapped to 1, and "female" to 0, and similarly "true" is mapped to 1 and "false" to 0. This convention being arbitrary, the user must make sure (s)he is happy with the results. For instance, if the labels are "cases/non-cases", the default mapping maps "cases" to 0s, whereas 1s would have been the intuitive choice in this instance. To avoid confusion, a message is produced describing the switch whenever one happens. 

The code will complain if the number of distinct labels in the input vector is not 2. 
}
\value{
a numeric array of 0s and 1s
}
\author{
Christoforos Anagnostopoulos <canagnos@imperial.ac.uk> and David J. Hand <d.j.hand@imperial.ac.uk>

Maintainer: Christoforos Anagnostopoulos <canagnos@imperial.ac.uk>
}
\seealso{
plotROC, summary.hmeasure, misclassCounts, HMeasure
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\examples{

relabel(c("0","1","1"))
relabel(c("no","yes","yes"))
relabel(c(FALSE,TRUE,TRUE))

# the code complains if the number of classes present in the vector is not 2
try(relabel(c("0","1","2")))
try(relabel(c("1","1","1")))

}
\keyword{ ~classif}
