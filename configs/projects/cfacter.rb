require 'json'
require 'git'
require 'base64'
require 'octokit'

project "cfacter" do |proj|
  platform = proj.get_platform

  proj.setting(:agent_ref, ENV['AGENT_REF'] || 'master')
  facter_data = JSON.parse(Base64.decode64(Octokit::Client.new.contents('puppetlabs/puppet-agent', path: 'configs/components/facter.json', ref: settings[:agent_ref]).content))
  facter_version_file = Base64.decode64(Octokit::Client.new.contents('puppetlabs/facter', path: 'CMakeLists.txt', ref: facter_data['ref']).content)

  facter_version = facter_version_file.match(/project\(FACTER VERSION [\d\.]*\)/).to_s.gsub(/[^\d\.]/, '')
  gem_version = facter_version + '.' + Time.now.strftime("%Y%m%d")
  proj.version gem_version

  proj.setting(:project_version, gem_version)
  proj.setting(:gemdir, '/var/tmp/facter_gem')
  if platform.is_windows?
    proj.setting(:ruby_dir, '/cygdrive/c/ProgramFiles64Folder/PuppetLabs/Puppet/sys/ruby')
    proj.setting(:gem_binary, File.join(proj.ruby_dir, 'gem.bat'))
    proj.setting(:ruby_binary, File.join(proj.ruby_dir, 'ruby.exe'))
    proj.setting(:build_tools_dir, '/cygdrive/c/tools/pl-build-tools/bin')
    arch = platform.architecture == "x64" ? "64" : "32"
    proj.setting(:gcc_bindir, "C:/tools/mingw#{arch}/bin")
  else
    proj.setting(:ruby_dir, '/opt/puppetlabs/puppet/bin')
    proj.setting(:gem_binary, File.join(proj.ruby_dir, 'gem'))
    proj.setting(:ruby_binary, File.join(proj.ruby_dir, 'ruby'))
    proj.setting(:build_tools_dir, '/opt/pl-build-tools/bin')
  end

  proj.component "facter-source"
  proj.component "leatherman-source"
  proj.component "cpp-hocon-source"
  proj.component "cfacter-source-gem"
  proj.component "cfacter-precompiled-gem"
  proj.component "puppet-runtime"

  proj.fetch_artifact "#{settings[:gemdir]}/cfacter*.gem"
  proj.no_packaging true
end