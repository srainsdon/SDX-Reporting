#!/usr/bin/perl -w

use strict;
use Excel::Writer::XLSX qw(!get_cell);
use Cwd;
use SdxReporting::Process;
	
    my $dir = getcwd;

    opendir(DIR, $dir) or die $!;

    while (my $file = readdir(DIR)) {

        # We only want files
        next unless (-f "$dir/$file");

        # Use a regular expression to find files ending in .txt
        next unless ($file =~ m/\.xls$/ || $file =~ m/\.XLS$/);

        
		if ($file =~ m/SVCReportsBreakdownByLocByPlanrpt/) {
			print "SVC: $file\n";
			ParceFlex($file);
			#unlink $file;
		} elsif ($file =~ m/BreakdownByLocrpt/) {
			print "LocRpt: $file\n";
			ParceFile($file);
			unlink $file;
		} elsif ($file =~ m/-Dis-/) {
		#print "Dis = $file\n";
		ParceDiscounts($file);
		} else {
		print "$file was not prossesed\n";
		}
		#ParceFile($file);
    }
	my $hash = GetDiscounts();
	foreach my $name (sort keys $hash) {
	next if ($hash->{$name} == 0);
	print '', $name, "\t", $hash->{$name}, "\n";
	}
    closedir(DIR);
    exit 0;