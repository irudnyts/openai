% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/delete_file.R
\name{delete_file}
\alias{delete_file}
\title{Delete file}
\usage{
delete_file(
  file_id,
  openai_api_key = Sys.getenv("OPENAI_API_KEY"),
  openai_organization = NULL
)
}
\arguments{
\item{file_id}{required; a length one character vector.}

\item{openai_api_key}{required; defaults to \code{Sys.getenv("OPENAI_API_KEY")}
(i.e., the value is retrieved from the \code{.Renviron} file); a length one
character vector. Specifies OpenAI API key.}

\item{openai_organization}{optional; defaults to \code{NULL}; a length one
character vector. Specifies OpenAI organization.}
}
\value{
Returns a list, elements of which contains ID of the deleted file and
status whether the file is deleted.
}
\description{
Deletes a file. See \href{https://platform.openai.com/docs/api-reference/files/delete}{this page} for details.
}
\details{
For arguments description please refer to the \href{https://platform.openai.com/docs/api-reference/files/delete}{official documentation}.
}
\examples{
\dontrun{
file <- system.file("extdata", "classification-file.jsonl", package = "openai")
file_info <- upload_file(file = file, purpose = "classification")
delete_file(file_info$id)
}
}
\seealso{
Other file functions: 
\code{\link{list_files}()},
\code{\link{retrieve_file_content}()},
\code{\link{retrieve_file}()},
\code{\link{upload_file}()}
}
\concept{file functions}
