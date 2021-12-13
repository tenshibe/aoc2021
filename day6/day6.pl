#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $inputfile = 'input.txt';
open my $data, $inputfile or die "Could not open $inputfile: $!";

my @fishstate;

for (my $i = 0 ; $i <= 8 ; $i++) {
    $fishstate[$i] = 0;
}

# Load Data
while( my $line = <$data>)  {
    chomp $line;
    my @fishinput = split /,/, $line;
    for (my $i = 0 ; $i <= $#fishinput ; $i++) {
        $fishstate[$fishinput[$i]]++;
    }
}

# Part 1

countfish(80);

# Part 2 

countfish(256);

# Subs

sub countfish {
    my $amountofdays = $_[0];
    my @localfishstate = @fishstate;

    for (my $i = 0 ; $i < $amountofdays ; $i++) {
        my $extrafish = shift(@localfishstate);
        $localfishstate[6] += $extrafish;
        push(@localfishstate, $extrafish);
    }

    my $totalfish = 0;
    for (my $i = 0 ; $i <= 8 ; $i++) {
        $totalfish += $localfishstate[$i];
    }

    print ("Total amount of fish after $amountofdays days is $totalfish\n");
}
