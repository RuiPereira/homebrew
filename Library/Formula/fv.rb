require 'formula'

class Fv < Formula
  url 'http://heasarc.gsfc.nasa.gov/FTP/software/lheasoft/fv/fv53_src.tar.gz'
  homepage ''
  md5 '6f58bb886185a11d3ab64f7d57aeac05'
  version '5.3'

  # depends_on 'cmake'

  def install
    ENV.x11
    cd 'BUILD_DIR' do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make"
      raise
    end
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test fv`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end
