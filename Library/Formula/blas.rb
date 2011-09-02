require 'formula'

class Blas < Formula
  url 'http://www.netlib.org/blas/blas.tgz'
  homepage 'http://www.netlib.org/blas'
  md5 '5e99e975f7a1e3ea6abcad7c6e7e42e6'
  version '2011.04.19'

  def install
    ENV.deparallelize
    ENV.fortran
    system "make"
    lib.install 'blas_LINUX.a' =>'libblas.a'
  end
end
