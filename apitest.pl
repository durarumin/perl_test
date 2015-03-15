#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use JSON 'decode_json';

#ファイルの取得はapiシミュレートのため
my $file = shift;
unless ($file){
    die "Usage: filename"   
}

my $list = decode_json(json_generate($file));

print Dumper $list;
print "$list->{error}->{errors}->[0]->{domain}\n"; 

#jsonを取得する。apiでの取得をシミュレート
sub json_generate{
    my $file = shift;
 
    open my $fh, '<', $file or die $!; 
    my @json = <$fh>;
    close($fh);

    my $line;
        foreach my $item (@json){
        $line = "$line$item";
    };
    return $line;
} 
