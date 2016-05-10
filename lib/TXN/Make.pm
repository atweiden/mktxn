use v6;
unit class TXN::Make;

method build(
    Str:D $file,
    Str :$pkgname,
    Str :$pkgver,
    Int :$pkgrel,
    Str :$pkgdesc,
    Str :$template
) returns Hash
{
    my Str $dt = ~DateTime.now;
    my Str:D $f = resolve-txn-file-path($file);

    my %txninfo;

    if $template
    {
        use Config::TOML;
        my %template = from-toml(:file($template));
        %txninfo<pkgname> = %template<pkgname> if %template<pkgname>;
        %txninfo<pkgver> = %template<pkgver> if %template<pkgver>;
        %txninfo<pkgrel> = Int(%template<pkgrel>) if %template<pkgrel>;
        %txninfo<pkgdesc> = %template<pkgdesc> if %template<pkgdesc>;
    }

    # cmdline options override values defined in template
    %txninfo<pkgname> = $pkgname if $pkgname;
    %txninfo<pkgver> = $pkgver if $pkgver;
    %txninfo<pkgrel> = Int($pkgrel) if $pkgrel;
    %txninfo<pkgdesc> = $pkgdesc if $pkgdesc;

    # check for existence of pkgname, pkgver, and pkgrel
    die unless has-pkgname-pkgver-pkgrel(%txninfo);

    # note the compiler name and version, and time of compile
    %txninfo<compiler> = $GLOBAL::PROGRAM ~ ' v' ~ $GLOBAL::VERSION ~ " $dt";

    use TXN;
    my @txn = from-txn(:file($f));

    # compute basic stats about the transaction journal
    %txninfo<count> = @txn.elems;
    %txninfo<entities-seen> = get-entities-seen(@txn);

    # stringify DateTimes in preparation for JSON serialization
    loop (my Int $i = 0; $i < @txn.elems; $i++)
    {
        @txn[$i]<header><date> = ~@txn[$i]<header><date>;
    }

    my %build = :$dt, :@txn, :%txninfo;
}

method package(
    Str:D $file,
    *%opts (
        Str :$pkgname,
        Str :$pkgver,
        Int :$pkgrel,
        Str :$pkgdesc,
        Str :$template
    )
)
{
    my %build = TXN::Make.build($file, |%opts);
    my Str $dt = %build<dt>;
    my @txn = %build<txn>;
    my %txninfo = %build<txninfo>;

    say "Making txn pkg: %txninfo<pkgname> %txninfo<pkgver>-%txninfo<pkgrel> ($dt)";

    # make build directory
    my Str $build-dir = $*CWD ~ '/build';
    my Str $txninfo-file = "$build-dir/.TXNINFO";
    my Str $txnjson-file = "$build-dir/txn.json";
    mkdir $build-dir;

    # serialize .TXNINFO to JSON
    use JSON::Tiny;
    spurt $txninfo-file, to-json(%txninfo) ~ "\n";

    say "Creating txn pkg \"%txninfo<pkgname>\"…";

    # serialize transactions to JSON
    spurt $txnjson-file, to-json(@txn) ~ "\n";

    # compress
    my Str $tarball =
        "%txninfo<pkgname>-%txninfo<pkgver>-%txninfo<pkgrel>\.txn.tar.xz";
    shell "tar \\
             -C $build-dir \\
             --xz \\
             -cvf $tarball \\
             {$txninfo-file.IO.basename} {$txnjson-file.IO.basename}";

    say "Finished making: %txninfo<pkgname> ",
        "%txninfo<pkgver>-%txninfo<pkgrel> ($dt)";

    say "Cleaning up…";

    # clean up build directory
    dir($build-dir)».unlink;
    rmdir $build-dir;
}

sub get-entities-seen(@txn) returns Array
{
    my Str @entities-seen;

    for @txn -> $entry
    {
        for $entry<postings>.Array -> $posting
        {
            push @entities-seen, $posting<account><entity>;
        }
    }

    @entities-seen .= unique;
    @entities-seen .= sort;
}

# resolve-txn-file-path {{{

multi sub exists-readable-file(
    Str $file,
    :@checks! where *.elems == 1
) returns Array
{
    exists-readable-file($file, :checks[|@checks, $file.IO.r]);
}

multi sub exists-readable-file(
    Str $file,
    :@checks! where *.elems == 2
) returns Array
{
    exists-readable-file($file, :checks[|@checks, $file.IO.f]);
}

multi sub exists-readable-file(
    Str $file,
    :@checks! where *.elems == 3
) returns Array
{
    @checks;
}

# you passed a direct-file-name.txn
multi sub exists-readable-file(
    Str:D $file where *.chars > 0 && *.IO.extension eq 'txn'
) returns Bool
{
    given exists-readable-file($file, :checks[$file.IO.e])
    {
        when $_[0] eqv False
        {
            die "Sorry, determined path 「$file」 does not exist";
        }
        when [True, True, True]
        {
            True;
        }
        when [True, True, False]
        {
            die "Sorry, determined path 「$file」 was not to file";
        }
        when [True, False, True]
        {
            die "Sorry, determined path 「$file」 was not readable";
        }
        when [True, False, False]
        {
            die "Sorry, determined path 「$file」 was not readable";
        }
    }
}

# you used a shortcut by leaving off the trailing chars '.txn'
multi sub exists-readable-file(Str:D $file where *.chars > 0) returns Bool
{
    # append .txn to bare file path
    given exists-readable-file("$file.txn", :checks["$file.txn".IO.e])
    {
        when $_[0] eqv False
        {
            die "Sorry, could not find txn file at path 「$file.txn」";
        }
        when [True, True, True]
        {
            True;
        }
        when [True, True, False]
        {
            die "Sorry, determined path 「$file.txn」 was not to file";
        }
        when [True, False, True]
        {
            die "Sorry, determined txn file at 「$file.txn」 was not readable";
        }
        when [True, False, False]
        {
            die "Sorry, determined path 「$file.txn」 was not readable";
        }
    }
}

# you didn't pass a filename
multi sub exists-readable-file(Str $file)
{
    die "txn file must exist";
}

sub resolve-txn-file-path(Str $file) returns Str
{
    die unless exists-readable-file($file);
    $file.IO.extension eq 'txn' ?? $file !! "$file.txn";
}

# end resolve-txn-file-path }}}

# pkgname-pkgver-pkgrel {{{

multi sub pkgname-pkgver-pkgrel(
    %txninfo,
    :@checks! where *.elems == 1
) returns Array
{
    pkgname-pkgver-pkgrel(%txninfo, :checks[|@checks, %txninfo<pkgver>:exists]);
}

multi sub pkgname-pkgver-pkgrel(
    %txninfo,
    :@checks! where *.elems == 2
) returns Array
{
    pkgname-pkgver-pkgrel(%txninfo, :checks[|@checks, %txninfo<pkgrel>:exists]);
}

multi sub pkgname-pkgver-pkgrel(
    %txninfo,
    :@checks! where *.elems == 3
) returns Array
{
    @checks;
}

sub has-pkgname-pkgver-pkgrel(%txninfo) returns Bool
{
    given pkgname-pkgver-pkgrel(%txninfo, :checks[%txninfo<pkgname>:exists])
    {
        when .grep(*.so).elems == .elems
        {
            True;
        }
        default
        {
            my Str $message = 'Sorry, ';
            my Str @missing;
            if $_[0] eqv False
            {
                push @missing, 'pkgname';
            }
            if $_[1] eqv False
            {
                push @missing, 'pkgver';
            }
            if $_[2] eqv False
            {
                push @missing, 'pkgrel';
            }
            $message ~= @missing.join(', ');
            $message ~= ' missing from %txninfo. Got:' ~ "\n";
            $message ~= %txninfo.perl;
            die $message;
        }
    }
}

# end pkgname-pkgver-pkgrel }}}

# vim: ft=perl6 fdm=marker fdl=0
