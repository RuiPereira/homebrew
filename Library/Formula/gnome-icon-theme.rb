require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class GnomeIconTheme < Formula
  homepage ''
  url 'http://ftp.gnome.org/pub/gnome/sources/gnome-icon-theme/3.6/gnome-icon-theme-3.6.2.tar.xz'
  version '3.6.2'
  sha1 'a92d1935d738860266f9590b011af747fb67beb4'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'intltool'
  depends_on 'gettext'
  depends_on 'gtk+'
  depends_on 'icon-naming-utils'

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
    # were more thorough. Run the test with `brew test gnome-icon-theme`.
    system "false"
  end
end
