require 'formula'

class CfitsioExamples < Formula
  url 'http://heasarc.gsfc.nasa.gov/docs/software/fitsio/cexamples/cexamples.zip'
  homepage 'http://heasarc.gsfc.nasa.gov/docs/software/fitsio/cexamples.html'
  md5 '31a5f5622a111f25bee5a3fda2fdac28'
  version '1.0'

  depends_on 'cfitsio'

  def install
    # compile - compressed_fits.c does not work
    Dir.glob('*.c').each do |f|
      begin
        system "gcc #{f} -lcfitsio -o #{f.sub('.c','')}"
       rescue
        opoo "Compilation of #{f} failed..."
       end
    end
    # install the binaries
    bin.install Dir['*[a-z][a-z]']
  end
end
