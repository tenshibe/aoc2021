#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use experimental 'smartmatch';
use Array::Utils qw(:all);

my $inputfile = 'input.txt';
open my $data, $inputfile or die "Could not open $inputfile: $!";

my @patternlist;
my @outputlist;

# Load Data
while ( my $line = <$data> ) {
    chomp $line;
    my ( $patterns, $output ) = split( /\s\|\s/, $line );
    @patternlist[ $. - 1 ] = [ split( /\s/, $patterns ) ];
    @outputlist[ $. - 1 ]  = [ split( /\s/, $output ) ];
}

#print Dumper(@outputlist);

# Basics...
# 0 : 6 segments : 4x2 and 2x4
# 1 : 2 segments : 2x2
# 2 : 5 segments : 2x2 and 3x4
# 3 : 5 segments : 2x2 and 3x4
# 4 : 4 segments : 3x2 and 1x4
# 5 : 5 segments : 2x2 and 3x4
# 6 : 6 segments : 3x2 and 3x3
# 7 : 3 segments : 2x2 and 1x3
# 8 : 7 segments : 4x2 and 3x3
# 9 : 6 segments : 3x2 and 3x3
# So unique is 2 segments (1), 3 segments (7), 4 segments (4), 7 segments (8)
# So triple is 5 segments (2,3,5) and 6 segments (0,6,9)
# 5's are identical : all 2x2 and 3x4 - 6's have 0 as unique

# Part 1

my $uniquecount = 0;

for ( my $i = 0 ; $i <= $#outputlist ; $i++ ) {
    for ( my $j = 0 ; $j < 4 ; $j++ ) {
        if ( length( $outputlist[$i][$j] ) ~~ [ 2, 3, 4, 7 ] ) {
            $uniquecount++;
        }
    }
}

print("Unique outputcount is $uniquecount\n");

# Part 2

my $totalcount = 0;

for ( my $i = 0 ; $i <= $#patternlist ; $i++ ) {

    my %segpatterns;
    my %decodepatterns;

    my @diff;

    my @zero;
    my @one;
    my @two;
    my @three;
    my @four;
    my @five;
    my @six;
    my @seven;
    my @eight;
    my @nine;

    my @listoffivesegments;
    my @listofsixsegments;

    # Grab some numbers in buckets...
    for ( my $j = 0 ; $j <= 9 ; $j++ ) {
        if ( length( $patternlist[$i][$j] ) == 2 ) {
            @one = sort(split //, $patternlist[$i][$j]);
        }
        if ( length( $patternlist[$i][$j] ) == 3 ) {
            @seven = sort(split //, $patternlist[$i][$j]);
        }
        if ( length( $patternlist[$i][$j] ) == 4 ) {
            @four = sort(split //, $patternlist[$i][$j]);
        }
        if ( length( $patternlist[$i][$j] ) == 5 ) {
            push( @listoffivesegments, [ sort(split //, $patternlist[$i][$j]) ] );
        }
        if ( length( $patternlist[$i][$j] ) == 6 ) {
            push( @listofsixsegments, [ sort(split //, $patternlist[$i][$j]) ] );
        }
        if ( length( $patternlist[$i][$j] ) == 7 ) {
            @eight = sort(split //, $patternlist[$i][$j]);
        }
    }

    # 1 and 7 are unique and differ one segment => identify top
    @diff = array_minus(@seven,@one);
    $segpatterns{'0'} = $diff[0];

    # since we now know top, we can add top to 4 and look to the ones with 6 segments : only 9 will have 1 difference
    # => identify bottom row and identify 9
    my @extrafour = @four;
    push @extrafour, $segpatterns{'0'};
    for ( my $j = 0 ; $j < @listofsixsegments ; $j++ ) {
        my @x = map {@$_} $listofsixsegments[$j];
        @diff = array_minus(@x, @extrafour);
        if ($#diff == 0) {
            @nine = sort(@x);
            $segpatterns{'6'} = $diff[0];
        }
    }

    # 2 out of 7 segments, 5 out 10 numbers
    # We now know top and bottom aka 0 and 6...
    # 9 is known, grab bottom left segment by comparing with 8
    @diff = array_minus(@eight, @nine);
    $segpatterns{'4'} = $diff[0];

    # 3 out of 7 segments, 5 out 10 numbers
    # Out of the ones with 5 segments, we can now take one, remove top and bottom, and compare with the others.
    # Shared component is middle segment (3)
    my @firstof5 = sort(map {@$_} $listoffivesegments[0]);
    my @secondof5 = sort(map {@$_} $listoffivesegments[1]);
    my @thirdof5 = sort(map {@$_} $listoffivesegments[2]);
    %decodepatterns = reverse %segpatterns;
    for my $index (reverse 0..$#firstof5) {
        if ( $decodepatterns{$firstof5[$index]} ~~ ['0', '6'] ) {
            splice(@firstof5, $index, 1, ());
        }
    }
    my @intersect1 = intersect(@firstof5, @secondof5);
    my @intersect2 = intersect(@firstof5, @thirdof5);
    my @finalintersect = intersect(@intersect1, @intersect2);
    $segpatterns{'3'} = $finalintersect[0];
    #print Dumper(@finalintersect);

    # 4 out of 7 segments, 5 out 10 numbers
    # There's only one out of the list of 5 segments that has top,bottom,middle and bottom left : 2
    # Identify two and set the top right segment
    %decodepatterns = reverse %segpatterns;
    for (my $i = 0 ; $i <= $#listoffivesegments ; $i++) {
        my @fiver = sort(map {@$_} $listoffivesegments[$i]);
        for my $index (reverse 0..$#fiver) {
            if ( $decodepatterns{$fiver[$index]} ~~ ['0', '6', '3', '4'] ) {
                splice(@fiver, $index, 1, ());
            }
        }
        if ($#fiver == 0) {
            $segpatterns{'2'} = $fiver[0];
            @two = sort(map {@$_} $listoffivesegments[$i]);
            last;
        }     
    }

    # 5 out of 7 segments, 6 out 10 numbers
    # We know 9. So there's only two left in the six segments : 0 and 6
    # The one with the middle segment is 6, the other is 0. 
    my @remainingsixes;
    for (my $i = 0 ; $i <= $#listofsixsegments ; $i++) {
        my @comparer = sort(map {@$_} $listofsixsegments[$i]);
        my @arraydiff = array_diff(@comparer, @nine);
        if ( $#arraydiff < 0 ) {
        }
        else {
            if ( grep( /^$segpatterns{'3'}$/, @comparer ) ) {
                @six = @comparer;
            }
            else {
                @zero = @comparer;
            }
        }
    }
    # 5 out of 7 segments, 8 out of 10 numbers.
    # We know 2. So there's only two left in the five segments : 3 and 5
    # 3 has the top right
    my @remainingfives;
    for (my $i = 0 ; $i <= $#listoffivesegments ; $i++) {
        my @comparer = sort(map {@$_} $listoffivesegments[$i]);
        my @arraydiff = array_diff(@comparer, @two);
        if ( $#arraydiff < 0 ) {
        }
        else {
            if ( grep( /^$segpatterns{'2'}$/, @comparer ) ) {
                @three = @comparer;
            }
            else {
                @five = @comparer;
            }
        }
    }   
    # We have all numbers
    # Now go check the results and translate them...
    my %translationdict;
    my $zero = "@zero";
    $zero =~ s/(.)\s/$1/seg;
    $translationdict{"$zero"} = "0";
    my $one = "@one";
    $one =~ s/(.)\s/$1/seg;
    $translationdict{"$one"} = "1";
    my $two = "@two";
    $two =~ s/(.)\s/$1/seg;
    $translationdict{"$two"} = "2";
    my $three = "@three";
    $three =~ s/(.)\s/$1/seg;
    $translationdict{"$three"} = "3";
    my $four = "@four";
    $four =~ s/(.)\s/$1/seg;
    $translationdict{"$four"} = "4";
    my $five = "@five";
    $five =~ s/(.)\s/$1/seg;
    $translationdict{"$five"} = "5";
    my $six = "@six";
    $six =~ s/(.)\s/$1/seg;
    $translationdict{"$six"} = "6";
    my $seven = "@seven";
    $seven =~ s/(.)\s/$1/seg;
    $translationdict{"$seven"} = "7";
    my $eight = "@eight";
    $eight =~ s/(.)\s/$1/seg;
    $translationdict{"$eight"} = "8";
    my $nine = "@nine";
    $nine =~ s/(.)\s/$1/seg;
    $translationdict{"$nine"} = "9";


    my $number = "";
    for (my $j = 0 ; $j < 4 ; $j++) {
        my @matcher = sort(split //, $outputlist[$i][$j]);
        my $matcher = "@matcher";
        $matcher =~ s/(.)\s/$1/seg;
        $number = $number . $translationdict{$matcher};
    }
    $totalcount += $number;
}

print("The total count is $totalcount\n");

# Subs
