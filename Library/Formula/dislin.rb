require 'formula'

class Dislin < Formula
  homepage 'http://www.dislin.de/'
  if build.build_32_bit?
    url 'ftp://ftp.gwdg.de/pub/grafik/dislin/darwin/dislin-10.3.darwin.intel.32.tar.gz'
    sha1 '76e50e0b182f7e86fefd80a41ceeb751d5c7d281'
    version '10.3-32bit'
  else
    url 'ftp://ftp.gwdg.de/pub/grafik/dislin/darwin/dislin-10.3.darwin.intel.64.tar.gz'
    sha1 '90cd80a32e29747a649ddb7e4e870546422802ce'
    version '10.3-64bit'
  end

  option '32-bit'
  depends_on 'lesstif'

  keg_only <<-EOS
  You should add the following to your .bashrc or equivalent:
    export DISLIN=`brew --prefix dislin #{ARGV.build_32_bit? ? '--32-bit' : ''}`
  EOS

  def install
    ENV['DISLIN'] = prefix
    system 'sh INSTALL' # &> /dev/null'
  end

  def test
    mktemp do
      arch = `lipo -info #{prefix}/libdislin.dylib`.chomp[/i386$/] ? '-m32' : ''
      system "gcc #{arch} #{prefix}/examples/exa_c.c -I#{prefix} -L#{prefix} -ldislin -lXm -o exa; ./exa"
    end
  end
end
