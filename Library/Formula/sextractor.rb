require 'formula'

class Sextractor < Formula
  head 'https://astromatic.net/pubsvn/software/sextractor/trunk', :using => :svn
  homepage ''
  md5 'dcebfeb1c4ede205a79b07f4394f58cd'

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test sextractor`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end
