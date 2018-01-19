# Documentation: https://docs.brew.sh/Formula-Cookbook.html
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Ltfs < Formula
  desc "Reference implementation of the LTFS format Spec for stand alone tape drive"
  homepage ""
  url "https://github.com/LinearTapeFileSystem/ltfs/archive/14b1eeddc47255579250bd01741a750e1d7dcdd4.tar.gz#/ltfs-2.4.0.1-0.tar.gz"
  sha256 "e09fca90236cd4cb0982289d134ccad5bf59a68a9275997315cb5dd013d1dc28"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on :osxfuse
  depends_on "ossp-uuid" => :build
  depends_on "libxml2" => :build
  depends_on "icu4c" => :build
  depends_on "gnu-sed" => :build

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
