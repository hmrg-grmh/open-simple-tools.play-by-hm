! /usr/bin/awk -f


## usage-try:
## awk '{for(i=2;i<=NF;i++){ip_namesseq[$1]=ip_namesseq[$1]" "$i};ip_firstlinenum[$1]=ip_firstlinenum[$1]!=""?(NR<ip_firstlinenum[$1]?NR:ip_firstlinenum[$1]):NR}END{for(ip in ip_firstlinenum){nr_ip[ip_firstlinenum[ip]]=ip};PROCINFO["sorted_in"]="@ind_num_asc";for(nr in nr_ip){print nr_ip[nr],ip_namesseq[nr_ip[nr]]}}' /etc/hosts

## check:
## awk '{for(i=2;i<=NF;i++){ip_namesseq[$1]=ip_namesseq[$1]" "$i};ip_firstlinenum[$1]=ip_firstlinenum[$1]!=""?(NR<ip_firstlinenum[$1]?NR:ip_firstlinenum[$1]):NR}END{for(ip in ip_firstlinenum){nr_ip[ip_firstlinenum[ip]]=ip};PROCINFO["sorted_in"]="@ind_num_asc";for(nr in nr_ip){print nr,nr_ip[nr],ip_namesseq[nr_ip[nr]]};for(ip in ip_namesseq){print ip,ip_namesseq[ip]}}' /etc/hosts

## shell-fn:
## hosts_tidy_uppn () { awk '{for(i=2;i<=NF;i++){ip_namesseq[$1]=ip_namesseq[$1]" "$i};ip_firstlinenum[$1]=ip_firstlinenum[$1]!=""?(NR<ip_firstlinenum[$1]?NR:ip_firstlinenum[$1]):NR}END{for(ip in ip_firstlinenum){nr_ip[ip_firstlinenum[ip]]=ip};PROCINFO["sorted_in"]="@ind_num_asc";for(nr in nr_ip){print nr_ip[nr],ip_namesseq[nr_ip[nr]]}}' /etc/hosts > /etc/.hosts.tidy-uppn"${1:-}" ; ls -a  /etc/hosts /etc/.hosts* ; }


# # code:
# 
# {
#     for (i=2; i<=NF; i++)
#     {
#         ip_namesseq[$1] = ip_namesseq[$1]" "$i ;
#     } ;
#     ip_firstlinenum[$1] = 
#         ip_firstlinenum[$1] != "" ?
#         (
#             NR < ip_firstlinenum[$1] ?
#             NR : ip_firstlinenum[$1]
#         ) : NR ;
# }
# END{
#     for (ip in ip_firstlinenum)
#     {
#         nr_ip[ip_firstlinenum[ip]] = ip ;
#     } ;
#     PROCINFO["sorted_in"]="@ind_num_asc" ;
#     for (nr in nr_ip)
#     {
#         print nr_ip[nr],ip_namesseq[nr_ip[nr]] ;
#     } ;
# }



## ----------------------------------------------------------------- 
## 
## 上面的格式化好的代码其实是不能用的，因为 AWK 不支持等号和小括号折行。不过注释里的 SHell 代码是测过能用的。
## 上面的不能对 hostname 去重，下面增加了这个功能，还是只用一个 AWK 。
## ----------------------------------------------------------------- 



# # code:
# 
# {
#     for (i=2; i<=NF; i++)
#     {
#         ip_name_countvalsseq[$1][$i] += 1 ;
#     } ;
#     
#     ip_firstlinenum[$1] = ip_firstlinenum[$1] == "" ? NR : ( NR < ip_firstlinenum[$1] ? NR : ip_firstlinenum[$1] ) ;
# }
# END{
#     PROCINFO["sorted_in"] = "@ind_num_desc" ;
#     for (ip in ip_name_countvalsseq)
#     {
#         for (name in ip_name_countvalsseq[ip])
#         {
#             ip_cnt_namesetseq[ip][ip_name_countvalsseq[ip][name]] = ip_cnt_namesetseq[ip][ip_name_countvalsseq[ip][name]]" "name ;
#         } ;
#         for (cnt in ip_cnt_namesetseq[ip])
#         {
#             ip_namesortedsetseq[ip] = ip_namesortedsetseq[ip]" "ip_cnt_namesetseq[ip][cnt] ;
#         } ;
#     } ;
#     
#     for (ip in ip_firstlinenum)
#     {
#         nr_ip[ip_firstlinenum[ip]] = ip ;
#     } ;
#     PROCINFO["sorted_in"] = "@ind_num_asc" ;
#     for (nr in nr_ip) { print nr_ip[nr],ip_namesortedsetseq[nr_ip[nr]] ; } ;
# }

## oneline-shell:
## awk '{for(i=2;i<=NF;i++){ip_name_countvalsseq[$1][$i]++};ip_firstlinenum[$1]=ip_firstlinenum[$1]==""?NR:(NR<ip_firstlinenum[$1]?NR:ip_firstlinenum[$1])}END{PROCINFO["sorted_in"]="@ind_num_desc";for(ip in ip_name_countvalsseq){for(name in ip_name_countvalsseq[ip]){ip_cnt_namesetseq[ip][ip_name_countvalsseq[ip][name]]=ip_cnt_namesetseq[ip][ip_name_countvalsseq[ip][name]]" "name};for(cnt in ip_cnt_namesetseq[ip]){ip_namesortedsetseq[ip]=ip_namesortedsetseq[ip]" "ip_cnt_namesetseq[ip][cnt]}};for(ip in ip_firstlinenum){nr_ip[ip_firstlinenum[ip]]=ip};PROCINFO["sorted_in"]="@ind_num_asc";for(nr in nr_ip){print nr_ip[nr],ip_namesortedsetseq[nr_ip[nr]]}}' /etc/hosts

## shell-fn:
## hosts_tidy_uppn () { awk '{for(i=2;i<=NF;i++){ip_name_countvalsseq[$1][$i]++};ip_firstlinenum[$1]=ip_firstlinenum[$1]==""?NR:(NR<ip_firstlinenum[$1]?NR:ip_firstlinenum[$1])}END{PROCINFO["sorted_in"]="@ind_num_desc";for(ip in ip_name_countvalsseq){for(name in ip_name_countvalsseq[ip]){ip_cnt_namesetseq[ip][ip_name_countvalsseq[ip][name]]=ip_cnt_namesetseq[ip][ip_name_countvalsseq[ip][name]]" "name};for(cnt in ip_cnt_namesetseq[ip]){ip_namesortedsetseq[ip]=ip_namesortedsetseq[ip]" "ip_cnt_namesetseq[ip][cnt]}};for(ip in ip_firstlinenum){nr_ip[ip_firstlinenum[ip]]=ip};PROCINFO["sorted_in"]="@ind_num_asc";for(nr in nr_ip){print nr_ip[nr],ip_namesortedsetseq[nr_ip[nr]]}}' /etc/hosts > /etc/.hosts.tidy-uppn"${1:-}" ; ls -a  /etc/hosts /etc/.hosts* ; }



## ----------------------------------------------------------------- 
## 
## 这个会给你把你在这个 IP 后配过的 Hostname 去重后按照出现次数排序放在一个 IP 后。
## IP 会按照原来的顺序出现，这个是之前就实现好了的。
## 请注意：不会帮你检查 Hostname 有没有配错，比如，你不该把一个 Hostname 放到两个不一样的 IP 后头。用完这个工具后自行检查吧！
## ~~~~:  或许以后会增加这个功能。现在是还没想好，是怎么给用户提示出来或者直接改正。
## -----------------------------------------------------------------------------------------

## -----------------------------------------------------------------------------------------
## 
## 虽然代码是 AWK 的，不过，思路上是用 Scala 思考的。有了后者，就知道了怎么样的事是能做的怎么是做不到的。
## 一开始想用 Scala 的，但是一想到编译打包还有运行时就觉得算了吧。反正是简单的 SHell 工具，而 AWK 有天然简单的 Map Set 的支持，并且我资金也很想试试，就用 AWK 了。
## 不过啊！！这个 AWK 这个解释器也过于残次品了吧！等号后面都不让折行？小括号不在一行就找不到了？倒真是够简单的这个实现，不愧是为了实现简单允许用着不简单的设计哲学。。。
## 另外，就先不对代码写注释了。我起的名字应该不那么难懂吧？。。。。
## ----------------------------------------------------------------- 



## ----------------------------------------------------------------- 
## 
## 上面的实现是按照出现次数排序的。
## 下面改成，按照出现前后排序。
## 优先按照行内顺序，排不了再行外。
## 。。。其实开始的思路是让行号列号分开计数。不过既然已经决定了线性顺序，那也就没必要做这个区分了，这部分信息是不需要的，通过简单的先行后列的自然数计数来把它丢了就好。
## ----------------------------------------------------------------- 



# code:

{
    for (i=2; i<=NF; i++)
    {
        ordinalof_hostname += 1 ;
        ip_name_ordinalseqseq[$1][$i] = ip_name_ordinalseqseq[$1][$i] == "" ? ordinalof_hostname : ( ordinalof_hostname < ip_name_ordinalseqseq[$1][$i] ? ordinalof_hostname : ip_name_ordinalseqseq[$1][$i] ) ;
    } ;
    
    ip_firstlinenum[$1] = ip_firstlinenum[$1] == "" ? NR : ( NR < ip_firstlinenum[$1] ? NR : ip_firstlinenum[$1] ) ;
}
END{
    PROCINFO["sorted_in"] = "@ind_num_asc" ;
    
    for (ip in ip_name_ordinalseqseq)
    {
        for (name in ip_name_ordinalseqseq[ip])
        {
            ip_ord_namesetseq[ip][ip_name_ordinalseqseq[ip][name]] = name ;
        } ;
        for (ord in ip_ord_namesetseq[ip])
        {
            ip_namesortedsetseq[ip] = ip_namesortedsetseq[ip]" "ip_ord_namesetseq[ip][ord] ;
        } ;
    } ;
    
    for (ip in ip_firstlinenum)
    {
        nr_ip[ip_firstlinenum[ip]] = ip ;
    } ;
    for (nr in nr_ip) { print nr_ip[nr],ip_namesortedsetseq[nr_ip[nr]] ; } ;
}

## oneline-shell:
## awk '{for(i=2;i<=NF;i++){ordinalof_hostname++;ip_name_ordinalseqseq[$1][$i]=ip_name_ordinalseqseq[$1][$i]==""?ordinalof_hostname:(ordinalof_hostname<ip_name_ordinalseqseq[$1][$i]?ordinalof_hostname:ip_name_ordinalseqseq[$1][$i])};ip_firstlinenum[$1]=ip_firstlinenum[$1]==""?NR:(NR<ip_firstlinenum[$1]?NR:ip_firstlinenum[$1])}END{PROCINFO["sorted_in"]="@ind_num_asc";for(ip in ip_name_ordinalseqseq){for(name in ip_name_ordinalseqseq[ip]){ip_ord_namesetseq[ip][ip_name_ordinalseqseq[ip][name]]=name};for(ord in ip_ord_namesetseq[ip]){ip_namesortedsetseq[ip]=ip_namesortedsetseq[ip]" "ip_ord_namesetseq[ip][ord]}};for(ip in ip_firstlinenum){nr_ip[ip_firstlinenum[ip]]=ip};for(nr in nr_ip){print nr_ip[nr],ip_namesortedsetseq[nr_ip[nr]]}}' /etc/hosts

## sh-fn:
## hosts_tidier () { awk '{for(i=2;i<=NF;i++){ordinalof_hostname++;ip_name_ordinalseqseq[$1][$i]=ip_name_ordinalseqseq[$1][$i]==""?ordinalof_hostname:(ordinalof_hostname<ip_name_ordinalseqseq[$1][$i]?ordinalof_hostname:ip_name_ordinalseqseq[$1][$i])};ip_firstlinenum[$1]=ip_firstlinenum[$1]==""?NR:(NR<ip_firstlinenum[$1]?NR:ip_firstlinenum[$1])}END{PROCINFO["sorted_in"]="@ind_num_asc";for(ip in ip_name_ordinalseqseq){for(name in ip_name_ordinalseqseq[ip]){ip_ord_namesetseq[ip][ip_name_ordinalseqseq[ip][name]]=name};for(ord in ip_ord_namesetseq[ip]){ip_namesortedsetseq[ip]=ip_namesortedsetseq[ip]" "ip_ord_namesetseq[ip][ord]}};for(ip in ip_firstlinenum){nr_ip[ip_firstlinenum[ip]]=ip};for(nr in nr_ip){print nr_ip[nr],ip_namesortedsetseq[nr_ip[nr]]}}' "${1:-/dev/stdin}" ; } && hosts_tidy_uppn () { hosts_tidier /etc/hosts > /etc/.hosts.tidy-uppn"${1:-}" ; ls -a /etc/hosts /etc/.hosts* ; } ;



## ----------------------------------------------------------------- 
## 
## 说起来，上面这一共仨版本，只有第一版本是完全在命令行上写的。
## 之后要替换变量名嘛。就直接在 Kate 里编辑了。
## 其实，循环用 for while 等语法关键字的一个坏处就在于，你不能给这个循环起名字。
## 你看，如果用尾递归，我起码要给函数个名字的对吧？这样就能在变量名里体现，这部分循环或者嵌套循环，是为何而循环的了。
## 而 for while 还有著名的 if 就必须注释说明为何要循环/分支了。
## 如果能用函数的递归/调用来表示逻辑，像 erlang 里那样，甚至可以不用注释，因为代码本身就可以写成一个足够严谨规范的注释了。
## 这就是一种语言和语言的区别：它能把代码写得无需注释；它就不能，无法做到，如果不让写注释的话就只能用猜的了。
## 当然，我只是说 erlang 那种好，并不是说只要是函数式都好。
## 不是所有函数式都有类似于 erlang 的这种设计的。
## 至少，从一个浅显的角度看：虽然所有函数式里循环都应当可以用有名字的函数的尾递归代替(这应该是起码要做到的)，但分支的话，不少函数式语言也要用一个并不能体现业务逻辑的 if 的。
## ----------------------------------------------------------------- 
