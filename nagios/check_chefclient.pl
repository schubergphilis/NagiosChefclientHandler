#!/usr/bin/env perl
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
# Nagios check that reads the results of the Eventhandler for Chef.
# This check is based on the SBP-Internal Nagios check Check_cfengine (Original Author not documented)
#


use strict;
use warnings;
use POSIX;

my $thres_warn = 30; # minutes
my $thres_critical = 60; #minutes
my $failed = "nill";
my $cheflr_file;
my $cheflo_file;
my $lrstatus;
my $perfdata;

# find the LR file for this OS
my $osv = lc($^O);
$osv = "win" if ($osv =~ /^mswin/);
if ($osv eq "win") {
  $cheflr_file = "c:\\var\\chef\\lastrun_results";
  $cheflo_file = "$ENV{'TEMP'}\\chef_lastok.txt"; 
} else {
  $cheflr_file = "/var/chef/lastrun_results";
  $cheflo_file = "/tmp/chef_lastok"; 
}


# Chef if there is a last-results file 
if ( ! -f $cheflr_file ) {
	print "Chef-Client UNKNOWN $cheflr_file not found\n";
	exit 3;	#unknown
}

# check the age of the file
my $cclastmodified = floor (( -M $cheflr_file ) * 24 * 60); #minutes

# read the content of the file 
open (my $lrfh, $cheflr_file);
while (my $lrrow = <$lrfh>) {
   if ($lrrow =~ m/^OK(\|.*)/) {
      $lrstatus = "OK";
      $perfdata = $1;
   }
   elsif ($lrrow =~ /^CRITICAL(\|.*)/) {
      $lrstatus = "CRITICAL";
      $perfdata = $1;
   }
   else {
      $lrstatus = "UNKNOWN";
      $perfdata = "|";
   }
}

# If file is to old report about it
if ( $cclastmodified >  $thres_critical ) {
	print "Chef-Client CRITICAL chef-client not run for $cclastmodified minutes $perfdata\n";
	exit 2; #Critical
}
elsif ( $cclastmodified >  $thres_warn ) {
        print "Chef-Client WARNING chef-client not run for $cclastmodified minutes $perfdata\n";
        exit 1; #Warning
}

# proceed on what's in the file
if ($lrstatus eq "OK") {
   # update last OK run flag
   open HANDLE, ">$cheflo_file" or $failed = $! ;
   if ( $failed  ne "nill" ) {
      print "Chef-Client UNKNOWN $cheflo_file: $failed $perfdata\n";
      exit 3;
   }
   close HANDLE;
   # exit with the OK status
   print "Chef-Client OK $perfdata\n";
   exit 0; #OK
}
elsif ($lrstatus eq "CRITICAL") {      
   # see for what time we are critical now   
   if ( ! -f $cheflo_file ) {
      # file does not exist. asuming this is the first chef-run, creating the file and exite with OK.
      open HANDLE, ">$cheflo_file" or $failed = $! ;
      if ( $failed  ne "nill" ) {
         print "Chef-Client UNKNOWN $cheflo_file: $failed $perfdata\n";
         exit 3;
      }
      close HANDLE;
      print "Chef-Client OK $perfdata\n";
      exit 0; #OK
   }
   else {
      # check the age of the file
      my $cclastok = floor (( -M $cheflo_file ) * 24 * 60); #minutes
      # If file is to old report about it
      if ( $cclastok >  $thres_critical ) {
         print "Chef-Client CRITICAL chef-client not finished OK for $cclastok minutes $perfdata\n";
         exit 2; #Critical
      }
      elsif ( $cclastok >  $thres_warn ) {
         print "Chef-Client WARNING chef-client not finished OK for $cclastmodified minutes $perfdata\n";
         exit 1; #Warning
      }
      else {
         print "Chef-Client OK $perfdata\n";
         exit 0; #OK
      }
   }
}
   
# we should not end up here 
print "Chef-Client UNKNOWN could not determine the actual status\n";
exit 3; #UNKNOWN

