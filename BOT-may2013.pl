use Irssi;
use vars qw($VERSION %IRSSI);
use strict;
use warnings;
use URI;
use Web::Scraper;
use WWW::WolframAlpha;

#  PEP 20
#
#    Beautiful is better than ugly.
#    Explicit is better than implicit.
#    Simple is better than complex.
#    Complex is better than complicated.
#    Readability counts. 


$VERSION = "0.1b";
%IRSSI = (
    author => 'artoo',
    contact => 'artoo@inventati.org',
    name => 'R2-D2',
    description => 'A nice chap',
    license => 'GNU GPL'
);


sub event_privmsg {
	
my ($server, $data, $nick, $mask) =@_;
my ($target, $text) = $data =~ /^(\S*)\s:(.*)/;
my @biscotto = ();
my @bestemmia= ();
my @answer = ();
my @risposta = ();
open my $rand, '<', '/dev/urandom' or die "could not open /dev/urandom:$!"; 


	if ($text=~/^man\s{1}R2-D2\s{0,1}$/){
		$server->command ( "query $nick I comandi fanno quello che dicono e lo fanno in canale anche se richiesti tramite query. !wolfram invece puo' usare l'opzione -q per pastare in query o -c per pastare in canale.");
		$server->command ( "query $nick COMMAND LIST:");
		$server->command ( "query $nick !wolfram -q|-c [whatever]  (le parentesi quadre contano)");
		$server->command ( "query $nick abuse !nickname");
		$server->command ( "query $nick !biscotto");
		$server->command ( "query $nick !bestemmia");
		$server->command ( "query $nick !chuck (sputa un fatto su Chuck Norris)" );
	        $server->command ( "query $nick !riddle (richiede un indovinello a caso. per rispondere invece: #n !risposta   -> dove n= numero indovinello");
	        $server->command ( "query $nick !riddle #n  (riporta l'indovinello numero `n'");
	}


#WOLFRAM ALPHA QUERY
	if ($text =~ /^!wolfram\s+/i and $text=~/-c/i and $text=~/-q/i) {
		$server->command ( "msg $target Ambiguous command you jerk. Use !wolfram -q [whatever] to print output in a query and !wolfram -c [whatever] to print results here");
	}
	elsif ($text =~ /^!wolfram\s{0,1}.*/i and $text!~/.-c\s|.-q\s/i) {
		$server->command ( "msg $target Use !wolfram -q [whatever] to print output in a query and !wolfram -c [whatever] to print results here");
	}
	elsif ($text =~ /^!wolfram\s{0,1}.*/i and $text=~/.-c\s/) {
		my $test = $text =~ /\[(.*?)\]/;
		my $GREP = $1;
		my $wa = WWW::WolframAlpha->new (
	    	appid => 'VP5KR8-4GEA5873QU',
		);
	
		my $query = $wa->query(
		    'input' => $GREP,
		    'scantimeout' => 3,
		);
	
		if ($query->success) {
			#my @output=();
			foreach my $pod (@{$query->pods}) {
				my @output=();
				if (!$pod->error) {
					push @output, $pod->title, ": " if $pod->title;
					foreach my $subpod (@{$pod->subpods}) {
					push @output, $subpod->plaintext, ""if $subpod->plaintext;
					push @output, $subpod->title, "" if $subpod->title;
					$server->command ( "msg #pollaio @output"); 
					# use: $server->command ( "msg $target @output"); to pick channel name from the variable
				}
				}
			}
			#$server->command ( "msg $target @output2");
		}
	}

	elsif ($text =~ /^!wolfram\s{0,1}.*/i and $text=~/.-q\s/) {
		my $test = $text =~ /\[(.*?)\]/;
		my $GREP = $1;
		my $wa = WWW::WolframAlpha->new (
	    	appid => 'VP5KR8-4GEA5873QU',
		);
	
		my $query = $wa->query(
		    'input' => $GREP,
		    'scantimeout' => 3,
		);
	
		if ($query->success) {
			#my @output=();
			foreach my $pod (@{$query->pods}) {
				my @output=();
				if (!$pod->error) {
					push @output, $pod->title, ": " if $pod->title;
					foreach my $subpod (@{$pod->subpods}) {
					push @output, $subpod->plaintext, ""if $subpod->plaintext;
					push @output, $subpod->title, "" if $subpod->title;
					$server->command ( "query $nick @output");
				}
				}
			}
		#$server->command ( "msg $target @output2");
		}
	}



# IDENTITY 
	
	if ($text =~ /^ciao.R2-D2\s*.*$|^R2-D2\s*.*creato\?$|^R2-D2\s*.*sei\?$/i) {
        	$server->command ( "msg $target sono un astromech droid R2-series, assemblato da Industrial Automaton e riprogrammato da artoo (scrivi 'man R2-D2' per una lista di funzioni)" );
	}
	
	
#QUESTIONS
#
	elsif ($text =~ /^R2-D2\s*.*\?$/i ) {
        	open ( SKY, "</home/pi/.irssi/risposte" )or die "can't open risposte:$!\n";
		chomp( @risposta = <SKY> );
		close SKY;
		my $ia; 
		{ local $/ = \1; $ia = int ord(<$rand>) / 256 * 19 }
		my $answer = $risposta[$ia];
        	$server->command ( "msg $target $answer" );
	}

	




#INSULT REQUEST TO NICK
#
	#
	elsif ($text =~/^abuse\s*.*/i and $text!~/!\w+/){
		$server->command ("query $nick Use: abuse !nickname");
	}

	elsif ($text =~/^abuse\s!\w*/i and $text=~/!R2-D2/i){
		my $insult = scraper {
			process "div#insult", insult => 'TEXT';
			result 'insult';
			};
		my $uri3 = URI->new("http://www.autoinsult.com/webinsult.php?style=3");
		my $out = $insult->scrape ($uri3);
		$server->command ("msg $target $nick, $out ");
	} 
	
	elsif ($text =~/^abuse\s!\w*/i and $text!~/elverde|putiferica/i){
		my $test = $text=~ /\!(.*?$)/;
		my $grep = $1;
		my $insult = scraper {
			process "div#insult", insult => 'TEXT';
			result 'insult';
			};
		my $uri3 = URI->new("http://www.autoinsult.com/webinsult.php?style=3");
		my $out = $insult->scrape ($uri3);
		$server->command ("msg #pollaio $grep, $out ");
	}


#INSULT REQUEST TO elVerde and putiferica
#
	elsif ($text =~ /^abuse\s!\w*/i and $text=~/!putiferica/i){
		my $comp = scraper {
			process "h3.blurb_title_1", comp => 'TEXT';
			result 'comp';
			};
		my $uri1 = URI->new("http://toykeeper.net/programs/mad/compliments");
		my $compget= $comp->scrape ($uri1);
		$server->command ("msg #pollaio putiferica, $compget");	
	}

	elsif ($text =~ /^abuse\s!\w*/i and $text=~/!elVerde/i){
		my $verde = scraper {
			process "div.generation", verde => 'TEXT';
			result 'verde';
			};
		my $uri0 = URI->new("http://www.polygen.org/it/grammatiche/costume_e_societa/ita/insulti.grm");
		my $grey = $verde->scrape ($uri0);
		$server->command ("msg #pollaio elVerde, $grey");	
	}

#	elsif ($text =~ /!futuro|!oroscopo/i){
#		my $prophecy = scraper {
#			process "div#container", abuse => 'TEXT';
#			result 'abuse';
#			};
#		my $uri4 = URI->new("http://slinky.imukuppi.org/nostra/");
#		my $pro = $prophecy->scrape ($uri4);
#		$server->command ( "msg $target $pro");
#	}

	#my $test = $text=~ /\!(.*?$)/;
	#	my $grep = $1;
	#	my $NKinsult = scraper {
	#		process "div#insultContainer", nki => 'TEXT';
	#		result 'nki';
	#		};
	#	my $NKuri = URI->new("http://www.nk-news.net/extras/insult_generator.php");
	#	my $NKget= $NKinsult->scrape ($NKuri);
		#	$server->command ("msg $target $grep, $NKget");	
	#	}

# BESTEMMIE

	elsif ($text =~ /!bestemmia\s*|^dio\sporco\s*/i and $text!~/^abuse/i){
		open ( SKY, "</home/pi/.irssi/bestemmie" )or die "can't open bestemmie:$!\n";
		chomp( @bestemmia = <SKY> );
		close SKY;
		my $ia; 
		{ local $/ = \1; $ia = int ord(<$rand>) / 256 * 59 }
		my $answer = $bestemmia[$ia];
        	$server->command ( "msg #pollaio $answer" );
	}



#CHUCK NORRIS

	elsif ($text =~/!chuck\s*/ and $text!~/^abuse/i) {
	        my $grep = $1;
		my $insult = scraper {
			process "div#wia_factBox", insult => 'TEXT';
			result 'insult';
			};
			my $uri3 = URI->new("http://www.whatisawesome.com/chuck");
			my $out = $insult->scrape ($uri3);
		$server->command ( "msg #pollaio $out");
		}





# BISCUITS	

	elsif ($text =~/!biscotto/ and $text!~/^abuse/i) {
	        open ( JAR, "</home/pi/.irssi/biscotti" )or die "can't open biscotti:$!\n";
		chomp( @biscotto = <JAR> );
		close JAR;
		my $ia; 
		{ local $/ = \1; $ia = int ord(<$rand>) / 256 * 59 }
		my $answer = $biscotto[$ia];
        	$server->command ( "msg #pollaio $answer" );
	} 

	
	elsif ($text=~/^!wargames$/i) {
	
		$server->command ("nick MINSK-1");
		$server->command ("msg $target Обнаружение несущей.");
		$server->command ("msg $target Подключение 128000.");
		$server->command ("msg $target Welcome to Protovision Systems, Sunnyvale, CA.");
		$server->command ("msg $target WOPR Не работает -  近义词 - ตายแล้ว - muerto - 죽은 - chết");
		$server->command ("msg $target Последней игры: GLOBAL THERMONUCLEAR WAR.");
		$server->command ("Всеобщая вера в революцию есть уже начало революции. - Ленин");
		$server->command ("nick R2-D2");
	}




		
#RIDDLES
#
#
	elsif ($text =~ /^!riddle$/i ){
		open my $riddles, '<', '/home/pi/.irssi/riddle' or die "could not open riddle:$!\n";	
		my @list;
		while (<$riddles>){
			chomp;
			my ($key, @values) = split /#/;
			$list[$key] = \@values;
			}
		my $ia; 
		{ local $/ = \1; $ia = int ord(<$rand>) / 256 * 171 }	
		my $question = $list[$ia][0]; #, @{$list[$ia]};
		$server->command ("msg $target #$ia $question");
	}

	elsif ($text =~ /^!riddle\s#\d+$/i ){
			
		my $test1 = $text=~/\#(.*?)$/;
		my $num = $1;
		open my $riddles, '<', '/home/pi/.irssi/riddle' or die "could not open riddle:$!\n";
		my @list;
		while (<$riddles>){
			chomp;
			my ($key, @values) = split /#/;
			$list[$key] = \@values;
			}
		my $question = $list[$num][0]; #, @{$list[$num]};
		$server->command ("msg $target $question");
	}

      	elsif ($text =~/^#\d*\s!\.*/i ){
		my $test1 = $text=~/\#(.*?)\s/;
	      	my $num = $1;
		my $test2 = $text=~ /\!(.*?)$/;
		my $risp = $1;
		open my $riddles, '<', '/home/pi/.irssi/riddle' or die "could not open riddle:$!\n";	
		my @list;
		while (<$riddles>){
			chomp;
			my ($key, @values) = split /#/;
			$list[$key] = \@values;
			}
		my $correct = $list[$num][1]; #, @{$list[$num]};
		$correct = lc($correct);
		$risp = lc($risp);
		if ($risp eq $correct){
			$server->command ("msg $target $nick, THAT IS CORRECT");
		}	
		else {
			my $insult = scraper {
			process "table#AutoNumber1", insult => 'TEXT';
			result 'insult';
			};
			my $uri2 = URI->new("http://www.randominsults.net/");
			my $get = $insult->scrape ($uri2);
			$server->command ("msg $target INCORRECT $nick! $get");
			

		}
	}

#INSULTS IF ENGAGED WITHOUT REASON
#
#
	elsif ($text =~ /^R2-D2\s.+/i ){
		my $insult = scraper {
			process "table#AutoNumber1", insult => 'TEXT';
			result 'insult';
			};
		my $uri2 = URI->new("http://www.randominsults.net/");
		my $get = $insult->scrape ($uri2);
		$server->command ("msg $target $nick, $get ");	
	}



#end of script
}



Irssi::signal_add('event privmsg', 'event_privmsg');
