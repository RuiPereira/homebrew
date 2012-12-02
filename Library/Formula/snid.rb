require 'formula'

class SnidTemplates < Formula
  url 'http://marwww.in2p3.fr/~blondin/software/snid/templates-2.0.tgz'
  md5 '3534a6a990c4b35e611514dfe95cce83'
end

class SnidBSNIPTemplates < Formula
  url 'http://hercules.berkeley.edu/database/BSNIPI/bsnip_v7_snid_templates.tar.gz'
  md5 'ed9d5c7fbd067a95ff6bc5f276097864'
  version '7.0'
end

class Snid < Formula
  url 'http://marwww.in2p3.fr/~blondin/software/snid/snid-5.0.tar.gz'
  homepage 'http://marwww.in2p3.fr/~blondin/software/snid/'
  md5 'aefed2e2cbd5b26fd1f0171bbb7b6092'

  depends_on 'pgplot'

  # no libbutton compilation and patch for new templates
  def patches() DATA end

  def install
    ENV.fortran
    ENV.x11

    # new templates
    SnidTemplates.new.brew do
      prefix.install '../templates-2.0'
    end
    SnidBSNIPTemplates.new.brew do
      safe_system 'ls *.lnw > templist'
      cp "#{buildpath}/templates/texplist", '.'
      cp "#{buildpath}/templates/tfirstlist", '.'
      (prefix + 'templates_bsnip_v7.0').install Dir['*']
    end

    cp 'source/snid.inc', '.'
    # where to store spectral templates
    inreplace 'source/snidmore.f', 'INSTALL_DIR/snid-5.0/templates', "#{prefix}/templates-2.0"

    ENV.append 'FCFLAGS', '-O -fno-automatic'
    ENV['PGLIBS'] = "-Wl,-framework -Wl,Foundation -L#{HOMEBREW_PREFIX}/lib -lpgplot"
    system "make"
    bin.install 'snid', 'logwave', 'plotlnw'
    prefix.install Dir['templates']
    prefix.install Dir['test']
    doc.install Dir['doc/*']
  end

  def test
    mktemp do
      system "snid inter=0 plot=0 #{prefix}/test/sn2003jo.dat"
    end

  end
end

__END__
--- a/Makefile
+++ b/Makefile
@@ -167,12 +167,11 @@ OUTILS2= utils/lnb.o utils/median.o
 OUTILS3= utils/four2.o utils/lnb.o
 
 # Button library
-BUTTLIB= button/libbutton.a
+BUTTLIB= -lbutton
 
 all : snid logwave plotlnw
 
 snid :  $(OBJ1) $(OUTILS1)
-	cd button && $(MAKE) FC=$(FC)
 	$(FC) $(FFLAGS) $(OBJ1) $(OUTILS1) $(XLIBS) $(BUTTLIB) $(PGLIBS) -o $@
 
 logwave : $(OBJ2) $(OUTILS2)
--- a/source/typeinfo.f
+++ b/source/typeinfo.f
@@ -48,6 +48,8 @@
       typename(1,4) = 'Ia-91bg'
       typename(1,5) = 'Ia-csm'
       typename(1,6) = 'Ia-pec'
+      typename(1,7) = 'Ia-99aa'
+      typename(1,8) = 'Ia-02cx'
 * SN Ib      
       typename(2,1) = 'Ib'
       typename(2,2) = 'Ib-norm'
@@ -70,6 +72,8 @@
       typename(5,3) = 'Gal'
       typename(5,4) = 'LBV'
       typename(5,5) = 'M-star'
+      typename(5,6) = 'C-star'
+      typename(5,7) = 'QSO'
 
       return
       end
--- a/source/snid.inc
+++ b/source/snid.inc
@@ -44,16 +44,16 @@
       parameter (MAXPARAM = 200)
       parameter (MAXPEAK = 20)
       parameter (MAXPLOT = 20)
-      parameter (MAXPPT = 20000)
+      parameter (MAXPPT = 50000)
       parameter (MAXR = 999.9)
       parameter (MAXRLAP = 999)
       parameter (MAXSN = 300)
       parameter (MAXUSE = 30)
-      parameter (MAXTEMP = 3000)
+      parameter (MAXTEMP = 10000)
       parameter (MAXTOK = 32)
       parameter (MAXWAVE = 10000)
       parameter (NT = 5)
-      parameter (NST = 6)
+      parameter (NST = 8)
 
       character*10 typename(NT,NST) ! character array containing type/subtype names
 
