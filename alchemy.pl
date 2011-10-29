#!/usr/local/bin/perl

#initialize with base elements
$elements{"air"}=1;
$elements{"earth"}=1;
$elements{"fire"}=1;
$elements{"water"}=1;

$combinations_file="combinations.txt";

#read combinations file, create elements and hash array
open (COMBINATIONS, "$combinations_file");

##for each line
while (<COMBINATIONS>) {
	###split into element1/2, result
	###if element 1/2 not in elements, add to elements
	###add result to has array at {element1}{element2}

	chomp;
	($element1, $element2, $res) = split(/ /);
	#ensure correct ordering of elements
	($element1, $element2) = sort { $a cmp $b } ($element1, $element2);

	$elements{$element1}=1;
	$elements{$element2}=1;
	$results{$element1}{$element2}=$res;

	#make sure any resulting element is added to the elements list
	my @new_elements = split(/,/, $res);
	foreach my $new_element	(@new_elements) {
		unless ($new_element eq 'x') { $elements{$new_element}=1; }
	}
}
close (COMBINATIONS);

#loop: find first untried combination
##prompt user for result
##add to combinations file
##if new elements, add to elements list

$exit = "no";
until ( $exit eq "yes" ) {
	$found_unknown = "false";
	LOOP: foreach $key1 (sort keys %elements) {
		foreach $key2 (sort keys %elements) {
			next if ( $key1 gt $key2 );
			unless ( defined($results{$key1}{$key2}) ) {
				$element1 = $key1;
				$element2 = $key2;
				$found_unknown = "true";
				last LOOP;
			}
		}
	}
	if ( $found_unknown eq "false" ) {
		die("No untried combinations.\n");
	}
	print "Result of $element1 - $element2: ";
	$new_result = <STDIN>;
	chomp($new_result);
	if ( $new_result eq "" ) {
		$exit = "yes";
	} else {
		#add new elements
			my @new_elements = split(/,/, $new_result);
			foreach my $new_element	(@new_elements) {
			unless ($new_element eq 'x') { $elements{$new_element}=1; }
			}
		#add new results
		$results{$element1}{$element2} = $new_result;
		#write the new result to the combinations file
		open (COMBINATIONS, ">>$combinations_file");
		print COMBINATIONS "$element1 $element2 $new_result\n";
		close (COMBINATIONS);
	}
}
