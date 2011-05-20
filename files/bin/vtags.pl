#!/usr/bin/perl -w
#
# Copyright 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005 Providenza & Boekelheide, Inc
#	Feel free to use this, let me know of any bugs or enhancements
#	John Providenza
# 
# 
# Create a Vi style tags file for Verilog files
# Scan Verilog files to extract function/task/module keywords
# Optionally scan VHDL files for architecture sections
#
# 4-1-99	added support for -y flag to specify library directories
#		it can be used on the command line ("-y /proj/lib")
#		or in the file_of_files
#
# 11-1-00	fixed Function detection to support function size info, ie
#		function [10:0] foo ;
#
# 6-1-01	changed from hashes to an array to store the module info.
#		this allows us to remember identical tag names that could
#		be in different files
#
# 7-18-01	fixed 2 problems with functions.
#			1) a scalar declaration (function foo;) failed
#			2) functions burried in funny comments failed
#
# 9-25-01	1) added scanning of +incdir+ directories specified in a -f file.
#		2) deleted duplicate filenames from processing
#
# 10-4-01	process `include directive
#
# 10-16-01	1) cleanup on 'function' scanning
#		2) for `include, auto-add directory that calling file is in
#
# 2-22-02	1) mods to add the basename of `include files as a tag so that
#		   simple includes files with only parameters can be pushed in to.
#
# 3-29-02	Yet another fix to function finding
#
# 7-17-02	Minor cleanup to 'include' filename searching.  The leading PATH
#		info is stripped from the tag name now
#
# 8-23-02	1) Function, Task, and Module keywords now allow the name to be on the next line
#		2) Fixed bug in adding include file basenames as tags - embedded '.' and '..'
#		   path seperators confused it
#
# 10-24-02	1) Added -r to have vtags recursively search downward from current directory
#		   looking for verilog files.
#		2) corrected -y handling to handle command lines like either
#			-y my_dir    OR     "-y my_dir"
#
# 2-9-04        fixed problem with -r option: it ignored uppercase file names.
#
# 4-14-04       added 'glob' of input filenames to allow wild-cards
#
# 4-21-04       allow directory names on cmd line.  Now you can say
#                       vtags chiptop testbed
#               and have it get the Verilog files from those directories.
#
# 6-2-04        added rudimentary support for VHDL
#
# 4-5-06        Added code to allow macro names for task/modules:
#                       module `PACOBLAZE
#               is now legal
#
#               Added code to add the filename as a tag
#
# 6-9-06        Added code for VHDL to detect
#                       - procedure,
#                       - function,
#                       - type
#                       - subtype
#                       - constant
#               definitions
#
# 7-20-06       Allow for verilog .vh file extension
#
# 10-13-06      Allow System Verilog (.sv) files
#
# 10-18-06      Added -R recursion mode to allow recursing multiple specific directories
#
# Note that the "file_of_file_names" may also include lines like
#	-y /proj/lib_dir
#	+incdir+foo/bar
# This can be used to suck in all verilog files from a libray directory

$ARGV[0] || die "usage:\n   vtags.pl [-r] [-R dir] [-f file_of_file_names] [-vhdl] [-y lib_dir] [file] [dir] ...\n\t\tCopyright 1998-2005 Providenza & Boekelheide, Inc.\n" ;

$file_cnt = 0 ;
my @inc_dirs = ();
my @inc_files = ();
my @missing_includes = ();
#my $file_extension = '(s?v[ht]?$)';       # default: verilog only (.v or .vt .vh .sv)
my $file_extension = '((sv$)|(v[ht]?$))';

# These directories are NOT to be searched when using the -r option.  Regular Expressions
# are allowed.
my @exclude_dirs = ('mti', 'xilinx.*', 'results', 'cvs', 'bin');

sub read_lib_dir {
    my $lib_dir_name = shift ;
    my $type = shift;

    print "including $type directory $lib_dir_name\n" ;

    opendir (LIBDIR, $lib_dir_name) || die "can't open $type $lib_dir_name\n" ;
    my @lib_files = readdir(LIBDIR) ;
    foreach $lib_file (@lib_files) {
	push(@files, "$lib_dir_name/$lib_file") if ($lib_file =~ /\.$file_extension/i) ;
    }
    closedir (LIBDIR) ;
}


# look for the include file in our path....
# this includes our current directory as well as the include paths
# called with the include file name to look for as well as the calling
# file  path
sub do_include {
    my $ifile = shift;
    my $call_file = shift;
    my $call_dir = $call_file;
    $call_dir =~ s,/\w[\w.]+$,, ;
    my $ifile2 = $ifile;
    $ifile2 =~ s,^.*/,,;	# remove any leading PATH info

    my $found = "";
    foreach my $dir (($call_dir, @inc_dirs)) {
	if (-r "$dir/$ifile") {
	    $found = "$dir/$ifile";
	    last;
	} elsif (-r "$dir/$ifile2") {
	    $found = "$dir/$ifile2";
	    last;
	}
    }
    if ($found ne "") {
	# print "do_include: adding $found\n";
	push (@inc_files, $found);
	# also add the basename of the file as a tag JIC the include
	# file doesn't have any modules
	$ifile2 =~ s/\.\S+$//;
	push (@tags, "$ifile2\t$found\t1");
	# print "adding include tag entry $ifile2\t$found\t1\n";
    } else {
	push (@missing_includes, $ifile);
    }
}

# check a line for interesting Verilog things to process:
#	function, task, module, `include
sub proc_vline {
    # get the input line and line number
    $_ = shift;
    my $line_num = shift;

    # print "Trying $_\n";
    if (/^\s*`include\s+"(\w+)"/) {
	# look for the include file in our path....
	&do_include ($1, $file);
    } else {
	# remove strings
	s,\\.,,g;	# no \ style escapes...
	s,"[^"]*",,g;	# remove matched "
	s,'[^']*',,g;	# remove matched '

	# check for keywords, remember them
	if (/\b(module|task)\b/) {
	    while (!eof(INPUT)) {
		if (/\b(module|task)\s+(`*)([a-zA-Z]\w+)/) {
                    #print "Got $1 $3\n";
		    push (@tags, "$3\t$file\t$line_num");
		    last;
		}
		# task/module name must be on next line....
		$_ .= <INPUT>;
	    }
	} elsif (/\bfunction\b/) {
	    while (!eof(INPUT)) {
		if (/\bfunction(\s*\[\s*\S+\s*:\s*\S+\s*]\s*|\s+real\s+|\s+integer\s+|\s+)([a-zA-Z]\w*)/) {
		    #print "Got function $2\n";
		    push (@tags, "$2\t$file\t$line_num");
		    last;
		}
		# function name must be on next line....
		$_ .= <INPUT>;
	    }
	}
    }
}

# read all the files scanning for
#       Verilog:        module/task/function keywords
#       VHDL:           architecture, procedure, function keywords
sub scan_files {
    my (@files) = @_;

    $last_file = "";
    foreach $file (sort(@files)) {
	# skip duplicate file names
	next if ($last_file eq $file);
	$last_file = $file;

        if ($file =~ m,(.*)\.($file_extension),) {
            $root_name = $1;
            $root_name =~ s,.*/,,;
        }

	open (INPUT, $file) || (warn "can't open input file $file\n", next) ;
	$file_cnt++ ;
	$in_comment = 0 ;
        $tag_cnt = @tags;
        if ($file =~ /(.+)\.$file_extension/i) {
            # VERILOG scanner....
            print "processing $file\n";

            while (<INPUT>) {
                # Scan each line for keywords while keeping track of comments
                # This can be written much more concisely, but this tries to
                # minimize the code for each common case
                if (!$in_comment) {
                    # not currently in a block comment
                    if (m,/[/*],) {
                        # some kind of start of comment
                        s,//.*$|/\*.*\*/,, ;	# strip //....  and /*....*/  comments
                        $in_comment = s,/\*.*$,, ;	# remove /*...$ comment text
                    }
                    &proc_vline ($_, $.) if (/\b(include|module|task|function)\b/);
                } else {
                    # we're in a comment already
                    if ( !($in_comment = !s,^.*\*/,,) ) {
                        s,//.*$|/\*.*\*/,, ;	# strip //....  and /*....*/  comments
                        $in_comment = s,/\*.*$,, ;	# remove /*...$ comment text
                        &proc_vline ($_, $.) if (/\b(include|module|task|function)\b/);
                    }
                }
            }
        } elsif ($file =~ /.*vhdl?$/i) {
            # VHDL scanner....
            my $p_body = 0;
            my $a_body = 0;
            while (<INPUT>) {
                chomp;
                if (/^\s*architecture\s+(\S+)\s+of\s+(\w+)\s/i) {
                    #printf "vhdl found: $_ ($2)\n";
		    push (@tags, "$2\t$file\t$.");
                    $a_body = 1;
                } elsif (/^\s*constant\s+(\S+)\s*:\s+/i) {
                    #printf "vhdl found: type ($1)\n";
		    push (@tags, "$1\t$file\t$.");
                } elsif (/^\s*(sub)*type\s+(\S+)\s+is\s+/i) {
                    #printf "vhdl found: type ($2)\n";
		    push (@tags, "$2\t$file\t$.");
                } elsif (/^\s*end\s+architecture\s/i) {
                    $a_body = 0;
                } elsif (/^\s*package\s+body\s/i) {
                    $p_body = 1;
                } elsif (/^\s*end\s+package\s+body\s/i) {
                    $p_body = 0;
                } elsif (($p_body or $a_body) and /^\s*(procedure|function)\s+(\S+)\s*\(/i) {
                    # grab procedure definitions only inside the package or architectur body
                    # printf "vhdl file $file found: $1 $2\n";
                    push (@tags, "$2\t$file\t$.");
                }
            }
        } else {
            warn "unknown type for file $file\n";
        }
	close (INPUT) ;

        # if the file didn't add any tags or it didn't add it's root name as a tag,
        # add the root name of the file as a tag
        if ($tag_cnt == @tags || !grep (/^$root_name\s/i, @tags)) {
            #print "file $file didn't add any tags\n";
            #print "file root is $root_name\n";
            push (@tags, "$root_name\t$file\t1");
        }

    }
}

# look through current and lower directories looking for Verilog files
sub find_files {
    my $root_dir = shift;
    my $lib_file;

    # print "checking dir '$root_dir' ...\n";
    opendir (LIBDIR, $root_dir) || die "can't open $root_dir\n" ;
    my @lib_files = readdir(LIBDIR) ;
    closedir (LIBDIR) ;
    foreach $lib_file (@lib_files) {
	$_ = $lib_file;
	# skip files starting with '.'
	next if (/^\./);

        my $skip_dir = 0;
        foreach $exclude_name (@exclude_dirs) {
            if ($lib_file =~ /^$exclude_name/i) {
                $skip_dir = 1;
            }
        }
        next if ($skip_dir);

        if (-d "$root_dir/$lib_file") {
	    # recurse into a lower directory
            # print "looking into $root_dir/$lib_file\n";
	    &find_files("$root_dir/$lib_file")
	} elsif ( /\.$file_extension/i) {
            # print "adding file $root_dir/$lib_file\n";
	    push(@files, "$root_dir/$lib_file")
	}
    }
}

#**********************************************************************
#                       MAINLINE
#
#
# expand command line to remove '-f' flags
my @do_recurse_dirs = ();
my @targets = ();
while ($n_arg = shift) {
    if ($n_arg eq "-f") {
	# process a file that lists files/directories
	$n_arg = shift ;
	open(FILES, $n_arg) || die "can't open cmd line file $n_arg\n" ;
	while (<FILES>) {
	    chomp ;
	    if (/^\/\//) {
                next;
            } elsif (/^-y\s+(\S+)/) {
		# we got a -y argument specifying a library directory.
		# the command line must have had quotes, like:
		#	"-y my_dir"
                if (-d $1) {
                    push (@targets, $1);
                } else {
                    warn "invalid directory name '$1' at line $.\n";
                }
	    } elsif (/\+incdir\+(\S+)/) {
                if (-d $1) {
                    push (@inc_dirs, $1) ;
                } else {
                    warn "invalid directory name '$1' at line $.\n";
                }
	    } elsif (/(\S+\.($file_extension)\b)/i) {
                # add any file ending with .vXXXX - desired file types will
                # be filtered out later...
                if (-f $1) {
                    push (@targets, $1);
                } else {
                    warn "invalid file name '$1' at line $.\n";
                }
	    }
	}
    } elsif ($n_arg =~ /^-vhdl?/) {
        # enable VHDL files
        $file_extension .= '|(vhdl?$)';

    } elsif ($n_arg =~ /^-y\s+(.*$)/) {
	# we got a -y argument specifying a library directory.
	# the command line must have had quotes, like:
	#	"-y my_dir"
        push (@targets, $1);

    } elsif ($n_arg eq "-y") {
	# we got a -y argument specifying a library directory.
	# the command line must NOT have had quotes, like:
	#	-y my_dir
        push (@targets, shift);

    } elsif ($n_arg eq "-r") {
        # look for files in all subdirectories later...
        push (@do_recurse_dirs, ".");

    } elsif ($n_arg eq "-R") {
        # do a recursive search starting at a specific direcory
        push (@do_recurse_dirs, shift);

    } else {
        # must be a file/directory name on the command line....
        while ( glob($n_arg) ) {
            if (-d $_) {
                # save a directory to be scanned...
                push (@targets, $_);
            } else {
                # save file name
                push (@targets, $_) if ($_ =~ /\.$file_extension/i ) ;
            }
        }
    }
}

if (@do_recurse_dirs) {
    # look for files in the specified directory and subdirectories
    foreach my $dir (sort(@do_recurse_dirs)) {
        die "$dir is not a directory\n" unless (-d $dir);
        &find_files($dir);
    }
}

while (@targets) {
    my $name = pop(@targets);
    if (-d $name) {
	read_lib_dir ($name, "lib_dir") ;
    } elsif (-f $name) {
        push (@files, $name) if ($name =~ /\.$file_extension/i) ;
    } else {
        die "gack non-existant file snuck through $name\n";
    }
}

# print "all Verilog input files are: @files\n" ;

# scan all the specified input files for modules, tasks, functions, `includes
#   when done, we'll have added tags and created two arrays for `includes:
#   one if for includes in the same directory as the calling file or in the
#   include path, the other for missing includes
&scan_files (@files) ;


print "looking for missing include files...\n" ;
# these were not found in the include_path or in the directory of the
# calling file
foreach $file (@files) {
    $file =~ s,/[^/]+$,,;		# remove trailing file name to get path
    push (@dirs, $file);
}

$last_miss = "";
foreach $missing (sort(@missing_includes)) {
    # only include each missing file once!
    next if ($last_miss eq $missing);
    $last_miss = $missing;

    my $found = 0;
    $last_dir = "";
    foreach $dir (sort(@dirs)) {
	if ($last_dir ne $dir) {
	    my $target = "$dir/$missing";
	    if (-f $target) {
		# print "adding include file $missing from $dir\n";
		push(@inc_files, $target);
		$found = 1;

		# also add the basename of the file as a tag JIC the include
		# file doesn't have any modules
		my $base_name = $missing;
		$base_name =~ s,^.*/,,;		# no leading PATH info
		$base_name =~ s,\.\S+$,,;	# no trailing suffix
		push (@tags, "$base_name\t$target\t1");
		# print "adding missing include $base_name\t$target\t1\n";
	    }
	}
	$last_dir = $dir;
    }
    if ($found == 0) {
	print "NOTE: couldn't find include file $missing\n";
    }
}
# now process the include files
&scan_files (@inc_files) ;


# send out the tags file
open(TAGS, ">tags") || die "can't open tags file\n" ;
my $tag_cnt = 0;
my $last_tag = "";
foreach $i (sort (@tags) ) {
    print TAGS "$i\n" if ($i ne $last_tag);
    $last_tag = $i;
    $tag_cnt++;
}
print "$file_cnt files scanned, $tag_cnt tags found\n" ;
