require 'formula'

class Opal < Formula
  homepage 'http://www.opalvoip.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/opal/3.10/opal-3.10.9.tar.xz'
  version '3.10.9'
  sha1 'ccc918a866a85bd926a24c2968f994f24fc17f13'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'ffmpeg'
  depends_on 'ptlib'

  def patches
    # Fixes compiling with recent releases of ffmpeg.
    "http://git.pld-linux.org/gitweb.cgi?p=packages/opal.git;a=blob_plain;f=opal-ffmpeg10.patch"
  end

  def install
    # remove malloc.h include
    inreplace 'plugins/video/H.263-1998/rfc2190.cxx', '#include <malloc.h>', '//#include <malloc.h>'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test opal`.
    system "false"
  end
end
