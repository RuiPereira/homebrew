require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Cdsclient < Formula
  homepage 'http://cdsarc.u-strasbg.fr/doc/cdsclient.html'
  url 'http://cdsarc.u-strasbg.fr/ftp/pub/sw/cdsclient-3.71.tar.gz'
  sha1 '67639a1bb14f4ad5e48444950f42bcfa123af0a0'
  version '3.71'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    mv (prefix+'man'), share
  end

  def test
    system "#{bin}/sesame -o2 Vega"
  end
end
