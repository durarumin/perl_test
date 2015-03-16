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
my @origin = ("test1", "test3", "test4");

#use List::Compare
my $lc = List::Compare->new(\@domains, \@origin);
my @domainlist = $lc->get_Lonly;
my @originlist = $lc->get_Ronly;

#print "domains list\n";
#print Dumper @domainlist;

#print "original list\n";
#print Dumper @originlist;

#other
my %seen;
my @diff;

#参照元リスト
#先に参照元リストをハッシュに入れておく
foreach my $item(@domains){
    $seen{$item} = 1;
}

#検査したいリスト
#A-Bの差分（Aにしかない）リストが抽出できる。
#Bにしかないデータは抽出できない
foreach my $item (@origin){
    unless($seen{$item}){
        push(@diff, $item);
    }
}
print "diff list\n";
print Dumper @diff;

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
