#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use JSON 'decode_json';
use List::Compare;

#ファイルの取得はapiシミュレートのため
my $file = shift;
unless ($file){
    die "Usage: filename"   
}

my $list = decode_json(json_generate($file));
my @domains = get_domain_list($list->{error}->{errors});

print Dumper @domains;

my @origin = ("test1", "test3");

my $lc = List::Compare->new(\@domains, \@origin);

my @domainlist = $lc->get_Lonly;
my @originlist = $lc->get_Ronly;

print "domains list\n";
print Dumper @domainlist;

print "original list\n";
print Dumper @originlist;

#domainのみを取り出す
sub get_domain_list{
    my $list_ref = shift;
    my @domains;

    foreach my $item (@$list_ref){
        push(@domains, $item->{domain});
    }
    return @domains;
}    

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
