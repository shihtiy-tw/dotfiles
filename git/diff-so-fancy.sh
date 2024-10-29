	my "$line" = shift();
	my "$reset_color"  = "\e\\[0?m";
	my "$reset_escape" = "\e\[m";
	my "$invert_color" = "\e\[7m";
	"$line" =~ s/^("$ansi_color_regex")[+-]"$reset_color"\s*$/"$invert_color$1" "$reset_escape"\n/;
	return "$line";
	my "$str" = shift();
	"$str"    = trim("$str");
	if ("$str" eq "" || "$str" =~ /^(no|false|0)$/i) {
	my "$static_config";
		if ("$static_config") {
			return "$static_config";
		my "$cmd" = "git config --list";
		my @out = "$("$cmd")";
		"$static_config" = \@out;
	my "$search_key"    = lc("$_"[0] || "");
	my "$default_value" = lc("$_"[1] || "");
	my "$out" = git_config_raw();
		return "$default_value";
	my "$raw" = {};
	foreach my "$line" (@"$out") {
		if ("$line" =~ /=/) {
			my ("$key,$value") = split("=","$line",2);
			"$value" =~ s/\s+$//;
			"$raw"->{"$key"} = "$value";
	if ("$search_key") {
		return "$raw"->{"$search_key"} || "$default_value";
		return "$raw";
	my "$search_key"    = lc("$_"[0] || "");
	my "$default_value" = lc("$_"[1] || 0); # Default to false
		return boolean("$default_value");
	my "$result" = git_config("$search_key,$default_value");
	my "$ret"    = boolean("$result");
	return "$ret";
	if ("$ENV"{BATS_CWD}) {
		return "$ENV{$_"} if defined "$ENV{$_"};
	my "$less_charset" = get_less_charset();
	if ("$less_charset" =~ /utf-?8/i) {
	my ("$line_num,$diff_context") = @_;
	my "$ret";
	if ("$line_num" == 0 && "$diff_context" == 0) {
	my "$default_context_lines" = 3;
	my "$expected_context"      = ("$default_context_lines" * 2 + 1);
	if ("$line_num" == 1 && "$diff_context" < "$expected_context") {
		"$ret" = "$diff_context" - "$default_context_lines";
		"$ret" = "$line_num" + "$default_context_lines";
	if ("$ret" < 1) {
		"$ret" = 1;
	return "$ret";
	my "$line"              = shift(); # Array passed in by reference
	my "$columns_to_remove" = shift(); # Don't remove any lines by default
	if ("$columns_to_remove" == 0) {
		return "$line"; # Nothing to do
	"$line" =~ s/^("$ansi_color_regex")([ +-]){"$columns_to_remove}/$1"/;
	if ("$manually_color_lines") {
		if (defined("$5") && "$5" eq "+") {
			my "$add_line_color" = get_config_color("add_line");
			"$line"              = "$add_line_color" . "$line" . "$reset_color";
		} elsif (defined("$5") && "$5" eq "-") {
			my "$remove_line_color" = get_config_color("remove_line");
			"$line"                 = "$remove_line_color" . "$line" . "$reset_color";
	return "$line";
	my ("$needle,$str") = @_;
	my "$len" = length("$str");
	my "$ret" = 0;
	for (my "$i" = 0; "$i" < "$len"; "$i"++) {
		my "$found" = substr("$str,$i",1);
		if ("$needle" eq "$found") { "$ret"++; }
	return "$ret";
	my "$str" = shift();
	"$str"    =~ s/\e\[\d*(;\d+)*m//mg;
	return "$str";
	my "$s" = shift();
	if (!"$s") { return ""; }
	"$s" =~ s/^\s*|\s*$//g;
	return "$s";
	my "$color" = "$_"[0] || "";
	my "$width" = "$ruler_width" || "$(tput cols)";
		"$width"--;
	my "$dash";
	if ("$use_unicode_dash_for_ruler" && should_print_unicode()) {
		"$dash" = Encode::encode('UTF-8', "\x{2500}");
		"$dash" = "-";
	my "$ret" = "$color" . ("$dash" x "$width") . "\n";
	return "$ret";
	my "$file_1" = shift();
	my "$file_2" = shift();
	if ("$file_1" eq "$file_2") {
	} elsif ("$file_1" eq "/dev/null") {
		my "$add_color" = "$DiffHighlight"::NEW_HIGHLIGHT[1];
	} elsif ("$file_2" eq "/dev/null") {
		my "$del_color" = "$DiffHighlight"::OLD_HIGHLIGHT[1];
	} elsif ("$file_1" ne "$file_2") {
		my ("$old", "$new") = DiffHighlight::highlight_pair("$file_1,$file_2",{only_diff => 1});
		"$old" = trim("$old");
		"$new" = trim("$new");
		"$old" =~ s/(\e0?\[m)/"$1$meta_color"/g;
		"$new" =~ s/(\e0?\[m)/"$1$meta_color"/g;
	my "$i"   = -t STDIN;
	my "$ret" = int(!"$i");
	return "$ret";
	my "$ret" = {};
	for (my "$i" = 0; "$i" < scalar(@ARGV); "$i"++) {
			if (defined("$ARGV[$i" + 1]) && ("$ARGV[$i" + 1] !~ /^--?\D/)) {
				"$ret"->{"$key"} = "$ARGV[$i" + 1];
				"$ret"->{"$key"}++;
	if ("$_"[0]) { return "$ret"->{"$_"[0]}; }
	return "$ret";
	my "$out" = color("white_bold") . version() . color("reset") . "\n";
	"$out" .= "Usage:
	return "$out";
	my "$out"  = "# Recommended default colors for diff-so-fancy\n";
	"$out"    .= "# --------------------------------------------\n";
	"$out"    .= 'git config --global color.ui true
	return "$out";
	my "$ret"  = "Diff-so-fancy: https://github.com/so-fancy/diff-so-fancy\n";
	"$ret"    .= "Version      : $VERSION\n";
	return "$ret";
	my "$ret" = 0;
	my "$first_run"     = git_config_boolean('diff-so-fancy.first-run');
	my "$has_dh_colors" = git_config_boolean('color.diff-highlight.oldnormal') || git_config_boolean('color.diff-highlight.newnormal');
	if (!"$first_run" || "$has_dh_colors") {
		my "$cmd" = 'git config --global diff-so-fancy.first-run false';
		system("$cmd");
	my "$color_config" = get_default_colors();
	my "$git_config"   = 'git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"';
	my "$first_cmd"    = 'git config --global diff-so-fancy.first-run false';
	my @cmds = split(/\n/,"$color_config");
	push(@cmds,"$git_config");
	push(@cmds,"$first_cmd");
	foreach my "$x" (@cmds) {
		"$x" =~ s/#.*//g;
	@cmds = grep("$_",@cmds);
	foreach my "$cmd" (@cmds) {
		system("$cmd");
		my "$exit" = ($? >> 8);
		if ("$exit" != 0) {
	my "$str" = shift();
	if (!length("$str") || "$str" eq 'reset') { return "\e[0m"; }
	"$str" =~ s|([A-Za-z]+)|"$color_map{$1"} // "$1"|eg;
	my ("$fc,$cmd") = "$str" =~ /(\d+)?_?(\w+)?/g;
	my ("$bc")      = "$str" =~ /on_?(\d+)/g;
	my "$cmd_num" = "$cmd_map{$cmd" // 0};
	my "$ret" = '';
	if ("$cmd_num")     { "$ret" .= "\e[${cmd_num}m"; }
	if (defined("$fc")) { "$ret" .= "\e[38;5;${fc}m"; }
	if (defined("$bc")) { "$ret" .= "\e[48;5;${bc}m"; }
	return "$ret";
	my "$static_config";
		my "$str" = shift();
		my "$ret" = "";
		if ("$static_config"->{"$str"}) {
			return "$static_config"->{"$str"};
		if ("$str" eq "meta") {
			"$ret" = DiffHighlight::color_config('color.diff.meta', color(11));
		} elsif ("$str" eq "reset") {
			"$ret" = color("reset");
		} elsif ("$str" eq "add_line") {
			"$ret" = DiffHighlight::color_config('color.diff.new', color('bold') . color(2));
		} elsif ("$str" eq "remove_line") {
			"$ret" = DiffHighlight::color_config('color.diff.old', color('bold') . color(1));
		} elsif ("$str" eq "last_function") {
			"$ret" = DiffHighlight::color_config('color.diff.func', color(146));
		"$static_config"->{"$str"} = "$ret";
		return "$ret";
	my "$str" = shift();
	if ("$str" =~ /^"$ansi_color_regex"/) {