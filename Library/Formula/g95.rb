require 'formula'

class G95 < Formula
  homepage ''
  url 'http://ftp.g95.org/g95-x86-osx.tgz'
  md5 'e64c84b1e9d9b03f2762b951bb12e8da'
  version '18-08-2010'

  # depends_on 'cmake' => :build

  def install
    bin.install Dir['bin/*']
    bin.install_symlink 'i686-apple-darwin10.3.0-g95' => 'g95'
    lib.install Dir['lib/*']
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test g95`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end
