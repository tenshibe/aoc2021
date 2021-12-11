#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $inputfile = 'input.txt';
open my $data, $inputfile or die "Could not open $inputfile: $!";

# Part 1

my @binarystrings;
my $gammarate = "";

while( my $line = <$data>)  {   
    my $i = 0;
    while ($line =~ /(.)/g) {
        if ($1 == 0) {
            $binarystrings[$i][0] += 1;
        }
        elsif ($1 == 1) {
            $binarystrings[$i][1] += 1;
        }
        $i++;
    }
}

for (my $i = 0 ; $i < $#binarystrings ; $i++) {
    if ($binarystrings[$i][0] > $binarystrings[$i][1]) {
        $gammarate = $gammarate . "0";
    }
    else {
        $gammarate = $gammarate . "1";
    }
}

my $gammarateint = oct("0b" . $gammarate);
my $epsilonrateint = (((2**12) - 1) - $gammarateint);

print("gamma : $gammarateint - epsilon : $epsilonrateint - product: ${\($gammarateint * $epsilonrateint)}\n");

close($data);

# Part 2

open my $data2, $inputfile or die "Could not open $inputfile: $!";

my @measurements;
my $oxystartpoint = 0;
my $scrubberstartpoint = 0;

# initialize
while( my $line = <$data2>)  {   
        $measurements[($.-1)] = $line;
}

my @oxymeasurements = @measurements;
my @scrubbermeasurements = @measurements;

# recurse oxygen
while (@oxymeasurements > 1) {
    @oxymeasurements = reduce("oxygen", $oxystartpoint, @oxymeasurements);
    $oxystartpoint++;
}
$oxymeasurements[0] =~ s/\s+$//;
my $oxyint = oct("0b" . $oxymeasurements[0] );

# recurse scrubber
while (@scrubbermeasurements > 1) {
    @scrubbermeasurements = reduce("scrubber", $scrubberstartpoint, @scrubbermeasurements);
    $scrubberstartpoint++;
}
$scrubbermeasurements[0] =~ s/\s+$//; 
my $scrubberint = oct("0b" . $scrubbermeasurements[0] );

print("oxygen : $oxyint - scrubber : $scrubberint - product : ${\($oxyint * $scrubberint)}\n");

sub reduce {
    my @zerolist;
    my @onelist;
    my $type = $_[0];
    my $startpoint = $_[1];
    my $length = scalar @_;
    for (my $i = 2 ; $i < $length ; $i++) {
        my $significant_bit = substr $_[$i], $startpoint, 1;
        if ($significant_bit == "0") {
            push @zerolist, $_[$i];
        }
        else {
            push @onelist, $_[$i];

        }
    }
    if ($type =~ "oxygen") {
        if ($#onelist >= $#zerolist) {
            return @onelist;
        }
        else {
            return @zerolist;
        }
    }
    else {
        if ($#zerolist <= $#onelist ) {
            return @zerolist;
        }
        else {
            return @onelist;
        }
    }
}

close($data2);