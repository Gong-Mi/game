#!/usr/bin/env sh

#
# Copyright 2015 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Determine the Java command to run.
if [ -n "$JAVA_HOME" ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
        # Solaris
        JAVA_CMD="$JAVA_HOME/jre/sh/java"
    else
        JAVA_CMD="$JAVA_HOME/bin/java"
    fi
    if [ ! -x "$JAVA_CMD" ] ; then
        unset JAVA_CMD
    fi
fi

if [ -z "$JAVA_CMD" ] ; then
    JAVA_CMD="java"
fi

# Determine the script path.
SCRIPT_PATH="$0"

# Check if the script is a symbolic link.
if [ -L "$SCRIPT_PATH" ] ; then
    # Resolve the symbolic link path.
    SCRIPT_PATH=$(readlink -f "$SCRIPT_PATH")
fi

# Determine the script directory.
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

# Determine the distribution properties file.
DISTRIBUTION_PROPERTIES="$SCRIPT_DIR/gradle/wrapper/gradle-wrapper.properties"

# Check if the distribution properties file exists.
if [ ! -f "$DISTRIBUTION_PROPERTIES" ] ; then
    echo "Error: Could not find or access '$DISTRIBUTION_PROPERTIES'."
    exit 1
fi

# Determine the distribution URL.
DISTRIBUTION_URL=$(grep "distributionUrl" "$DISTRIBUTION_PROPERTIES" | sed 's/distributionUrl=//')

# Check if the distribution URL is set.
if [ -z "$DISTRIBUTION_URL" ] ; then
    echo "Error: Could not find 'distributionUrl' in '$DISTRIBUTION_PROPERTIES'."
    exit 1
fi

# Determine the distribution name.
DISTRIBUTION_NAME=$(echo "$DISTRIBUTION_URL" | sed 's/.*\///')

# Determine the distribution path.
DISTRIBUTION_PATH="$SCRIPT_DIR/gradle/wrapper/dists/$DISTRIBUTION_NAME"

# Determine the distribution file.
DISTRIBUTION_FILE="$DISTRIBUTION_PATH/$DISTRIBUTION_NAME"

# Check if the distribution file exists.
if [ ! -f "$DISTRIBUTION_FILE" ] ; then
    echo "Downloading Gradle distribution from '$DISTRIBUTION_URL'..."
    mkdir -p "$DISTRIBUTION_PATH"
    if command -v curl >/dev/null 2>&1; then
        curl --location "$DISTRIBUTION_URL" --output "$DISTRIBUTION_FILE"
    elif command -v wget >/dev/null 2>&1; then
        wget --output-document="$DISTRIBUTION_FILE" "$DISTRIBUTION_URL"
    else
        echo "Error: Could not find 'curl' or 'wget' to download the Gradle distribution."
        exit 1
    fi
    if [ ! -f "$DISTRIBUTION_FILE" ] ; then
        echo "Error: Download failed. Could not find '$DISTRIBUTION_FILE'."
        exit 1
    fi
fi

# Determine the Gradle command.
GRADLE_CMD="$JAVA_CMD -classpath '$DISTRIBUTION_FILE' org.gradle.wrapper.GradleWrapperMain"

# Execute the Gradle command.
exec $GRADLE_CMD "$@"
