#! /usr/bin/perl
use strict;
use warnings;
use File::Find 'find';

#补全安装模块
my $LIST_DIR = "$ENV{HOME}/.vim_extras/";
my $LIST_FILE = "file_perl_module";

unless(-e $LIST_DIR){
	mkdir $LIST_DIR or die "Couldn't create directory $LIST_DIR($!)\n";
}
open my $fh,">","$LIST_DIR$LIST_FILE" or die "Couldn't create file '$LIST_FILE'($!)\n";

my %already_seen;
for my $incl_dir (@INC){
	find{
		wanted => sub{
			my $file = $_;
			return unless $file =~ /\.pm\z/;
			$file =~ s#^\Q$incl_dir/\E##;
			$file =~ s{/}{::}g;
			$file =~ s#\.pm\z##;
			print {$fh} $file,"\n" unless $already_seen{$file}++;
		},
		no_chdir => 1,
	},$incl_dir;
}
