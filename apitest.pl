#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use JSON 'decode_json';

my $file = shift;
unless ($file){
    die "Usage: filename"   
}

open my $fh, '<', $file or die $!; 

my @json;
@json = <$fh>;

close($fh);
my $line;

foreach my $item (@json){
    $line = "$line$item";
};

my $djson = decode_json($line);

print Dumper $djson;


