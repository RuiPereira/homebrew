require 'formula'

class Ptlib < Formula
  homepage 'http://www.opalvoip.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/ptlib/2.10/ptlib-2.10.9.tar.xz'
  version '2.10.9'
  sha1 '3158fa78adc3b0d6c76693e328d1531a7dab9339'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build

  def install
    # pthread_yield -> sched_yield
    inreplace "src/ptlib/unix/tlibthrd.cxx", "pthread_yield()", "sched_yield()"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
