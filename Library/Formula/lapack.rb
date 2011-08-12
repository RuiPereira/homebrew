require 'formula'

class Lapack < Formula
  url 'http://www.netlib.org/lapack/lapack-3.3.1.tgz'
  homepage 'http://www.netlib.org/lapack'
  md5 'd0d533ec9a5b74933c2a1e84eedc58b4'

  depends_on 'blas'

  def install
    ENV.fortran
    cp 'INSTALL/make.inc.gfortran', 'make.inc'
    inreplace 'make.inc', '../../blas$(PLAT).a', Dir[File.join HOMEBREW_PREFIX, 'lib/libblas.a'][0]
    system "make"
    lib.install 'lapack_LINUX.a' => 'liblapack.a'
    lib.install 'tmglib_LINUX.a' => 'libtmg.a'
  end
end
