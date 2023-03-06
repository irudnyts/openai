## Test environments

* local MacOS 12.5.1, R 3.5.1 and R 4.2.0
* R-hub Windows Server 2022, R-devel, 64 bit
* R-hub Fedora Linux, R-devel, clang, gfortran
* R-hub Ubuntu Linux 20.04.1 LTS, R-release, GCC
* win-builder (R-release, R-devel)

## R CMD check results

0 errors | 0 warnings | 3 notes

* Windows (Server 2022, R-devel 64-bit):

```
* checking for detritus in the temp directory ... NOTE
Found the following files/directories:
  'lastMiKTeXException'
```

It seems like a leftover auto-generated file since none of the examples in the documentation launches the browser.

* win-builder (R-release, R-devel)

```
Found the following (possibly) invalid file URI:
  URI: this%20issue
    From: NEWS.md
```

The link has been checked and is valid.

* Fedora Linux, R-devel, clang, gfortran

```
* checking HTML version of manual ... NOTE
Skipping checking HTML validation: no command 'tidy' found
```

It seems like a problem related only to Fedora OS.

## Downstream dependencies

There are currently no downstream dependencies for this package.

## Resubmission

This is a resubmission. In this version I have:

* Added endpoints `create_chat_completion()`, `create_transcription()`, and `create_translation()`
* Downgraded R dependence to 3.5 (see [https://github.com/irudnyts/openai/issues/27](this issue))
* Removed redundant options of `upload_file()`'s argument `purpose`, namely `"search"`, `"answers"`, and `"classifications"`
* Updated links in documentation
