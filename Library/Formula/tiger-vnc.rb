require 'formula'

class TigerVnc < Formula
  homepage 'http://tigervnc.org/'
  url 'http://downloads.sourceforge.net/project/tigervnc/tigervnc/1.2.0/tigervnc-1.2.0.tar.gz'
  sha1 '0542b2549a85b6723deebc3b5ecafa4f1fbee8e6'

  depends_on 'cmake' => :build
  depends_on 'jpeg-turbo'
  depends_on 'gnutls' => :recommended

  def install
    ENV.x11
    jpegdir = `brew --prefix jpeg-turbo`.chomp
    jpeglib = Dir["#{jpegdir}/lib/libjpeg.a"][0]
    system "cmake -G \"Unix Makefiles\" #{std_cmake_parameters} -DENABLE_NLS:BOOL=OFF -DJPEG_INCLUDE_DIR=#{jpegdir}/include -DJPEG_LIBRARY=#{jpeglib}"
    system "make install"
    # move man pages to proper path
    man1.install Dir["#{prefix}/man/man1/*"]
    rmtree "#{prefix}/man"
  end
end
