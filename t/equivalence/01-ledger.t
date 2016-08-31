use v6;
use lib 'lib';
use Test;
use TXN;

plan 1;

subtest
{
    my Str $file = 't/data/sample/sample.txn';

    # with TXN::Parser
    my Match $match-ledger = TXN::Parser.parsefile($file);

    # with TXN
    my TXN::Parser::AST::Entry @entry = from-txn(:$file);

    is-deeply(
        @entry,
        $match-ledger.made,
        q:to/EOF/
        ♪ [Is from-txn equivalent to Match.made?] - 1 of 1
        ┏━━━━━━━━━━━━━┓
        ┃             ┃  ∙ from-txn produces equivalent results to
        ┃   Success   ┃    Match.made, as expected
        ┃             ┃
        ┗━━━━━━━━━━━━━┛
        EOF
    );
}

# vim: set filetype=perl6 foldmethod=marker foldlevel=0:
