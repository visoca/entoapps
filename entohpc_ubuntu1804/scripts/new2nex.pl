#!/usr/bin/env perl

# (c) Victor Soria-Carrasco
# victor.soria.carrasco@gmail.com
# Last modified: 06/06/2022 14:30:26

# Description:
# Converts a tree from newick format to nexus
#
# Usage:
# new2nex.pl <newick file>

# Changelog
# 1.02 - Added possibility to choose field separator
#      - Colours assigned alphabetically for consistency

use warnings;
use strict;
use Bio::Perl;
use Bio::TreeIO;
use IO::String;
use File::Basename;
use Getopt::Long qw(:config ignore_case_always);

my $version='1.02-2022.06.06';

&author;

my $debug=1;
my ($infile, $outfile);
my $colour=0;
my $field=0; # name fields
my $sep='-'; # name field separator
my $outgroup;
my $textrem;
my $consensus=0;
GetOptions( 
    'i=s'    => \$infile, 
    'o=s'    => \$outfile, 
    'c'      => \$colour, 
    'f=i'    => \$field, 
    's=s'    => \$sep,
	'g=s'    => \$outgroup,
	't=s'    => \$textrem,
	'x'      => \$consensus,
    'h|help' => \&usage 
) or print ("\nERROR: Option/s not recognized (see above)\n") and &usage;

&usage if (!defined($infile));

if (!defined($outfile)){
	$outfile=$infile;
	$outfile=~ s/\.new(ick)?$/\.nex/g;
}
$outfile.='.nex' if ($infile eq $outfile); # avoid overwriting input file


my $in='';
if ($consensus){
	my $string='';
	open (FILE, "$infile")
		or die ("\nCan't open input file\n\n");
		while (<FILE>){
			s/\:1\.0\[([0-9]+)\]/$1/g;
			# s/\:(1\.0)?//g;
			s/\:(1\.0)?/\:999/g;
			s/\)([0-9]+(\.[0-9]+)?)([:1\.0|999])?/\)$1:999/g;
			$string.=$_;
			print "\n\n---------$string----------\n\n";
		}
	close (FILE);

	my $input = IO::String->new($string);
	$in = Bio::TreeIO->new(
		-fh => $input, 
		-format => 'newick');
}
else{
	$in = Bio::TreeIO->new(
		-file => "$infile", 
		-format => 'newick',
		-internal_node_id => 'bootstrap');
}

my $out= Bio::TreeIO->new(
		-file => ">$outfile",
		-format => 'nexus', 
		-translate=>1,
		-header=>1,
		-internal_node_id => 'bootstrap',
		-bootstrap_style=>'traditional'); 

my $i=1;
my @taxa=();
while (my $t = $in->next_tree) {
	my @leaves=$t->get_leaf_nodes;
	if (!defined($taxa[0])){
		foreach my $l (@leaves){
			if (defined($textrem)){
				my $tn=$l->id;
				$tn=~ s/$textrem//g;
				$l->id("$tn");
			}
			push (@taxa, $l->id);
		}
	}

	if (defined($outgroup)){
		# find lca and root on that node
		my @aux=split(/\,/,$outgroup);
		my @outgroup_leaves;
		foreach my $a (@aux){
			my $nd=$t->find_node(-id=>"$a")
				or die ("\nERROR: Cannot find node $a in the tree (outgroup)\n\n");
			push (@outgroup_leaves, $nd);
		}
		my $lca=$t->get_lca(@outgroup_leaves);
		# $t->reroot($lca); # long branch to ingroup
		# $t->reroot($lca->ancestor); # long branch to outgroup
		my $bts=$lca->bootstrap();
		$t->reroot_at_midpoint($lca);
		my $root=$t->get_root_node();
		my @rootdesc=$root->each_Descendent;
		foreach my $rd (@rootdesc){
			$rd->bootstrap($bts) if (defined($bts));
		}
	}
	else{
		my $root=$t->get_root_node();
		if (($root->each_Descendent)>2){ # unrooted tree
			# unroot tree (i.e. root with a leaf)
			$t->reroot($leaves[0]);
		}

	}
	
	# rename tree
	my $treeid=sprintf("TREE_%04d", $i);
	$t->id($treeid);
	
	# write out tree
	$out->write_tree($t);
	$i++;
}

if ($colour){
	# Colour palette

	my @colours=(
		"#1C86EE", # dogerblue
		"#E31A1C", # red
		"#008B00", # green4
		"#6A3D9A", # purple
		"#FF7F00", # orange
		"#000000", # black
		"#FFD700", # gold1
		"#7EC0EE", # skyblue2
		"#FB9A99", # lt pink
		"#90EE90", # palegreen2
		"#CAB2D6", # lt purple
		"#FDBF6F", # lt orange
		"#B3B3B3", # gray70
		"#EEE685", # khaki2
		"#B03060", # maroon
		"#FF83FA", # orchid1
		"#FF1493", # deeppink1
		"#0000FF", # blue1
		"#36648B", # steelblue4
		"#00CED1", # darkturquoise
		"#00FF00", # green1
		"#8B8B00", # yellow4
		"#CDCD00", # yellow3
		"#8B4500", # darkorange4
		"#A52A2A"  # brown
	);

	# Read nexus file
	open (FILE, "$outfile")
		or die ("\nCan't open file $outfile\n\n");
		my @nexus=<FILE>;
	close (FILE);
	
	# Assign colours to taxa categories
	my %taxcol;
	my %cats;
	foreach my $tax (@taxa){
		my @aux=split(/$sep/,$tax);
		if ($debug==1){
			print "SEPARATOR: $sep - ";
			foreach my $i (0..$#aux){
				print "$i:$aux[$i]";
				print "," if ($i < $#aux);
			}
			print "\n";
		}
		$cats{$aux[$field]}=1;
		$taxcol{$tax}=$aux[$field];
	}
	
	if (scalar(keys %cats) > scalar(@colours)){
		print "\nWarning: there are more categories (".scalar(keys %cats).") than colours (".scalar(@colours).") in the current colour palette.\n";
		print "Some colours will be used for more than one category\n\n";
	}

	# Assign colours alphabetically for consistency
	my $i=0;
	foreach my $c (sort keys %cats){
		$i=0 if ($i == scalar(@colours));
		$cats{$c}=$colours[$i];
		$i++;
	}
	# Modify nexus to add colours and correct bootstrap format
	open (FILE, ">$outfile")
		or die ("\nCan't write to file $outfile\n\n");
		foreach (@nexus){
			# Add figtree colors
			if (/Begin trees/i){
				print FILE "Begin taxa;\n";
				print FILE "\tdimensions ntax=".scalar(@taxa).";\n";
				print FILE "\ttaxlabels\n";
				foreach my $tax (@taxa){
					print FILE "\t$tax\[\&\!color\=$cats{$taxcol{$tax}}\]\n";
				}
				print FILE ";\n";
				print FILE "end;\n\n";
			} 
			# convert bootstrap format from molphy to traditional
			elsif (/tree .*\;$/){
				s/\:(\d+(\.\d+)?)\[(\d+(\.\d+)?)\]/$3\:$1/g;
				s/\[\]//g; # remove empty bootstrap at root
				
				# alternative method (maybe safer?)
				# my @aux=split(/(\:)/,$_);
				# $_='';
				# foreach my $i (0..$#aux){
				# 	if ($aux[$i]=~ s/\[(\d+(\.\d+)?)\]//g){
				# 		$aux[$i-1]=$1.':';
				# 	}
				# }
				# foreach my $a (@aux){
				# 	$_.=$a;
				# }
				
				# Remove branch lengths
				if ($consensus){
					s/\:\d+(\.\d)?//g;
				}
			}
			print FILE $_;

		}
	close (FILE);
}

print "Output file saved as: $outfile\n\n";

# ==============================================================================
# ==============================================================================
# ============================== SUBROUTINES ===================================
# ==============================================================================
# ==============================================================================


# Show copyright
# ==============================================================================
sub author{
    print "\n";
    print "#########################################\n";
    print "  ".basename($0)."\n";
	print "  version $version     \n";
    print "  (c) Victor Soria-Carrasco             \n";
    print "  victor.soria.carrasco\@gmail.com      \n";
    print "#########################################\n";
	print "\n";
}
# ==============================================================================

# Show usage
# ==============================================================================
sub usage{
    print "\n";
	print "  Usage:\n";
    print "    ".basename($0)."\n";
	print "      -i <input file>\n";
	print "      -o <output file> (optional)\n";
	print "      -c assign colours to taxon categories (for FigTree) (optional, default=no)\n";
	print "      -f <number> field to define taxon categories (optional, default=0)\n";
	print "      -s <number> character to use as separators for fields (optional, default=-)\n";
	print "      -g <list of taxa (separated by commas)> outgroup (optional, default=none)\n";
	print "      -t <text to remove from taxa names> (optional, default=none)\n";
	print "      -x RAxML consensus tree format (optional, default=no)\n";
    print "\n";
    exit;
}
# ==============================================================================


