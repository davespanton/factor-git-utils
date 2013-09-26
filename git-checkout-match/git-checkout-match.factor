! Copyright (C) 2013 Dave Spanton.
! See http://factorcode.org/license.txt for BSD license.

USING: kernel accessors arrays grouping locals sequences sequences.deep sequences.extras math math.functions byte-arrays prettyprint core-foundation.launch-services images.loader images.http images.loader.cocoa ;

IN: imaging

: >pixels ( image -- arr )
    4 group ;

: rows ( image -- arr )
    dup bitmap>> >pixels swap dim>> first group ;

: >bitmap ( arr -- bytes )
    flatten >byte-array ;

: update-bitmap ( image bytes w h -- image )
    [ >bitmap >>bitmap ] 2dip 2array >>dim ;

:: >YUV ( r g b -- yuv )
    r 0.257 * g 0.504 * + b 0.098 * + 16 +
    r -0.148 * g 0.291 *  - b 0.439 * + 128 +
    r 0.439 * g 0.368 * - b 0.071 * - 128 +
    3array ;

: compare-pixels ( a a -- x )
    [ first3 >YUV rest ] bi@ [ - abs sq ] 2map-sum ;

: straight-compare-pixels ( a a -- x )
    [ - abs ] 2map-sum ;

: columns ( arr -- arr )
    [ 32 group ] map flip ;

: stripe ( image -- arr )
    rows columns ;

: un-stripe ( arr -- barr )
    flip flatten >byte-array ;

: neighbours ( arr arr -- arr arr )
    [ last ] map swap [ first ] map ;

:: compare-to-left ( arr -- arr )
   arr first length :> l
   arr dup cartesian-product
   [ :> i [ :> j i j =
            [ drop l 1024 * ]
            [ first2 neighbours [ compare-pixels ] 2map sum ]
            if ]
       map-index ] map-index ;

: find-left-index ( arr -- n )
    [ infimum ] map dup supremum swap index ;

: right-of-index ( n arr -- n n )
    [ nth ] with map dup infimum [ swap index ] keep ;

:: position-of ( comparison -- arr )
    comparison
    [ 1array :> out-order! :> row 0 :> score!
      [ out-order length comparison length < ]
      [ out-order last comparison right-of-index
        score + score!
        out-order swap suffix out-order! ]
      while { out-order score } ] map-index ;

: stripe-order ( arr -- arr )
    dup find-left-index swap position-of dupd remove-nth swap
    prefix ;

: arrange-stripes ( arr arr -- arr )
    swap nths  ;

: best-route ( arr -- arr )
    [ second ] infimum-by first ;

: unshred ( image -- image )
    dup stripe dup compare-to-left position-of best-route arrange-stripes
    un-stripe >>bitmap ;

: run ( -- )
    "~/shredded.png" load-image unshred  "/tmp/unshredded.png" kUTTypePNG
    save-ns-image ;

MAIN: run
