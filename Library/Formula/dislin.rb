require 'formula'

class Dislin < Formula
  homepage 'http://www.dislin.de/'
  if ARGV.build_32_bit?
    url 'ftp://ftp.gwdg.de/pub/grafik/dislin/darwin/dislin-10.2.darwin.intel.32.tar.gz'
    md5 '49fd100185959216d7c4f363da5f635a'
    version '10.2-32bit'
  else
    url 'ftp://ftp.gwdg.de/pub/grafik/dislin/darwin/dislin-10.2.darwin.intel.64.tar.gz'
    md5 '117dc4f9fef63f054bf6976c97048dd3'
    version '10.2-64bit'
  end

  depends_on 'lesstif'

  keg_only <<-EOS
  You should add the following to your .bashrc or equivalent:
    export DISLIN=`brew --prefix dislin #{ARGV.build_32_bit? ? '--32-bit' : ''}`
  EOS

  def options
    [["--32-bit", "Install 32-bit version."]]
  end

  def install
    ENV['DISLIN'] = prefix
    system 'sh INSTALL &> /dev/null'
  end

  def test
    mktemp do
      arch = `lipo -info #{prefix}/libdislin.dylib`.chomp[/i386$/] ? '-m32' : ''
      system "gcc #{arch} #{prefix}/examples/exa_c.c -I#{prefix} -L#{prefix} -ldislin -lXm -o exa; ./exa"
    end
  end
end
