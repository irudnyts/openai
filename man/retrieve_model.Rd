% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/retrieve_model.R
\name{retrieve_model}
\alias{retrieve_model}
\title{Retrieve model}
\usage{
retrieve_model(
  model,
  openai_api_key = Sys.getenv("OPENAI_API_KEY"),
  openai_organization = NULL
)
}
\arguments{
\item{model}{required; a length one character vector.}

\item{openai_api_key}{required; defaults to \code{Sys.getenv("OPENAI_API_KEY")}
(i.e., the value is retrieved from the \code{.Renviron} file); a length one
character vector. Specifies OpenAI API key.}

\item{openai_organization}{optional; defaults to \code{NULL}; a length one
character vector. Specifies OpenAI organization.}
}
\value{
Returns a list, elements of which contain information about the
model.
}
\description{
Retrieves a model instance, providing basic information about the model
such as the owner and permissioning. See \href{https://platform.openai.com/docs/api-reference/models/retrieve}{this page} for
details.
}
\details{
For arguments description please refer to the \href{https://platform.openai.com/docs/api-reference/models/retrieve}{official documentation}.
}
\examples{
\dontrun{
retrieve_model("text-davinci-002")
}
}
\seealso{
Other model functions: 
\code{\link{list_models}()}
}
\concept{model functions}
