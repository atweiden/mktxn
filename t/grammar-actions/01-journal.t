use v6;
use lib 'lib';
use Test;
use TXN::Parser::Actions;
use TXN::Parser::Grammar;

plan 1;

subtest
{
    my Str $file = 't/data/sample/sample.txn';

    my TXN::Parser::Actions $actions .= new;
    my $match_journal = TXN::Parser::Grammar.parsefile($file, :$actions);

    is(
        $match_journal.WHAT,
        Match,
        q:to/EOF/
        ♪ [Grammar.parse($document)] - 1 of 26
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
        ♪ [Is array?] - 2 of 26
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
        ♪ [Is expected value?] - 3 of 26
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
        ♪ [Is expected value?] - 4 of 26
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<header><descripon>
        ┃   Success   ┃        ~~ '...'
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
    is(
        $match_journal.made[0]<header><important>,
        0,
        q:to/EOF/
        ♪ [Is expected value?] - 5 of 26
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
        ♪ [Is expected value?] - 6 of 26
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
        ♪ [Is expected value?] - 7 of 26
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
        ♪ [Is expected value?] - 8 of 26
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
        ♪ [Is expected value?] - 9 of 26
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
        ♪ [Is expected value?] - 10 of 26
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
        ♪ [Is expected value?] - 11 of 26
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
        ♪ [Is expected value?] - 12 of 26
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
        ♪ [Is expected value?] - 13 of 26
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
        ♪ [Is expected value?] - 14 of 26
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
        ♪ [Is expected value?] - 15 of 26
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
        ♪ [Is expected value?] - 16 of 26
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
        ♪ [Is expected value?] - 17 of 26
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
        ♪ [Is expected value?] - 18 of 26
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
        ♪ [Is expected value?] - 19 of 26
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
        ♪ [Is expected value?] - 20 of 26
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
        ♪ [Is expected value?] - 21 of 26
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
        ♪ [Is expected value?] - 22 of 26
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
        ♪ [Is expected value?] - 23 of 26
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
        ♪ [Is expected value?] - 24 of 26
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
        ♪ [Is expected value?] - 25 of 26
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
        ♪ [Is expected value?] - 26 of 26
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ $match_journal.made[0]<postings>[0]<id><entry_id><xxhash>
        ┃   Success   ┃        == 3251202721
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

# vim: ft=perl6
