#!/usr/bin/perl

if (!-d 'ceoorissa.nic.in') {system("mkdir ceoorissa.nic.in");}
if (!-d 'ceoorissa.nic.in/Voter-List-2014') {system("mkdir ceoorissa.nic.in/Voter-List-2014");}

use WWW::Mechanize;
my $ua = WWW::Mechanize->new(agent=>'Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.0.16)',cookie_jar=>{},onerror=>undef);

$ua->get("http://ceoorissa.nic.in/erollpdf.asp");

for ($c=1;$c<=147;$c++) {

    print "Download constituency $c\n";
    
    if (!-d 'ceoorissa.nic.in/Voter-List-2014/'.$c)  {system("mkdir ceoorissa.nic.in/Voter-List-2014/$c");}
    
    my $const = $c;
    
    if ($const <10) {$const="00$const"}
    elsif ($const <100) {$const="0$const"}
    
    for ($no=1;$no<500;$no++) {
	my $part;
	if ($no <10) {$part="00$no"}
	elsif ($no <100) {$part="0$no"}
	else {$part="$no"}
	
	if (!-e "ceoorissa.nic.in/Voter-List-2014/$const/$const-$part-Mother.pdf") {
	    my $result=$ua->get( "http://ceoorissa.nic.in/erolls/pdf/ORIYA/A".$const."/A".$const."0".$part.".pdf", ':content_file' => 'ceoorissa.nic.in/Voter-List-2014/'.$c.'/'.$const."-".$part."-Mother.pdf" );
	    next if $result->code == 404;
	    if ($result->is_error) {
		open (REPORT,">>ceoorissa.nic.in/Voter-List-2014/".$c.'/$const.failure');
		print REPORT "Failed to download roll $part: ".$result->status_line."\n";
		close (REPORT);
	    }
	}
	
	if (!-e "ceoorissa.nic.in/Voter-List-2014/$const/$const-$part-Supp.pdf") {
	    my $result=$ua->get( "http://ceoorissa.nic.in/erolls/pdf/Supp1/A".$const."/SI".$const."0".$part.".pdf", ':content_file' => 'ceoorissa.nic.in/Voter-List-2014/'.$c.'/'.$const."-".$part."-Supp.pdf" );
	    next if $result->code == 404;
	    if ($result->is_error) {
		open (REPORT,">>ceoorissa.nic.in/Voter-List-2014/".$c.'/$const.failure');
		print REPORT "Failed to download supplementary roll $part: ".$result->status_line."\n";
		close (REPORT);
	    }
	}
        
    }
}