#! /usr/bin/awk -F


## usage:
## awk '{for(i=2;i<=NF;i++){ip_namesseq[$1]=ip_namesseq[$1]" "$i};ip_firstlinenum[$1]=ip_firstlinenum[$1]!=""?(NR<ip_firstlinenum[$1]?NR:ip_firstlinenum[$1]):NR}END{for(ip in ip_firstlinenum){nr_ip[ip_firstlinenum[ip]]=ip};PROCINFO["sorted_in"]="@ind_num_asc";for(nr in nr_ip){print nr_ip[nr],ip_namesseq[nr_ip[nr]]}}' /etc/hosts

## check:
## awk '{for(i=2;i<=NF;i++){ip_namesseq[$1]=ip_namesseq[$1]" "$i};ip_firstlinenum[$1]=ip_firstlinenum[$1]!=""?(NR<ip_firstlinenum[$1]?NR:ip_firstlinenum[$1]):NR}END{for(ip in ip_firstlinenum){nr_ip[ip_firstlinenum[ip]]=ip};PROCINFO["sorted_in"]="@ind_num_asc";for(nr in nr_ip){print nr,nr_ip[nr],ip_namesseq[nr_ip[nr]]};for(ip in ip_namesseq){print ip,ip_namesseq[ip]}}' /etc/hosts

## shell-fn:
## hosts-tidy-uppn () { awk '{for(i=2;i<=NF;i++){ip_namesseq[$1]=ip_namesseq[$1]" "$i};ip_firstlinenum[$1]=ip_firstlinenum[$1]!=""?(NR<ip_firstlinenum[$1]?NR:ip_firstlinenum[$1]):NR}END{for(ip in ip_firstlinenum){nr_ip[ip_firstlinenum[ip]]=ip};PROCINFO["sorted_in"]="@ind_num_asc";for(nr in nr_ip){print nr_ip[nr],ip_namesseq[nr_ip[nr]]}}' /etc/hosts > /etc/.hosts.tidy-uppn"${1:-}" ; ls -a  /etc/hosts /etc/.hosts* ; }


# code:

{
    for (i=2; i<=NF; i++)
    {
        ip_namesseq[$1] = ip_namesseq[$1]" "$i ;
    } ;
    ip_firstlinenum[$1] = 
        ip_firstlinenum[$1] != "" ?
        (
            NR < ip_firstlinenum[$1] ?
            NR : ip_firstlinenum[$1]
        ) : NR ;
}
END{
    for (ip in ip_firstlinenum)
    {
        nr_ip[ip_firstlinenum[ip]] = ip ;
    } ;
    PROCINFO["sorted_in"]="@ind_num_asc" ;
    for (nr in nr_ip)
    {
        print nr_ip[nr],ip_namesseq[nr_ip[nr]] ;
    } ;
}
