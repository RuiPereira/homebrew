require 'formula'

class Cfitsio < Formula
  url 'ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/cfitsio3280.tar.gz'
  homepage 'http://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html'
  md5 'fdb9c0f51678b47e78592c70fb5dc793'
  version '3.28'

  def options
    [
     ['--examples', "Compile and install example programs from http://heasarc.gsfc.nasa.gov/docs/software/fitsio/cexamples.html"]
    ]
  end

  def install
    # --disable-debug and --disable-dependency-tracking are not recognized by configure
    system "./configure", "--prefix=#{prefix}"
    system "make shared"
    system "make install"

    # fetch, compile and install examples programs
    # compressed_fits.c does not work under x86_64
    if ARGV.include? '--examples'
      mkdir 'examples'
      Dir.chdir 'examples' do
        ohai 'Downloading example programs'
        curl 'http://heasarc.gsfc.nasa.gov/docs/software/fitsio/cexamples/cexamples.zip', '-O'
        system 'unzip cexamples.zip'
        mkdir 'bin'
        Dir.glob('*.c').each do |f|
          begin
            system "#{ENV.compiler} #{f} -I #{include} -L #{lib} -lcfitsio -o bin/#{f.sub('.c','')}"
          rescue
            opoo "Compilation of #{f} failed..."
          end
        end
        bin.install Dir['bin/*']
      end
    end

  end
end
