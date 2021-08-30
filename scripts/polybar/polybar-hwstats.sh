#!/usr/bin/env bash
#
# Report cpu temperature & frequency, memory & partition usage

require() {
    command -v "${*}" >/dev/null
}

getInfo() {
    require "sensors" && sensors --no-adapter
    require "cpupower" && cpupower frequency-info --freq --human
    require "free" && free
    require "df" && df --local --si
}

getInfo | awk '
    function formatNumber(number, places,    format) {
        format = "%0.0" places "f"
        return sprintf(format, number)
    }

    function join(array, delim, start, end,    str, i) {
        str = array[start]
        for (i = start + 1; i <= end; i++)
            str = str delim array[i]
        return str
    }

    function getCpuTemp() {
        if (cpuTempSum == "" || cpuTempSum == "")
            return "N/A"
        return formatNumber(cpuTempSum / cpuTempCnt, 0) "°C"
    }

    BEGIN {
        diskIndex = 1
    }

    /^Core/ {
        cpuTempSum += $3
        cpuTempCnt += 1
    }

    /current/ {
        cpuFreq = $4 $5
    }

    /^Mem/ {
        ram = formatNumber($3 / $2, 2)
    }

    /^Swap/ {
        swap = formatNumber($3 / $2, 2)
    }

    $0 ~ /^\/dev/ && $NF !~ /boot/ {
        disks[diskIndex] = $NF ": " $(NF - 1)
        diskIndex += 1
    }

    END {
        cpuTemp = "N/A"
        if (cpuTempSum != "" && cpuTempCnt != "") {
            if (cpuTempCnt != 0)
                cpuTemp = formatNumber(cpuTempSum / cpuTempCnt, 0)
        }

        if (cpuFreq == "")
            cpuFreq = "N/A"
        if (ram == "")
            ram = "N/A"
        if (swap == "")
            swap = "N/A"

        diskList = "N/A"
        if (disks[1] != "")
            diskList = join(disks, " ", 1, diskIndex)

        print " " getCpuTemp() "  " cpuFreq "  " ram "% " swap "%  " diskList
    }
'
