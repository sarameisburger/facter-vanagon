component "cpp-hocon-source" do |pkg, settings, platform|
  source_info = JSON.parse(Base64.decode64(Octokit::Client.new.contents('puppetlabs/puppet-agent', path: 'configs/components/cpp-hocon.json', ref: settings[:agent_ref]).content))
  pkg.url source_info['url']
  pkg.ref source_info['ref']

  pkg.build do
    [
      "mkdir -p #{settings[:gemdir]}/ext/facter/cpp-hocon",
      "cp -r * #{settings[:gemdir]}/ext/facter/cpp-hocon"
    ]
  end
end
