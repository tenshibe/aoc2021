#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $inputfile = 'input.txt';
open my $data, $inputfile or die "Could not open $inputfile: $!";

my @numberqueue;
my @boards;
my $boardindex = "x";
my $boardrow = 0;
my $drawcount = 0;

# Load Data

while( my $line = <$data>)  {   
    if ($. == 1) {
        chomp($line);
        @numberqueue = split /,/, $line;
    }
    # new board coming up
    elsif ($line eq "\n") {
        if ($boardindex eq "x") {
            $boardindex = 0;
        }
        else {
            $boardindex++;
        }
        $boardrow = 0;
    }
    else {
        chomp($line);
        $line =~ s!^\s+!!;
        my @tokens = split /\s+/, $line;
        my $counter = 0;
        foreach (@tokens) {
            $boards[$boardindex][$boardrow][$counter][0] = int($_);
            $boards[$boardindex][$boardrow][$counter][1] = 0;
            $counter++
        }
        $boardrow++;
    }
}
close($data);

# Part 1
my @numberqueue1 = @numberqueue;
while (@numberqueue1) {
    my $drawnumber = shift(@numberqueue1);
    draw($drawnumber);
    my $bingostate = checkbingo();
    if ($bingostate != -1) {
        print("Bingoboard is $bingostate\n");
        my $count = countboard($bingostate);
        print("Count is $count \n");
        print("Last drawn number was $drawnumber, product is " . $count*$drawnumber ."\n");
        last;
    }
}

# Part 2
my @numberqueue2 = @numberqueue;
while (@numberqueue2) {
    my $drawnumber = shift(@numberqueue2);
    draw($drawnumber);
    if ($#boards > 0) {
        while ((my $bingostate = checkbingo()) != -1) {
            splice(@boards, $bingostate, 1);
        }
    }
    else {
        print("Last board found\n");
        my $count = countboard(0);
        print("Count is $count \n");
        print("Last drawn number was $drawnumber, product is " . $count*$drawnumber ."\n");
        last;
    }
}

# Subs

sub draw {
    my $drawnumber = $_[0];
    for(my $i = 0 ; $i < $#boards + 1 ; $i++) {
        for (my $j = 0 ; $j < 5 ; $j++) {
            for (my $k = 0 ; $k < 5 ; $k++) {
                if ($boards[$i][$j][$k][0] == $drawnumber) {
                    $boards[$i][$j][$k][1] = 1;
                }
            }
        }
    }
    $drawcount++;
}

sub checkbingo {
    for(my $i = 0 ; $i < $#boards + 1 ; $i++) {
        # check lines
        for (my $j = 0 ; $j < 5 ; $j++) {
            if ($boards[$i][$j][0][1] == 1 && $boards[$i][$j][1][1] == 1 && $boards[$i][$j][2][1] == 1 && $boards[$i][$j][3][1] == 1 && $boards[$i][$j][4][1] == 1 ) {
                return $i;
            }
        }
        # check columns
        for (my $j = 0 ; $j < 5 ; $j++) {
            if ($boards[$i][0][$j][1] == 1 && $boards[$i][1][$j][1] == 1 && $boards[$i][2][$j][1] == 1 && $boards[$i][3][$j][1] == 1 && $boards[$i][4][$j][1] == 1 ) {
                return $i;
            }
        }
    }
    return -1;
}

sub countboard {
    my $boardnumber = $_[0];
    my $result = 0;
    for (my $j = 0 ; $j < 5 ; $j++) {
        for (my $k = 0 ; $k < 5 ; $k++) {
            if ($boards[$boardnumber][$j][$k][1] == 0) {                
                $result += $boards[$boardnumber][$j][$k][0];
            }
        }
    }
    return $result;
}