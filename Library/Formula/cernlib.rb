require 'formula'

class CernlibDownloadStrategy < CurlDownloadStrategy
  def stage
    # unpack the HEP on OSX RPM binary distribution
    safe_system "rpm2cpio  #{@tarball_path} 2>/dev/null | cpio -d -i - 2>1 1>/dev/null"
  end
end

class CernlibTest < Formula
  url 'http://grid.tsl.uu.se/RTEs/CERNLIB/tests/cerntest.tar.gz'
  md5 '02f296a7665ceb733f7c5eace1b863b9'
  version '2006'
end

class Cernlib < Formula
  homepage 'http://cernlib.web.cern.ch/cernlib/'
  url 'http://www-jlc.kek.jp/~fujiik/macosx/10.7.X/HEPonX/RPMS/i386/cernlib-2006-10.6hepx1d.i386.rpm'
  md5 '7f47f9a8eab426bc7d7f7c857bd9e86e'
  version '2006'

  depends_on 'rpm2cpio' => :build

  def download_strategy () CernlibDownloadStrategy end

  def install
    ENV.fortran
    # change the hardcoded libgfortran in the binaries
    libfortran = File.expand_path `gfortran -m32 --print-file-name libgfortran.dylib`.chomp
    Dir['cern/2006/bin/*'].reject{|f| !`file #{f}`[/Mach-O executable/]}.each do |f|
      oldlib = `otool -L #{f} 2>1`.chomp[/^.*libgfortran.*/]
      if oldlib then safe_system "install_name_tool -change #{oldlib.split[0]} #{libfortran} #{f}" end
    end

    bin.install Dir['cern/2006/bin/*']
    bin.install_symlink 'nypatchy' => 'ypatchy'
    include.install Dir['cern/2006/include/*']
    lib.install Dir['cern/2006/lib/*']
    # cerntest
    CernlibTest.new.brew do
      (prefix + 'cerntest').install Dir['*']
    end
  end

  def caveats;  <<-EOS.undent
    You should add the following to your .bashrc or equivalent:
       export CERN=#{prefix + '..'}
       export CERN_LEVEL=2006
       export CERN_ROOT=#{prefix}
    EOS
  end

  def test
    mktemp do
      system "gfortran -m32 -o cerntest #{prefix + 'cerntest' + 'cerntest.f'} `cernlib mathlib`"
      system "./cerntest; paw -b #{prefix + 'cerntest' + 'cerntest.kumac'} -w 1"
      cp 'cerntest.ps', ENV['HOME']
      system "open #{ENV['HOME']}/cerntest.ps"
    end
  end
end
