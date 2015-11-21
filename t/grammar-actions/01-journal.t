use v6;
use lib 'lib';
use Test;
use TXN;

plan 2;

subtest
{
    my Str $file = 't/data/sample/sample.txn';

    my TXN::Parser::Actions $actions .= new;
    my $match_journal = TXN::Parser::Grammar.parsefile($file, :$actions);

    is(
        $match_journal.WHAT,
        Match,
        q:to/EOF/
        ♪ [Grammar.parse($document)] - 1 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ Parses transaction journal successfully
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match_journal.made.WHAT,
        Array,
        q:to/EOF/
        ♪ [Is array?] - 2 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made.WHAT ~~ Array
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        $match_journal.made[0]<header><date>.Date,
        "2014-01-01",
        q:to/EOF/
        ♪ [Is expected value?] - 3 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<header><date>.Date
        ┃   Success   ┃        ~~ "2014-01-01"
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_journal.made[0]<header><description>,
        'I started the year with $1000 in Bankwest cheque account',
        q:to/EOF/
        ♪ [Is expected value?] - 4 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<header><description>
        ┃   Success   ┃        ~~ '...'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_journal.made[0]<header><important>,
        0,
        q:to/EOF/
        ♪ [Is expected value?] - 5 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<header><important>
        ┃   Success   ┃        == 0
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_journal.made[0]<header><tags>[0],
        'TAG1',
        q:to/EOF/
        ♪ [Is expected value?] - 6 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<header><tags>[0]
        ┃   Success   ┃        ~~ 'TAG1'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_journal.made[0]<header><tags>[1],
        'TAG2',
        q:to/EOF/
        ♪ [Is expected value?] - 7 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<header><tags>[1]
        ┃   Success   ┃        ~~ 'TAG2'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_journal.made[0]<id><number>,
        0,
        q:to/EOF/
        ♪ [Is expected value?] - 8 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<id><number>
        ┃   Success   ┃        == 0
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_journal.made[0]<id><text>,
        "2014-01-01 \"I started the year with \$1000 in Bankwest cheque account\" \@TAG1 \@TAG2 # EODESC COMMENT\n  # this is a comment line\n  Assets:Personal:Bankwest:Cheque    \$1000.00 USD\n  # this is a second comment line\n  Equity:Personal                    \$1000.00 USD # EOL COMMENT\n  # this is a third comment line\n# this is a stray comment\n# another\n",
        q:to/EOF/
        ♪ [Is expected value?] - 9 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<id><text>
        ┃   Success   ┃        ~~ "..."
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_journal.made[0]<id><xxhash>,
        3251202721,
        q:to/EOF/
        ♪ [Is expected value?] - 10 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<id><xxhash>
        ┃   Success   ┃        == 3251202721
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_journal.made[0]<postings>[0]<account><entity>,
        'Personal',
        q:to/EOF/
        ♪ [Is expected value?] - 11 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<postings>[0]<account><entity>
        ┃   Success   ┃        ~~ 'Personal'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_journal.made[0]<postings>[0]<account><silo>,
        'ASSETS',
        q:to/EOF/
        ♪ [Is expected value?] - 12 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<postings>[0]<account><silo>
        ┃   Success   ┃        ~~ 'ASSETS'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_journal.made[0]<postings>[0]<account><subaccount>[0],
        'Bankwest',
        q:to/EOF/
        ♪ [Is expected value?] - 13 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<postings>[0]<account><subaccount>[0]
        ┃   Success   ┃        ~~ 'Bankwest'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_journal.made[0]<postings>[0]<account><subaccount>[1],
        'Cheque',
        q:to/EOF/
        ♪ [Is expected value?] - 14 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<postings>[0]<account><subaccount>[1]
        ┃   Success   ┃        ~~ 'Cheque'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_journal.made[0]<postings>[0]<amount><asset_code>,
        'USD',
        q:to/EOF/
        ♪ [Is expected value?] - 15 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<postings>[0]<amount><asset_code>
        ┃   Success   ┃        ~~ 'USD'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_journal.made[0]<postings>[0]<amount><asset_quantity>,
        1000.0,
        q:to/EOF/
        ♪ [Is expected value?] - 16 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<postings>[0]<amount><asset_quantity>
        ┃   Success   ┃        == 1000.0
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_journal.made[0]<postings>[0]<amount><asset_symbol>,
        '$',
        q:to/EOF/
        ♪ [Is expected value?] - 17 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<postings>[0]<amount><asset_symbol>
        ┃   Success   ┃        ~~ '$'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_journal.made[0]<postings>[0]<amount><exchange_rate>,
        {},
        q:to/EOF/
        ♪ [Is expected value?] - 18 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<postings>[0]<amount><exchange_rate>
        ┃   Success   ┃        ~~ {}
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_journal.made[0]<postings>[0]<amount><plus_or_minus>,
        '',
        q:to/EOF/
        ♪ [Is expected value?] - 19 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<postings>[0]<amount><plus_or_minus>
        ┃   Success   ┃        ~~ ''
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_journal.made[0]<postings>[0]<decinc>,
        'INC',
        q:to/EOF/
        ♪ [Is expected value?] - 20 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<postings>[0]<decinc>
        ┃   Success   ┃        ~~ 'INC'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_journal.made[0]<postings>[0]<id><number>,
        0,
        q:to/EOF/
        ♪ [Is expected value?] - 21 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<postings>[0]<id><number>
        ┃   Success   ┃        == 0
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_journal.made[0]<postings>[0]<id><text>,
        'Assets:Personal:Bankwest:Cheque    $1000.00 USD',
        q:to/EOF/
        ♪ [Is expected value?] - 22 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<postings>[0]<id><text>
        ┃   Success   ┃        ~~ '...'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_journal.made[0]<postings>[0]<id><xxhash>,
        352942826,
        q:to/EOF/
        ♪ [Is expected value?] - 23 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<postings>[0]<id><xxhash>
        ┃   Success   ┃        == 352942826
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_journal.made[0]<postings>[0]<id><entry_id><number>,
        0,
        q:to/EOF/
        ♪ [Is expected value?] - 24 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<postings>[0]<id><entry_id><number>
        ┃   Success   ┃        == 0
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_journal.made[0]<postings>[0]<id><entry_id><text>,
        "2014-01-01 \"I started the year with \$1000 in Bankwest cheque account\" \@TAG1 \@TAG2 # EODESC COMMENT\n  # this is a comment line\n  Assets:Personal:Bankwest:Cheque    \$1000.00 USD\n  # this is a second comment line\n  Equity:Personal                    \$1000.00 USD # EOL COMMENT\n  # this is a third comment line\n# this is a stray comment\n# another\n",
        q:to/EOF/
        ♪ [Is expected value?] - 25 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<postings>[0]<id><entry_id><text>
        ┃   Success   ┃        ~~ "..."
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_journal.made[0]<postings>[0]<id><entry_id><xxhash>,
        3251202721,
        q:to/EOF/
        ♪ [Is expected value?] - 26 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<postings>[0]<id><entry_id><xxhash>
        ┃   Success   ┃        == 3251202721
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

subtest
{
    my Str $file = 't/data/with-includes/jrnl/with-includes.txn';
    my @txn = from-txn(:$file);

    is(
        @txn[0]<header><date>.Date,
        "2011-01-01",
        q:to/EOF/
        ♪ [Is expected value?] - 27 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<header><date>.Date ~~ "2011-01-01"
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<header><description>,
        'FooCorp started the year with $1000 in Bankwest cheque account',
        q:to/EOF/
        ♪ [Is expected value?] - 28 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<header><description> ~~ '...'
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<header><important>,
        0,
        q:to/EOF/
        ♪ [Is expected value?] - 29 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<header><important> == 0
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<id><number>,
        0,
        q:to/EOF/
        ♪ [Is expected value?] - 30 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<id><number> == 0
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<id><text>,
        "2011-01-01 \"FooCorp started the year with \$1000 in Bankwest cheque account\"\n  Assets:FooCorp:Bankwest:Cheque      \$1000.00 USD\n  Equity:FooCorp                      \$1000.00 USD\n",
        q:to/EOF/
        ♪ [Is expected value?] - 31 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<id><text> ~~ "..."
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<id><xxhash>,
        4150991411,
        q:to/EOF/
        ♪ [Is expected value?] - 32 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<id><xxhash> == 4150991411
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[0]<account><entity>,
        'FooCorp',
        q:to/EOF/
        ♪ [Is expected value?] - 33 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[0]<account><entity>
        ┃   Success   ┃        ~~ 'FooCorp'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[0]<account><silo>,
        'ASSETS',
        q:to/EOF/
        ♪ [Is expected value?] - 34 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[0]<account><silo>
        ┃   Success   ┃        ~~ 'ASSETS'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[0]<account><subaccount>[0],
        'Bankwest',
        q:to/EOF/
        ♪ [Is expected value?] - 35 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[0]<account><subaccount>[0]
        ┃   Success   ┃        ~~ 'Bankwest'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[0]<account><subaccount>[1],
        'Cheque',
        q:to/EOF/
        ♪ [Is expected value?] - 36 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[0]<account><subaccount>[1]
        ┃   Success   ┃        ~~ 'Cheque'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[0]<amount><asset_code>,
        'USD',
        q:to/EOF/
        ♪ [Is expected value?] - 37 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[0]<amount><asset_code>
        ┃   Success   ┃        ~~ 'USD'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[0]<amount><asset_quantity>,
        1000.0,
        q:to/EOF/
        ♪ [Is expected value?] - 38 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[0]<amount><asset_quantity>
        ┃   Success   ┃        == 1000.0
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[0]<amount><asset_symbol>,
        '$',
        q:to/EOF/
        ♪ [Is expected value?] - 39 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[0]<amount><asset_symbol>
        ┃   Success   ┃        ~~ '$'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[0]<decinc>,
        'INC',
        q:to/EOF/
        ♪ [Is expected value?] - 40 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[0]<decinc> ~~ 'INC'
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[0]<id><entry_id><number>,
        0,
        q:to/EOF/
        ♪ [Is expected value?] - 41 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[0]<id><entry_id><number>
        ┃   Success   ┃        == 0
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[0]<id><entry_id><text>,
        "2011-01-01 \"FooCorp started the year with \$1000 in Bankwest cheque account\"\n  Assets:FooCorp:Bankwest:Cheque      \$1000.00 USD\n  Equity:FooCorp                      \$1000.00 USD\n",
        q:to/EOF/
        ♪ [Is expected value?] - 42 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[0]<id><entry_id><text>
        ┃   Success   ┃        ~~ "..."
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[0]<id><entry_id><xxhash>,
        4150991411,
        q:to/EOF/
        ♪ [Is expected value?] - 43 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[0]<id><entry_id><xxhash>
        ┃   Success   ┃        == 4150991411
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[0]<id><number>,
        0,
        q:to/EOF/
        ♪ [Is expected value?] - 44 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[0]<id><number> == 0
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[0]<id><text>,
        "Assets:FooCorp:Bankwest:Cheque      \$1000.00 USD",
        q:to/EOF/
        ♪ [Is expected value?] - 45 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[0]<id><text> ~~ "..."
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[0]<id><xxhash>,
        3244003616,
        q:to/EOF/
        ♪ [Is expected value?] - 46 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[0]<id><xxhash> == 3244003616
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[1]<account><entity>,
        'FooCorp',
        q:to/EOF/
        ♪ [Is expected value?] - 47 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[1]<account><entity> ~~ 'FooCorp'
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[1]<account><silo>,
        'EQUITY',
        q:to/EOF/
        ♪ [Is expected value?] - 48 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[1]<account><silo> ~~ 'EQUITY'
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[1]<amount><asset_code>,
        'USD',
        q:to/EOF/
        ♪ [Is expected value?] - 49 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[1]<amount><asset_code>
        ┃   Success   ┃        ~~ 'USD'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[1]<amount><asset_quantity>,
        1000.0,
        q:to/EOF/
        ♪ [Is expected value?] - 50 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[1]<amount><asset_quantity>
        ┃   Success   ┃        == 1000.0
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[1]<amount><asset_symbol>,
        '$',
        q:to/EOF/
        ♪ [Is expected value?] - 51 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[1]<amount><asset_symbol>
        ┃   Success   ┃        ~~ '$'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[1]<decinc>,
        'INC',
        q:to/EOF/
        ♪ [Is expected value?] - 52 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[1]<decinc> ~~ 'INC'
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[1]<id><entry_id><number>,
        0,
        q:to/EOF/
        ♪ [Is expected value?] - 53 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[1]<id><entry_id><number>
        ┃   Success   ┃        == 0
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[1]<id><entry_id><text>,
        "2011-01-01 \"FooCorp started the year with \$1000 in Bankwest cheque account\"\n  Assets:FooCorp:Bankwest:Cheque      \$1000.00 USD\n  Equity:FooCorp                      \$1000.00 USD\n",
        q:to/EOF/
        ♪ [Is expected value?] - 54 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[1]<id><entry_id><text>
        ┃   Success   ┃        ~~ "..."
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[1]<id><entry_id><xxhash>,
        4150991411,
        q:to/EOF/
        ♪ [Is expected value?] - 55 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[1]<id><entry_id><xxhash>
        ┃   Success   ┃        == 4150991411
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[1]<id><number>,
        1,
        q:to/EOF/
        ♪ [Is expected value?] - 56 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[1]<id><number> == 1
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[1]<id><text>,
        "Equity:FooCorp                      \$1000.00 USD",
        q:to/EOF/
        ♪ [Is expected value?] - 57 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[1]<id><text> ~~ "..."
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        @txn[0]<postings>[1]<id><xxhash>,
        1025058054,
        q:to/EOF/
        ♪ [Is expected value?] - 58 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[0]<postings>[1]<id><xxhash> == 1025058054
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        @txn[1]<header><date>.Date,
        "2012-01-01",
        q:to/EOF/
        ♪ [Is expected value?] - 59 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[1]<header><date>.Date ~~ "2012-01-01"
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        @txn[2]<header><date>.Date,
        "2013-01-01",
        q:to/EOF/
        ♪ [Is expected value?] - 60 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[2]<header><date>.Date ~~ "2013-01-01"
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );

    is(
        @txn[3]<header><date>.Date,
        "2014-01-01",
        q:to/EOF/
        ♪ [Is expected value?] - 61 of 61
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ @txn[3]<header><date>.Date ~~ "2014-01-01"
        ┃   Success   ┃
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

# vim: ft=perl6