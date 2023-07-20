# Installation

## Preliminaries

TODO: `git-secrets` explanation.

## Repository

Using submodule for [`redbad-setup`](https://github.com/rubigdata/redbad-setup).

    git submodule add -b main git@github.com:rubigdata/redbad-setup.git
    git submodule init
    git commit -a
		
    cd redbad-setup
    git submodule update --init --recursive
