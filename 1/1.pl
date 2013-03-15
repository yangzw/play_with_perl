#! /usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use utf8;

open (IN1, $ARGV[0]) or die $!;
open (IN2, $ARGV[1]) or die $!;
open (OUT, ">$ARGV[2]") or die $!;


my %h;
my $title1 = <IN1>;
while(<IN1>){
	chomp;
	my @m=split(/\t/,$_);
	push @{ $h{$m[0]} }, $m[1]; 
}             

my $title2 = <IN2>;         
while(<IN2>)                                          
{                                                     
	my ($sTerm, $sGenes) = split(/\t/,$_, 2);
	my @aGenes = split /\s*,\s*/ => $sGenes;
	my ( @barcode, %hUniq );
	for my $g (@aGenes) {
		next unless exists $h{$g};
		map { push @barcode, $_ } grep { !$hUniq{$_}++ } @{ $h{$g} };
	}
	print OUT "$sTerm\t@barcode\n";
}
