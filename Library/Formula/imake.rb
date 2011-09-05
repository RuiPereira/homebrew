require 'formula'

class Imake < Formula
  url 'http://xorg.freedesktop.org/releases/individual/util/imake-1.0.4.tar.bz2'
  homepage 'http://xorg.freedesktop.org'
  md5 '48133c75bd77c127c7eff122e08ebbf6'

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
