#! /usr/bin/perl
use strict;
use warnings;

my $tags;
foreach my $dir (@INC){
	if(!($dir =~ m/site_perl|\.$/)){
		chdir $dir or die "cannot chdir $dir$!\n";
		system 'sudo ctags -R --languages=perl --langmap=perl:+.pl';
		$tags  = $tags . "\nset tags+=$dir/tags";}
}
open (my $vimrc,'>>',"$ENV{HOME}/.vimrc");
print {$vimrc} $tags;
