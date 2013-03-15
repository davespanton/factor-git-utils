#! /usr/bin/env factor

USING: combinators command-line namespaces locals locals.types io io.encodings.utf8 io.launcher math sequences sets splitting system kernel ;

IN: arg-filter

: validate-args ( -- t )
    [let command-line get :> args
        { { [ args length 0 = ] [ "No arguments passed.\n" print f ] }
          { [ args length 1 = ] [ t ] }
          { [ args length 1 > ] [ "More than one argument passed.\n" print f ] } } cond ] ;

: first-arg ( -- str )
    command-line get dup length 1 = [ first ] [ drop "" ] if ;

: contains-arg? ( str -- ? )
    first-arg swap subseq? ;

: last-part ( str -- str )
    "/" split last ;

: remove-star ( str -- str )
    [ CHAR: * = ] trim-head ;

: remove-spaces ( str -- str )
    [ 32 = ] trim ;

: git-branch-cmd ( -- seq )
    { "git" "branch" "-a" } utf8 [ lines ] with-process-reader ;

:: git-checkout-cmd ( branch -- seq )
    { "git" "checkout" branch } utf8 [ lines ] with-process-reader ;

:: eval-results ( s -- )
    { { [ s length 0 = ] [ "No matching branches found.\n" print ] }
      { [ s length 1 > ] [ "Several results found:\n" print s [ print ] each ] }
      [  s first git-checkout-cmd [ print ] each ] } cond ;

: trim-input ( str -- str )
    remove-star remove-spaces last-part ;


validate-args
  [ git-branch-cmd [ trim-input ] map [ contains-arg? ] filter members eval-results ]
  [ "Bye!" print ]
if
