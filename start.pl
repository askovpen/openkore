# Win32 Perl script launcher
# This file is meant to be compiled by PerlApp. It acts like a mini-Perl interpreter.
#
# Your script's initialization and main loop code should be placed in a function
# called __start() in the main package. That function will be called by this
# launcher. The reason for this is that otherwise, the perl interpreter will be
# in "eval" all the time while running your script. It will break __DIE__ signal
# handlers that check for the value of $^S.
#
# If your script is run by this launcher, the environment variable INTERPRETER is
# set. Your script should call __start() manually if this environment variable is not
# set.
#
# Example script:
# our $quit = 0;
#
# sub __start {
# 	print "Hello world initialized.\n";
# 	while (!$quit) {
# 		...
# 	}
# }
#
# __start() unless defined $ENV{INTERPRETER};
use strict;

if (0) {
	# Force PerlApp to include the following modules
	require base;
	require bytes;
	require warnings;
	require Exporter;
	require Carp;
	require FindBin;
	require Math::Trig;
	require Text::Wrap;
	require Time::HiRes;
	require IO::Socket;
	require Getopt::Long;
	require Digest::MD5;
	require Win32::Console;
}

if ($0 =~ /\.exe$/i) {
	$ENV{INTERPRETER} = $0;
}

my $file = 'openkore.pl';
if ($ARGV[0] eq '!') {
	shift;
	$file = shift;
}

do $file;
die $@ if ($@);

main::__start() if defined(&main::__start);
