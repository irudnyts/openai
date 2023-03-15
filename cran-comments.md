## Test environments

* local MacOS 12.5.1, R 3.5.1 and R 4.2.0
* R-hub Windows Server 2022, R-devel, 64 bit
* R-hub Fedora Linux, R-devel, clang, gfortran
* R-hub Ubuntu Linux 20.04.1 LTS, R-release, GCC
* win-builder (R-release, R-devel)

## R CMD check results

0 errors | 0 warnings | 1 note

* Windows (Server 2022, R-devel 64-bit):

```
* checking for detritus in the temp directory ... NOTE
Found the following files/directories:
  'lastMiKTeXException'
```

It seems like a leftover auto-generated file since none of the examples in the documentation launches the browser.

## Downstream dependencies

There are currently no downstream dependencies for this package.

## Resubmission

This is a resubmission. In this version I have:

* Relaxed validation of `model` argument in functions `create_chat_completion()`, `create_fine_tune()`, `create_moderation()`, `create_embedding()`, `create_transcription()`, and `create_translation()`. Otherwise, each time OpenAI will roll out a new model, the list of models has to be updated
