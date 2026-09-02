#   Copyright (C) 2022 John Törnblom
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; see the file COPYING. If not see
# <http://www.gnu.org/licenses/>.

DISC_LABEL := BD-JB5-2.5

#
# Host tools
#
MAKEFILE_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
BDJSDK_HOME  ?= /home/dev/Documents/bdj-sdk
BDSIGNER     := $(BDJSDK_HOME)/host/bin/bdsigner
MAKEFS       := $(BDJSDK_HOME)/host/bin/makefs
JAVA8_HOME   ?= /usr/lib/jvm/java-1.8.0-openjdk-amd64
JAVA11_HOME  ?= /usr/lib/jvm/java-11-openjdk-amd64
JAVAC        := $(JAVA8_HOME)/bin/javac
JAR          := $(JAVA8_HOME)/bin/jar

export JAVA8_HOME
export JAVA11_HOME

#
# Compilation artifacts
#
CLASSPATH := $(BDJSDK_HOME)/target/lib/enhanced-stubs.zip:$(BDJSDK_HOME)/target/lib/rt.jar

SOURCES := $(wildcard src/jdk/internal/misc/*.java) \
           $(wildcard src/org/bdj/*.java) \
           $(wildcard src/org/bdj/api/*.java) \
           $(wildcard src/org/bdj/sandbox/*.java)

JFLAGS := -Xlint:-options -source 1.4 -target 1.4

#
# Disc files
#
TMPL_DIRS  := $(shell find $(BDJSDK_HOME)/resources/AVCHD/ -type d)
TMPL_FILES := $(shell find $(BDJSDK_HOME)/resources/AVCHD/ -type f)

#
# Required BDMV directory structure
#
BDMV_DIRS := \
	discdir/BDMV \
	discdir/BDMV/AUXDATA \
	discdir/BDMV/BACKUP \
	discdir/BDMV/BDJO \
	discdir/BDMV/CLIPINF \
	discdir/BDMV/JAR \
	discdir/BDMV/PLAYLIST \
	discdir/BDMV/STREAM
#
# Directories/files copied from the AVCHD template
#
DISC_DIRS := $(patsubst $(BDJSDK_HOME)/resources/AVCHD%,discdir%,$(TMPL_DIRS)) \
             $(BDMV_DIRS)

DISC_FILES := $(patsubst $(BDJSDK_HOME)/resources/AVCHD%,discdir%,$(TMPL_FILES)) \
              discdir/BDMV/JAR/00000.jar

#
# Default target
#
all: $(DISC_LABEL).iso

#
# Create complete disc directory structure
#
discdir:
	mkdir -p $(DISC_DIRS)

#
# Create BDMV directories explicitly
#
$(BDMV_DIRS):
	mkdir -p $@

#
# Build and sign the BD-J application
#
discdir/BDMV/JAR/00000.jar: $(BDMV_DIRS) $(SOURCES)
	$(JAVAC) $(JFLAGS) -cp $(CLASSPATH) $(SOURCES)
	$(JAR) cf $@ -C src/ .
	$(BDSIGNER) -keystore $(BDJSDK_HOME)/resources/sig.ks $@

#
# Copy files from the AVCHD template
#
discdir/%: discdir
	cp $(BDJSDK_HOME)/resources/AVCHD/$* $@

#
# Build ISO image
#
$(DISC_LABEL).iso: $(DISC_FILES)
	cp -r BDMV/META discdir/BDMV/
	cp -r BDMV/BDJO discdir/BDMV/

	$(JAR) cfM discdir/BDMV/JAR/00001.jar -C 00001 .

	$(MAKEFS) -m 16m -t udf \
		-o T=bdre,v=2.50,L=$(DISC_LABEL) \
		$@ discdir

#
# Clean build artifacts
#
clean:
	rm -rf META-INF \
	       $(DISC_LABEL).iso \
	       discdir \
	       src/jdk/internal/misc/*.class \
	       src/org/bdj/*.class \
	       src/org/bdj/sandbox/*.class \
	       src/org/bdj/api/*.class
