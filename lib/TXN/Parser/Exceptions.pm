use v6;

# for Actions.entry verify entry is limited to one entity
class X::TXN::Parser::Entry::MultipleEntities is Exception
{
    has Str $.entry_text;
    has Int $.number_entities;

    method message()
    {
        say qq:to/EOF/;
        Sorry, only one entity per journal entry allowed, but found
        $.number_entities entities.

        In entry:

        「$.entry_text」
        EOF
    }
}

class X::TXN::Parser::Include is Exception
{
    has Str $.filename;

    method message()
    {
        say qq:to/EOF/;
        Sorry, could not load transaction journal to include at

            「$.filename」

        Transaction journal not found or not readable.
        EOF
    }
}

# vim: ft=perl6
