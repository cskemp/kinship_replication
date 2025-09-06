#!/usr/bin/perl -w 

# merge a complexity file and a cost file (duplicate entries stripped)

# usage: combinescorecost.pl complexscorefile costfile outfile

use strict; 
my $c1 = shift;
my $c2 = shift;
my $scorefile= shift;
my $costfile= shift;
my $outfile  =  shift; 
my %hTmp;
 
open (IN1, "<$scorefile")  or die "Couldn't open score file: $!"; 
open (IN2, "<$costfile")  or die "Couldn't open cost file: $!"; 
open (OUT, ">$outfile") or die "Couldn't open output file: $!"; 
  
while (my $sLine = <IN1>) {
  my $sLine2 = <IN2>;
  $sLine2 = sprintf("%.3f", $sLine2);
  my @terms = split(/ /, $sLine);
  my $cx = $c1*$terms[0] + $c2*$terms[1];
  my $outline = $cx . " ". $sLine2. " ". $terms[1];
  print OUT $outline unless ($hTmp{$outline}++);
}

close OUT;
close IN2;
close IN1;
