#!/usr/bin/perl
use 5.028;
use strict;
use warnings;

my @VALUES;

my $DT = {
    1 => sub ($$) {
	return $_[0] + $_[1];
    },
    2 => sub ($$) {
	return $_[0] * $_[1];
    },
    DEFAULT => sub ($) {
	my $opcode = shift;
	warn "Invalid opcode: $opcode";
    },
};

sub parse_input_file ($) {
    my $input_file = shift;

    open(my $fh, "<", $input_file) or die "Can't open $input_file: $!";

    while (my $line = <$fh>) {
	chomp $line;

	push @VALUES, split ",", $line;
    }

    close $fh;
}

sub execute ($$$$) {
    my $proc = shift;
    my $a = shift;
    my $b = shift;
    my $target = shift;

    $VALUES[$target] = $proc->($VALUES[$a], $VALUES[$b]);
}

sub run_program {
    my $index = 0;
    my $step = 4;

    while ($VALUES[$index] != 99) {
	if ($DT->{$VALUES[$index]}) {
	    execute($DT->{$VALUES[$index]}, $VALUES[$index + 1], $VALUES[$index + 2], $VALUES[$index + 3]);
	} else {
	    $DT->{"DEFAULT"}->();
	    exit 1;
	}
	$index += $step;
    }
};

if (@ARGV) {
    parse_input_file($ARGV[0]);
} else {
    say "Please provide an input file.";
    exit 1;
}

$VALUES[1] = 12;
$VALUES[2] = 2;

run_program;

say join ":", @VALUES;
