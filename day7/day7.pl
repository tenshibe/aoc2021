#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $inputfile = 'input.txt';
open my $data, $inputfile or die "Could not open $inputfile: $!";

my @crabpositions;

# Load Data
while( my $line = <$data>)  {
    chomp $line;
    @crabpositions = split /,/, $line;
}

# Part 1

my @sortedcrabpositions = sort { $a <=> $b } @crabpositions;
my $median;
my $midpoint = int @sortedcrabpositions / 2;
if (@sortedcrabpositions % 2) {
    $median = $sortedcrabpositions[ $midpoint ];
} else {
    $median = ($sortedcrabpositions[$midpoint-1] + $sortedcrabpositions[$midpoint])/2;
} 

my $fuelspend = 0;
for (my $i = 0 ; $i <= $#crabpositions ; $i++) {
    $fuelspend += abs($crabpositions[$i] - $median);
}

print ("The median is $median\n");
print ("The fuelspend is $fuelspend\n");


# Part 2

my $total;
for (my $i = 0 ; $i <= $#crabpositions ; $i++) {
    $total += $crabpositions[$i];
}
my $avg = int ( ($total / @crabpositions) );


my $fuelspend = 0;
for (my $i = 0 ; $i <= $#crabpositions ; $i++) {
    my $distance = abs($crabpositions[$i] - $avg);
    $fuelspend += ($distance * ( $distance + 1 )) / 2
}

print ("The average is $avg\n");
print ("The fuelspend is $fuelspend\n");

# Subs