require 'formula'

class Lacheck < Formula
  url 'http://mirrors.ctan.org/support/lacheck/lacheck-1.26.tar.gz'
  homepage 'http://mirrors.ctan.org/support/lacheck'
  md5 'a3f2ea68e48e550392e8a4b8f46c2eef'

  def install
    system "make"
    bin.install 'lacheck'
  end
end
