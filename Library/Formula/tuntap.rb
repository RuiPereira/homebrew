require 'formula'

class Tuntap < Formula
  head 'git://tuntaposx.git.sourceforge.net/gitroot/tuntaposx/tuntaposx', :using => :git
  homepage ''
  md5 '636e550b3bc204c82564ec7c254f57e1'

  def install
    chdir 'tuntap' do
      # inreplace ['src/tun/Makefile', 'src/tap/Makefile'], '-arch ppc', ''
      system "make"
      prefix.install ['tun.kext', 'tap.kext', 'startup_item']
    end
  end

  def caveats; <<-EOS.undent
  * how to install the extensions
    sudo mkdir -p /Library/Extensions
    sudo cp -pR #{prefix}/tap.kext /Library/Extensions/
    sudo chown -R root:wheel /Library/Extensions/tap.kext
    sudo cp -pR #{prefix}/tun.kext /Library/Extensions/ 
    sudo chown -R root:wheel /Library/Extensions/tun.kext

  * how to load the extensions
    sudo kextload /Library/Extensions/tap.kext
    sudo kextload /Library/Extensions/tun.kext

  * how to install the startup items
    sudo cp -pR #{prefix}/startup_item/tap /Library/StartupItems/
    sudo chown -R root:wheel /Library/StartupItems/tap
    sudo cp -pR #{prefix}/startup_item/tun /Library/StartupItems/ 
    sudo chown -R root:wheel /Library/StartupItems/tun
  EOS
  end
end
