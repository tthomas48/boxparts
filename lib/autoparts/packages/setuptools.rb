# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

# All python packages should be rebuild on version change.
module Autoparts
  module Packages
    class Setuptools < Package
      name 'setuptools'
      version '5.7'
      description 'Setuptools: Easily download, build, install, upgrade, and uninstall Python packages'
      source_url 'https://pypi.python.org/packages/source/s/setuptools/setuptools-5.7.tar.gz'
      source_sha1 '807552212cda409b074e0e55630c3801a39eb198'
      source_filetype 'tgz'
      category Category::DEVELOPMENT_TOOLS

      depends_on "python2"

      def compile
        Dir.chdir("setuptools-5.7") do
          args = [
            "-s", "setup.py",
            "--no-user-cfg",
            "install",
            "--force", "--verbose",
            "--prefix=#{prefix_path}",
            "--install-lib=#{python_dependency.site_packages}"
          ]

          execute python_dependency.bin_path + "python", *args
        end
      end

      def install
        required_files.each do |f|
          execute "mv",
            python_dependency.site_packages + f,
            prefix_path + f
        end
      end

      def post_install
        required_files.each do |f|
          execute "cp", "-rf",
            prefix_path + f,
            python_dependency.site_packages + f
        end
      end

      def python_dependency
        @python ||= get_dependency("python2")
      end

      def required_files
        [
          "easy-install.pth",
          "setuptools-5.7-py2.7.egg",
          "setuptools.pth",
        ]
      end
    end
  end
end
