% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_completion.R
\name{create_completion}
\alias{create_completion}
\title{Create completion}
\usage{
create_completion(
  engine_id = deprecated(),
  model,
  prompt = "<|endoftext|>",
  suffix = NULL,
  max_tokens = 16,
  temperature = 1,
  top_p = 1,
  n = 1,
  stream = FALSE,
  logprobs = NULL,
  echo = FALSE,
  stop = NULL,
  presence_penalty = 0,
  frequency_penalty = 0,
  best_of = 1,
  logit_bias = NULL,
  user = NULL,
  openai_api_key = Sys.getenv("OPENAI_API_KEY"),
  openai_organization = NULL
)
}
\arguments{
\item{engine_id}{\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#deprecated}{\figure{lifecycle-deprecated.svg}{options: alt='[Deprecated]'}}}{\strong{[Deprecated]}}}

\item{model}{required; a length one character vector.}

\item{prompt}{required; defaults to \code{"<|endoftext|>"}; an arbitrary length
character vector.}

\item{suffix}{optional; defaults to \code{NULL}; a length one character vector.}

\item{max_tokens}{required; defaults to \code{16}; a length one numeric vector
with the integer value greater than \code{0}.}

\item{temperature}{required; defaults to \code{1}; a length one numeric vector
with the value between \code{0} and \code{2}.}

\item{top_p}{required; defaults to \code{1}; a length one numeric vector with the
value between \code{0} and \code{1}.}

\item{n}{required; defaults to \code{1}; a length one numeric vector with the
integer value greater than \code{0}.}

\item{stream}{required; defaults to \code{FALSE}; a length one logical vector.
\strong{Currently is not implemented.}}

\item{logprobs}{optional; defaults to \code{NULL}; a length one numeric vector
with the integer value between \code{0} and \code{5}.}

\item{echo}{required; defaults to \code{FALSE}; a length one logical vector.}

\item{stop}{optional; defaults to \code{NULL}; a character vector of length
between one and four.}

\item{presence_penalty}{required; defaults to \code{0}; a length one numeric
vector with a value between \code{-2} and \code{2}.}

\item{frequency_penalty}{required; defaults to \code{0}; a length one numeric
vector with a value between \code{-2} and \code{2}.}

\item{best_of}{required; defaults to \code{1}; a length one numeric vector with
the integer value greater than \code{0}.}

\item{logit_bias}{optional; defaults to \code{NULL}; a named list.}

\item{user}{optional; defaults to \code{NULL}; a length one character vector.}

\item{openai_api_key}{required; defaults to \code{Sys.getenv("OPENAI_API_KEY")}
(i.e., the value is retrieved from the \code{.Renviron} file); a length one
character vector. Specifies OpenAI API key.}

\item{openai_organization}{optional; defaults to \code{NULL}; a length one
character vector. Specifies OpenAI organization.}
}
\value{
Returns a list, elements of which contain completion(s) and
supplementary information.
}
\description{
Creates a completion based on the provided prompt and parameters. See \href{https://platform.openai.com/docs/api-reference/completions/create}{this page} for
details.
}
\details{
For arguments description please refer to the \href{https://platform.openai.com/docs/api-reference/completions/create}{official documentation}.
}
\examples{
\dontrun{
create_completion(
    model = "text-davinci-002",
    prompt = "Say this is a test",
    max_tokens = 5
)

logit_bias <- list(
    "11" = -100,
    "13" = -100
)
create_completion(
    model = "ada",
    prompt = "Generate a question and an answer",
    n = 4,
    best_of = 4,
    logit_bias = logit_bias
)
}
}
