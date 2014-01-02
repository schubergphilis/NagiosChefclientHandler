Nagios Chef-Client Handler
==========================

This Chef-client handler is available as Ruby Gem on Rubygems.org.
the handler generates and updates a file on the local file system of a
host that contains information about the latest chef-client run.
The accompanying Nagios check the age of the file and reads its content.
based o this information it reports back to Nagios.

The Gem is tested on Linux (RHEL6 & Binary compatibles) & MS-Windows 2008R2
but its likely it will run without issues on other OSses

For automatic deployment and configuration this Handler depends on the chef-client cookbook

installation and configuration
------------------------------
Add the following to your role/environment to install and configure the handler:

    "chef_client": {
      "load_gems": {
         "sbp_nagios_chefclient_handler": {
           "require_name": "sbp_nagios_chefclient_handler/sbp_nagios_chefclient_handler"
         }
      },
      "config": {
        "report_handlers": [
           {"class": "SBP::Nagios::Chefclient::Handler", "arguments": []}
        ],
        "exception_handlers": [
           {"class": "SBP::Nagios::Chefclient::Handler", "arguments": []}
        ]
      }
    },

The load_gems attribute will install the gem, the config part will tell chef-client to 
actually use the reporthandler for bot, normal and failed execution. 

Also: add the chef-client::config recipe to your runlist. 

The results file will be created as /var/chef/lastrun_results on Linur or 
c:\var\chef\lastrun_results on Windows. You can influence the path where the 
lastrun_results file will be created by provisioning the following attribute:

    "chef_client": {
        "resultspath": "/your/custom/path/"
      }
    }

