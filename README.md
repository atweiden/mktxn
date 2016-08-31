# TXN

Double-entry accounting ledger parser and serializer


## Synopsis

**cmdline**

```sh
mktxn \
  --pkgname="txnjrnl" \
  --pkgver="1.0.0" \
  --pkgrel=1 \
  --pkgdesc="My transactions" \
  sample.txn
```

**perl6**

Parse ledger from string:

```perl6
use TXN;

my $txn = Q:to/EOF/;
2014-01-01 "I started the year with $1000 in Bankwest"
  Assets:Personal:Bankwest:Cheque    $1000 USD
  Equity:Personal                    $1000 USD
EOF
my TXN::Parser::AST::Entry @entry = from-txn($txn);
```

Parse ledger from file:

```perl6
use TXN;

my $file = 'sample.txn';
my TXN::Parser::AST::Entry @entry = from-txn(:$file);
```


## Description

Serializes double-entry accounting ledgers to JSON.

### Release Mode

In release mode, mktxn produces a tarball comprised of two JSON files:

#### .TXNINFO

Inspired by Arch Linux `.PKGINFO` files, `.TXNINFO` files contain
accounting ledger metadata useful in simple queries.

```json
{
   "count" : 112,
   "pkgrel" : 1,
   "entities-seen" : [
      "FooCorp",
      "Personal",
      "WigwamLLC"
   ],
   "pkgver" : "1.0.0",
   "pkgname" : "with-includes",
   "pkgdesc" : "txn with include directives",
   "compiler" : "mktxn v0.0.2 2016-05-10T10:22:44.054586-07:00"
}
```

#### txn.json

txn.json contains the output of serializing the accounting ledger to JSON.

```json
[
  {
    "id" : {
      "xxhash" : 1468523538,
      "text" : "2014-01-01 \"I started the year with $1000 in Bankwest cheque account\"\n  Assets:Personal:Bankwest:Cheque      $1000.00 USD\n  Equity:Personal                      $1000.00 USD",
      "number" : [
        3
      ]
    },
    "header" : {
      "tag" : [ ],
      "important" : 0,
      "description" : "I started the year with $1000 in Bankwest cheque account",
      "date" : "2014-01-01"
    },
    "posting" : [
      {
        "annot" : null,
        "id" : {
          "xxhash" : 4134277096,
          "text" : "Assets:Personal:Bankwest:Cheque      $1000.00 USD",
          "entry-id" : {
            "xxhash" : 1468523538,
            "text" : "2014-01-01 \"I started the year with $1000 in Bankwest cheque account\"\n  Assets:Personal:Bankwest:Cheque      $1000.00 USD\n  Equity:Personal                      $1000.00 USD",
            "number" : [
              3
            ]
          },
          "number" : 0
        },
        "drcr" : "DEBIT",
        "decinc" : "INC",
        "amount" : {
          "asset-code" : "USD",
          "asset-symbol" : "$",
          "plus-or-minus" : null,
          "asset-quantity" : 1000
        },
        "account" : {
          "entity" : "Personal",
          "path" : [
            "Bankwest",
            "Cheque"
          ],
          "silo" : "ASSETS"
        }
      },
      {
        "annot" : null,
        "id" : {
          "xxhash" : 344831063,
          "text" : "Equity:Personal                      $1000.00 USD",
          "entry-id" : {
            "xxhash" : 1468523538,
            "text" : "2014-01-01 \"I started the year with $1000 in Bankwest cheque account\"\n  Assets:Personal:Bankwest:Cheque      $1000.00 USD\n  Equity:Personal                      $1000.00 USD",
            "number" : [
              3
            ]
          },
          "number" : 1
        },
        "drcr" : "CREDIT",
        "decinc" : "INC",
        "amount" : {
          "asset-code" : "USD",
          "asset-symbol" : "$",
          "plus-or-minus" : null,
          "asset-quantity" : 1000
        },
        "account" : {
          "entity" : "Personal",
          "path" : [ ],
          "silo" : "EQUITY"
        }
      }
    ]
  }
]
```

`.TXNINFO` and `txn.json` are compressed and saved as filename
`$pkgname-$pkgver-$pkgrel.txn.tar.xz` in the current working directory.


## Installation

### Dependencies

- Rakudo Perl6
- [Config::TOML](https://github.com/atweiden/config-toml)
- [File::Presence](https://github.com/atweiden/file-presence)
- [TXN::Parser](https://github.com/atweiden/txn-parser)

### Test Dependencies

- [Peru](https://github.com/buildinspace/peru)

To run the tests:

```
$ git clone https://github.com/atweiden/mktxn && cd mktxn
$ peru --file=.peru.yml --sync-dir="$PWD" sync
$ PERL6LIB=lib prove -r -e perl6
```


## Licensing

This is free and unencumbered public domain software. For more
information, see http://unlicense.org/ or the accompanying UNLICENSE file.
