#' Create answer
#'
#' Answers the specified question using the provided documents and examples. See
#' \href{https://beta.openai.com/docs/api-reference/answers/create}{this page}
#' for details.
#'
#' Given a question, a set of documents, and some examples, the API generates an
#' answer to the question based on the information in the set of documents. This
#' is useful for question-answering applications on sources of truth, like
#' company documentation or a knowledge base. Answers the specified question
#' using the provided documents and examples. The endpoint first
#' \href{https://beta.openai.com/docs/api-reference/searches}{searches} over
#' provided documents or files to find relevant context. The relevant context is
#' combined with the provided examples and question to create the prompt for
#' \href{https://beta.openai.com/docs/api-reference/completions}{completion}.
#' Related guide:
#' \href{https://beta.openai.com/docs/guides/answers}{Question answering}.
#'
#' @param model required; defaults to \code{"ada"}; a length one character
#' vector, one among \code{"ada"}, \code{"babbage"}, \code{"curie"}, and
#' \code{"davinci"}. ID of the engine to use for completion.
#' @param question required; a length one character vector. Question to get
#' answered.
#' @param examples required; a list. List of (question, answer) pairs that will
#' help steer the model towards the tone and answer format you'd like. We
#' recommend adding 2 to 3 examples.
#' @param examples_context required; a length one character vector. A text
#' snippet containing the contextual information used to generate the answers
#' for the \code{examples} you provide.
#' @param documents optional; defaults to \code{NULL}; an arbitrary length
#' character vector. List of documents from which the answer for the input
#' \code{question} should be derived. If this is an empty list, the question
#' will be answered based on the question-answer examples. You should specify
#' either \code{documents} or a \code{file}, but not both.
#' @param file optional; defaults to \code{NULL}; a length one character vector.
#' The ID of an uploaded file that contains documents to search over. See
#' \code{\link{upload_file()}} for how to upload a file of the desired format
#' and purpose. You should specify either \code{documents} or a \code{file}, but
#' not both.
#' @param search_model required; defaults to \code{ada}; a length one character
#' vector, one among \code{"ada"}, \code{"babbage"}, \code{"curie"}, and
#' \code{"davinci"}. ID of the engine to use for \code{\link{create_search()}}.
#' @param max_rerank required; defaults to \code{200}; a length one numeric vector
#' with the integer value greater than \code{0}. The maximum number of documents
#' to be ranked by \code{\link{create_search()}} when using \code{file}. Setting
#' it to a higher value leads to improved accuracy but with increased latency
#' and cost.
#' @param temperature required; defaults to \code{0}; a length one numeric
#' vector with the value between \code{0} and \code{2}. What sampling
#' temperature to use. Higher values mean the model will take more risks and
#' value 0 (argmax sampling) works better for scenarios with a well-defined
#' answer.
#' @param logprobs optional; defaults to \code{NULL}; a length one numeric
#' vector with the integer value between \code{0} and \code{5}. Include the log
#' probabilities on the \code{logprobs} most likely tokens, as well the chosen
#' tokens. For example, if \code{logprobs} is \code{5}, the API will return a
#' list of the 5 most likely tokens. The API will always return the
#' \code{logprob} of the sampled token, so there may be up to \code{logprobs+1}
#' elements in the response. The maximum value for logprobs is \code{5}. If you
#' need more than this, please contact \email{support@openai.com} and describe
#' your use case. When \code{logprobs} is set, \code{completion} will be
#' automatically added into \code{expand} to get the logprobs.
#' @param max_tokens required; defaults to \code{16}; a length one
#' numeric vector with the integer value greater than \code{0}. The maximum
#' number of tokens allowed for the generated answer.
#' @param stop optional; defaults to \code{NULL}; a character vector of length
#' between one and four. Up to 4 sequences where the API will stop generating
#' further tokens. The returned text will not contain the stop sequence.
#' @param n required; defaults to \code{1}; a length one numeric vector with the
#' integer value greater than \code{0}. How many answers to generate for each
#' question.
#' @param logit_bias optional; defaults to \code{NULL}; a named list. Modify the
#' likelihood of specified tokens appearing in the completion. Accepts a list
#' that maps tokens (specified by their token ID in the GPT tokenizer) to an
#' associated bias value from \code{-100} to \code{100}. You can use this
#' tokenizer tool (which works for both GPT-2 and GPT-3) to convert text to
#' token IDs. Mathematically, the bias is added to the logits generated by the
#' model prior to sampling. The exact effect will vary per model, but values
#' between \code{-1} and \code{1} should decrease or increase likelihood of
#' selection; values like \code{-100} or \code{100} should result in a ban or
#' exclusive selection of the relevant token. As an example, you can pass
#' \code{list("50256" = -100)} to prevent the \code{<|endoftext|>} token from
#' being generated.
#' @param return_metadata required; defaults to \code{FALSE}; a length one
#' logical vector. A special boolean flag for showing metadata. If set to
#' \code{TRUE}, each document entry in the returned JSON will contain a
#' "metadata" field. This flag only takes effect when \code{file} is set.
#' @param return_prompt required; defaults to \code{FALSE}; a length one logical
#' vector. If set to \code{TRUE}, the returned JSON will include a "prompt"
#' field containing the final prompt that was used to request a completion. This
#' is mainly useful for debugging purposes.
#' @param expand optional; defaults to \code{NULL}; a list. If an object name is
#' in the list, we provide the full information of the object; otherwise, we
#' only provide the object ID. Currently we support \code{completion} and
#' \code{file} objects for expansion.
#' @param user optional; defaults to \code{NULL}; a length one character vector.
#' A unique identifier representing your end-user, which will help OpenAI to
#' monitor and detect abuse.
#' @param openai_api_key required; defaults to
#' \code{Sys.getenv("OPENAI_API_KEY")} (i.e., the value is retrieved from the
#' \code{.Renviron} file); a length one character vector. Specifies OpenAI API
#' key.
#' @param openai_organization optional; defaults to \code{NULL}; a length one
#' character vector. Specifies OpenAI organization.
#' @return Returns a list, elements of which contain an answer and other
#' supplementary information.
#' @examples \dontrun{
#' create_answer(
#'     search_model = "ada",
#'     model = "curie",
#'     question = "How many red apples do I have?",
#'     documents = c("I have five green apples.", "I love oranges."),
#'     examples_context = "Jack has three brothers and one sister. His sister is sad",
#'     examples = list(
#'         c("How many siblings has Jack?", "Three"),
#'         c("Who is sad?", "Jack's sister is.")
#'     ),
#'     max_tokens = 5,
#'     stop = c("\n", "<|endoftext|>"),
#' )
#' }
#' @export
create_answer <- function(
        model = c("ada", "babbage", "curie", "davinci"),
        question,
        examples,
        examples_context,
        documents = NULL,
        file = NULL,
        search_model = c("ada", "babbage", "curie", "davinci"),
        max_rerank = 200,
        temperature = 0,
        logprobs = NULL,
        max_tokens = 16,
        stop = NULL,
        n = 1,
        logit_bias = NULL,
        return_metadata = FALSE,
        return_prompt = FALSE,
        expand = NULL,
        user = NULL,
        openai_api_key = Sys.getenv("OPENAI_API_KEY"),
        openai_organization = NULL
) {

    model <- match.arg(model)
    search_model <- match.arg(search_model)

    #---------------------------------------------------------------------------
    # Validate arguments

    assertthat::assert_that(
        assertthat::is.string(model),
        assertthat::noNA(model)
    )

    assertthat::assert_that(
        assertthat::is.string(question),
        assertthat::noNA(question)
    )

    assertthat::assert_that(
        is.list(examples)
    )

    assertthat::assert_that(
        assertthat::is.string(examples_context),
        assertthat::noNA(examples_context)
    )

    if (!is.null(documents)) {
        assertthat::assert_that(
            is.character(documents),
            assertthat::noNA(documents)
        )
    }

    if (!is.null(file)) {
        assertthat::assert_that(
            assertthat::is.string(file),
            assertthat::noNA(file)
        )
    }

    if ((is.null(documents) && is.null(file)) ||
        (!is.null(documents) && !is.null(file))) {
        stop("You should specify either documents or a file, but not both.")
    }

    assertthat::assert_that(
        assertthat::is.string(search_model),
        assertthat::noNA(search_model)
    )

    assertthat::assert_that(
        assertthat::is.count(max_rerank)
    )

    assertthat::assert_that(
        assertthat::is.number(temperature),
        assertthat::noNA(temperature),
        value_between(temperature, 0, 2)
    )

    if (!is.null(logprobs)) {
        assertthat::assert_that(
            assertthat::is.count(logprobs + 1),
            value_between(logprobs, 0, 5)

        )
    }

    assertthat::assert_that(
        assertthat::is.count(max_tokens)
    )

    if (!is.null(stop)) {
        assertthat::assert_that(
            is.character(stop),
            assertthat::noNA(stop),
            length_between(stop, 1, 4)
        )
    }

    assertthat::assert_that(
        assertthat::is.count(n)
    )

    if (!is.null(logit_bias)) {
        assertthat::assert_that(
            is.list(logit_bias)
        )
    }

    assertthat::assert_that(
        assertthat::is.flag(return_metadata),
        assertthat::noNA(return_metadata)
    )

    assertthat::assert_that(
        assertthat::is.flag(return_prompt),
        assertthat::noNA(return_prompt)
    )

    # XXX: validate expand

    if (!is.null(user)) {
        assertthat::assert_that(
            assertthat::is.string(user),
            assertthat::noNA(user)
        )
    }

    assertthat::assert_that(
        assertthat::is.string(openai_api_key),
        assertthat::noNA(openai_api_key)
    )

    if (!is.null(openai_organization)) {
        assertthat::assert_that(
            assertthat::is.string(openai_organization),
            assertthat::noNA(openai_organization)
        )
    }

    #---------------------------------------------------------------------------
    # Build path parameters

    task <- "answers"

    base_url <- glue::glue("https://api.openai.com/v1/{task}")

    headers <- c(
        "Authorization" = paste("Bearer", openai_api_key),
        "Content-Type" = "application/json"

    )

    if (!is.null(openai_organization)) {
        headers["OpenAI-Organization"] <- openai_organization
    }

    #---------------------------------------------------------------------------
    # Build request body

    body <- list()
    body[["model"]] <- model
    body[["question"]] <- question
    body[["examples"]] <- examples
    body[["examples_context"]] <- examples_context
    body[["documents"]] <- documents
    body[["file"]] <- file
    body[["search_model"]] <- search_model
    body[["max_rerank"]] <- max_rerank
    body[["temperature"]] <- temperature
    body[["logprobs"]] <- logprobs
    body[["max_tokens"]] <- max_tokens
    body[["stop"]] <- stop
    body[["n"]] <- n
    body[["logit_bias"]] <- logit_bias
    body[["return_metadata"]] <- return_metadata
    body[["return_prompt"]] <- return_prompt
    body[["expand"]] <- expand
    body[["user"]] <- user

    #---------------------------------------------------------------------------
    # Make a request and parse it

    response <- httr::POST(
        url = base_url,
        httr::add_headers(.headers = headers),
        body = body,
        encode = "json"
    )

    verify_mime_type(response)

    parsed <- response %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE)

    #---------------------------------------------------------------------------
    # Check whether request failed and return parsed

    if (httr::http_error(response)) {
        paste0(
            "OpenAI API request failed [",
            httr::status_code(response),
            "]:\n\n",
            parsed$error$message
        ) %>%
            stop(call. = FALSE)
    }

    parsed

}

