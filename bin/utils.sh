
die (){
    errMsg=$1
    errCode=$2

    if [ -n "$errCode" ]; then
        errMsg="$errMsg - exiting with error code $errCode"
    else
        errCode=1
    fi

    echo -e "$errMsg" 1>&2
    exit $errCode
}

# Check the difference between config files or derived SDRFs, ignoring headers

diff_configs (){
    file1=$1
    file2=$2

    diffStat=

    if [ -e $file1 ] && [ -e $file2 ]; then
        diff -I '^//' $file1 $file2 > /dev/null 2>&1
        diffStat=$?
    else
        diffStat=1
    fi

    return $diffStat
}

# Pattern file exits

pattern_file_exists(){
    pattern=$1

    ls $pattern > /dev/null 2>&1
    fexists=$?
    if [ $fexists -eq 0 ]; then
        echo true
    fi

    return $fexists    
}

# Satitise MAGE-TAB field names

sanitise_field(){
    local field=$1

    echo -en "$field" | \
        tr '[:upper:]' '[:lower:]' | \
        sed -e "s/\(characteristics\|factor[ ]*value\)[ ]*//g" | \
        sed -e "s/^\[//" | \
        sed -e "s/\]$//" | \
        sed "s/ /_/g"
}
