Nagios Chef-Client Handler
==========================

This Chef-client handler is available as Ruby Gem on Rubygems.org.
the handler generates and updates a file on the local file system of a
host that contains information about the latest chef-client run.
The accompanying Nagios check the age of the file and reads its content.
based o this information it reports back to Nagios.

The Gem is tested on Linux (RHEL6 & Binary compatibles) & MS-Windows 2008R2
but its likely it will run without issues on other OSses


installation
------------
Coming soon

client.rb
---------
Add the following to your client.rb to make the magic happen:

    require '/etc/chef/sbp_nagios_chefclient_handler'
    report_handlers << SBP::Nagios::Chefclient::Handler.new()
    exception_handlers << SBP::Nagios::Chefclient::Handler.new()


