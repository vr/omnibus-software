name "nghttp2"
default_version "1.41.0"

# NOTE: Historically nghttp2 had openssl dependency here. It turns out it's
# not actually needed. It is only required to build the "app" (which we
# disable in the configure call) and "HTTP/3 enabled h2load and nghttps":
# https://github.com/nghttp2/nghttp2#build-http3-enabled-h2load-and-nghttpx
# Which we don't use.

source url: "https://github.com/nghttp2/nghttp2/releases/download/v#{version}/nghttp2-#{version}.tar.gz"

version("1.41.0") { source sha256: "eacc6f0f8543583ecd659faf0a3f906ed03826f1d4157b536b4b385fe47c5bb8" }

relative_path "nghttp2-#{version}"

build do
  license "MIT"
  license_file "./COPYING"

  command [
    "./configure",
    "--disable-static",
    "--enable-shared",
    "--disable-app",
    "--disable-examples",
    "--disable-hpack-tools",
    "--prefix=#{install_dir}/embedded",
  ].join(" ")
  command "make -j #{workers}", env: { "LD_RUN_PATH" => "#{install_dir}/embedded/lib" }
  command "make install"
end
