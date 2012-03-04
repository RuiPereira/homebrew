require 'formula'

class SimpleCosfitter < Formula
  homepage 'http://qold.astro.utoronto.ca/conley/simple_cosfitter'
  url 'http://qold.astro.utoronto.ca/conley/simple_cosfitter/simple_cosfitter-1.6.11.tar.gz'
  md5 '5c079c7a37b60cffb00796e5b317eeb9'

  depends_on 'cfitsio'
  depends_on 'gsl'
  depends_on 'doxygen' if ARGV.include? '--with-docs'

  def options
    [['--with-docs', 'Build documentation']]
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-cfitswrite", "--with-cfitsiolib=#{HOMEBREW_PREFIX}"
    system "make all"
    system "make docs" if ARGV.include? '--with-docs'
    system "make install"
    prefix.install Dir['sample']
    doc.install Dir['doc/*'] if ARGV.include? '--with-docs'
  end

  def test
    mktemp do
      cp Dir["#{prefix}/sample/Kowalski*"], '.'
      system "#{bin}/runfitter Kowalski_wom_param.txt"
      system "#{bin}/convert_to_fits Kowalski_wom_param.txt Kowalski_wom_output.fits"
    end
  end
end
