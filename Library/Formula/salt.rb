require 'formula'

class Salt < Formula
  homepage 'http://supernovae.in2p3.fr/~guy/salt/'
  url 'http://supernovae.in2p3.fr/~guy/salt/download/snfit-2.2.2b.tar.gz'
  sha1 'e435ca19d22800f95f5363038297593ec4dae97f'

  option 'snifs', 'Install SNIFS data'
  depends_on :fortran

  resource 'SALT2' do
    url 'http://supernovae.in2p3.fr/~guy/salt-dev/download/salt2_model_data-2-0.tar.gz'
    sha1 '271e67d764c98b423dfaa264b9baf759a46acff1'
  end

  resource '04D3gx' do
    url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-04D3gx.tar.gz"
    sha1 '6267be3319f4c777d8f67642bb0e9bfde298ffff'
    version '2.2.2b'
  end

  resource '4SHOOTER2' do
    url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-4Shooter2.tar.gz"
    sha1 '6929813baaf5368979325d79ca1ea8068f410a1d'
    version '2.2.2b'
  end

  resource 'SWOPE' do
    url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-CSP-Swope.tar.gz"
    sha1 '3ec88a86d77693d8f99c95b76a0a6208208ccfcd'
    version '2.2.2b'
  end

  resource 'ACSWF' do
    url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-HST-ACSWF.tar.gz"
    sha1 '1d3c49efe65964c69d932314c0e137fa746b7b71'
    version '2.2.2b'
  end

  resource 'NICMOS2' do
    url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-HST-NICMOS2.tar.gz"
    sha1 '52bce4a15bf3a6e2c6fe93c9077cc85865cf58db'
    version '2.2.2b'
  end

  resource 'KEPLERCAM' do
    url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-Keplercam.tar.gz"
    sha1 'de1e79204c05457c86ea07918cb3a1c2bdde9d21'
    version '2.2.2b'
  end

  resource 'STANDARD' do
    url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-Landolt-model.tar.gz"
    sha1 'd2421fb470f678ee94619622433fb975339fe7ac'
    version '2.2.2b'
  end

  resource 'MEGACAM' do
    url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-Megacam-model.tar.gz"
    sha1 '8b112a69881bb6a9967576b5e18c8d62b93f009b'
    version '2.2.2b'
  end

  resource 'SDSS' do
    url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-SDSS-model-Doi2010.tar.gz"
    sha1 '8858167928151bc07e790c30abf609614ad817d2'
    version '2.2.2b'
  end

  resource 'SNIFS' do
    url "http://snovae.in2p3.fr/pereira/SNIFS.tar.gz"
    sha1 '7a7dc2541068942488d3ee5dec3e2e1fc4343741'
    version '2.2.2b'
  end

  resource 'SWOPE2' do
    url "http://snovae.in2p3.fr/pereira/Swope.tar.gz"
    sha1 'da45bfcfaa39756d0145aade9f7383de093e0a59'
    version '2.2.2b'
  end

  resource 'BESSELL12' do
    url "http://snovae.in2p3.fr/pereira/Bessell12.tar.gz"
    sha1 'f98b97f044cd297e6fe9e403b48247cf51632c5b'
    version '2.2.2b'
  end

  resource 'SDSS-AB-off' do
    url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-SDSS-magsys.tar.gz"
    sha1 'd1e4a4c5fe7f56c2502ba42f0b3e28f5168928be'
    version '2.2.2b'
  end

  resource 'VEGAHST' do
    url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-Vega-magsys.tar.gz"
    sha1 'add0b1df6353a34912311c1a1973b03147862539'
    version '2.2.2b'
  end

  resource 'VEGA' do
    url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-magsys-1.tar.gz"
    sha1 '4f3f05d1d08c6840f13b0ec6101826159a450eff'
    version '2.2.2b'
    # if build.include? 'snifs'
    #   def patches
    #     "https://gist.github.com/RuiPereira/1758248/raw/ba02b5aab0c676f0628089e4dadddfb2cfb4b85f/BD17.diff"
    #   end
    # end
  end

  def install_resource(name, dir)
    resource(name).stage do
      d = File.basename Dir.pwd
      (dir/d).install Dir['*']

      # the fitmodel file will link by default to the first dir
      # on the path right after #{prefix}/data/
      linkto = {
        'SDSS-AB-off' => 'MagSys/SDSS-AB-off.dat',
        'VEGAHST'     => 'MagSys/Vega0.dat',
        'VEGA'        => 'MagSys/BD17-snls3.dat',
      }.fetch(name) do
        base = File.basename(dir)
        base == 'data' ? d : File.join(base, d)
      end

      "@#{name} #{linkto}\n"
    end
  end

  if build.include? 'snifs'
    def patches
      # data for \Delta m_15(B) + DeltaDayMax and snmag from HEAD
      ["https://gist.github.com/RuiPereira/1758248/raw/6dfbda52b28ce5b5246c165e7faeddb2f47651b4/snfit.diff",
       "https://gist.github.com/RuiPereira/1758248/raw/be1bbdc5c98800d3329351a176ed85e919e8fd55/snmag.diff"]
    end
  end

  def install
    ENV.deparallelize
    # the libgfortran.a path needs to be set explicitly
    # for the --enable-gfortran option to work
    libgfortran = `$FC --print-file-name libgfortran.a`.chomp
    ENV.append 'LDFLAGS', "-L#{File.dirname libgfortran}"
    system "./configure", "--prefix=#{prefix}", "--enable-gfortran"
    system "make install"

    # install all the model data
    # http://supernovae.in2p3.fr/~guy/salt/download/snls3-intallation.sh
    (data = prefix/'data').mkpath
    (data/'fitmodel.card').open('w') do |f|
      # salt2 model + magsys
      %w{SALT2 VEGA SDSS-AB-off VEGAHST}.each do |name|
        f.write(install_resource(name, data))
      end
      # instruments
      inst = data + 'Instruments'
      %w{
        STANDARD MEGACAM KEPLERCAM 4SHOOTER2
        SDSS SWOPE ACSWF NICMOS2
      }.each do |name|
        f.write(install_resource(name, inst))
      end
      if build.include? 'snifs'
        %w{SNIFS SWOPE2 BESSELL12}.each do |name|
          f.write(install_resource(name, data))
        end
      end
    end

    # for testing
    (prefix/'04D3gx').install resource('04D3gx')
  end

  test do
    ENV['PATHMODEL'] = "#{prefix}/data"
    cp_r Dir[prefix + '04D3gx' + '*'], '.'
    # I don't know why I need to redo the cd on the shell, but it doesn't work otherwise
    system "cd #{Dir.pwd}; #{bin}/snfit lc2fit_g.dat lc2fit_r.dat lc2fit_i.dat lc2fit_z.dat"
    system "cat result_salt2.dat result_salt2_SNLS3.dat"
  end

  def caveats
    <<-EOS.undent
    You should add the following to your .bashrc or equivalent:
      export PATHMODEL=#{prefix}/data
    EOS
  end

end
