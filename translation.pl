use LWP::Simple;
use JSON;
use Data::Dumper;
use URI::Escape;
use Encode;

##baidu translation API demo
##http://openapi.baidu.com/public/2.0/bmt/translate?client_id=YourApiKey&q=today&from=auto&to=auto
##baidu dict api demo
##http://openapi.baidu.com/public/2.0/translate/dict/simple?client_id=YourApiKey&q=do&from=en&to=zh
##
#$base = "http://openapi.baidu.com/public/2.0/bmt/translate";
$base = "http://openapi.baidu.com/public/2.0/translate/dict/simple";
$APIKEY='geHaGXAL96ZBkuIvqDvHGGDV';

$DEBUG = 1 if(@ARGV[0] eq 'D');
	

while(1){
	$input_base = <STDIN>;
	chomp($input_base);
	$input =  uri_escape_utf8(decode('gbk',$input_base));
	$trans_url = $base."?client_id=".$APIKEY."&q=".$input."&from=auto&to=auto";
	if ($DEBUG){
		print $trans_url;
		print "\n";
	};
	$content=get($trans_url);
	$result = decode_json($content);
	 if ($DEBUG){
		print Dumper $result;
		print "\n";
	};
	$data = $result->{data};
	eval{
		@symbols = $data->{symbols};
	};if($@){
		print "$input\n";
		next;
	};

	for $symbol (@symbols){
			for my $sub (@{$symbol}){
				
				for my $part (@{$sub->{parts}})
				{
					print encode('gb2312',$part->{part})."\n	";
					for my $mean (@{$part->{means}}){
						print encode('gb2312',$mean);
						print "; ";
					}
					print "\n";
				}
			}
	}
	print "-------------------------------end------------------------------\n";
}

