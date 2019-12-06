#!/usr/bin/env perl6
use v6;

my Int %coords;
my Int %intersected;

my Int $closest = 999_999_999_999;
my Int $min-steps = $closest;

sub insert-coords (Int $x, Int $y, Int $steps) {
    %coords{"$x,$y"} = $steps if !%coords{"$x,$y"};
}

sub check-and-update-dist (Int $x, Int $y, Int $steps) {
    if (%coords{"$x,$y"} && !%intersected{"$x,$y"}) {
	%intersected{"$x,$y"} = $steps;
	my Int $total-steps = $steps + %coords{"$x,$y"};
	$min-steps = min($min-steps, $total-steps);
	my Int $dist = abs($x) + abs($y);
	$closest = min($closest, $dist);
    }
}

sub parse-input (Str $line, Code $block) {
    my Int ($x, $y) = (0, 0);

    my %DT = %(
	D => sub { $y-- },
	L => sub { $x-- },
	R => sub { $x++ },
	U => sub { $y++ },
    );

    my $move = sub { die "move wasn't set" };
    my Int $steps = 1;

    for split ",", $line -> $instruction {
	my Str $direction = substr $instruction, 0, 1;
	my Int $distance = substr($instruction, 1).Int;

	$move = %DT{$direction};

	for ^$distance {
	    $move();
	    $block($x, $y, $steps++);
	}
    }
}

sub MAIN (Str $input) {
    my Str ($first, $last) = $input.IO.slurp(:close).lines();
    parse-input($first, &insert-coords);
    parse-input($last, &check-and-update-dist);
    say $closest;
    say $min-steps;
}
