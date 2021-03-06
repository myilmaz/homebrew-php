require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php56Redis < AbstractPhp56Extension
  init
  homepage "https://github.com/phpredis/phpredis"
  url "https://github.com/phpredis/phpredis/archive/2.2.7.tar.gz"
  sha256 "a5882dd9b21908e123b3d5c5f72d6dc8cbbbb6a29996e568c4d18ed356c0362b"
  head "https://github.com/phpredis/phpredis.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-php"
    sha256 "fb7a6c68fa796d296a70429042c49b0bb23be210cebcca53f4251aedc3fe1d39" => :yosemite
    sha256 "cdabbdfc81f769068f25e4843800a1c670f5a25db4ff424c4a407191767de018" => :mavericks
    sha256 "27ed40fb435528fc05bc6a4fcc499a19e88c6d37da4ed2e6b5051c906e293cf5" => :mountain_lion
  end

  option "with-igbinary", "Build with igbinary support"

  depends_on "php56-igbinary" if build.with? "igbinary"

  def install
    ENV.universal_binary if build.universal?

    args = []
    args << "--enable-redis-igbinary" if build.with? "igbinary"

    safe_phpize

    if build.with? "igbinary"
      mkdir "ext/igbinary"
      cp Formula["php56-igbinary"].opt_prefix+"/include/igbinary.h", "ext/igbinary/igbinary.h"
    end

    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          *args
    system "make"
    prefix.install "modules/redis.so"
    write_config_file if build.with? "config-file"
  end

  test do
    shell_output("php -m").include?("redis")
  end
end
