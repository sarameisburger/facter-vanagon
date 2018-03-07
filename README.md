Facter-Vanagon (cfacter gem)
===
 * Overview
 * Runtime requirements

Overview
---
facter-vanagon is a [vanagon](http://github.com/puppetlabs/vanagon) configuration
project that contains the information for building the cfacter gem (for native C++ facter).

facter-vanagon leverages information in the [puppet-agent](http://github.com/puppetlabs/puppet-agent)
project to identify what refs/tags to use of facter's dependencies. To build cfacter you must specify
which version of the agent to use to decide which versions of facter and it's dependencies to build.


Runtime Requirements
---
The [Gemfile](Gemfile) specifies all of the needed ruby libraries to build the cfacter
gem. Additionally, facter-vanagon requires a VM to build within for each
desired package.

Environment variables
--
#### AGENT\_REF
By specifying `AGENT_REF` you can identify which branch (or tag) of puppet agent to pull facter and dependency
versions from. By default this is set to `master`.
