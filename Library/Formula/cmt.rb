require 'formula'

class Cmt < Formula
  homepage 'http://www.cmtsite.org/'
  url 'http://www.cmtsite.org/v1r25/CMTv1r25.tar.gz'
  sha1 '3502ae0c1e4cdb01a6e6e9453c1a3c9d8058d8b6'
  version '1r25'

  keg_only "Self-contained install"

  def install
    mv Dir["v#{version}/*"], prefix
    chdir prefix+'mgr' do
      inreplace "INSTALL", '= "CMT"', '= "cmt"'
      system "./INSTALL; . setup.sh"
      system "make"
    end
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test CMTv1r`.
    system "false"
  end
end
