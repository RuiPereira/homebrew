require 'formula'

class Libquicktime < Formula
  homepage 'http://libquicktime.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/libquicktime/libquicktime/1.2.4/libquicktime-1.2.4.tar.gz'
  sha1 '7008b2dc27b9b40965bd2df42d39ff4cb8b6305e'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'jpeg' => :optional
  depends_on 'lame' => :optional
  depends_on 'schroedinger' => :optional
  depends_on 'ffmpeg' => :optional
  depends_on 'libvorbis' => :optional

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gpl",
                          "--without-doxygen",
                          "--without-gtk"
    system "make"
    system "make install"
  end
end
