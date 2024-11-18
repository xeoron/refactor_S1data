#!/usr/bin/perl
# Name: refactorS1data.pl
# Author: Jason Campisi
# Date: 11/18/2024
# Version: v1.0.0
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
my @lad = ();
my @azure = ();

sub printToFile($) {  # pass the string that has the file to process
  my ($filename)=@_;
  my @data = ();

 #autodetect which data to write to file
  if ($filename eq $filename_localAD){ @data=@lad; }
  else{ @data=@azure; }

  open(FH, '>', $filename) or die $!;
     print FH $line1;  #head description of the columns
     foreach (@data){ print FH $_; }
   close(FH);
}#end printToFile

sub main (){
 for $data (<>){   # read the file line by line passed at runtime
   $line1 = $data if ($count++ == 0);
   $data =~s/Dell Inc. - //;  #strip data

   if ($data=~m/$ladGROUP/){  #local AD group name
      push (@lad, $data); 
      next;
   }elsif ($data=~m/$azureGROUP/) {  #azureAD group name
      push (@azure, $data); 
      next;
   }
 }#end read file

 #print "line1: $line1\n";
 #print Dumper(@lad);
 print "Writing to file $filename_localAD\n";
 printToFile($filename_localAD);

 #print Dumper(@azure);
 print "Writing to file $filename_intune\n";
 printToFile($filename_intune); 
}#nd main()

#print Dumper(@ARGV); exit;
if (scalar(@ARGV)==0){
  print "\nPlease provide a s1 data export file.\nUsage: ./refactorS1data.pl s1Data.csv\n";
  exit; 
}
main();
