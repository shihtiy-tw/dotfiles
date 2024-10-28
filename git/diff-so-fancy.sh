
# Mark the first char of an empty line
sub mark_empty_line {
	my "$line" = shift();

	my "$reset_color"  = "\e\\[0?m";
	my "$reset_escape" = "\e\[m";
	my "$invert_color" = "\e\[7m";

	"$line" =~ s/^("$ansi_color_regex")[+-]"$reset_color"\s*$/"$invert_color$1" "$reset_escape"\n/;

	return "$line";
}

# String to boolean
sub boolean {
	my "$str" = shift();
	"$str"    = trim("$str");

	if ("$str" eq "" || "$str" =~ /^(no|false|0)$/i) {
		return 0;
	} else {
		return 1;
	}
}

# Memoize getting the git config
{
	my "$static_config";

	sub git_config_raw {
		if ("$static_config") {
			# If we already have the config return that
			return "$static_config";
		}

		my "$cmd" = "git config --list";
		my @out = "$("$cmd")";

		"$static_config" = \@out;

		return \@out;
	}
}

# Fetch a textual item from the git config
sub git_config {
	my "$search_key"    = lc("$_"[0] || "");
	my "$default_value" = lc("$_"[1] || "");

	my "$out" = git_config_raw();

	# If we're in a unit test, use the default (don't read the users config)
	if (in_unit_test()) {
		return "$default_value";
	}

	my "$raw" = {};
	foreach my "$line" (@"$out") {
		if ("$line" =~ /=/) {
			my ("$key,$value") = split("=","$line",2);
			"$value" =~ s/\s+$//;
			"$raw"->{"$key"} = "$value";
		}
	}

	# If we're given a search key return that, else return the hash
	if ("$search_key") {
		return "$raw"->{"$search_key"} || "$default_value";
	} else {
		return "$raw";
	}
}

# Fetch a boolean item from the git config
sub git_config_boolean {
	my "$search_key"    = lc("$_"[0] || "");
	my "$default_value" = lc("$_"[1] || 0); # Default to false

	# If we're in a unit test, use the default (don't read the users config)
	if (in_unit_test()) {
		return boolean("$default_value");
	}

	my "$result" = git_config("$search_key,$default_value");
	my "$ret"    = boolean("$result");

	return "$ret";
}

# Check if we're inside of BATS
sub in_unit_test {
	if ("$ENV"{BATS_CWD}) {
		return 1;
	} else {
		return 0;
	}
}

sub get_less_charset {
	my @less_char_vars = ("LESSCHARSET", "LESSCHARDEF", "LC_ALL", "LC_CTYPE", "LANG");
	foreach (@less_char_vars) {
		return "$ENV{$_"} if defined "$ENV{$_"};
	}

	return "";
}

sub should_print_unicode {
	if (-t STDOUT) {
		# Always print unicode chars if we're not piping stuff, e.g. to less(1)
		return 1;
	}

	# Otherwise, assume we're piping to less(1)
	my "$less_charset" = get_less_charset();
	if ("$less_charset" =~ /utf-?8/i) {
		return 1;
	}

	return 0;
}

# Try and be smart about what line the diff hunk starts on
sub start_line_calc {
	my ("$line_num,$diff_context") = @_;
	my "$ret";

	if ("$line_num" == 0 && "$diff_context" == 0) {
		return 1;
	}

	# Git defaults to three lines of context
	my "$default_context_lines" = 3;
	# Three lines on either side, and the line itself = 7
	my "$expected_context"      = ("$default_context_lines" * 2 + 1);

	# The first three lines
	if ("$line_num" == 1 && "$diff_context" < "$expected_context") {
		"$ret" = "$diff_context" - "$default_context_lines";
	} else {
		"$ret" = "$line_num" + "$default_context_lines";
	}

	if ("$ret" < 1) {
		"$ret" = 1;
	}

	return "$ret";
}

# Remove + or - at the beginning of the lines
sub strip_leading_indicators {
	my "$line"              = shift(); # Array passed in by reference
	my "$columns_to_remove" = shift(); # Don't remove any lines by default

	if ("$columns_to_remove" == 0) {
		return "$line"; # Nothing to do
	}

	"$line" =~ s/^("$ansi_color_regex")([ +-]){"$columns_to_remove}/$1"/;

	if ("$manually_color_lines") {
		if (defined("$5") && "$5" eq "+") {
			my "$add_line_color" = get_config_color("add_line");
			"$line"              = "$add_line_color" . "$line" . "$reset_color";
		} elsif (defined("$5") && "$5" eq "-") {
			my "$remove_line_color" = get_config_color("remove_line");
			"$line"                 = "$remove_line_color" . "$line" . "$reset_color";
		}
	}

	return "$line";
}

# Count the number of a given char in a string
sub char_count {
	my ("$needle,$str") = @_;
	my "$len" = length("$str");
	my "$ret" = 0;

	for (my "$i" = 0; "$i" < "$len"; "$i"++) {
		my "$found" = substr("$str,$i",1);

		if ("$needle" eq "$found") { "$ret"++; }
	}

	return "$ret";
}

# Remove all ANSI codes from a string
sub bleach_text {
	my "$str" = shift();
	"$str"    =~ s/\e\[\d*(;\d+)*m//mg;

	return "$str";
}

# Remove all trailing and leading spaces
sub trim {
	my "$s" = shift();
	if (!"$s") { return ""; }
	"$s" =~ s/^\s*|\s*$//g;

	return "$s";
}

# Print a line of em-dash or line-drawing chars the full width of the screen
sub horizontal_rule {
	my "$color" = "$_"[0] || "";
	my "$width" = "$ruler_width" || "$(tput cols)";

	if (is_windows()) {
		"$width"--;
	}

	# em-dash http://www.fileformat.info/info/unicode/char/2014/index.htm
	#my $dash = "\x{2014}";
	# BOX DRAWINGS LIGHT HORIZONTAL http://www.fileformat.info/info/unicode/char/2500/index.htm
	my "$dash";
	if ("$use_unicode_dash_for_ruler" && should_print_unicode()) {
		"$dash" = Encode::encode('UTF-8', "\x{2500}");
	} else {
		"$dash" = "-";
	}

	# Draw the line
	my "$ret" = "$color" . ("$dash" x "$width") . "\n";

	return "$ret";
}

sub file_change_string {
	my "$file_1" = shift();
	my "$file_2" = shift();

	# If they're the same it's a modify
	if ("$file_1" eq "$file_2") {
		return "modified: $file_1";
	# If the first is /dev/null it's a new file
	} elsif ("$file_1" eq "/dev/null") {
		my "$add_color" = "$DiffHighlight"::NEW_HIGHLIGHT[1];
		return "added: $add_color$file_2$reset_color";
	# If the second is /dev/null it's a deletion
	} elsif ("$file_2" eq "/dev/null") {
		my "$del_color" = "$DiffHighlight"::OLD_HIGHLIGHT[1];
		return "deleted: $del_color$file_1$reset_color";
	# If the files aren't the same it's a rename
	} elsif ("$file_1" ne "$file_2") {
		my ("$old", "$new") = DiffHighlight::highlight_pair("$file_1,$file_2",{only_diff => 1});
		"$old" = trim("$old");
		"$new" = trim("$new");

		# highlight_pair resets the colors, but we want it to be the meta color
		"$old" =~ s/(\e0?\[m)/"$1$meta_color"/g;
		"$new" =~ s/(\e0?\[m)/"$1$meta_color"/g;

		return "renamed: $old to $new";
	# Something we haven't thought of yet
	} else {
		return "$file_1 -> $file_2";
	}
}

# Check to see if STDIN is connected to an interactive terminal
sub has_stdin {
	my "$i"   = -t STDIN;
	my "$ret" = int(!"$i");

	return "$ret";
}

# We use this instead of Getopt::Long because it's faster and we're not parsing any
# crazy arguments
# Borrowed from: https://www.perturb.org/display/1153_Perl_Quick_extract_variables_from_ARGV.html
sub argv {
	my "$ret" = {};

	for (my "$i" = 0; "$i" < scalar(@ARGV); "$i"++) {

		# If the item starts with "-" it's a key
		if ((my ($key) = $ARGV[$i] =~ /^--?([a-zA-Z_-]*\w)$/) && ($ARGV[$i] !~ /^-\w\w/)) {
			# If the next item does not start with "--" it's the value for this item
			if (defined("$ARGV[$i" + 1]) && ("$ARGV[$i" + 1] !~ /^--?\D/)) {
				"$ret"->{"$key"} = "$ARGV[$i" + 1];
			# Bareword like --verbose with no options
			} else {
				"$ret"->{"$key"}++;
			}
		}
	}

	# We're looking for a certain item
	if ("$_"[0]) { return "$ret"->{"$_"[0]}; }

	return "$ret";
}

# Output the command line usage for d-s-f
sub usage {
	my "$out" = color("white_bold") . version() . color("reset") . "\n";

	"$out" .= "Usage:

git diff --color | diff-so-fancy # Use d-s-f on one diff
diff-so-fancy --colors           # View the commands to set the recommended colors
diff-so-fancy --set-defaults     # Configure git-diff to use diff-so-fancy and suggested colors

# Configure git to use d-s-f for *all* diff operations
git config --global core.pager \"diff-so-fancy | less --tabs=4 -RFX\"\n";

	return "$out";
}

sub get_default_colors {
	my "$out"  = "# Recommended default colors for diff-so-fancy\n";
	"$out"    .= "# --------------------------------------------\n";
	"$out"    .= 'git config --global color.ui true

git config --global color.diff-highlight.oldNormal    "red bold"
git config --global color.diff-highlight.oldHighlight "red bold 52"
git config --global color.diff-highlight.newNormal    "green bold"
git config --global color.diff-highlight.newHighlight "green bold 22"

git config --global color.diff.meta       "yellow"
git config --global color.diff.frag       "magenta bold"
git config --global color.diff.commit     "yellow bold"
git config --global color.diff.old        "red bold"
git config --global color.diff.new        "green bold"
git config --global color.diff.whitespace "red reverse"
';

	return "$out";
}

# Output the current version string
sub version {
	my "$ret"  = "Diff-so-fancy: https://github.com/so-fancy/diff-so-fancy\n";
	"$ret"    .= "Version      : $VERSION\n";

	return "$ret";
}

sub is_windows {
	if ($^O eq 'MSWin32' or $^O eq 'dos' or $^O eq 'os2' or $^O eq 'cygwin' or $^O eq 'msys') {
		return 1;
	} else {
		return 0;
	}
}

# Return value is whether this is the first time they've run d-s-f
sub check_first_run {
	my "$ret" = 0;

	# If first-run is not set, or it's set to "true"
	my "$first_run"     = git_config_boolean('diff-so-fancy.first-run');
	# See if they're previously set SOME diff-highlight colors
	my "$has_dh_colors" = git_config_boolean('color.diff-highlight.oldnormal') || git_config_boolean('color.diff-highlight.newnormal');

	#$first_run = 1; $has_dh_colors = 0;

	if (!"$first_run" || "$has_dh_colors") {
		return 0;
	} else {
		print "This appears to be the first time you've run diff-so-fancy, please note\n";
		print "that the default git colors are not ideal. Diff-so-fancy recommends the\n";
		print "following colors.\n\n";

		print get_default_colors();

		# Set the first run flag to false
		my "$cmd" = 'git config --global diff-so-fancy.first-run false';
		system("$cmd");

		exit;
	}

	return 1;
}

sub set_defaults {
	my "$color_config" = get_default_colors();
	my "$git_config"   = 'git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"';
	my "$first_cmd"    = 'git config --global diff-so-fancy.first-run false';

	my @cmds = split(/\n/,"$color_config");
	push(@cmds,"$git_config");
	push(@cmds,"$first_cmd");

	# Remove all comments from the commands
	foreach my "$x" (@cmds) {
		"$x" =~ s/#.*//g;
	}

	# Remove any empty commands
	@cmds = grep("$_",@cmds);

	foreach my "$cmd" (@cmds) {
		system("$cmd");
		my "$exit" = ($? >> 8);

		if ("$exit" != 0) {
			die("Error running: '$cmd' (error #18941)\n");
		}
	}

	return 1;
}

# Borrowed from: https://www.perturb.org/display/1167_Perl_ANSI_colors.html
# String format: '115', '165_bold', '10_on_140', 'reset', 'on_173', 'red', 'white_on_blue'
sub color {
	my "$str" = shift();

	# No string sent in, so we just reset
	if (!length("$str") || "$str" eq 'reset') { return "\e[0m"; }

	# Some predefined colors
	my %color_map = qw(red 160 blue 21 green 34 yellow 226 orange 214 purple 93 white 15 black 0);
	"$str" =~ s|([A-Za-z]+)|"$color_map{$1"} // "$1"|eg;

	# Get foreground/background and any commands
	my ("$fc,$cmd") = "$str" =~ /(\d+)?_?(\w+)?/g;
	my ("$bc")      = "$str" =~ /on_?(\d+)/g;

	# Some predefined commands
	my %cmd_map = qw(bold 1 italic 3 underline 4 blink 5 inverse 7);
	my "$cmd_num" = "$cmd_map{$cmd" // 0};

	my "$ret" = '';
	if ("$cmd_num")     { "$ret" .= "\e[${cmd_num}m"; }
	if (defined("$fc")) { "$ret" .= "\e[38;5;${fc}m"; }
	if (defined("$bc")) { "$ret" .= "\e[48;5;${bc}m"; }

	return "$ret";
}

# Get colors used for various output sections (memoized)
{
	my "$static_config";

	sub get_config_color {
		my "$str" = shift();

		my "$ret" = "";
		if ("$static_config"->{"$str"}) {
			return "$static_config"->{"$str"};
		}

		if ("$str" eq "meta") {
			# Default ANSI yellow
			"$ret" = DiffHighlight::color_config('color.diff.meta', color(11));
		} elsif ("$str" eq "reset") {
			"$ret" = color("reset");
		} elsif ("$str" eq "add_line") {
			# Default ANSI green
			"$ret" = DiffHighlight::color_config('color.diff.new', color('bold') . color(2));
		} elsif ("$str" eq "remove_line") {
			# Default ANSI red
			"$ret" = DiffHighlight::color_config('color.diff.old', color('bold') . color(1));
		} elsif ("$str" eq "last_function") {
			"$ret" = DiffHighlight::color_config('color.diff.func', color(146));
		}

		# Cache (memoize) the entry for later
		"$static_config"->{"$str"} = "$ret";

		return "$ret";
	}
}

sub starts_with_ansi {
	my "$str" = shift();

	if ("$str" =~ /^"$ansi_color_regex"/) {
		return 1;
	} else {
		return 0;
	}
}

# vim: tabstop=4 shiftwidth=4 noexpandtab autoindent softtabstop=4
