#' @export
search <- function(
        engine,
        query,
        documents = NULL,
        file = NULL,
        max_rerank = 200,
        return_metadata = FALSE,
        user = NULL,
        openai_api_key = Sys.getenv("OPENAI_API_KEY"),
        openai_organization = NULL
) {

    #---------------------------------------------------------------------------
    # Validate arguments

    assertthat::assert_that(
        assertthat::is.string(engine),
        assertthat::noNA(engine)
    )

    assertthat::assert_that(
        assertthat::is.string(query),
        assertthat::noNA(query)
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
        assertthat::is.count(max_rerank)
    )

    assertthat::assert_that(
        assertthat::is.flag(return_metadata),
        assertthat::noNA(return_metadata)
    )

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

    task <- "search"

    base_url <- glue::glue("https://api.openai.com/v1/engines/{engine}/{task}")

    headers <- c(
        Authorization = paste("Bearer", openai_api_key)
    )

    if (!is.null(openai_organization)) {
        headers["OpenAI-Organization"] <- openai_organization
    }

    #---------------------------------------------------------------------------
    # Build request body

    body <- list()
    body[["query"]] <- query
    body[["documents"]] <- documents
    body[["file"]] <- file
    body[["max_rerank"]] <- max_rerank
    body[["return_metadata"]] <- return_metadata
    body[["user"]] <- user

    #---------------------------------------------------------------------------
    # Make a request and verify its result

    result <- httr::POST(
        url = base_url,
        httr::content_type_json(),
        httr::add_headers(.headers = headers),
        body = body,
        encode = "json"
    )

    verify_mime_type(result)

    httr::stop_for_status(result)

    #---------------------------------------------------------------------------
    # Parse the result of the request

    result %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE)

}
