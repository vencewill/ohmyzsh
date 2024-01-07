#!/usr/bin/env zsh

__podfile_completion() {
    setopt localoptions noshwordsplit noksh_arrays noposixbuiltins
    local tokens cmd
    
    tokens=(${(z)LBUFFER})
    cmd=${tokens[1]}
    
    if [[ "$LBUFFER" =~ "^\ *[^\ ]*\/Podfile\ *$" ]]; then
        LBUFFER="pod install --project-directory=\"$(echo $LBUFFER | sed 's/Podfile\ *$//' | sed 's/^\ *//')\""
    else
        zle ${__zic_default_completion:-expand-or-complete}
    fi
}

[ -z "$__zic_default_completion" ] && {
    binding=$(bindkey '^I')
    # $binding[(s: :w)2]
    # The command substitution and following word splitting to determine the
    # default zle widget for ^I formerly only works if the IFS parameter contains
    # a space via $binding[(w)2]. Now it specifically splits at spaces, regardless
    # of IFS.
    [[ $binding =~ 'undefined-key' ]] || __zic_default_completion=$binding[(s: :w)2]
    unset binding
}

zle -N __podfile_completion
if [ -z $zic_custom_binding ]; then
    zic_custom_binding='^I'
fi
bindkey "${zic_custom_binding}" __podfile_completion
