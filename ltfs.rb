# Documentation: https://docs.brew.sh/Formula-Cookbook.html
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class OsxfuseRequirement < Requirement
  fatal true

  satisfy(build_env: false) { self.class.binary_osxfuse_installed? }

  def self.binary_osxfuse_installed?
    File.exist?("/usr/local/include/osxfuse/fuse.h") &&
      !File.symlink?("/usr/local/include/osxfuse")
  end

  env do
    ENV.append_path "PKG_CONFIG_PATH",
                    "/usr/local/lib/pkgconfig:#{HOMEBREW_PREFIX}/lib/pkgconfig:"\
                    "#{HOMEBREW_PREFIX}/opt/openssl@1.1/lib/pkgconfig"
    ENV.append_path "BORG_OPENSSL_PREFIX", "#{HOMEBREW_PREFIX}/opt/openssl@1.1/"

    unless HOMEBREW_PREFIX.to_s == "/usr/local"
      ENV.append_path "HOMEBREW_LIBRARY_PATHS", "/usr/local/lib"
      ENV.append_path "HOMEBREW_INCLUDE_PATHS", "/usr/local/include/osxfuse"
    end
  end

  def message
    "osxfuse is required to build ltfs. Please run `brew install --cask osxfuse` first."
  end
end

class Ltfs < Formula
  desc 'Reference implementation of the LTFS format Spec for stand alone tape drive'
  homepage 'https://github.com/LinearTapeFileSystem/ltfs'
  url 'https://github.com/LinearTapeFileSystem/ltfs/archive/v2.4.3.1-10461.tar.gz'
  sha256 'ae39778a47cb09c126fd394c269cbf464f7b43c876ea71a9c880e1159ce87066'

  head do
    url 'https://github.com/LinearTapeFileSystem/ltfs.git'
  end

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build
  depends_on 'gnu-sed' => :build
  depends_on 'ossp-uuid'
  depends_on 'libxml2'
  depends_on 'icu4c'

  on_macos do
    depends_on OsxfuseRequirement
    ENV['LDFLAGS'] = '-framework CoreFoundation -framework IOKit'
  end

  on_linux do
    depends_on "libfuse"
  end

  env :std

  def install
    ENV.deparallelize
    ENV['CC'] = 'gcc'

    system './autogen.sh'
    system './configure', "--prefix=#{prefix}", '--disable-snmp', '--enable-buggy-ifs'                                               
    system 'make'
    system 'make', 'install'
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
    # executables being tested: `system '#{bin}/program', 'do', 'something'`.
    system 'false'
  end
end
