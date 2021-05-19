# def
see_usable_ports () { seq $@ | sh -c 'awk '"$(lsof -i -nOP | awk \{print\$9\} | tr -d \- | tr \> \\n | cut -d: -f2 | awk /[0-9]/ | sort -nu | awk \{print\"\\\\\\\\\\\\\<\"\$0\"\\\\\\\\\\\\\>\\\\\|\"\}END\{print\"\\\\\\\\\\\\\<x\\\\\\\\\\\\\>\/\"\}BEGIN\{ORS=\"\"\;print\"\\\\\!\/\"\})" ; }
see_usable_ports () { sh -c 'seq '"$*"' | awk '"$(lsof -i -nOP | awk \{print\$9\} | tr -d \- | tr \> \\n | cut -d: -f2 | awk /[0-9]/ | sort -nu | awk \{print\"\\\\\\\\\\\\\<\"\$0\"\\\\\\\\\\\\\>\\\\\|\"\}END\{print\"\\\\\\\\\\\\\<x\\\\\\\\\\\\\>\/\"\}BEGIN\{ORS=\"\"\;print\"\\\\\!\/\"\})" ; }

# usage
see_usable_ports 40000 40220

