#!/bin/bash

# --- Revised 3-Clause BSD License ---
# Copyright Semtech Corporation 2022. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright notice,
#       this list of conditions and the following disclaimer in the documentation
#       and/or other materials provided with the distribution.
#     * Neither the name of the Semtech corporation nor the names of its
#       contributors may be used to endorse or promote products derived from this
#       software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL SEMTECH CORPORATION. BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

set -e
cd $(dirname $0)

lgwversion="v${lgwversion:-5.0.1}"

if [[ ! -d git-repo ]]; then
    git clone https://github.com/Lora-net/lora_gateway.git git-repo
fi

if [[ -z "${platform}" ]] || [[ -z "${variant}" ]]; then
    echo "Expecting env vars platform/variant to be set - comes naturally if called from a makefile"
    echo "If calling manually try: variant=std platform=linux $0"
    exit 1
fi

if [[ ! -d platform-${platform} ]]; then
    git clone -b ${lgwversion} git-repo platform-${platform}

    cd platform-${platform}
    if [ -f ../${lgwversion}-${platform}.patch ]; then
        echo "Applying ${lgwversion}-${platform}.patch ..."
        git apply ../${lgwversion}-${platform}.patch
    fi

    # share the same patch set for rpi and rpi64 platforms.
    if [ "${platform}" = "rpi64" ]; then
        echo "Treating rpi64 platform as rpi for patching/dependency purposes..."
        if [ -f ../${lgwversion}-rpi.patch ]; then
            echo "Applying ${lgwversion}-rpi.patch ..."
            git apply ../${lgwversion}-rpi.patch
        fi
    fi
fi
