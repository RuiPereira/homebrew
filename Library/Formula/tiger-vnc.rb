require 'formula'

class TigerVnc < Formula
  homepage 'http://tigervnc.org/'
  url 'http://downloads.sourceforge.net/project/tigervnc/tigervnc/1.2.0/tigervnc-1.2.0.tar.gz'
  md5 '3a5755b4ed600a81c3a17976c6f8420d'

  depends_on 'cmake' => :build
  depends_on 'jpeg-turbo'
  depends_on 'gnutls' => :recommended

  def install
    ENV.x11
    # also install unix subdir
    inreplace 'CMakeLists.txt', 'add_subdirectory(vncviewer)', "add_subdirectory(vncviewer)\nadd_subdirectory(unix)"
    jpegdir = `brew --prefix jpeg-turbo`.chomp
    jpeglib = Dir["#{jpegdir}/lib/libjpeg.a"][0]
    system "cmake -G \"Unix Makefiles\" #{std_cmake_parameters} -DENABLE_NLS:BOOL=OFF -DJPEG_INCLUDE_DIR=#{jpegdir}/include -DJPEG_LIBRARY=#{jpeglib}"
    system "make install"
    # move man pages to proper path
    man.mkpath
    mv Dir["#{prefix}/man/*"], man
  end
end
