# Documentation: https://docs.brew.sh/Formula-Cookbook.html
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Ltfs < Formula
  desc "Reference implementation of the LTFS format Spec for stand alone tape drive"
  homepage ""
  url "https://github.com/LinearTapeFileSystem/ltfs/archive/725912b88bc0e0467a73c39a89cbfc78d3f44f55.tar.gz#/ltfs-2.4.1.2-10254.tar.gz"
  sha256 "552e465b7e5f3ca3e6e997213ed574ae3f3d6fbf14af608df69b639d4ef3a867"

  head do
    url "https://github.com/LinearTapeFileSystem/ltfs.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gnu-sed" => :build
  depends_on :osxfuse
  depends_on "ossp-uuid"
  depends_on "libxml2"
  depends_on "icu4c"

  env :std

  def install
    ENV.deparallelize
    ENV['CC'] = 'gcc'
    ENV['LDFLAGS'] = '-framework CoreFoundation -framework IOKit'

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--disable-snmp"
    system "make"
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test ltfs`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
