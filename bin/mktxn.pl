#!/usr/bin/perl6




use v6;
our $PROGRAM = 'mktxn';
our $VERSION = '0.0.1';



# -----------------------------------------------------------------------------
# helper functions
# -----------------------------------------------------------------------------

sub get_entities_seen(@txn) returns Array[Str]
{
    my Str @entities_seen;

    for @txn -> $entry
    {
        for $entry<postings>.Array -> $posting
        {
            push @entities_seen, $posting<account><entity>;
        }
    }

    @entities_seen .= unique;
    @entities_seen .= sort;
}


# -----------------------------------------------------------------------------
# main
# -----------------------------------------------------------------------------

# release
multi sub MAIN(Str:D :t(:$target) = 'TXNBUILD')
{
    use Config::TOML;
    use JSON::Tiny;
    use TXN::Parser;

    # get directory of TXNBUILD
    my Str $txnbuild_dir = $target.IO.abspath.IO.dirname;

    # error unless mktxn is being run in same directory as TXNBUILD
    unless $txnbuild_dir ~~ ~$*CWD
    {
        die "Sorry, mktxn must be run in same directory as TXNBUILD";
    }

    # make srcdir
    my Str $srcdir = $txnbuild_dir ~ '/src';
    my Str $txn_file = "$srcdir/txn.json";
    my Str $txninfo_file = "$srcdir/.TXNINFO";
    mkdir $srcdir;

    # parse TXNBUILD
    my %txnbuild = from-toml(slurp $target);

    # find transaction journal file to parse and serialize
    my Str $file = %txnbuild<source> || die "Sorry, missing source in TXNBUILD";
    my Str $file_dir = $file.IO.abspath.IO.dirname;

    # error unless transaction journal is in same directory as TXNBUILD
    unless $txnbuild_dir ~~ $file_dir
    {
        die "Sorry, transaction journal must be in same directory as TXNBUILD";
    }

    # build .TXNINFO
    my %txninfo;

    # note the time
    my Str $dt = ~DateTime.now;

    # note the compiler name and version, and time of compile
    %txninfo<compiler> = "$PROGRAM $VERSION $dt";

    # TODO: validate these
    %txninfo<name> = %txnbuild<name> || die "Sorry, name missing from TXBUILD";
    %txninfo<version> = %txnbuild<version>
        || die "Sorry, version missing from TXNBUILD";
    %txninfo<release> = %txnbuild<release> || 1;
    %txninfo<description> = %txnbuild<description> || '';

    say "Making txn: %txnbuild<name> ",
        "%txnbuild<version>-%txnbuild<release> ($dt)";

    # parse transactions from journal
    my @txn = TXN::Parser.parsefile($file, :json).made;

    # compute basic stats about the transaction journal
    %txninfo<count> = @txn.elems;
    %txninfo<entities-seen> = get_entities_seen(@txn);

    # serialize .TXNINFO to JSON
    spurt $txninfo_file, to-json(%txninfo) ~ "\n";

    say "Creating txn \"%txnbuild<name>\"...";

    # serialize transactions to JSON
    spurt $txn_file, to-json(@txn) ~ "\n";

    # compress
    my Str $tarball =
        "%txninfo<name>-%txninfo<version>-%txninfo<release>\.txn.tar.xz";
    shell "tar \\
             -C $srcdir \\
             --xz \\
             -cvf $tarball \\
             {$txninfo_file.IO.basename} {$txn_file.IO.basename}";

    say "Finished making: %txnbuild<name> ",
        "%txnbuild<version>-%txnbuild<release> ($dt)";

    say "Cleaning up...";

    # clean up srcdir
    dir($srcdir)».unlink;
    rmdir $srcdir;
}

# serialize
multi sub MAIN(Str:D $file, Str:D :m(:$mode) = 'perl', *%opts)
{
    use TXN;
    given $mode
    {
        when /:i perl/
        {
            say from-txn(:$file).perl;
        }
        when /:i json/
        {
            say from-txn(:$file, :json);
        }
        default
        {
            say "Sorry, invalid mode.\n";
            USAGE();
            exit;
        }
    }
}




# -----------------------------------------------------------------------------
# usage
# -----------------------------------------------------------------------------

sub USAGE()
{
    my Str $help_text = q:to/EOF/;
    Usage:
      mktxn [--target="TXNBUILD"]   Make release tarball
      mktxn [--mode="MODE"] "FILE"  Parse transaction journal

    optional arguments:
      -m, --mode=MODE
        json, perl
      -t, --target=TXNBUILD
        the location of the TXNBUILD
    EOF
    say $help_text.trim;
}

# vim: ft=perl6
