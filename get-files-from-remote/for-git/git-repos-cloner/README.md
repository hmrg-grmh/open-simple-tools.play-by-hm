这个用来批量下载 github (或别处(别处还没测)) 的代码。

[`grepos-clone.sh`](./grepos-clone.sh):

```bash
#! /bin/bash

repo_chooser ()
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



repo_lister ()
{
    {
        echo https://github.com ;
        echo https://ghproxy.com/https://github.com ;
        echo https://mirror.ghproxy.com/https://github.com ;
        echo https://gitclone.com/github.com ;
        echo https://github.com.cnpmjs.org ;
        echo https://hub.fastgit.org ;
    } |
        awk "${1:-//}"
} ;



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
            -b|--begin-fetchdepth) bgfetch=$2 && shift 2 ;;
            -p|--part-depth) partdepth=$2 && shift 2 ;;
            
            -c|--clone-depth) clonedepth=$2 && shift 2 ;;
            -r|--repo-choode) GIT_REPO=$2 && shift 2 ;;
            
            --|*) oth="$*" && break ;;
            
        esac ;
    done &&
    
    
    
    kritik="${kritik:-sh -c}" &&
    fromfile="${fromfile:-/dev/stdin}" &&
    
    maxdepth=${maxdepth:-1024} &&
    bgfetch=${bgfetch:-4} &&
    partdepth=${partdepth:-2} &&
    
    clonedepth=${clonedepth:-$partdepth} &&
    GIT_REPO=${GIT_REPO:-github} &&
    
    
    {
        echo :in :: ;
        echo :k :: $kritik, :f :: "$fromfile", :d :: $maxdepth, ;
        echo :b :: $bgfetch, :p :: $partdepth, :c :: $clonedepth, ;
        echo :r :: $GIT_REPO ;
    } &&
    
    
    
    repo_url_pre="$(repo_chooser $GIT_REPO)" &&
    GIT_REPO_PRE_URL="${repo_url_pre:-${GIT_REPO_PRE_URL:-git://github.com}}" &&
    
    [[ $fromfile == /dev/stdin ]] || [[ -f "$fromfile" ]] || { echo nofile "$fromfile" >&2 ; exit 2 ; } ;
    
    
    fetch_iter ()
    {
        repo_iter ()
        {
            {
                echo https://github.com ;
                echo https://ghproxy.com/https://github.com ;
                echo https://mirror.ghproxy.com/https://github.com ;
                echo https://gitclone.com/github.com ;
                echo https://github.com.cnpmjs.org ;
                echo https://hub.fastgit.org ;
            } |
                awk "${1:-//}" &&
            exec ${2:-sh -c} repo_iter' '"$1"' '"'$2'" ;
        } &&
        export -f repo_iter &&
        
        dep=$1 repo="$2" kritic="${3:-bash -c}" repoawk="${4:-//}" &&
        (repo_iter "$repoawk" "$kritic") |
            awk '
            {
                echo = "echo" ; s = ":" ; msg = "msg" ; fetching = "fetching" ;
                dep = "dep" ; repo = "repo" ; aa = "&&" ; oo = "||" ; c = "," ; ff = ";" ;
                
                git = "/usr/bin/env git" ; fetch = "fetch" ; depth = "depth" ;
                repo_url = $0"/'"$repo"'" ; mm = "--" ; eq = "=" ; url = "url" ;
                
                lefb = "{" ; rigb = "}" ; ln = "-" ; err = "err" ; ii = s""s ; xexit = "exit" ;
                
                print  echo, s""msg""c, s""fetching""c, s""dep, ii, '$dep'""c, s""url, ii, "'"'"'"repo_url"'"'"'", aa ;
                print  git, fetch, mm""depth""eq"'$dep'", "'"'"'"repo_url"'"'"'", aa, lefb, xexit, 0, ff, rigb, ff ;
            } ' ;
    } &&
    export -f fetch_iter &&
    gtone () { echo $1 ; } &&
    
    
    
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
        /usr/bin/env seq' -- $bgfetch $partdepth $maxdepth '|' '
            while' read dep ';' '
            do' '
                echo' :msg, :starting :: fetch-'$dep', :repo :: "'"'{}'"'" '>&2' '&&' '
                fetch_iter'  '$dep'   "'"'{}'"'"   "'$kritik'"  '|'  $(gtone $kritik)   '&>>'  '"$'logpath_pre'"'  '||'  '
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

更新：

- `git fetch` 部分增加了重试机制。
- 这个重试机制基于刚刚发现的*类尾递归*写法。

🐍🐍🐍🐍🐍🐍🐍🐍🐍🐍🐍🐍🐍🐍🐍🐍🐍

当然了，这玩意现在用 simple usage 都很花我 CPU 了（没占满但温度不小），  
所以在性能的节约高效利用上还有待优化。  

> 实际在 Windows 的 Msys2 试了一下，正常运作还行，但如果结束进程树的话，就会出现一些十分刚烈的失控的现象，故建议轻易不要使用。。。。


