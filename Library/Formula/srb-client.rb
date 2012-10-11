require 'formula'

class SrbClient < Formula
  homepage 'http://www.sdsc.edu/srb/index.php'
  url 'http://www.sdsc.edu/srb/tarfiles/SRB3_4_2client.tar'
  md5 'cb42947abbabd7677ef4c960fc2ce2be'
  version '3.4.2'

  def patches () DATA end

  def install
    inreplace 'mk/mk.common', 'MY_CFLAG+= -g', 'MY_CFLAG+= -g -fPIC'
    system "./configure", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    # case insensitive filesystem?
    if File.exists? Dir.pwd.upcase
      mv 'utilities/bin/Scp', 'utilities/bin/Scp2'
      mv 'utilities/bin/Ssh', 'utilities/bin/Ssh2'
    end
    bin.install Dir['utilities/bin/S*']
    lib.install ['obj/libSrbClient.a']
    include.install Dir['utilities/include/*']
    man1.install Dir['utilities/man/man1/*']
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test SRB3`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end

__END__
diff --git a/src/include/srbStat.h b/src/include/srbStat.h
index 8c757c9..aa1b69b 100644
--- a/src/include/srbStat.h
+++ b/src/include/srbStat.h
@@ -373,7 +373,7 @@ typedef struct myDirent {
         char            d_name[1];      /* name of file */
 } dirent_t;
 
-typedef srb_size_t ino64_t;
+/* typedef srb_size_t ino64_t; */
 typedef srb_size_t off64_t;
 
 typedef struct myDirent64 {
diff --git a/utilities/src/getsrbobj.c b/utilities/src/getsrbobj.c
index 22fa612..466b96e 100644
--- a/utilities/src/getsrbobj.c
+++ b/utilities/src/getsrbobj.c
@@ -337,22 +337,22 @@ getmultipartword( entry *iEntry, char **stquery, char *boundary)
      return -1;
  }
 
- int getline(char *s, int n, FILE *f) {
-     register int i=0;
-
-     while(1) {
-	 s[i] = (char)fgetc(f);
-
-	 if(s[i] == CR)
-	     s[i] = fgetc(f);
-
-	 if((s[i] == 0x4) || (s[i] == LF) || (i == (n-1))) {
-	     s[i] = '\0';
-	     return (feof(f) ? 1 : 0);
-	 }
-	 ++i;
-     }
- }
+ /* int getline(char *s, int n, FILE *f) { */
+ /*     register int i=0; */
+
+ /*     while(1) { */
+ /*     s[i] = (char)fgetc(f); */
+
+ /*     if(s[i] == CR) */
+ /*         s[i] = fgetc(f); */
+
+ /*     if((s[i] == 0x4) || (s[i] == LF) || (i == (n-1))) { */
+ /*         s[i] = '\0'; */
+ /*         return (feof(f) ? 1 : 0); */
+ /*     } */
+ /*     ++i; */
+ /*     } */
+ /* } */
 
  void send_fd(FILE *f, FILE *fd)
  {
