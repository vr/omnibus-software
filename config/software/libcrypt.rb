#
# Copyright:: Copyright (c) 2022-present Datadog, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name "libcrypt"
default_version "4.4.28"

version "4.4.28" do
    source sha256: "9e936811f9fad11dbca33ca19bd97c55c52eb3ca15901f27ade046cc79e69e87"
end

source url: "https://github.com/besser82/libxcrypt/releases/download/v#{version}/libxcrypt-#{version}.tar.xz",
       extract: :seven_zip

build do
    license "LGPL-2.1"
    license_file "./COPYING.lib"

    env = with_standard_compiler_flags

    # This builds libcrypt.so.1
    # To build libcrypt.so.2, the --disable-obsolete-api option
    # needs to be passed to the ./configure script.
    command ["./configure",
        "--prefix=#{install_dir}/embedded",
        ].join(" "), env: env
    command "make -j #{workers}", env: env
    command "make -j #{workers} install"
end