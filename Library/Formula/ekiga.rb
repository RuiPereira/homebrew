require 'formula'

class Ekiga < Formula
  homepage ''
  url 'http://ftp.gnome.org/pub/gnome/sources/ekiga/4.0/ekiga-4.0.0.tar.xz'
  version '4.0.0'
  sha1 'e4320dce57aad470d5fe1aa104d3c1a2c02d6aaa'

  depends_on :automake
  depends_on :libtool

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'intltool'
  depends_on 'boost'
  depends_on 'gtk+'
  depends_on 'gconf'
  depends_on 'gnome-doc-utils'
  depends_on 'gnome-icon-theme'
  depends_on 'ptlib'
  depends_on 'opal'

  def install
    inreplace 'configure.ac', '-module', ''
    system "autoreconf", "-fvi"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gdu", "--disable-eds", "--disable-avahi"
    system "make"
    system "make install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test ekiga`.
    system "false"
  end
end
