#!/usr/bin/perl
# Name: refactorS1data.pl
# Author: Jason Campisi
# Date: 2/4/2025
# Version: v1.3.3
# Repository: https://github.com/xeoron/refactor_S1data
# Purpose: Refactor Sentinel 1 export and spit out 2 files for LocalAD and AzureAD devices only
# License: Released under GPL v3 or higher. Details here http://www.gnu.org/licenses/gpl.html

use strict;
use warnings;
#use Data::Dumper;

#global variables
my ($ladGROUP, $azureGROUP) = ("IN", "WORKGROUP");  #Group names of Local AD and Azure machines to target
my $filename_localAD = "_localAD.csv";
my $filename_intune = "_intune.csv";
my ($data, $count, $line1) = ("", 0, "");
#### add more things to strip out of the csv file by adding a comma after the quotes and then another quote ###
my @strip = ("Dell Inc. - ");   #  Example of adding more: = ("x", "y", "z");


sub printToFile($@) {  #Requires $filename, @csv_DATA
  my ($filename, @data) = @_;
  my $result = "Failed.... filename or data not provide";

  return $result if ($filename eq "" or scalar(@data)==0); # #if varaibles are empty return false.

  open(FH, '>', $filename) or return $result;
     print FH $line1;  #head description of the columns
     foreach (@data){ print FH $_; }
  close(FH);
 
 return " refactored SentinelOne data into file $filename";
}#end printToFile

sub main(){

 if (scalar(@ARGV)==0){
    print " Refactor Sentinel 1 export and spit out 2 files for LocalAD and AzureAD devices only\n";
    print "   Usage: refactorS1data.pl s1Data.csv\n\n";
    exit; 
 } 

# local scope data refactor variables 
 my @lad = (); # harvested local AD data
 my @azure = (); # harvested azureAD data

  for $data (<>){   # read the file line by line passed at runtime
     $line1 = $data if ($count++ == 0);
     foreach my $remove (@strip){ $data =~s/$remove//; } #strip data
   
     if ($data=~m/$ladGROUP/){ push (@lad, $data); next; } #local AD group name
     elsif ($data=~m/$azureGROUP/) { push (@azure, $data); next; }#azureAD group name
  }#end read file

  #print "line1: $line1\n";
  #print Dumper(@lad);
  #print Dumper(@azure);
   print printToFile($filename_localAD, @lad) . "\n";
   print printToFile($filename_intune, @azure) . "\n";

}#end main()

#print Dumper(@ARGV); exit;
main(); #run
