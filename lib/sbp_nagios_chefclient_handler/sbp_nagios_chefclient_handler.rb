# ------------------------------------------------------------------------------
# Copyright 2013 Steven Geerts
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Eventhandler for Chef to report the status of the last chef-run to Nagios.


require 'chef/handler'
require 'chef/config'

class SBP
  class Nagios
    class Chefclient
      class Handler < ::Chef::Handler
        def initialize
          if (ENV['OS'] == 'Windows_NT')
            @results_path    = Chef::Config['resultspath'] || 'c:\var\chef'
          else
            @results_path    = Chef::Config['resultspath'] || '/var/chef'
          end
        end

        def report
          # get the exception status
          if exception
            ret="CRITICAL"
            Chef::Log.error("Reporting exception status")
          else
            ret="OK"
            Chef::Log.info("Reporting normal status")
          end
        
          # make sure all variables have a value
          if run_status.elapsed_time.nil?
            elapsedtime=0
          else 
            elapsedtime=run_status.elapsed_time
          end
          if run_status.updated_resources.nil?
            updatedresources=0
          else 
            updatedresources=run_status.updated_resources.length
          end 
          if run_status.all_resources.nil?
            allresources=0
          else
            allresources=run_status.all_resources.length
          end
      
          # make sure the configured report directory is present
          build_report_dir
      
          # build the report string
          msg_string="#{ret}|StartTime=#{run_status.start_time.to_s.gsub!(/\s+/, ".")} ElapsedTime=#{elapsedtime} UpdatedResources=#{updatedresources} AllResources=#{allresources}\n"

          # write output to file
          File.open(File.join("#{@results_path}","lastrun_results"), 'w') { |file |file.write("#{msg_string}") }
        end
      
        def build_report_dir 
           # borrowed this function from the chef/handler/json_file handler
           unless File.exists?("#{@results_path}")
             FileUtils.mkdir_p("#{@results_path}")
             File.chmod(00700, "#{@results_path}")
           end
        end
      end
    end
  end
end
