#! /usr/bin/perl
#学习perl LWP时用post做的翻译小脚本
#调用的是有道词典
use strict;
use warnings;
use LWP::UserAgent;
use JSON ;
use Data::Dumper;

my $browser = LWP::UserAgent->new();
print "Please input the word:";
chomp (my $input = <STDIN>);
my $response = $browser->post(
	'http://fanyi.youdao.com/translate?smartresult=dict&smartresult=rule&smartresult=ugc&sessionFrom=https://www.google.com.hk/',
	[
		'type' => 'AUTO',
		'i' => "$input",
		'doctype' => 'json',
		'xmlVersion' => '1.6',
		'keyform' => 'fanyi.web',
		'ur' => 'UTF-8',
		'typeResult' => 'true',
		'flag' => 'false'
	],
	);

if($response->is_success){
	my $result = $response->content;
	#open FE,">","b.json";
	#select FE;
	#print $result;
	#select STDOUT;
	my $json = new JSON;
	my $obj = $json->decode($result);
	#print Dumper $obj;
	my $trans = @{$obj->{'translateResult'}[0]}[0]->{"tgt"};
	$trans = "翻译结果：$trans" if $trans;
	my $string;
	eval{
		$string  = join " ", @{$obj->{'smartResult'}->{"entries"}};
	};
	$trans = "$trans\n其他结果:$string" if $string;
	print $trans."\n" // "Not found\n";
}
