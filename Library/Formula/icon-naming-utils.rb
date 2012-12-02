require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class IconNamingUtils < Formula
  homepage ''
  url 'http://tango.freedesktop.org/releases/icon-naming-utils-0.8.90.tar.gz'
  version '0.8.90'
  sha1 'a195e635fd663f0697a2a047f0c9134876900cf1'

  # depends_on 'cmake' => :build
  # depends_on :x11 # if your formula requires any X11/XQuartz components

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake", ".", *std_cmake_args
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test icon-naming-utils`.
    system "false"
  end
end
