require 'formula'

class CernlibDownloadStrategy < CurlDownloadStrategy
  def stage
    # unpack the HEP on OSX RPM binary distribution
    safe_system "rpm2cpio #{@tarball_path} 2>/dev/null | cpio -d -i - &> /dev/null"
  end
end

class CernlibTest < Formula
  url 'http://grid.tsl.uu.se/RTEs/CERNLIB/tests/cerntest.tar.gz'
  md5 '02f296a7665ceb733f7c5eace1b863b9'
  version '2006'
end

class CernlibGfortran < Formula
  url 'http://www-jlc.kek.jp/~fujiik/macosx/10.5.X/HEPonX/RPMS/i386/gcc-4.3.0-10.5hepx1e.i386.rpm'
  md5 '57cc4b66bd8a2b6486caeb82f1a02447'
  version '2006'
  def download_strategy () CernlibDownloadStrategy end
end

class CernlibBin < Formula
  homepage 'http://cernlib.web.cern.ch/cernlib/'
  url 'http://www-jlc.kek.jp/~fujiik/macosx/10.7.X/HEPonX/RPMS/i386/cernlib-2006-10.6hepx1d.i386.rpm'
  md5 '7f47f9a8eab426bc7d7f7c857bd9e86e'
  version '2006'

  depends_on 'rpm2cpio' => :build

  def download_strategy () CernlibDownloadStrategy end

  def install
    ENV.m32
    ENV.enable_warnings
    ENV.fortran

    # fetch the libgfortran.dylib used to link all the binaries
    # (homebrew's gfortran has no libgfortran.dylib)
    # the system should already has a proper libgcc_s.1.dylib
    # gfortran = prefix + 'gfortran'
    # gfortran.mkdir
    # CernlibGfortran.new.brew do
    #   # 32 bit gfortran lib
    #   gfortran.install 'usr/osxws/lib/libgfortran.3.dylib'
    # end
    # change the hardcoded libgfortran in the binaries
    # static = File.expand_path `#{ENV['FC']} #{ENV['FCFLAGS']} --print-file-name libgfortran.a`.chomp
    # shared = gfortran + 'libgfortran.dylib'
    # system "libtool -dynamic -o #{shared} #{static} -lm -compatibility_version 4 -current_version 4"

    # check for dylib existence first!!!
    shared = File.expand_path `#{ENV['FC']} #{ENV['FCFLAGS']} --print-file-name libgfortran.dylib`.chomp
    Dir['cern/2006/bin/*'].reject{|f| !`file #{f}`[/Mach-O executable/]}.each do |f|
      oldlib = `otool -L #{f} 2>1`.chomp[/^.*libgfortran.*/]
      if oldlib then safe_system "install_name_tool -change #{oldlib.split[0]} #{shared} #{f}" end
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
