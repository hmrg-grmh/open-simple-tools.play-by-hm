#! /bin/bash

repo_choose ()
{
    case $1 in
    
        ghproxy)            echo https://ghproxy.com/https://github.com/ ;;
        mirror.ghproxy)     echo https://mirror.ghproxy.com/https://github.com/ ;;
        github)             echo https://github.com/ ;;
        gitclone)           echo https://gitclone.com/github.com/ ;;
        cnpmjs)             echo https://github.com.cnpmjs.org/ ;;
        fastgit)            echo https://hub.fastgit.org/ ;;
        
        *) echo WARN: err repo key >&2 `#; return 2` ;;
        
    esac ;
} &&


doc ()
{
    echo    :ideafromnet,   '"'https://stackoverflow.com/questions/21277806/fatal-early-eof-fatal-index-pack-failed'"' &&
    echo    :author,        '"'hmrg-grmh'"' ;
} &&



gits_clone ()
{
    
    `#(cd .git) || { /usr/bin/env git init ; } ;`
    
    
    while (($# != 0)) ;
    do
        case $1 in
        
            -f|--from-file) fromfile="$2" && shift 2 ;;
            -d|--max-depth) maxdepth=$2 && shift 2 ;;
            -p|--part-depth) partdepth=$2 && shift 2 ;;
            -r|--repo-choode) GIT_REPO=$2 && shift 2 ;;
            
            --|*) oth="$*" ; break ;;
            
        esac ;
    done &&
    
    fromfile="${fromfile:-/dev/stdin}" &&
    maxdepth=${maxdepth:-1024} &&
    partdepth=${partdepth:-2} &&
    GIT_REPO=${GIT_REPO:-cnpmjs} &&
    
    echo :in, "$fromfile", $maxdepth, $partdepth, $GIT_REPO &&
    
    repo_url_pre="$(repo_choose $GIT_REPO)" &&
    GIT_REPO_PRE_URL="${repo_url_pre:-${GIT_REPO_PRE_URL:-https://github.com/}}" &&
    
    [[ $fromfile == /dev/stdin ]] || [[ -f "$fromfile" ]] || { echo nofile "$fromfile" >&2 ; exit 2 ; } ;
    
    echo 'input cloning list:' &&
    cat "$fromfile" |
        tee -a /dev/stderr |
        xargs -i -P0 -- sh -c "$(
        echo '
        'logpath_pre'=''"$PWD"'"'"/'{}'.running.log"'" '&&' '
        mkdir' -p '"`' dirname "'"'{}'"'" '`"' '&&' '
        
        cd' "'"'{}'"'" '2>/dev/null' '||' '
        {' '
            echo' :msg, :first-clone, :repo :: "'"'{}'"'" '>&2' '&&' '
            /usr/bin/env git' clone `#-q` --depth $partdepth -- "'""$GIT_REPO_PRE_URL"/'{}'.git"'" "'"'{}'"'" '&>' '"''$'logpath_pre'"' '&&' '
            cd' "'"'{}'"'" ';' '
        }' '&&' '
        /usr/bin/env seq' -- $partdepth $partdepth $maxdepth '|' '
            while' read dep ';' '
            do' '
                /usr/bin/env git' fetch `#-q` --depth='$dep' '&>>' '"''$'logpath_pre'"' '||' '
                {' echo :err, :fetch-err :: depth:'$dep', :repo :: "'"'{}'"'" ';' exit 2 ';' '}' ';' '
            done' '&&' '
        /usr/bin/env git' pull `#-q` --all '&>>' '"''$'logpath_pre'"' '&&' '
        
        echo' :ok, :repo :: "'"'{}'"'" '||' '
        echo' :err, :repo :: "'"'{}'"'" ';' )" ;
} && 

doc `#>&2` >&2 &&
echo &&
gits_clone "$@" ; exit $? ;






configs_run () 
{
    gcf_add ()
    { /usr/bin/env git config --add $@ ; } &&
    
    (cd .git) || { /usr/bin/env git init ; } ;
    
    gcf_add     https.postbuffer            67108864 &&
    gcf_add     core.packedGitLimit         2048m &&
    gcf_add     core.packedGitWindowSize    2048m &&
    gcf_add     pack.deltaCacheSize         4095m &&
    gcf_add     pack.packSizeLimit          4095m &&
    gcf_add     pack.windowMemory           4095m &&
    gcf_add     core.compression            -1 ;
    
} ; `# may be you need this ...`


