#!/usr/bin/perl
use 5.028;
use strict;
use warnings;

my @VALUES;
my $VERBOSE = 0;

my $DT = {
    1 => sub ($$) {
	return $_[0] + $_[1];
    },
    2 => sub ($$) {
	return $_[0] * $_[1];
    },
    DEFAULT => sub ($) {
	my $opcode = shift || 0;
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

my $target = 0;

if (scalar @ARGV >= 2) {
    $target = $ARGV[1];
    $VERBOSE = $ARGV[2] || 0;
    parse_input_file($ARGV[0]);
} else {
    say "Please provide an input file and a target.";
    exit 1;
}

my @ORIGINAL_VALUES = @VALUES;

my $noun = 0;
my $verb = 0;

$VALUES[1] = $noun;
$VALUES[2] = $verb;

run_program;

while ($VALUES[0] != $target) {
    say "N: $noun, V: $verb, O: $VALUES[0]" if $VERBOSE;
    if ($verb > 99) {
	$verb = 0;
	$noun++;
    } else {
	$verb++;
    }
    
    @VALUES = @ORIGINAL_VALUES;

    $VALUES[1] = $noun;
    $VALUES[2] = $verb;

    run_program;
}

say "Found target: $target";
say "N: $noun, V: $verb, O: $VALUES[0]";
