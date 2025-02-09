#!/usr/bin/env bash

#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Usage: $0 [version]
# Generate dockerfiles for specified spark version.
#
# Examples:
# - Add 3.3.0 dockerfiles:
#   $ ./add-dockerfiles.sh
# - Add 3.3.1 dockerfiles:
#   $ ./add-dockerfiles.sh 3.3.1

VERSION=${1:-"3.3.0"}

TAGS="
scala2.12-java11-python3-r-ubuntu
scala2.12-java11-python3-ubuntu
scala2.12-java11-r-ubuntu
scala2.12-java11-ubuntu
"

for TAG in $TAGS; do
    OPTS=""
    if echo $TAG | grep -q "python"; then
        OPTS+=" --pyspark"
    fi

    if echo $TAG | grep -q "r-"; then
        OPTS+=" --sparkr"
    fi

    OPTS+=" --spark-version $VERSION"

    mkdir -p $VERSION/$TAG

    if [ "$TAG" == "scala2.12-java11-ubuntu" ]; then
        python3 tools/template.py $OPTS > $VERSION/$TAG/Dockerfile
        python3 tools/template.py $OPTS -f entrypoint.sh.template > $VERSION/$TAG/entrypoint.sh
        chmod a+x $VERSION/$TAG/entrypoint.sh
    else
        python3 tools/template.py $OPTS -f r-python.template > $VERSION/$TAG/Dockerfile
    fi
done
