# Example from
# https://tech.davis-hansson.com/p/make/
# Also consider reference at: http://www.gnu.org/software/make/manual/

## Initial setup
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >

## ------------------------- Main part of the build file
AppName := InstantHelp

# Default - top level rule is what gets ran when you run just `make`
build:
> xcodebuild -scheme ${AppName} -target ${AppName} -configuration Debug
.PHONY: build

release: dist dist/${AppName}.xcarchive dist/${AppName}.app
.PHONY: release

dist:
> mkdir -p dist

dist/${AppName}.xcarchive:
> xcodebuild archive -archivePath 'dist/${AppName}.xcarchive' -scheme ${AppName} -target ${AppName} -configuration Release
.PHONY: archive

dist/${AppName}.app:
> xcodebuild -exportArchive -archivePath './dist/${AppName}.xcarchive' -exportOptionsPlist ExportOptions.plist -exportPath dist/
.PHONY: exportArchive
