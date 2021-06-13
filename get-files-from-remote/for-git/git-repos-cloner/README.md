这个用来批量下载 github (或别处(别处还没测)) 的代码。

[`grepos-clone.sh`](./grepos-clone.sh):

```bash
#! /bin/bash

repo_choose ()
{
    case $1 in
    
        github)             echo https://github.com ;;
        ghproxy)            echo https://ghproxy.com/https://github.com ;;
        mirror.ghproxy)     echo https://mirror.ghproxy.com/https://github.com ;;
        gitclone)           echo https://gitclone.com/github.com ;;
        cnpmjs)             echo https://github.com.cnpmjs.org ;;
        fastgit)            echo https://hub.fastgit.org ;;
        
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
    
    
    while (($# != 0)) ; `# opts here`
    do
        case $1 in
        
            -k|--parser-itself) kritik="${2:-echo}" && shift 2 ;;
            -f|--from-file) fromfile="$2" && shift 2 ;;
            -d|--max-depth) maxdepth=$2 && shift 2 ;;
            -p|--part-depth) partdepth=$2 && shift 2 ;;
            -r|--repo-choode) GIT_REPO=$2 && shift 2 ;;
            
            --|*) oth="$*" && break ;;
            
        esac ;
    done &&
    
    kritik="${kritik:-sh -c}" &&
    fromfile="${fromfile:-/dev/stdin}" &&
    maxdepth=${maxdepth:-1024} &&
    partdepth=${partdepth:-2} &&
    GIT_REPO=${GIT_REPO:-github} &&
    
    echo :in, $kritik, "$fromfile", $maxdepth, $partdepth, $GIT_REPO &&
    
    repo_url_pre="$(repo_choose $GIT_REPO)" &&
    GIT_REPO_PRE_URL="${repo_url_pre:-${GIT_REPO_PRE_URL:-git://github.com}}" &&
    
    [[ $fromfile == /dev/stdin ]] || [[ -f "$fromfile" ]] || { echo nofile "$fromfile" >&2 ; exit 2 ; } ;
    
    echo 'input cloning list:' &&
    cat "$fromfile" |
        tee -a /dev/stderr |
        xargs -i -P0 --  $kritik  "$(
        echo '
        'logpath_pre'=''"$PWD"'"'"/'{}'.running.log"'" '&&' '
        mkdir' -p '"`' dirname "'"'{}'"'" '`"' '&&' '
        
        'repo_url'='"'""$GIT_REPO_PRE_URL"/'{}'.git"'" '&&' '
        cd' "'"'{}'"'" '2>/dev/null' '||' '
        {' '
            echo' :msg, :starting :: first-clone, :repo :: "'"'{}'"'" '>&2' '&&' '
            /usr/bin/env git' clone `#-q` --depth $partdepth --  '"$'repo_url'"'   "'"'{}'"'"   '&>'   '"$'logpath_pre'"'   '&&'  '
            cd' "'"'{}'"'" ';' '
        }' '&&' '
        /usr/bin/env seq' -- $partdepth $partdepth $maxdepth '|' '
            while' read dep ';' '
            do' '
                echo' :msg, :starting :: fetch-'$dep', :repo :: "'"'{}'"'" '>&2' '&&' '
                /usr/bin/env git' fetch `#-q` --depth='$dep'   '"$'repo_url'"'    '&>>'  '"$'logpath_pre'"'   '||'  '
                {' echo :msg, :fetch-err :: depth:'$dep', :repo :: "'"'{}'"'" '>&2' ';' exit 2 ';' '}' ';' '
            done' '&&' '
        /usr/bin/env git' pull `#-q` --all   '&>>'  '"$'logpath_pre'"'  '&&'  '
        
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



```

simple usage:

```bash
echo '
cisco/ChezScheme
tsasioglu/Total-Uninstaller
elixir-lang/ex_doc
nilaoda/BBDown
StepfenShawn/Cantonese
triska/the-power-of-prolog
hashicorp/vagrant
mthom/scryer-prolog' | grepos-clone.sh
```

这个脚本目前无法处理文件夹已经建好但 `.git` 损坏或没有的情况。  
这时候请自行删除对应的目录。删一层总之确保对它 `cd` 会出错就行。

在 msys2 里尝试的情况有点惨不忍睹，直接 `^C` 会让那个 `sh` 进程成为孤👶。

