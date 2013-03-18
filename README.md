Some Git utilities (only one at the moment), written in Factor.
==============================================================

_These only exist to help me learn Factor. They're not particularly tested and quite likey to break. They're definitely not to be taken too seriously._

### Usage

Run from a git repository passing the partial name of a local or remote branch as the argument.

For example:

`git checkout-match mast`

Will checkout master (if no other branches contain 'mast')

If a single match is found the branch will be checked out. If that match only exists as a remote branch, them a new local branch of the same name will be created
to track the remote version and it will be checked out.

If no matches or multiple matches are found, you will be informed.

### Installation

Ensure you have [Factor](www.factorcode.org) installed.

Clone the project.

**Compiled**

Load the Factor listener and:

Add the project's location to Factor's vocab root

```factor
USE: vocabs.loader
"path/to/project" add-vocab-root
```

and then run:

```factor
USING: tools.deploy git-checkout-match ;
"git-checkout-match" deploy
```

This should create a binary called git-checkout-match in FACTOR_ROOT/git-checkout-match/ . Put this somewhere on your path.

**Script**

_This approach has only been tried on Unix systems and follows the instruction from the [Scripting Cookbook](http://docs.factorcode.org:8080/content/article-cookbook-scripts.html) in the Factor documentation._

Copy git-checkout-match.factor to somewhere on your path and rename it to git-checkout-match.
