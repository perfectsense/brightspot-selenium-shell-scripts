#!/bin/bash

set -euo pipefail

# QA directory already exists?
QA=qa

if [[ -e "$QA" ]]; then
    echo "$QA directory already exists!"
    exit 1
fi

# Project name supplied?
PROJECT=${1:-}

if [[ -z "$PROJECT" ]]; then
    echo "Usage: $0 PROJECT"
    exit 1
fi

PROJECT="${PROJECT}-qa"

# Maven archetype:generate tries to add the new project as a module,
# so create a temporary container to prevent it.
CONTAINER=brightspot-selenium-archetype-container

mkdir $CONTAINER
cd $CONTAINER
mvn archetype:generate -B \
    -DarchetypeRepository=http://artifactory.psdops.com/public/ \
    -DarchetypeGroupId=com.psddev \
    -DarchetypeArtifactId=selenium-archetype \
    -DarchetypeVersion=1.1-SNAPSHOT \
    -DartifactId=$PROJECT
cd ..
mv $CONTAINER/$PROJECT $QA
rmdir $CONTAINER
