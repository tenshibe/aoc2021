#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $inputfile = 'input.txt';
open my $data, $inputfile or die "Could not open $inputfile: $!";

my @map;
while ( my $line = <$data> ) {
    chomp $line;
    

    $map[ $. - 1 ] = [ split( //, $line ) ];

}

# Part 1 - classic approach taking into account edges... with no exceptions for out of bound in perl, the hard way
my $dangercount = 0;

for (my $i = 0 ; $i < @map ; $i++) {
    for (my $j = 0 ; $j < @{$map[$i]} ; $j++) {
        if ($i == 0) {
            if ($j == 0) {
                if ($map[$i][$j] < $map[$i+1][$j] && $map[$i][$j] <  $map[$i][$j+1]) {
                    $dangercount += $map[$i][$j] + 1;
                }
            }
            elsif ($j == @{$map[$i]} - 1) {
                if ($map[$i][$j] < $map[$i+1][$j] && $map[$i][$j] <  $map[$i][$j-1]) {
                    $dangercount += $map[$i][$j] + 1;
                }
            }
            else {
                if ($map[$i][$j] < $map[$i+1][$j] && $map[$i][$j] <  $map[$i][$j-1] && $map[$i][$j] < $map[$i][$j+1]) {
                    $dangercount += $map[$i][$j] + 1;
                }
            }
        }
        elsif ($i == $#map ) {
            if ($j == 0) {
                if ($map[$i][$j] < $map[$i-1][$j] && $map[$i][$j] <  $map[$i][$j+1]) {
                    $dangercount += $map[$i][$j] + 1;
                }
            }
            elsif ($j == @{$map[$i]} - 1) {
                if ($map[$i][$j] < $map[$i-1][$j] && $map[$i][$j] <  $map[$i][$j-1]) {
                    $dangercount += $map[$i][$j] + 1;
                }
            }
            else {
                if ($map[$i][$j] < $map[$i-1][$j] && $map[$i][$j] <  $map[$i][$j-1] && $map[$i][$j] < $map[$i][$j+1]) {
                    $dangercount += $map[$i][$j] + 1;
                }
            }
        }
        else {
            if ($j == 0) {
                if ($map[$i][$j] < $map[$i+1][$j] && $map[$i][$j] <  $map[$i][$j+1] && $map[$i][$j] < $map[$i-1][$j]) {
                    $dangercount += $map[$i][$j] + 1;
                }
            }
            elsif ($j == @{$map[$i]} - 1) {
                if ($map[$i][$j] < $map[$i-1][$j] && $map[$i][$j] <  $map[$i][$j-1] && $map[$i][$j] < $map[$i+1][$j]) {
                    $dangercount += $map[$i][$j] + 1;
                }
            }
            else {
                if ($map[$i][$j] < $map[$i-1][$j] && $map[$i][$j] <  $map[$i][$j-1] && $map[$i][$j] < $map[$i+1][$j] && $map[$i][$j] < $map[$i][$j+1]) {
                    $dangercount += $map[$i][$j] + 1;
                }
            }
        }
    }
}
print "$dangercount \n";

# Part 2 - damn all those conditionals, pad the map with 9s
# I was in doubt for part 1 and decided not to, but that will make this thing way simpler
my @paddedmap = @map;
my @bunchofnines = map 9,(1..@{$paddedmap[0]});
unshift (@paddedmap, [@bunchofnines]);
push (@paddedmap, [@bunchofnines]);
for (my $i = 0 ; $i < @paddedmap ; $i++) {
    unshift (@{$paddedmap[$i]}, 9);
    push (@{$paddedmap[$i]}, 9);
}

my @basins;

# Flood 9s...

for (my $i = 0 ; $i < @paddedmap ; $i++) {
    for (my $j = 0 ; $j < @{$paddedmap[$i]} ; $j++) {
        my $basin = floodmap($i, $j, 0);
        if ($basin != 0) {
            push (@basins, $basin);
        }
    }
}

my @sortedbasins = sort { $a <=> $b } @basins;
my $biggestbasinmultiplier = $sortedbasins[-1] * $sortedbasins[-2] * $sortedbasins[-3];
print("Basinmultiplier : $biggestbasinmultiplier\n");

# Recursive flood sub
sub floodmap {
    my $row = $_[0];
    my $col = $_[1];
    my $counter = $_[2];
    if ($paddedmap[$row][$col] != 9) {
        $counter += 1;
        $paddedmap[$row][$col] = 9;
        $counter = floodmap($row, $col+1, $counter);
        $counter = floodmap($row, $col-1, $counter);
        $counter = floodmap($row+1, $col, $counter);
        $counter = floodmap($row-1, $col, $counter);
    }
    return $counter;

}
