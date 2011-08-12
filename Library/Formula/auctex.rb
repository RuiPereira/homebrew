require 'formula'

class Auctex < Formula
  url 'http://ftp.gnu.org/pub/gnu/auctex/auctex-11.86.tar.gz'
  homepage 'http://ftp.gnu.org/pub/gnu/auctex'
  md5 '6bc33a67b6ac59db1aa238f3693b36d2'

  depends_on 'emacs'

  def install
    begin
      system "which tex"
    rescue
      onoe 'TeX installation not found...'
      Process.exit
    else
      emacs = Dir[File.join HOMEBREW_PREFIX, 'bin', 'emacs']
      texmf = File.join ENV['HOME'], 'texmf'
      if !File.directory? texmf
        ohai 'Creating #{texmf}'
        Dir.mkdir texmf
      end
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
      "--prefix=#{prefix}", "--with-texmf-dir=#{texmf}", "--with-emacs=#{emacs}"
      system "make"
      system "make install"
    end
  end

  def caveats; <<-EOS.undent
    * texmf files are installed into
      #{File.join ENV['HOME'], 'texmf'}

    * to activate add the following to your .emacs
      (require 'tex-site)
    EOS
  end

end
