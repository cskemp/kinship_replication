#!/usr/bin/perl -w 

# combine two complexity_score files, taking the lower complexity value in
# each case

# usage: complexmin.pl file1 file2 outputfile

use strict; 

my $scorefile1= shift;
my $scorefile2= shift;
my $outfile  =  shift; 
my %hTmp;
 
open (IN1, "<$scorefile1")  or die "Couldn't open score file 1: $!"; 
open (IN2, "<$scorefile2")  or die "Couldn't open score file 2: $!"; 
open (OUT, ">$outfile") or die "Couldn't open output file: $!"; 
  
while (my $sLine1 = <IN1>) {
  my $sLine2 = <IN2>;
  my @terms1 = split(/ /, $sLine1);
  my @terms2 = split(/ /, $sLine2);
  my $cxmin = 0;
  if ($terms1[0] < $terms2[0]) {
    $cxmin = $terms1[0];
  } else {
    $cxmin = $terms2[0];
  }
  my $outline = $cxmin . " ". $terms1[1];
  print OUT $outline; 
}

close OUT;
close IN2;
close IN1;
