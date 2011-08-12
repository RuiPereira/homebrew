require 'formula'

class Minuit < Formula
  url 'http://seal.web.cern.ch/seal/minuit/releases/Minuit-1_7_9.tar.gz'
  homepage 'http://seal.web.cern.ch/seal/work-packages/mathlibs/minuit/'
  md5 '10fd518fc778317fdadbc4ef6f7ce8e4'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    This formula installs Minuit 1.7.9 (old API). Minuit2 is released with ROOT.
    EOS
  end

end
