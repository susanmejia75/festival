
##############variables#############

my $csvFile=$ARGV[0]; #"csv input file";
my $outFile=$ARGV[1]; #"csv output file";

######################################

print "\n Reading file : $csvFile\n";
open(OUT,">".$outFile);
open(IN,"<".$csvFile);
my @lines=<IN>;

foreach $line (@lines)
{
	chomp $line;

	my @temp=split(/,/,$line);
	# Check if this is an unassigned spot
	if ($temp[9] eq '')
	{
		next;
	}	
	if ($temp[0] =~ /Activity name/)
	{
		$temp[8]='Last Name,First Name';
		my $newEntry=join(',', @temp);
		print OUT "$newEntry\n";
	}
	else
	{
		# Get rid of booth categories
		my ($category,$booth)=split(/:/,$temp[0]);
		$temp[0]=$booth;

		# Fix phone numbers
		$temp[13]=~s/\-//g;
		$temp[13]=~s/\s+//g;

		# Change the single Name into two fields: Last Name and First Name
		$temp[8]=~s/\"//g;
		if ($temp[8] eq '')
		{
			$temp[8] = '"",""';
		}
		else
		{
			my @tmp=split(/ /,$temp[8]);
			$last = pop @tmp;
			$first = join ' ', @tmp;
                        # If first name is empty, then user probably didn't enter last name, so check Family Name
			if (($first eq '') && ($temp[17] ne ''))
			{
				$first = $last;
				$last = $temp[17];
			}
			#($first,$last)=split(/ /,$temp[8]);
			$temp[8]='"'.$last.'","'.$first.'"';
		}
		my $newEntry=join(',', @temp);
		print OUT "$newEntry\n";
	}
}
close(OUT);
close(IN);
