# Documentation: https://docs.brew.sh/Formula-Cookbook.html
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Ltfs < Formula
  desc "Reference implementation of the LTFS format Spec for stand alone tape drive"
  homepage ""
  url "https://github.com/LinearTapeFileSystem/ltfs/archive/b1ec9c626b38ed2ec824b14dd671dfb6cea2579b.tar.gz#/ltfs-2.4.1.0-0.tar.gz"
  sha256 "652f643b00ee083d39c4f4419dbe40042f443e5b9fd2b09052625fe8eeb9e669"

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
