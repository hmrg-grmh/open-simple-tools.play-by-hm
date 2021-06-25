

## sql-demo

function ParseToOneLine-SimpleSql
{
    process
    {
        [string]$sqlcode = $_ ; <# 确保标准输入每个元素是字串 #>
        (
            $sqlcode.Replace('--',"`n--").Split("`n",[StringSplitOptions]::RemoveEmptyEntries) | <# 这样一来 -- 到原 SQL 末尾就自己是一个元素了 #>
                ? {$_ -notlike '--*'} | <# 这里会把上面单独区分出来的只有注释内容的元素过滤掉 #>
                % {$_.Replace(' ',"`n").Split("`n",[StringSplitOptions]::RemoveEmptyEntries)} <# 这里是为统一空白符为单个空格做准备 #>
        ) -join ' ' -split ';' | <# 小括号里得到的数组的每个元素都是没有空格的一个个单词字串, 这一步是把这个数组合并为一整个字串且元素分隔指定为单个空格 #> <# 并又根据分号切分 #>
            ? {$_ -NotMatch '^[\s]*$'} | <# 对上面依据分号切分的补充, 相当于去掉只有空白符的行; 要注意正则里的转义还是用反斜杠 #>
            % {$_ + ' ' + ';'} <# 对每一句结尾都补上一个空格分号 #>
    }
}

function ParseToOneLine-SimpleSql { process { [string]$sqlcode = $_ ; ($sqlcode.Replace('--',"`n--").Split("`n",[StringSplitOptions]::RemoveEmptyEntries) | ? {$_ -notlike '--*'} | % {$_.Replace(' ',"`n").Split("`n",[StringSplitOptions]::RemoveEmptyEntries)}) -join ' ' -split ';' | ? {$_ -NotMatch '^[\s]*$'} | % {$_ + ' ' + ';'} } }

$sqlarray = 
'use xx ; ; select * from [dbo].[zzz1]',
@"
xxx xxx -- vvvvvv
...
xxx xxxx ;
--xxxx
xxx xxxxxxxx xx
xxxxxxxxx ;
xxxxx ;
"@,
@"
ccc cccccc ....
ddddddd --dddd dd
--kkkkkkkkk1
kkkkkkkkk2
"@

$sqlarray | ParseToOneLine-SimpleSql

这个工具不会管你用没用引号，我现在还没想好怎么处理引号
$sqlarray 的元素一个至少得是一句完整的 sql
支持 -- 注释，支持同一行多个分号
我的逻辑在上面，上面那个多行函数可以带着注释压缩。

上面这个逻辑，换一下注释符号的指定应该就能解析别的简单的语言，erlang应该就可以。

只支持一种注释并且是单行注释(多行或行内注释就都不用删了)



function ParseToOneLine-SimpleLang 
( [string]$CommentStr='#'
, [string]$InputFieldSplitStr=' '
, [string]$LineSplitStr=';' )
{
    process
    {
        [string]$sqlcode = $_ ; <# 确保标准输入每个元素是字串 #>
        (
            $sqlcode.Replace($CommentStr,"`n" + $CommentStr).Split("`n",[StringSplitOptions]::RemoveEmptyEntries) | <# 这样一来 $CommentStr 到输入代码的那行末尾, 就自己是一个元素了 #>
                ? {$_ -notlike ($CommentStr + '*')} | <# 这里会把上面单独区分出来的只有注释内容的元素过滤掉 #>
                % {$_.Replace($InputFieldSplitStr,"`n").Split("`n",[StringSplitOptions]::RemoveEmptyEntries)} <# 这里是为统一空白符为指定命令分割符(默认单个空格)做准备 #>
        ) -join $InputFieldSplitStr -split $LineSplitStr | <# 小括号里得到的数组的每个元素都是没有指定命令分割符(默认单个空格)的一个个单词字串, 这一步是把这个数组合并为一整个字串且元素分隔变为单个指定命令分割符(默认单个空格) #> <# 并又根据分行号切分(默认分号) #>
            ? {$_ -NotMatch ('^[' + $InputFieldSplitStr + '\s]*$')} | <# 对上面依据分号(默认)切分的补充, 相当于去掉只有空白符或者IFS的行; 要注意正则里的转义还是用反斜杠 #>
            % {$_ + $InputFieldSplitStr + $LineSplitStr} | <# 对每一句结尾都补上一个空格(默认)分号(默认) #>
            
            % { $_.Split($InputFieldSplitStr,[StringSplitOptions]::RemoveEmptyEntries) -join $InputFieldSplitStr } <# 最后整理(我也不知道为啥前面经历下来还得搞个这个) #>
    }
}


function ParseToOneLine-SimpleLang ([string]$CommentStr='#', [string]$InputFieldSplitStr=' ') { process { [string]$sqlcode = $_ ; ($sqlcode.Replace($CommentStr,"`n" + $CommentStr).Split("`n",[StringSplitOptions]::RemoveEmptyEntries) | ? {$_ -notlike ($CommentStr + '*')} | % {$_.Replace($InputFieldSplitStr,"`n").Split("`n",[StringSplitOptions]::RemoveEmptyEntries)}) -join $InputFieldSplitStr -split $LineSplitStr | ? {$_ -NotMatch ('^[' + $InputFieldSplitStr + '\s]*$')} | % {$_ + $InputFieldSplitStr + $LineSplitStr} | % { $_.Split($InputFieldSplitStr,[StringSplitOptions]::RemoveEmptyEntries) -join $InputFieldSplitStr } } }

## usage: 
$sqlarray | ParseToOneLine-SimpleLang -CommentStr '--'





