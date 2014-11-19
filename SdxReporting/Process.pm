#!/usr/bin/perl -w

use strict;
package SdxReporting::Process;
use Spreadsheet::ParseExcel;

use Exporter 'import'; # gives you Exporter's import() method directly
our @EXPORT = qw(ParceFlex ParceFile GetDiscounts ParceDiscounts);  # symbols to export on request

our $Discounts = {
				'Qbot $2.00 Off' => 0,
				'Qbot Free Drink' => 0,
				'CB Free Fountain' => 0,
				'Qbot 50%' => 0,
				'CB $2.00 OFF' => 0,
				'5 Frenzy' => 0,
				'50% Mocha Discount' => 0,
				'Free Quesadilla' => 0,
				
	};

sub SetDiscount {
	my ($Discount) = @_;
	# print "$Discount\n";
	if (exists $Discounts->{ $Discount }) {
	$Discounts->{ $Discount } = $Discounts->{ $Discount } + 1;
	}
}
	
sub GetDiscounts {
	return $Discounts; # return hash reference
}
	
sub ParceDiscounts {
	my ($OldFile) = @_;
    my $parser   = Spreadsheet::ParseExcel->new();
	my $workbook = $parser->parse($OldFile);
    my $GetRow    = 0;
    my $Year = 0;
    my $Day = 0;
    my $Month = 0;
	
	if ( !defined $workbook ) {
        die $parser->error(), ".\n";
    }
    
    for my $worksheet ( $workbook->worksheets() ) {
        
        my ( $row_min, $row_max ) = $worksheet->row_range();
        my ( $col_min, $col_max ) = $worksheet->col_range();
        
        for my $row ( $row_min .. $row_max ) {
            for my $col ( $col_min .. $col_max ) {
                
                my $cell = $worksheet->get_cell( $row, $col );
                next unless $cell;
				next unless ($row > 7);
                next unless ($col == 15);
				if ($cell->value() eq "")
                {
                    next;
                }
				SetDiscount($cell->value());
			}
		}
	}
}
	
sub ParceFlex{
	my ($OldFile) = @_;
    my $parser   = Spreadsheet::ParseExcel->new();
    my $workbook = $parser->parse($OldFile);
    my $GetRow    = 0;
    my $Year = 0;
    my $Day = 0;
    my $Month = 0;
    my $FileName;
    my $RecordTime;
    my $NewRow = 0;
    my $Newworkbook;
    my $Newworksheet;
	my $FlexCount = {
					' 6:00:00AM' => 0,
					' 6:15:00AM' => 0,
					' 6:30:00AM' => 0,
					' 6:45:00AM' => 0,
					' 7:00:00AM' => 0,
					' 7:15:00AM' => 0,
					' 7:30:00AM' => 0,
					' 7:45:00AM' => 0,
					' 8:00:00AM' => 0,
					' 8:15:00AM' => 0,
					' 8:30:00AM' => 0,
					' 8:45:00AM' => 0,
					' 9:00:00AM' => 0,
					' 9:15:00AM' => 0,
					' 9:30:00AM' => 0,
					' 9:45:00AM' => 0,
					'10:00:00AM' => 0,
					'10:15:00AM' => 0,
					'10:30:00AM' => 0,
					'10:45:00AM' => 0,
					'11:00:00AM' => 0,
					'11:15:00AM' => 0,
					'11:30:00AM' => 0,
					'11:45:00AM' => 0,
					'12:00:00PM' => 0,
					'12:15:00PM' => 0,
					'12:30:00PM' => 0,
					'12:45:00PM' => 0,
					' 1:00:00PM' => 0,
					' 1:15:00PM' => 0,
					' 1:30:00PM' => 0,
					' 1:45:00PM' => 0,
					' 2:00:00PM' => 0,
					' 2:15:00PM' => 0,
					' 2:30:00PM' => 0,
					' 2:45:00PM' => 0,
					' 3:00:00PM' => 0,
					' 3:15:00PM' => 0,
					' 3:30:00PM' => 0,
					' 3:45:00PM' => 0,
					' 4:00:00PM' => 0,
					' 4:15:00PM' => 0,
					' 4:30:00PM' => 0,
					' 4:45:00PM' => 0,
					' 5:00:00PM' => 0,
					' 5:15:00PM' => 0,
					' 5:30:00PM' => 0,
					' 5:45:00PM' => 0,
					' 6:00:00PM' => 0,
					' 6:15:00PM' => 0,
					' 6:30:00PM' => 0,
					' 6:45:00PM' => 0,
					' 7:00:00PM' => 0,
					' 7:15:00PM' => 0,
					' 7:30:00PM' => 0,
					' 7:45:00PM' => 0,
					' 8:00:00PM' => 0,
					' 8:15:00PM' => 0,
					' 8:30:00PM' => 0,
					' 8:45:00PM' => 0,
					' 9:00:00PM' => 0,
	};
    
    if ( !defined $workbook ) {
        die $parser->error(), ".\n";
    }
    
    for my $worksheet ( $workbook->worksheets() ) {
        
        my ( $row_min, $row_max ) = $worksheet->row_range();
        my ( $col_min, $col_max ) = $worksheet->col_range();
        
        for my $row ( $row_min .. $row_max ) {
            for my $col ( $col_min .. $col_max ) {
                
                my $cell = $worksheet->get_cell( $row, $col );
                next unless $cell;
                if ($cell->value() eq "")
                {
                    next;
                }
                if (($cell->value() =~ m/(\d+)\/(\d+)\/(\d+)/) && ($Day == 0)) {
					next if ($col > 0);
                    $Year = $3;
                    $Month = sprintf("%02d", $1);
                    $Day = sprintf("%02d", $2);
                    $FileName = "$Year-$Month-$Day-Flex.xlsx";
                    print "$FileName\n";
                    $Newworkbook = Excel::Writer::XLSX->new( $FileName );
                    $Newworksheet = $Newworkbook->add_worksheet();
                }
				if ($GetRow) {
					next if ($cell->value() eq 'Page');
                    # print "Row, Col    = ($row, $col)\n";
                    # print $RecordTime, ", " , $cell->value(),       "\n";
					$FlexCount->{ $RecordTime } = $FlexCount->{ $RecordTime } + $cell->value(); 
                    # print "Unformatted = ", $cell->unformatted(), "\n";
                    # $Newworksheet->write( $NewRow, 0, $RecordTime );
                    # $Newworksheet->write( $NewRow, 1, $cell->value() );
                    $GetRow = 0;
                    # $NewRow++;
                }
                if ($cell->value() =~ /\d:\d\d:\d\d\D\D/) {
					next if ($col > 3);
                    # print "Row, Col    = ($row, $col)\n";
                    $RecordTime = $cell->value();
					# $RecordTime =~ s/^\s+|\s+$//g; # Trim
                    # print "Unformatted = ", $cell->value(), "\n";
                    $GetRow = 1;
                }
            }
        }
    }
	# while( my ($k, $v) = each $FlexCount ) {
	# print "key: $k, value: $v.\n";
	# }
	foreach my $name (sort keys $FlexCount) {
		# print $name, ' ', $FlexCount->{$name}, "\n";
		#$Newworksheet->write( $NewRow, 0, $name );
        #$Newworksheet->write( $NewRow, 1, $FlexCount->{$name} );
        #$NewRow++;
		ParceDateTime($name, $FlexCount->{$name})
	}
}

sub ParceDateTime{
	my ($TimeCode, $count) = @_;
	#('%Y-%m-%d %H:%M:%S')
	@interval = $TimeCode =~ qr/(\d\d:\d\d)/;
	print "$interval[0] $count\n";
	
}

sub ParceFile{
	my ($OldFile) = @_;
    my $parser   = Spreadsheet::ParseExcel->new();
    my $workbook = $parser->parse($OldFile);
    my $GetRow    = 0;
    my $Year = 0;
    my $Day = 0;
    my $Month = 0;
    my $FileName;
    my $RecordTime;
    my $NewRow = 0;
    my $Newworkbook;
    my $Newworksheet;
	my $ColCount = 0;
    
    if ( !defined $workbook ) {
        die $parser->error(), ".\n";
    }
    
    for my $worksheet ( $workbook->worksheets() ) {
        
        my ( $row_min, $row_max ) = $worksheet->row_range();
        my ( $col_min, $col_max ) = $worksheet->col_range();
        
        for my $row ( $row_min .. $row_max ) {
            for my $col ( $col_min .. $col_max ) {
                
                my $cell = $worksheet->get_cell( $row, $col );
                next unless $cell;
                if ($cell->value() eq "")
                {
                    next;
                }
                if ($cell->value() =~ m/DateTime\((\d+), (\d+), (\d+), 1, 0, 0\)/) {
                    $Year = $1;
                    $Month = sprintf("%02d", $2);
                    $Day = sprintf("%02d", $3);
                    $FileName = "$Year-$Month-$Day-Bobs.xlsx";
                    print "$FileName\n";
                    $Newworkbook = Excel::Writer::XLSX->new( $FileName );
                    $Newworksheet = $Newworkbook->add_worksheet();
                }
                if ($GetRow) {
				$ColCount++;
                    #print "Row, Col    = ($row, $col)\n";
                    #print $RecordTime, ", " , $cell->value(),       "\n";
                    #print "Unformatted = ", $cell->unformatted(), "\n";
					if ($ColCount == 3) {
                    $Newworksheet->write( $NewRow, 0, $RecordTime );
                    $Newworksheet->write( $NewRow, 1, $cell->value() );
                    $GetRow = 0;
                    $NewRow++;
					$ColCount = 0;
					}
                }
                if ($cell->value() =~ /\d:\d\d:\d\d\D\D/ && $col == 2) {
                    #print "Row, Col    = ($row, $col)\n";
                    $RecordTime = $cell->value();
                    #print "Unformatted = ", $cell->unformatted(), "\n";
                    $GetRow = 1;
                }
            }
        }
    }
}

1;