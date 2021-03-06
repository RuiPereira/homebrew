require 'formula'

class G95 < Formula
  url 'http://ftp.g95.org/g95-x86-osx.tgz'
  md5 'e64c84b1e9d9b03f2762b951bb12e8da'
  version '18-08-2010'
end

class SnanaData < Formula
  # the data changes frequently, so using head to prevent frequent 'version' updates
  head 'http://sdssdp62.fnal.gov/sdsssn/SNANA-PUBLIC/downloads/SNDATA_ROOT.tar.gz'
end

class Snana < Formula
  homepage 'http://sdssdp62.fnal.gov/sdsssn/SNANA-PUBLIC/'
  url 'http://sdssdp62.fnal.gov/sdsssn/SNANA-PUBLIC/downloads/SNANA.tar.gz'
  md5 '5f9d8a6706738188ee8f322dc3789885'
  version '9.89b'

  depends_on 'cfitsio'
  depends_on 'gsl'
  depends_on 'cernlib'

  def options
    [
     ['--with-data', 'Download and install the full SNANA data files (~1GB)']
    ]
  end

  # cernlib is 32bit
  def patches () DATA end

  def install
    ENV.deparallelize
    ENV.fortran
    ENV.llvm
    ENV['GSL_DIR'] = HOMEBREW_PREFIX
    ENV['CFITSIO_DIR'] = HOMEBREW_PREFIX

    # install g95 temporarily for sncosmo
    g95 = Pathname.new File.expand_path 'g95'
    g95.mkdir
    G95.new.brew do
      g95.install Dir['*']
      (g95 + 'bin').install_symlink 'i686-apple-darwin10.3.0-g95' => 'g95'
    end
    ENV.prepend 'PATH', g95 + 'bin', ':'

    # compile
    chdir 'src' do
      system "make"
    end
    bin.install Dir['bin/*']
    lib.install Dir['lib/*']
    doc.install Dir['doc/*']
    prefix.install ['util', 'kumacs']

    # install data
    if ARGV.include? '--with-data'
      data = Pathname.new File.expand_path prefix + 'data'
      data.mkdir
      ohai 'This will take a while...'
      SnanaData.new.brew do
        data.install Dir['*']
      end
    end
  end

  def caveats
    if ARGV.include? '--with-data'
      data_info = <<-EOS
       export SNDATA_ROOT=#{prefix}/data
      EOS
    else
      data_info = <<-EOS

    You also need to download the full SNANA data files (~1GB), eg.:
       mkdir #{prefix}/data
       cd #{prefix}/data
       curl http://sdssdp62.fnal.gov/sdsssn/SNANA-PUBLIC/downloads/SNDATA_ROOT.tar.gz -o SNDATA_ROOT.tar.gz
       tar xf SNDATA_ROOT.tar.gz
    and add to the .bashrc or equivalent:
       export SNDATA_ROOT=#{prefix}/data
    EOS
    end

    <<-EOS.undent
    In case you're having problems with libgsl, it needs to be installed as an universal binary:
       brew install --universal gsl

    You should add the following to your .bashrc or equivalent:
       export SNDATA_DIR=#{prefix}
#{data_info}
    To setup the necessary PAW macros do:
       .#{prefix}/util/paw_setup.cmd
    EOS
  end

  def test
    mktemp do
      survey = 'HST'
      cp "#{prefix}/data/analysis/sample_input_files/mlcs2k2/snfit_#{survey}.nml", '.'
      # deprecated option
      inreplace "snfit_#{survey}.nml", 'OPT_SIMEFF     = 1', ''
      system "snlc_fit.exe snfit_#{survey}.nml"
    end
  end
end

__END__
diff --git a/src/Makefile b/src/Makefile
index cf9b3de..1792265 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -191,9 +191,9 @@ endif
 
 ifeq ($(OSNAME),Darwin)
    SNFFLAGS   = -c -fno-automatic -fsecond-underscore -static -m32
-   SNCFLAGS   = -c -mdynamic-no-pic -m32
+   SNCFLAGS   = -c -m32
 #   SNLDFLAGS  = -lg2c
-   SNLDFLAGS  = 
+   SNLDFLAGS  = -m32
    G95FLAGS   =
    SNCXXFLAGS = -m32
 endif
@@ -320,7 +320,7 @@ endif
 
 LIBSNANA  =   $(LIB)/libsnana.a
 LIBSNFIT  =   $(LIB)/libsnfit.a
-LCERN	  =  -L${CERN_DIR}/lib -lpacklib -lmathlib -lkernlib -lncurses
+LCERN	  =   $(shell cernlib)
 
 ICFITS    =  -I/$(CFITSIO_DIR)/include
 
@@ -334,8 +334,12 @@ CLEAN_FILES =  $(EXECUTABLES) $(OBJECTS)  $(LIBSNANA)  $(LIBSNFIT)
 ##	@ $(error error: Please invoke this makefile using sdssmake)
 
 
-all:	$(LIBSNANA)  $(LIBSNFIT) $(OBJECTS)  $(EXECUTABLES)
+all:	$(LIBSNANA)  $(LIBSNFIT) $(OBJECTS) myranlib $(EXECUTABLES)
 
+# force ranlib run
+myranlib :
+	ranlib $(LIBSNANA)
+	ranlib $(LIBSNFIT)
 
 # J.Hendry: 
 install :
