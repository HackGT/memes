// pull in desired CSS/SASS files
require( './styles/main.scss' );
require( '../../node_modules/bulma/bulma.sass' );

// inject bundled Elm app into div#main
var Elm = require( '../elm/Main' );
Elm.Main.embed( document.getElementById( 'main' ) );
