require 'formula'

class BbftpClient < Formula
  homepage 'http://doc.in2p3.fr/bbftp/'
  url 'http://doc.in2p3.fr/bbftp/dist/bbftp-client-3.2.1.tar.gz'
  sha1 '26113782b8826610c877f83bdaf79798b30a507d'

  def install
    chdir 'bbftpc' do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make install"
    end
    include.install Dir['includes/*']
    docs = Dir['doc/*']
    man1.install docs.delete 'doc/bbftp.1'
    doc.install docs
  end

  def test
    system "#{bin}/bbftp", "-v"
  end
end
