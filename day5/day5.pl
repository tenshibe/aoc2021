#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $inputfile = 'input.txt';
open my $data, $inputfile or die "Could not open $inputfile: $!";

my @commands;
my @board;
my $max_x = 0;
my $max_y = 0;

# Load Data
while( my $line = <$data>)  {
    chomp $line;
    my ($startpoint, $endpoint) = split(" -> ",$line);
    ($commands[$.-1][0][0], $commands[$.-1][0][1]) = split (",", $startpoint);
    ($commands[$.-1][1][0], $commands[$.-1][1][1]) = split (",", $endpoint);
    if ($commands[$.-1][0][0] > $max_x) {
        $max_x = $commands[$.-1][0][0]
    }
    if ($commands[$.-1][1][0] > $max_x) {
        $max_x = $commands[$.-1][1][0]
    }
    if ($commands[$.-1][0][1] > $max_y) {
        $max_y = $commands[$.-1][0][1]
    }
    if ($commands[$.-1][1][1] > $max_y) {
        $max_y = $commands[$.-1][1][1]
    }
}

# Initialize Board
for (my $i = 0 ; $i <= $max_x  ; $i++) {
    for (my $j = 0 ; $j <= $max_y ; $j++) {
        $board[$i][$j] = 0;
    }
}

print ("Maxvalues : $max_x x $max_y\n");

# Part1

for (my $i = 0; $i <= $#commands  ; $i++) {
    if ($commands[$i][0][0] eq $commands[$i][1][0]) {
        if($commands[$i][0][1] < $commands[$i][1][1]) {
            
            for(my $j = $commands[$i][0][1] ; $j <= $commands[$i][1][1] ; $j++) {
                $board[$j][($commands[$i][0][0])]++;
            }
        }
        elsif($commands[$i][0][1] > $commands[$i][1][1]) {
            for(my $j = $commands[$i][0][1] ; $j >= $commands[$i][1][1] ; $j--) {
                $board[$j][$commands[$i][0][0]]++;
            }
        }
    }
    elsif ($commands[$i][0][1] eq $commands[$i][1][1]) {
        if($commands[$i][0][0] < $commands[$i][1][0]) {
            
            for(my $j = $commands[$i][0][0] ; $j <= $commands[$i][1][0] ; $j++) {
                $board[($commands[$i][0][1])][$j]++;
            }
        }
        elsif($commands[$i][0][0] > $commands[$i][1][0]) {
            for(my $j = $commands[$i][0][0] ; $j >= $commands[$i][1][0] ; $j--) {
                $board[$commands[$i][0][1]][$j]++;
            }
        }        
    }
    else {  
    }
}

my $dangercount = countcrosses();
print ("Dangercount is $dangercount\n");

# Part2

for (my $i = 0; $i <= $#commands  ; $i++) {
    if (abs($commands[$i][0][0] - $commands[$i][1][0]) == abs($commands[$i][0][1] - $commands[$i][1][1])) {
        my $spread = abs($commands[$i][0][0] - $commands[$i][1][0]);
        if ($commands[$i][0][0] > $commands[$i][1][0]) {
            if ($commands[$i][0][1] < $commands[$i][1][1]) {
                for (my $j = 0; $j <= $spread ; $j++) {
                    $board[($commands[$i][0][1] + $j)][($commands[$i][0][0] - $j)]++;
                }
            }
            else {
                for (my $j = 0; $j <= $spread ; $j++) {
                    $board[($commands[$i][0][1] - $j)][($commands[$i][0][0] - $j)]++;
                }                
            }
        }
        else {
            if ($commands[$i][0][1] < $commands[$i][1][1]) {
                for (my $j = 0; $j <= $spread ; $j++) {
                    $board[($commands[$i][0][1] + $j)][($commands[$i][0][0] + $j)]++;
                }
            }            
            else {
                for (my $j = 0; $j <= $spread ; $j++) {
                    $board[($commands[$i][0][1] - $j)][($commands[$i][0][0] + $j)]++;
                }                
            }
        }
    }
}    

my $dangercount2 = countcrosses();
print ("Danger count 2 with diagonals is $dangercount2\n");

# Subs

sub countcrosses {
    my $localcount = 0;
    for (my $i = 0 ; $i <= $max_x ; $i++ ) {
        for (my $j = 0 ; $j <= $max_y ; $j++) {
            if ($board[$i][$j] > 1) {
                $localcount++;
            }
        }
    }
    return $localcount;
}