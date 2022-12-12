## Test environments

* local MacOS 12.5.1, R 4.2.0
* R-hub Windows Server 2022, R-devel, 64 bit
* R-hub Fedora Linux, R-devel, clang, gfortran
* R-hub Ubuntu Linux 20.04.1 LTS, R-release, GCC
* win-builder (R-release, R-devel)

## R CMD check results

0 errors | 0 warnings | 1 note

Possibly misspelled words in DESCRIPTION: Moderations (11:5)

### Comments:    
    
* "Moderations" is the "official" name of the endpoint.

## Downstream dependencies

There are currently no downstream dependencies for this package.

## Resubmission

This is a resubmission. In this version I have:

* Remove outdated endpoints `create_answer()`, `create_classification()`, and `create_search()`
* Deprecate `retrieve_engine()` and `list_engines()`
* Deprecate `engine_id` argument in `create_completion()`, `create_edit()`, and `create_embedding()`
