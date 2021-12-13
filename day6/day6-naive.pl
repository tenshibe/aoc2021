#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $inputfile = 'inputb.txt';
open my $data, $inputfile or die "Could not open $inputfile: $!";

my @fishstate;

# Load Data
while( my $line = <$data>)  {
    chomp $line;
    @fishstate = split /,/, $line;
}

# Part 1
for (my $i = 0 ; $i < 256 ; $i++) {
    my $newfishcount = 0;
    for( my $j = 0 ; $j <= $#fishstate ; $j++ ) {
        if ($fishstate[$j] == 0) {
            $fishstate[$j] = 6;
            $newfishcount++;
            print("Here\n");
        }
        else {
            $fishstate[$j] = $fishstate[$j] - 1;
        }
    }
    for (my $j = 0 ; $j < $newfishcount ; $j++) {
        push(@fishstate, 8);
    }
}

#print Dumper(@fishstate);
my $fishcount = $#fishstate + 1;
print ("Fishcount is : $fishcount\n");
