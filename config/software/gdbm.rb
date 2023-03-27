#
# Copyright:: Copyright (c) 2012-2014 Chef Software, Inc.
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

name "gdbm"
default_version "1.23"

dependency "libgcc"

source url: "http://ftp.gnu.org/gnu/gdbm/gdbm-#{version}.tar.gz",
       sha256: "74b1081d21fff13ae4bd7c16e5d6e504a4c26f7cde1dca0d963a484174bbcacd"

relative_path "gdbm-#{version}"

build do
  env = case ohai["platform"]
        when "solaris2"
          {
            "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -R#{install_dir}/embedded/lib",
            "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
            "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
            "LD_OPTIONS" => "-R#{install_dir}/embedded/lib",
          }
        else
          {
            "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
            "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
            "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
          }
        end

  configure_command = ["./configure",
                       "--enable-libgdbm-compat",
                       "--without-readline",
                       "--prefix=#{install_dir}/embedded"]

  if ohai["platform"] == "freebsd"
    configure_command << "--with-pic"
  end

  command configure_command.join(" "), env: env
  command "make -j #{workers}", env: env
  command "make install", env: env

  # drop some cli tools we do not use
  command "rm #{install_dir}/embedded/bin/gdbmtool"
  command "rm #{install_dir}/embedded/bin/gdbm_dump"
  command "rm #{install_dir}/embedded/bin/gdbm_load"
end
