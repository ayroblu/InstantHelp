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

release: dist/${AppName}.app
.PHONY: release

install: dist/${AppName}.app
> [ -e "/Applications/${AppName}.app" ] && rmtrash /Applications/${AppName}.app
> cp -a dist/${AppName}.app /Applications/${AppName}.app
.PHONY: install

## ------------------------- helper

dist:
> mkdir -p dist

artifacts:
> mkdir -p artifacts

artifacts/${AppName}.xcarchive: artifacts
> xcodebuild archive -archivePath $@ -scheme ${AppName} -target ${AppName} -configuration Release

dist/${AppName}.app: dist artifacts/${AppName}.xcarchive ExportOptions.plist
> xcodebuild -exportArchive -archivePath './artifacts/${AppName}.xcarchive' -exportOptionsPlist ExportOptions.plist -exportPath dist/
> touch $@


