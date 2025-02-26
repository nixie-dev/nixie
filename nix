#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.4.0-alpha
# date: 1970-01-01 01:00:00
split__3_v0() {
    local text=$1
    local delimiter=$2
    __AMBER_ARRAY_0=();
    local result=("${__AMBER_ARRAY_0[@]}")
     IFS="${delimiter}" read -rd '' -a result < <(printf %s "$text") ;
    __AS=$?
    __AF_split3_v0=("${result[@]}");
    return 0
}
split_lines__4_v0() {
    local text=$1
    split__3_v0 "${text}" "
";
    __AF_split3_v0__40_12=("${__AF_split3_v0[@]}");
    __AF_split_lines4_v0=("${__AF_split3_v0__40_12[@]}");
    return 0
}
join__6_v0() {
    local list=("${!1}")
    local delimiter=$2
    __AMBER_VAL_1=$( IFS="${delimiter}" ; echo "${list[*]}" );
    __AS=$?;
    __AF_join6_v0="${__AMBER_VAL_1}";
    return 0
}
parse_number__12_v0() {
    local text=$1
     [ -n "${text}" ] && [ "${text}" -eq "${text}" ] 2>/dev/null ;
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_parse_number12_v0=''
return $__AS
fi
    __AF_parse_number12_v0="${text}";
    return 0
}
text_contains__14_v0() {
    local text=$1
    local phrase=$2
    __AMBER_VAL_2=$( if [[ "${text}" == *"${phrase}"* ]]; then
    echo 1
  fi );
    __AS=$?;
    local result="${__AMBER_VAL_2}"
    __AF_text_contains14_v0=$([ "_${result}" != "_1" ]; echo $?);
    return 0
}
starts_with__20_v0() {
    local text=$1
    local prefix=$2
    __AMBER_VAL_3=$( if [[ "${text}" == "${prefix}"* ]]; then
    echo 1
  fi );
    __AS=$?;
    local result="${__AMBER_VAL_3}"
    __AF_starts_with20_v0=$([ "_${result}" != "_1" ]; echo $?);
    return 0
}
ends_with__21_v0() {
    local text=$1
    local suffix=$2
    __AMBER_VAL_4=$( if [[ "${text}" == *"${suffix}" ]]; then
    echo 1
  fi );
    __AS=$?;
    local result="${__AMBER_VAL_4}"
    __AF_ends_with21_v0=$([ "_${result}" != "_1" ]; echo $?);
    return 0
}
slice__22_v0() {
    local text=$1
    local index=$2
    local length=$3
    if [ $(echo ${length} '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_LEN="${text}";
        length=$(echo "${#__AMBER_LEN}" '-' ${index} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
fi
    if [ $(echo ${length} '<=' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_slice22_v0="";
        return 0
fi
    __AMBER_VAL_5=$( printf "%.${length}s" "${text:${index}}" );
    __AS=$?;
    __AF_slice22_v0="${__AMBER_VAL_5}";
    return 0
}
dir_exists__32_v0() {
    local path=$1
     [ -d "${path}" ] ;
    __AS=$?;
if [ $__AS != 0 ]; then
        __AF_dir_exists32_v0=0;
        return 0
fi
    __AF_dir_exists32_v0=1;
    return 0
}
file_exists__33_v0() {
    local path=$1
     [ -f "${path}" ] ;
    __AS=$?;
if [ $__AS != 0 ]; then
        __AF_file_exists33_v0=0;
        return 0
fi
    __AF_file_exists33_v0=1;
    return 0
}
file_write__35_v0() {
    local path=$1
    local content=$2
    __AMBER_VAL_6=$( echo "${content}" > "${path}" );
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_file_write35_v0=''
return $__AS
fi;
    __AF_file_write35_v0="${__AMBER_VAL_6}";
    return 0
}
dir_create__38_v0() {
    local path=$1
    dir_exists__32_v0 "${path}";
    __AF_dir_exists32_v0__52_12="$__AF_dir_exists32_v0";
    if [ $(echo  '!' "$__AF_dir_exists32_v0__52_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
         mkdir -p "${path}" ;
        __AS=$?
fi
}
env_var_test__87_v0() {
    local name=$1
     [[ ! -z ${!name+z} ]] ;
    __AS=$?;
if [ $__AS != 0 ]; then
        __AF_env_var_test87_v0=0;
        return 0
fi
    __AF_env_var_test87_v0=1;
    return 0
}
env_var_set__90_v0() {
    local name=$1
    local val=$2
     export $name="$val" 2> /dev/null ;
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_env_var_set90_v0=''
return $__AS
fi
}
env_var_get__91_v0() {
    local name=$1
    __AMBER_VAL_7=$( echo ${!name} );
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_env_var_get91_v0=''
return $__AS
fi;
    __AF_env_var_get91_v0="${__AMBER_VAL_7}";
    return 0
}
is_command__93_v0() {
    local command=$1
     [ -x "$(command -v ${command})" ] ;
    __AS=$?;
if [ $__AS != 0 ]; then
        __AF_is_command93_v0=0;
        return 0
fi
    __AF_is_command93_v0=1;
    return 0
}
printf__99_v0() {
    local format=$1
    local args=("${!2}")
     args=("${format}" "${args[@]}") ;
    __AS=$?
     printf "${args[@]}" ;
    __AS=$?
}
echo_warning__108_v0() {
    local message=$1
    __AMBER_ARRAY_8=("${message}");
    printf__99_v0 "\x1b[1;3;97;43m%s\x1b[0m
" __AMBER_ARRAY_8[@];
    __AF_printf99_v0__157_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__157_5" > /dev/null 2>&1
}
echo_error__109_v0() {
    local message=$1
    local exit_code=$2
    __AMBER_ARRAY_9=("${message}");
    printf__99_v0 "\x1b[1;3;97;41m%s\x1b[0m
" __AMBER_ARRAY_9[@];
    __AF_printf99_v0__162_5="$__AF_printf99_v0";
    echo "$__AF_printf99_v0__162_5" > /dev/null 2>&1
    if [ $(echo ${exit_code} '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        exit ${exit_code}
fi
}
array_last__116_v0() {
    local array=("${!1}")
    local index=$(echo "${#array[@]}" '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    __AF_array_last116_v0="${array[${index}]}";
    return 0
}
array_pop__119_v0() {
    local __AMBER_ARRAY_array="$1[@]"
    local array=$1
    __AMBER_LEN=("${!__AMBER_ARRAY_array}");
    local length="${#__AMBER_LEN[@]}"
    local index=$(echo ${length} '-' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    eval "local __AMBER_ARRAY_GET_10_array=\"\${$array[${index}]}\"";
    local element=$__AMBER_ARRAY_GET_10_array
    local __SLICE_UPPER_12=${index};
    local __SLICE_OFFSET_13=0;
    __SLICE_OFFSET_13=$((__SLICE_OFFSET_13 > 0 ? __SLICE_OFFSET_13 : 0));
    local __SLICE_LENGTH_14=$(eval "echo ${index} '-' $__SLICE_OFFSET_13 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//'");
    __SLICE_LENGTH_14=$((__SLICE_LENGTH_14 > 0 ? __SLICE_LENGTH_14 : 0));
    eval "local __AMBER_ARRAY_GET_11_array=\"\${$array[@]:$__SLICE_OFFSET_13:$__SLICE_LENGTH_14}\"";
    eval "${array}=($__AMBER_ARRAY_GET_11_array)"
    __AF_array_pop119_v0="${element}";
    return 0
}
array_shift__120_v0() {
    local __AMBER_ARRAY_array="$1[@]"
    local array=$1
    __AMBER_LEN=("${!__AMBER_ARRAY_array}");
    local length="${#__AMBER_LEN[@]}"
    eval "local __AMBER_ARRAY_GET_15_array=\"\${$array[0]}\"";
    local element=$__AMBER_ARRAY_GET_15_array
    local __SLICE_UPPER_17=${length};
    local __SLICE_OFFSET_18=1;
    __SLICE_OFFSET_18=$((__SLICE_OFFSET_18 > 0 ? __SLICE_OFFSET_18 : 0));
    local __SLICE_LENGTH_19=$(eval "echo ${length} '-' $__SLICE_OFFSET_18 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//'");
    __SLICE_LENGTH_19=$((__SLICE_LENGTH_19 > 0 ? __SLICE_LENGTH_19 : 0));
    eval "local __AMBER_ARRAY_GET_16_array=\"\${$array[@]:$__SLICE_OFFSET_18:$__SLICE_LENGTH_19}\"";
    eval "${array}=($__AMBER_ARRAY_GET_16_array)"
    __AF_array_shift120_v0="${element}";
    return 0
}
__AMBER_VAL_20=$(tput tsl);
__AS=$?;
__8_tsl="${__AMBER_VAL_20}"
__AMBER_VAL_21=$(tput fsl);
__AS=$?;
__9_fsl="${__AMBER_VAL_21}"
__AMBER_VAL_22=$(tput smcup);
__AS=$?;
__10_smcup="${__AMBER_VAL_22}"
__AMBER_VAL_23=$(tput rmcup);
__AS=$?;
__11_rmcup="${__AMBER_VAL_23}"
env_var_get__91_v0 "TERM";
__AS=$?;
__AF_env_var_get91_v0__13_18="${__AF_env_var_get91_v0}";
__12_TERM="${__AF_env_var_get91_v0__13_18}"
can_set_title__132_v0() {
    local has_statusline=1
    tput hs;
    __AS=$?;
if [ $__AS != 0 ]; then
        starts_with__20_v0 "${__12_TERM}" "xterm";
        __AF_starts_with20_v0__22_12="$__AF_starts_with20_v0";
        if [ "$__AF_starts_with20_v0__22_12" != 0 ]; then
            TERM=xterm+sl tput hs;
            __AS=$?
            if [ $(echo $__AS '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                __AMBER_VAL_24=$(TERM=xterm+sl tput tsl);
                __AS=$?;
                __8_tsl="${__AMBER_VAL_24}"
                __AMBER_VAL_25=$(TERM=xterm+sl tput fsl);
                __AS=$?;
                __9_fsl="${__AMBER_VAL_25}"
else
                has_statusline=0
fi
else
            has_statusline=0
fi
fi
    __AF_can_set_title132_v0=${has_statusline};
    return 0
}
set_title__133_v0() {
    local title=$1
    can_set_title__132_v0 ;
    __AF_can_set_title132_v0__43_8="$__AF_can_set_title132_v0";
    if [ "$__AF_can_set_title132_v0__43_8" != 0 ]; then
        echo "${__8_tsl}""${title}""${__9_fsl}"
fi
}
enter_alt_buffer__134_v0() {
    echo "${__10_smcup}"
}
exit_alt_buffer__135_v0() {
    echo "${__11_rmcup}"
}
teardown__136_v0() {
    local failure=$1
    if [ ${failure} != 0 ]; then
        echo "Press any key to continue..."
        read -n 1;
        __AS=$?
fi
    set_title__133_v0 "";
    __AF_set_title133_v0__66_5="$__AF_set_title133_v0";
    echo "$__AF_set_title133_v0__66_5" > /dev/null 2>&1
    exit_alt_buffer__135_v0 ;
    __AF_exit_alt_buffer135_v0__67_5="$__AF_exit_alt_buffer135_v0";
    echo "$__AF_exit_alt_buffer135_v0__67_5" > /dev/null 2>&1
}
__13_SELF=""
env_var_get__91_v0 "0";
__AS=$?;
__AF_env_var_get91_v0__12_16="${__AF_env_var_get91_v0}";
__14_me="${__AF_env_var_get91_v0__12_16}"
text_contains__14_v0 "${__14_me}" "/";
__AF_text_contains14_v0__15_4="$__AF_text_contains14_v0";
if [ "$__AF_text_contains14_v0__15_4" != 0 ]; then
    starts_with__20_v0 "${__14_me}" "/";
    __AF_starts_with20_v0__16_12="$__AF_starts_with20_v0";
    if [ $(echo  '!' "$__AF_starts_with20_v0__16_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        env_var_get__91_v0 "PWD";
        __AS=$?;
        __AF_env_var_get91_v0__17_25="${__AF_env_var_get91_v0}";
        PWD="${__AF_env_var_get91_v0__17_25}"
        __AMBER_VAL_26=$(readlink ${__14_me});
        __AS=$?;
if [ $__AS != 0 ]; then
            __13_SELF="${PWD}/${__14_me}"
fi;
        rl="${__AMBER_VAL_26}"
        starts_with__20_v0 "${rl}" "/";
        __AF_starts_with20_v0__25_17="$__AF_starts_with20_v0";
        if [ $([ "_${rl}" != "_" ]; echo $?) != 0 ]; then
            __13_SELF="${__13_SELF}"
elif [ $(echo  '!' "$__AF_starts_with20_v0__25_17" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            __13_SELF="${PWD}/${rl}"
else
            __13_SELF="${rl}"
fi
fi
else
    echo_error__109_v0 "This script must be run from an absolute or relative path." 1;
    __AF_echo_error109_v0__30_5="$__AF_echo_error109_v0";
    echo "$__AF_echo_error109_v0__30_5" > /dev/null 2>&1
fi
exists_newer__139_v0() {
    local left=$1
    local right=$2
    __AMBER_VAL_27=$(stat -c %W ${left});
    __AS=$?;
    parse_number__12_v0 "${__AMBER_VAL_27}";
    __AS=$?;
if [ $__AS != 0 ]; then
        __AF_exists_newer139_v0=0;
        return 0
fi;
    __AF_parse_number12_v0__37_21="$__AF_parse_number12_v0";
    local left_time="$__AF_parse_number12_v0__37_21"
    __AMBER_VAL_28=$(stat -c %W ${right});
    __AS=$?;
    parse_number__12_v0 "${__AMBER_VAL_28}";
    __AS=$?;
if [ $__AS != 0 ]; then
        __AF_exists_newer139_v0=0;
        return 0
fi;
    __AF_parse_number12_v0__40_22="$__AF_parse_number12_v0";
    local right_time="$__AF_parse_number12_v0__40_22"
    __AF_exists_newer139_v0=$(echo ${left_time} '>=' ${right_time} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//');
    return 0
}
bail__140_v0() {
    local message=$1
    local archive=$2
    exit_alt_buffer__135_v0 ;
    __AF_exit_alt_buffer135_v0__56_5="$__AF_exit_alt_buffer135_v0";
    echo "$__AF_exit_alt_buffer135_v0__56_5" > /dev/null 2>&1
    set_title__133_v0 "";
    __AF_set_title133_v0__57_5="$__AF_set_title133_v0";
    echo "$__AF_set_title133_v0__57_5" > /dev/null 2>&1
    echo_error__109_v0 "${message}" 0;
    __AF_echo_error109_v0__59_5="$__AF_echo_error109_v0";
    echo "$__AF_echo_error109_v0__59_5" > /dev/null 2>&1
    if [ ${archive} != 0 ]; then
        echo_error__109_v0 "This script can be rebuilt using the nixie tool." 0;
        __AF_echo_error109_v0__61_9="$__AF_echo_error109_v0";
        echo "$__AF_echo_error109_v0__61_9" > /dev/null 2>&1
fi
    exit 1
    kill -ABRT $$;
    __AS=$?
}
get_self__141_v0() {
    __AF_get_self141_v0="${__13_SELF}";
    return 0
}
dump_archive__142_v0() {
    __AMBER_VAL_29=$(mktemp -t nixie_XXXXXXXX.tar);
    __AS=$?;
    local dest="${__AMBER_VAL_29}"
    cat ${__13_SELF} | (
        read -r M
        while ! [[ "$M" =~ ^-----BEGIN\ ARCHIVE\ SECTION----- ]]
        do read -r M || return 1
        done
        gzip -d -c 2>/dev/null > ${dest}
    );
    __AS=$?;
if [ $__AS != 0 ]; then
        if [ $(echo $__AS '!=' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            bail__140_v0 "Could not find the script's resource archive." 1;
            __AF_bail140_v0__92_13="$__AF_bail140_v0";
            echo "$__AF_bail140_v0__92_13" > /dev/null 2>&1
fi
fi
    __AF_dump_archive142_v0="${dest}";
    return 0
}
untar__143_v0() {
    local member=$1
    local dump=$2
    dump_archive__142_v0 ;
    __AF_dump_archive142_v0__109_19="${__AF_dump_archive142_v0}";
    local archive="${__AF_dump_archive142_v0__109_19}"
    local tar_cmd="tar -x ${member} -f ${archive}"
    if [ ${dump} != 0 ]; then
        tar_cmd="tar -x -O ${member} -f ${archive}"
fi
    __AMBER_VAL_30=$(${tar_cmd});
    __AS=$?;
if [ $__AS != 0 ]; then
        local tar_status=$__AS
        rm ${archive};
        __AS=$?
        __AF_untar143_v0='';
        return ${tar_status}
fi;
    local tar_out="${__AMBER_VAL_30}"
    rm ${archive};
    __AS=$?
    __AF_untar143_v0="${tar_out}";
    return 0
}
check_deps__144_v0() {
    local deps=("${!1}")
    __AMBER_ARRAY_31=();
    local missing=("${__AMBER_ARRAY_31[@]}")
    for dep in "${deps[@]}"; do
        is_command__93_v0 "${dep}";
        __AF_is_command93_v0__136_16="$__AF_is_command93_v0";
        if [ $(echo  '!' "$__AF_is_command93_v0__136_16" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            __AMBER_ARRAY_32=("${dep}");
            missing+=("${__AMBER_ARRAY_32[@]}")
fi
done
    if [ $(echo "${#missing[@]}" '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        echo_error__109_v0 "The following commands are missing:" 0;
        __AF_echo_error109_v0__142_9="$__AF_echo_error109_v0";
        echo "$__AF_echo_error109_v0__142_9" > /dev/null 2>&1
        for cmd in "${missing[@]}"; do
            echo_error__109_v0 "- ${cmd}" 0;
            __AF_echo_error109_v0__144_13="$__AF_echo_error109_v0";
            echo "$__AF_echo_error109_v0__144_13" > /dev/null 2>&1
done
        echo_error__109_v0 "Use your distribution's package manager to install them, then try again." 0;
        __AF_echo_error109_v0__146_9="$__AF_echo_error109_v0";
        echo "$__AF_echo_error109_v0__146_9" > /dev/null 2>&1
        __AF_check_deps144_v0='';
        return 1
fi
}
get_osname__154_v0() {
    __AMBER_VAL_33=$(uname -s);
    __AS=$?;
    __AF_get_osname154_v0="${__AMBER_VAL_33}";
    return 0
}
get_machine__155_v0() {
    __AMBER_VAL_34=$(uname -m);
    __AS=$?;
    local machine="${__AMBER_VAL_34}"
    if [ $([ "_${machine}" != "_arm64" ]; echo $?) != 0 ]; then
        __AF_get_machine155_v0="aarch64";
        return 0
fi
    __AF_get_machine155_v0="${machine}";
    return 0
}
get_system__156_v0() {
    get_osname__154_v0 ;
    __AF_get_osname154_v0__33_18="${__AF_get_osname154_v0}";
    local osname="${__AF_get_osname154_v0__33_18}"
    get_machine__155_v0 ;
    __AF_get_machine155_v0__34_19="${__AF_get_machine155_v0}";
    local machine="${__AF_get_machine155_v0__34_19}"
    __AF_get_system156_v0="${osname}.${machine}";
    return 0
}
get_nix_root__158_v0() {
    env_var_get__91_v0 "HOME";
    __AS=$?;
    __AF_env_var_get91_v0__52_26="${__AF_env_var_get91_v0}";
    local userhome="${__AF_env_var_get91_v0__52_26}"
    get_osname__154_v0 ;
    __AF_get_osname154_v0__53_18="${__AF_get_osname154_v0}";
    local osname="${__AF_get_osname154_v0__53_18}"
    if [ $([ "_${osname}" != "_Darwin" ]; echo $?) != 0 ]; then
        __AF_get_nix_root158_v0="${userhome}/Library/Nix";
        return 0
else
        __AF_get_nix_root158_v0="${userhome}/.local/share/nix/root";
        return 0
fi
}
get_cache_root__159_v0() {
    env_var_get__91_v0 "HOME";
    __AS=$?;
    __AF_env_var_get91_v0__63_26="${__AF_env_var_get91_v0}";
    local userhome="${__AF_env_var_get91_v0__63_26}"
    get_osname__154_v0 ;
    __AF_get_osname154_v0__64_18="${__AF_get_osname154_v0}";
    local osname="${__AF_get_osname154_v0__64_18}"
    if [ $([ "_${osname}" != "_Darwin" ]; echo $?) != 0 ]; then
        __AF_get_cache_root159_v0="${userhome}/Library/Caches";
        return 0
else
        __AF_get_cache_root159_v0="${userhome}/.cache";
        return 0
fi
}
get_repo_root__160_v0() {
    get_self__141_v0 ;
    __AF_get_self141_v0__77_24="${__AF_get_self141_v0}";
    split__3_v0 "${__AF_get_self141_v0__77_24}" "/";
    __AF_split3_v0__77_18=("${__AF_split3_v0[@]}");
    local self_a=("${__AF_split3_v0__77_18[@]}")
    array_pop__119_v0 self_a;
    __AF_array_pop119_v0__78_5="${__AF_array_pop119_v0}";
    echo "${__AF_array_pop119_v0__78_5}" > /dev/null 2>&1
    join__6_v0 self_a[@] "/";
    __AF_join6_v0__80_26="${__AF_join6_v0}";
    local self_dir="/""${__AF_join6_v0__80_26}"
    __AMBER_VAL_35=$(git -C ${self_dir} rev-parse --show-toplevel);
    __AS=$?;
if [ $__AS != 0 ]; then
        echo_warning__108_v0 "Failed to find current Git repository, using script parent directory.";
        __AF_echo_warning108_v0__83_9="$__AF_echo_warning108_v0";
        echo "$__AF_echo_warning108_v0__83_9" > /dev/null 2>&1
        __AF_get_repo_root160_v0="${self_dir}";
        return 0
fi;
    __AF_get_repo_root160_v0="${__AMBER_VAL_35}";
    return 0
}
cmd_help__174_v0() {
    env_var_get__91_v0 "NIXIE_VERSION";
    __AS=$?;
    __AF_env_var_get91_v0__15_31="${__AF_env_var_get91_v0}";
    local NIXIE_VERSION="${__AF_env_var_get91_v0__15_31}"
    echo "Nix wrapper script, generated by Nixie ${NIXIE_VERSION}"
    echo ""
    echo "Available --nixie- options:"
    echo "  --nixie-help            Show this help message and exit."
    echo "  --nixie-print-config    Print this script's configuration."
    echo "  --nixie-extract         Unpack the resources archive into nixie/"
    echo "  --nixie-cleanup         Delete local Nix build files"
    echo "  --nixie-ignore-system   Behave as if Nix was not installed."
    exit 0
}
cmd_print_config__175_v0() {
    untar__143_v0 "features" 1;
    __AS=$?;
    __AF_untar143_v0__32_16="${__AF_untar143_v0}";
    echo "${__AF_untar143_v0__32_16}"
    exit 0
}
cmd_extract__176_v0() {
    dir_create__38_v0 "nixie";
    __AF_dir_create38_v0__38_5="$__AF_dir_create38_v0";
    echo "$__AF_dir_create38_v0__38_5" > /dev/null 2>&1
    cd "nixie" || exit
    untar__143_v0 "" 0;
    __AS=$?;
    __AF_untar143_v0__40_11="${__AF_untar143_v0}";
    echo "${__AF_untar143_v0__40_11}" > /dev/null 2>&1
    exit 0
}
cmd_cleanup__177_v0() {
    get_nix_root__158_v0 ;
    __AF_get_nix_root158_v0__46_20="${__AF_get_nix_root158_v0}";
    local nix_root="${__AF_get_nix_root158_v0__46_20}"
    get_cache_root__159_v0 ;
    __AF_get_cache_root159_v0__47_22="${__AF_get_cache_root159_v0}";
    local cache_root="${__AF_get_cache_root159_v0__47_22}"
    get_repo_root__160_v0 ;
    __AF_get_repo_root160_v0__48_21="${__AF_get_repo_root160_v0}";
    local repo_root="${__AF_get_repo_root160_v0__48_21}"
    echo "Removing local Nix channels and build files..."
    chmod -R +wx ${repo_root}/.nixie 2>/dev/null;
    __AS=$?
    rm -rf ${repo_root}/.nixie;
    __AS=$?
    echo "Removing user Nix store..."
    chmod -R +wx ${nix_root} 2>/dev/null;
    __AS=$?
    rm -rf ${nix_root};
    __AS=$?
    echo "Removing retrieved Nix binaries..."
    rm -rf ${cache_root}/nix-static ${cache_root}/nix-lib ${cache_root}/nix-deps;
    __AS=$?
    exit 0
}
opt_ignore_system__178_v0() {
    echo_warning__108_v0 "Ignoring system-wide Nix for testing purposes.";
    __AF_echo_warning108_v0__66_5="$__AF_echo_warning108_v0";
    echo "$__AF_echo_warning108_v0__66_5" > /dev/null 2>&1
    echo_warning__108_v0 "Re-run without the --nixie-ignore-system flag to import the single-user";
    __AF_echo_warning108_v0__67_5="$__AF_echo_warning108_v0";
    echo "$__AF_echo_warning108_v0__67_5" > /dev/null 2>&1
    echo_warning__108_v0 "Nix store into the system store.";
    __AF_echo_warning108_v0__68_5="$__AF_echo_warning108_v0";
    echo "$__AF_echo_warning108_v0__68_5" > /dev/null 2>&1
    env_var_set__90_v0 "nosystem" "1";
    __AS=$?;
    __AF_env_var_set90_v0__69_11="$__AF_env_var_set90_v0";
    echo "$__AF_env_var_set90_v0__69_11" > /dev/null 2>&1
}
opt_no_precompiled__179_v0() {
    echo_warning__108_v0 "Ignoring precompiled binaries for testing purposes.";
    __AF_echo_warning108_v0__74_5="$__AF_echo_warning108_v0";
    echo "$__AF_echo_warning108_v0__74_5" > /dev/null 2>&1
    echo_warning__108_v0 "This implies --nixie-ignore-system.";
    __AF_echo_warning108_v0__75_5="$__AF_echo_warning108_v0";
    echo "$__AF_echo_warning108_v0__75_5" > /dev/null 2>&1
    env_var_set__90_v0 "nobins" "1";
    __AS=$?;
    __AF_env_var_set90_v0__76_11="$__AF_env_var_set90_v0";
    echo "$__AF_env_var_set90_v0__76_11" > /dev/null 2>&1
    env_var_set__90_v0 "nosystem" "1";
    __AS=$?;
    __AF_env_var_set90_v0__77_11="$__AF_env_var_set90_v0";
    echo "$__AF_env_var_set90_v0__77_11" > /dev/null 2>&1
}
notfound__180_v0() {
    local cmd=$1
    env_var_get__91_v0 "0";
    __AS=$?;
    __AF_env_var_get91_v0__82_22="${__AF_env_var_get91_v0}";
    local self="${__AF_env_var_get91_v0__82_22}"
    echo_error__109_v0 "No such option: --nixie-${cmd}. Run '${self} --nixie-help' for available options." 1;
    __AF_echo_error109_v0__84_5="$__AF_echo_error109_v0";
    echo "$__AF_echo_error109_v0__84_5" > /dev/null 2>&1
}
eval_cmd__181_v0() {
    local cmd=$1
    if [ $([ "_${cmd}" != "_help" ]; echo $?) != 0 ]; then
        cmd_help__174_v0 ;
        __AF_cmd_help174_v0__90_34="$__AF_cmd_help174_v0";
        echo "$__AF_cmd_help174_v0__90_34" > /dev/null 2>&1
elif [ $([ "_${cmd}" != "_print-config" ]; echo $?) != 0 ]; then
        cmd_print_config__175_v0 ;
        __AF_cmd_print_config175_v0__91_34="$__AF_cmd_print_config175_v0";
        echo "$__AF_cmd_print_config175_v0__91_34" > /dev/null 2>&1
elif [ $([ "_${cmd}" != "_extract" ]; echo $?) != 0 ]; then
        cmd_extract__176_v0 ;
        __AF_cmd_extract176_v0__92_34="$__AF_cmd_extract176_v0";
        echo "$__AF_cmd_extract176_v0__92_34" > /dev/null 2>&1
elif [ $([ "_${cmd}" != "_cleanup" ]; echo $?) != 0 ]; then
        cmd_cleanup__177_v0 ;
        __AF_cmd_cleanup177_v0__93_34="$__AF_cmd_cleanup177_v0";
        echo "$__AF_cmd_cleanup177_v0__93_34" > /dev/null 2>&1
elif [ $([ "_${cmd}" != "_ignore-system" ]; echo $?) != 0 ]; then
        opt_ignore_system__178_v0 ;
        __AF_opt_ignore_system178_v0__94_34="$__AF_opt_ignore_system178_v0";
        echo "$__AF_opt_ignore_system178_v0__94_34" > /dev/null 2>&1
elif [ $([ "_${cmd}" != "_no-precompiled" ]; echo $?) != 0 ]; then
        opt_no_precompiled__179_v0 ;
        __AF_opt_no_precompiled179_v0__95_34="$__AF_opt_no_precompiled179_v0";
        echo "$__AF_opt_no_precompiled179_v0__95_34" > /dev/null 2>&1
else
        notfound__180_v0 "${cmd}";
        __AF_notfound180_v0__96_15="$__AF_notfound180_v0";
        echo "$__AF_notfound180_v0__96_15" > /dev/null 2>&1
fi
}
catch_args__182_v0() {
    local __AMBER_ARRAY_args="$1[@]"
    local args=$1
    local local_args=("${!__AMBER_ARRAY_args}")
    __AMBER_ARRAY_36=();
    eval "${args}=(\"\${__AMBER_ARRAY_36[@]}\")"
    for arg in "${local_args[@]}"; do
        local cmd=""
        starts_with__20_v0 "${arg}" "--nixie-";
        __AF_starts_with20_v0__110_12="$__AF_starts_with20_v0";
        if [ "$__AF_starts_with20_v0__110_12" != 0 ]; then
            __AMBER_LEN="--nixie-";
            slice__22_v0 "${arg}" "${#__AMBER_LEN}" 0;
            __AF_slice22_v0__111_19="${__AF_slice22_v0}";
            cmd="${__AF_slice22_v0__111_19}"
            eval_cmd__181_v0 "${cmd}";
            __AF_eval_cmd181_v0__112_13="$__AF_eval_cmd181_v0";
            echo "$__AF_eval_cmd181_v0__112_13" > /dev/null 2>&1
else
            __AMBER_ARRAY_37=("${arg}");
            eval "${args}+=(\"\${__AMBER_ARRAY_37[@]}\")"
fi
done
}
file_download__233_v0() {
    local url=$1
    local path=$2
    is_command__93_v0 "curl";
    __AF_is_command93_v0__9_9="$__AF_is_command93_v0";
    is_command__93_v0 "wget";
    __AF_is_command93_v0__12_9="$__AF_is_command93_v0";
    is_command__93_v0 "aria2c";
    __AF_is_command93_v0__15_9="$__AF_is_command93_v0";
    if [ "$__AF_is_command93_v0__9_9" != 0 ]; then
         curl -L -o "${path}" "${url}" ;
        __AS=$?
elif [ "$__AF_is_command93_v0__12_9" != 0 ]; then
         wget "${url}" -P "${path}" ;
        __AS=$?
elif [ "$__AF_is_command93_v0__15_9" != 0 ]; then
         aria2c "${url}" -d "${path}" ;
        __AS=$?
else
        __AF_file_download233_v0=0;
        return 0
fi
    __AF_file_download233_v0=1;
    return 0
}
cachix_url__239_v0() {
    local derivation=$1
    local member=$2
    env_var_get__91_v0 "SOURCE_CACHE";
    __AS=$?;
    __AF_env_var_get91_v0__13_30="${__AF_env_var_get91_v0}";
    local SOURCE_CACHE="${__AF_env_var_get91_v0__13_30}"
    __AF_cachix_url239_v0="https://${SOURCE_CACHE}/serve/${derivation}/${member}";
    return 0
}
pull_binary__241_v0() {
    local member=$1
    local dest=$2
    env_var_get__91_v0 "NIX_BINS_DERIVATION";
    __AS=$?;
    __AF_env_var_get91_v0__84_37="${__AF_env_var_get91_v0}";
    local NIX_BINS_DERIVATION="${__AF_env_var_get91_v0__84_37}"
    untar__143_v0 "${member}" 0;
    __AS=$?;
    __AF_untar143_v0__86_23="${__AF_untar143_v0}";
    local where="${__AF_untar143_v0__86_23}"
    if [ $(echo $__AS '!=' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_VAL_38=$(mktemp -t nixie_${member}_XXXXXXXX);
        __AS=$?;
        local tmpf="${__AMBER_VAL_38}"
        cachix_url__239_v0 "${NIX_BINS_DERIVATION}" "${member}";
        __AF_cachix_url239_v0__90_30="${__AF_cachix_url239_v0}";
        file_download__233_v0 "${__AF_cachix_url239_v0__90_30}" "${tmpf}";
        __AF_file_download233_v0__90_16="$__AF_file_download233_v0";
        if [ $(echo  '!' "$__AF_file_download233_v0__90_16" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            __AF_pull_binary241_v0='';
            return 1
fi
        where="${tmpf}"
fi
    mv "${where}" "${dest}"
__AS=$?
}
__AMBER_VAL_39=$(tput tsl);
__AS=$?;
__15_tsl="${__AMBER_VAL_39}"
__AMBER_VAL_40=$(tput fsl);
__AS=$?;
__16_fsl="${__AMBER_VAL_40}"
__AMBER_VAL_41=$(tput smcup);
__AS=$?;
__17_smcup="${__AMBER_VAL_41}"
__AMBER_VAL_42=$(tput rmcup);
__AS=$?;
__18_rmcup="${__AMBER_VAL_42}"
env_var_get__91_v0 "TERM";
__AS=$?;
__AF_env_var_get91_v0__13_18="${__AF_env_var_get91_v0}";
__19_TERM="${__AF_env_var_get91_v0__13_18}"
can_set_title__258_v0() {
    local has_statusline=1
    tput hs;
    __AS=$?;
if [ $__AS != 0 ]; then
        starts_with__20_v0 "${__19_TERM}" "xterm";
        __AF_starts_with20_v0__22_12="$__AF_starts_with20_v0";
        if [ "$__AF_starts_with20_v0__22_12" != 0 ]; then
            TERM=xterm+sl tput hs;
            __AS=$?
            if [ $(echo $__AS '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                __AMBER_VAL_43=$(TERM=xterm+sl tput tsl);
                __AS=$?;
                __15_tsl="${__AMBER_VAL_43}"
                __AMBER_VAL_44=$(TERM=xterm+sl tput fsl);
                __AS=$?;
                __16_fsl="${__AMBER_VAL_44}"
else
                has_statusline=0
fi
else
            has_statusline=0
fi
fi
    __AF_can_set_title258_v0=${has_statusline};
    return 0
}
set_title__259_v0() {
    local title=$1
    can_set_title__258_v0 ;
    __AF_can_set_title258_v0__43_8="$__AF_can_set_title258_v0";
    if [ "$__AF_can_set_title258_v0__43_8" != 0 ]; then
        echo "${__15_tsl}""${title}""${__16_fsl}"
fi
}
__AMBER_VAL_45=$(tput tsl);
__AS=$?;
__20_tsl="${__AMBER_VAL_45}"
__AMBER_VAL_46=$(tput fsl);
__AS=$?;
__21_fsl="${__AMBER_VAL_46}"
__AMBER_VAL_47=$(tput smcup);
__AS=$?;
__22_smcup="${__AMBER_VAL_47}"
__AMBER_VAL_48=$(tput rmcup);
__AS=$?;
__23_rmcup="${__AMBER_VAL_48}"
env_var_get__91_v0 "TERM";
__AS=$?;
__AF_env_var_get91_v0__13_18="${__AF_env_var_get91_v0}";
__24_TERM="${__AF_env_var_get91_v0__13_18}"
can_set_title__278_v0() {
    local has_statusline=1
    tput hs;
    __AS=$?;
if [ $__AS != 0 ]; then
        starts_with__20_v0 "${__24_TERM}" "xterm";
        __AF_starts_with20_v0__22_12="$__AF_starts_with20_v0";
        if [ "$__AF_starts_with20_v0__22_12" != 0 ]; then
            TERM=xterm+sl tput hs;
            __AS=$?
            if [ $(echo $__AS '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                __AMBER_VAL_49=$(TERM=xterm+sl tput tsl);
                __AS=$?;
                __20_tsl="${__AMBER_VAL_49}"
                __AMBER_VAL_50=$(TERM=xterm+sl tput fsl);
                __AS=$?;
                __21_fsl="${__AMBER_VAL_50}"
else
                has_statusline=0
fi
else
            has_statusline=0
fi
fi
    __AF_can_set_title278_v0=${has_statusline};
    return 0
}
set_title__279_v0() {
    local title=$1
    can_set_title__278_v0 ;
    __AF_can_set_title278_v0__43_8="$__AF_can_set_title278_v0";
    if [ "$__AF_can_set_title278_v0__43_8" != 0 ]; then
        echo "${__20_tsl}""${title}""${__21_fsl}"
fi
}
exit_alt_buffer__281_v0() {
    echo "${__23_rmcup}"
}
__25_SELF=""
env_var_get__91_v0 "0";
__AS=$?;
__AF_env_var_get91_v0__12_16="${__AF_env_var_get91_v0}";
__26_me="${__AF_env_var_get91_v0__12_16}"
text_contains__14_v0 "${__26_me}" "/";
__AF_text_contains14_v0__15_4="$__AF_text_contains14_v0";
if [ "$__AF_text_contains14_v0__15_4" != 0 ]; then
    starts_with__20_v0 "${__26_me}" "/";
    __AF_starts_with20_v0__16_12="$__AF_starts_with20_v0";
    if [ $(echo  '!' "$__AF_starts_with20_v0__16_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        env_var_get__91_v0 "PWD";
        __AS=$?;
        __AF_env_var_get91_v0__17_25="${__AF_env_var_get91_v0}";
        PWD="${__AF_env_var_get91_v0__17_25}"
        __AMBER_VAL_51=$(readlink ${__26_me});
        __AS=$?;
if [ $__AS != 0 ]; then
            __25_SELF="${PWD}/${__26_me}"
fi;
        rl="${__AMBER_VAL_51}"
        starts_with__20_v0 "${rl}" "/";
        __AF_starts_with20_v0__25_17="$__AF_starts_with20_v0";
        if [ $([ "_${rl}" != "_" ]; echo $?) != 0 ]; then
            __25_SELF="${__25_SELF}"
elif [ $(echo  '!' "$__AF_starts_with20_v0__25_17" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            __25_SELF="${PWD}/${rl}"
else
            __25_SELF="${rl}"
fi
fi
else
    echo_error__109_v0 "This script must be run from an absolute or relative path." 1;
    __AF_echo_error109_v0__30_5="$__AF_echo_error109_v0";
    echo "$__AF_echo_error109_v0__30_5" > /dev/null 2>&1
fi
bail__286_v0() {
    local message=$1
    local archive=$2
    exit_alt_buffer__281_v0 ;
    __AF_exit_alt_buffer281_v0__56_5="$__AF_exit_alt_buffer281_v0";
    echo "$__AF_exit_alt_buffer281_v0__56_5" > /dev/null 2>&1
    set_title__279_v0 "";
    __AF_set_title279_v0__57_5="$__AF_set_title279_v0";
    echo "$__AF_set_title279_v0__57_5" > /dev/null 2>&1
    echo_error__109_v0 "${message}" 0;
    __AF_echo_error109_v0__59_5="$__AF_echo_error109_v0";
    echo "$__AF_echo_error109_v0__59_5" > /dev/null 2>&1
    if [ ${archive} != 0 ]; then
        echo_error__109_v0 "This script can be rebuilt using the nixie tool." 0;
        __AF_echo_error109_v0__61_9="$__AF_echo_error109_v0";
        echo "$__AF_echo_error109_v0__61_9" > /dev/null 2>&1
fi
    exit 1
    kill -ABRT $$;
    __AS=$?
}
get_self__287_v0() {
    __AF_get_self287_v0="${__25_SELF}";
    return 0
}
dump_archive__288_v0() {
    __AMBER_VAL_52=$(mktemp -t nixie_XXXXXXXX.tar);
    __AS=$?;
    local dest="${__AMBER_VAL_52}"
    cat ${__25_SELF} | (
        read -r M
        while ! [[ "$M" =~ ^-----BEGIN\ ARCHIVE\ SECTION----- ]]
        do read -r M || return 1
        done
        gzip -d -c 2>/dev/null > ${dest}
    );
    __AS=$?;
if [ $__AS != 0 ]; then
        if [ $(echo $__AS '!=' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            bail__286_v0 "Could not find the script's resource archive." 1;
            __AF_bail286_v0__92_13="$__AF_bail286_v0";
            echo "$__AF_bail286_v0__92_13" > /dev/null 2>&1
fi
fi
    __AF_dump_archive288_v0="${dest}";
    return 0
}
untar__289_v0() {
    local member=$1
    local dump=$2
    dump_archive__288_v0 ;
    __AF_dump_archive288_v0__109_19="${__AF_dump_archive288_v0}";
    local archive="${__AF_dump_archive288_v0__109_19}"
    local tar_cmd="tar -x ${member} -f ${archive}"
    if [ ${dump} != 0 ]; then
        tar_cmd="tar -x -O ${member} -f ${archive}"
fi
    __AMBER_VAL_53=$(${tar_cmd});
    __AS=$?;
if [ $__AS != 0 ]; then
        local tar_status=$__AS
        rm ${archive};
        __AS=$?
        __AF_untar289_v0='';
        return ${tar_status}
fi;
    local tar_out="${__AMBER_VAL_53}"
    rm ${archive};
    __AS=$?
    __AF_untar289_v0="${tar_out}";
    return 0
}
get_osname__292_v0() {
    __AMBER_VAL_54=$(uname -s);
    __AS=$?;
    __AF_get_osname292_v0="${__AMBER_VAL_54}";
    return 0
}
get_dll_ext__295_v0() {
    get_osname__292_v0 ;
    __AF_get_osname292_v0__42_18="${__AF_get_osname292_v0}";
    local osname="${__AF_get_osname292_v0__42_18}"
    if [ $([ "_${osname}" != "_Darwin" ]; echo $?) != 0 ]; then
        __AF_get_dll_ext295_v0="dylib";
        return 0
else
        __AF_get_dll_ext295_v0="so";
        return 0
fi
}
get_cache_root__297_v0() {
    env_var_get__91_v0 "HOME";
    __AS=$?;
    __AF_env_var_get91_v0__63_26="${__AF_env_var_get91_v0}";
    local userhome="${__AF_env_var_get91_v0__63_26}"
    get_osname__292_v0 ;
    __AF_get_osname292_v0__64_18="${__AF_get_osname292_v0}";
    local osname="${__AF_get_osname292_v0__64_18}"
    if [ $([ "_${osname}" != "_Darwin" ]; echo $?) != 0 ]; then
        __AF_get_cache_root297_v0="${userhome}/Library/Caches";
        return 0
else
        __AF_get_cache_root297_v0="${userhome}/.cache";
        return 0
fi
}
get_repo_root__298_v0() {
    get_self__287_v0 ;
    __AF_get_self287_v0__77_24="${__AF_get_self287_v0}";
    split__3_v0 "${__AF_get_self287_v0__77_24}" "/";
    __AF_split3_v0__77_18=("${__AF_split3_v0[@]}");
    local self_a=("${__AF_split3_v0__77_18[@]}")
    array_pop__119_v0 self_a;
    __AF_array_pop119_v0__78_5="${__AF_array_pop119_v0}";
    echo "${__AF_array_pop119_v0__78_5}" > /dev/null 2>&1
    join__6_v0 self_a[@] "/";
    __AF_join6_v0__80_26="${__AF_join6_v0}";
    local self_dir="/""${__AF_join6_v0__80_26}"
    __AMBER_VAL_55=$(git -C ${self_dir} rev-parse --show-toplevel);
    __AS=$?;
if [ $__AS != 0 ]; then
        echo_warning__108_v0 "Failed to find current Git repository, using script parent directory.";
        __AF_echo_warning108_v0__83_9="$__AF_echo_warning108_v0";
        echo "$__AF_echo_warning108_v0__83_9" > /dev/null 2>&1
        __AF_get_repo_root298_v0="${self_dir}";
        return 0
fi;
    __AF_get_repo_root298_v0="${__AMBER_VAL_55}";
    return 0
}
__27_step_current=1
get_source_root__302_v0() {
    get_repo_root__298_v0 ;
    __AF_get_repo_root298_v0__38_21="${__AF_get_repo_root298_v0}";
    local repo_root="${__AF_get_repo_root298_v0__38_21}"
    __AF_get_source_root302_v0="${repo_root}/.nixie/sources";
    return 0
}
cachix_url__312_v0() {
    local derivation=$1
    local member=$2
    env_var_get__91_v0 "SOURCE_CACHE";
    __AS=$?;
    __AF_env_var_get91_v0__13_30="${__AF_env_var_get91_v0}";
    local SOURCE_CACHE="${__AF_env_var_get91_v0__13_30}"
    __AF_cachix_url312_v0="https://${SOURCE_CACHE}/serve/${derivation}/${member}";
    return 0
}
pull_source_file__313_v0() {
    local member=$1
    local dest=$2
    env_var_get__91_v0 "SOURCE_DERIVATION";
    __AS=$?;
    __AF_env_var_get91_v0__30_35="${__AF_env_var_get91_v0}";
    local SOURCE_DERIVATION="${__AF_env_var_get91_v0__30_35}"
    local where=""
    local my_status=1
    env_var_test__87_v0 "_NIXIE_TESTING_SKIP_TARBALL";
    __AF_env_var_test87_v0__36_12="$__AF_env_var_test87_v0";
    if [ $(echo  '!' "$__AF_env_var_test87_v0__36_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        untar__289_v0 "sources/${member}" 0;
        __AS=$?;
        __AF_untar289_v0__37_23="${__AF_untar289_v0}";
        where="${__AF_untar289_v0__37_23}"
        my_status=$__AS
fi
    env_var_test__87_v0 "_NIXIE_TESTING_SOURCES_DIR";
    __AF_env_var_test87_v0__41_8="$__AF_env_var_test87_v0";
    if [ $(echo "$__AF_env_var_test87_v0__41_8" '&&' $(echo ${my_status} '!=' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        env_var_get__91_v0 "_NIXIE_TESTING_SOURCES_DIR";
        __AS=$?;
        __AF_env_var_get91_v0__42_28="${__AF_env_var_get91_v0}";
        local srcdir="${__AF_env_var_get91_v0__42_28}"
        __AMBER_VAL_56=$(mktemp -t -d nixie_${member}_XXXXXXXX);
        __AS=$?;
        local tmpd="${__AMBER_VAL_56}"
        file_exists__33_v0 "${srcdir}/${member}.tar.gz";
        __AF_file_exists33_v0__45_12="$__AF_file_exists33_v0";
        if [ "$__AF_file_exists33_v0__45_12" != 0 ]; then
            gzip -d -c ${srcdir}/${member}.tar.gz | tar -x -C ${tmpd};
            __AS=$?
            my_status=$__AS
            where="${tmpd}/${member}"
else
            my_status=1
fi
fi
    if [ $(echo ${my_status} '!=' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_VAL_57=$(mktemp -t nixie_src_XXXXXXXX.tgz);
        __AS=$?;
        local tmpf="${__AMBER_VAL_57}"
        __AMBER_VAL_58=$(mktemp -t -d nixie_${member}_XXXXXXXX);
        __AS=$?;
        local tmpd="${__AMBER_VAL_58}"
        cachix_url__312_v0 "${SOURCE_DERIVATION}" "${member}.tar.gz";
        __AF_cachix_url312_v0__58_30="${__AF_cachix_url312_v0}";
        file_download__233_v0 "${__AF_cachix_url312_v0__58_30}" "${tmpf}";
        __AF_file_download233_v0__58_16="$__AF_file_download233_v0";
        if [ $(echo  '!' "$__AF_file_download233_v0__58_16" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            __AF_pull_source_file313_v0='';
            return 1
fi
        gzip -d -c ${tmpf} | tar -x -C ${tmpd};
        __AS=$?;
if [ $__AS != 0 ]; then
__AF_pull_source_file313_v0=''
return $__AS
fi
        rm -f ${tmpf};
        __AS=$?
        where="${tmpd}/${member}"
fi
    rm -rf ${dest};
    __AS=$?
    mv "${where}" "${dest}"
__AS=$?
}
__28_step_current=1
pkg_exists__322_v0() {
    local package=$1
    pkg-config ${package};
    __AS=$?;
if [ $__AS != 0 ]; then
        __AF_pkg_exists322_v0=0;
        return 0
fi
    __AF_pkg_exists322_v0=1;
    return 0
}
step_title__323_v0() {
    local name=$1
    env_var_get__91_v0 "step_total";
    __AS=$?;
    __AF_env_var_get91_v0__26_28="${__AF_env_var_get91_v0}";
    local step_total="${__AF_env_var_get91_v0__26_28}"
    clear;
    __AS=$?
    set_title__259_v0 "Building Nix: ${name} (${__28_step_current}/${step_total})";
    __AF_set_title259_v0__30_5="$__AF_set_title259_v0";
    echo "$__AF_set_title259_v0__30_5" > /dev/null 2>&1
    __28_step_current=$(echo ${__28_step_current} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
}
get_source_root__324_v0() {
    get_repo_root__298_v0 ;
    __AF_get_repo_root298_v0__38_21="${__AF_get_repo_root298_v0}";
    local repo_root="${__AF_get_repo_root298_v0__38_21}"
    __AF_get_source_root324_v0="${repo_root}/.nixie/sources";
    return 0
}
make_headers__328_v0() {
    __AMBER_VAL_59=$(grep ".*\.h:" ./Makefile | cut -f 1 -d :);
    __AS=$?;
    split_lines__4_v0 "${__AMBER_VAL_59}";
    __AF_split_lines4_v0__19_19=("${__AF_split_lines4_v0[@]}");
    for header in "${__AF_split_lines4_v0__19_19[@]}"; do
        make ${header};
        __AS=$?;
if [ $__AS != 0 ]; then
__AF_make_headers328_v0=''
return $__AS
fi
done
}
build_openssl_inner__329_v0() {
    get_dll_ext__295_v0 ;
    __AF_get_dll_ext295_v0__27_19="${__AF_get_dll_ext295_v0}";
    local dll_ext="${__AF_get_dll_ext295_v0__27_19}"
    get_cache_root__297_v0 ;
    __AF_get_cache_root297_v0__28_22="${__AF_get_cache_root297_v0}";
    local cache_root="${__AF_get_cache_root297_v0__28_22}"
    chmod +x ./config;
    __AS=$?
    ./config;
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_openssl_inner329_v0=''
return $__AS
fi
    make_headers__328_v0 ;
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_openssl_inner329_v0=''
return $__AS
fi;
    __AF_make_headers328_v0__33_5="$__AF_make_headers328_v0";
    echo "$__AF_make_headers328_v0__33_5" > /dev/null 2>&1
    make libcrypto.${dll_ext} libcrypto.pc;
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_openssl_inner329_v0=''
return $__AS
fi
    cp ./libcrypto.* ${cache_root}/nix-deps/lib/;
    __AS=$?
    cp ./libcrypto.pc ${cache_root}/nix-deps/lib/pkgconfig;
    __AS=$?
    cp -r ./include ${cache_root}/nix-deps/;
    __AS=$?
}
build_openssl__330_v0() {
    get_source_root__324_v0 ;
    __AF_get_source_root324_v0__51_23="${__AF_get_source_root324_v0}";
    local source_root="${__AF_get_source_root324_v0__51_23}"
    get_cache_root__297_v0 ;
    __AF_get_cache_root297_v0__52_22="${__AF_get_cache_root297_v0}";
    local cache_root="${__AF_get_cache_root297_v0__52_22}"
    step_title__323_v0 "libcrypto";
    __AF_step_title323_v0__54_5="$__AF_step_title323_v0";
    echo "$__AF_step_title323_v0__54_5" > /dev/null 2>&1
    pkg_exists__322_v0 "libcrypto";
    __AF_pkg_exists322_v0__56_8="$__AF_pkg_exists322_v0";
    if [ "$__AF_pkg_exists322_v0__56_8" != 0 ]; then
        __AF_build_openssl330_v0=0;
        return 0
fi
    env_var_test__87_v0 "OPENSSL_LIBS";
    __AF_env_var_test87_v0__58_8="$__AF_env_var_test87_v0";
    env_var_test__87_v0 "OPENSSL_CFLAGS";
    __AF_env_var_test87_v0__58_41="$__AF_env_var_test87_v0";
    if [ $(echo "$__AF_env_var_test87_v0__58_8" '&&' "$__AF_env_var_test87_v0__58_41" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_build_openssl330_v0=0;
        return 0
fi
    pull_source_file__313_v0 "openssl" "${source_root}/openssl";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_openssl330_v0=''
return $__AS
fi;
    __AF_pull_source_file313_v0__61_5="$__AF_pull_source_file313_v0";
    echo "$__AF_pull_source_file313_v0__61_5" > /dev/null 2>&1
    (cd ${source_root}/openssl && build_openssl_inner__329_v0);
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_openssl330_v0=''
return $__AS
fi
}
macos_build_post__339_v0() {
    cc -shared -o liblowdown.1.dylib *.o;
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_macos_build_post339_v0=''
return $__AS
fi
}
build_lowdown_inner__340_v0() {
    get_cache_root__297_v0 ;
    __AF_get_cache_root297_v0__21_22="${__AF_get_cache_root297_v0}";
    local cache_root="${__AF_get_cache_root297_v0__21_22}"
    ./configure PREFIX=${cache_root}/nix-deps;
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_lowdown_inner340_v0=''
return $__AS
fi
    make;
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_lowdown_inner340_v0=''
return $__AS
fi
    get_osname__292_v0 ;
    __AF_get_osname292_v0__26_8="${__AF_get_osname292_v0}";
    if [ $([ "_${__AF_get_osname292_v0__26_8}" != "_Darwin" ]; echo $?) != 0 ]; then
        macos_build_post__339_v0 ;
        __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_lowdown_inner340_v0=''
return $__AS
fi;
        __AF_macos_build_post339_v0__27_9="$__AF_macos_build_post339_v0";
        echo "$__AF_macos_build_post339_v0__27_9" > /dev/null 2>&1
fi
    make install_shared;
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_lowdown_inner340_v0=''
return $__AS
fi
}
build_lowdown__341_v0() {
    get_source_root__324_v0 ;
    __AF_get_source_root324_v0__36_23="${__AF_get_source_root324_v0}";
    local source_root="${__AF_get_source_root324_v0__36_23}"
    get_cache_root__297_v0 ;
    __AF_get_cache_root297_v0__37_22="${__AF_get_cache_root297_v0}";
    local cache_root="${__AF_get_cache_root297_v0__37_22}"
    step_title__323_v0 "lowdown";
    __AF_step_title323_v0__39_5="$__AF_step_title323_v0";
    echo "$__AF_step_title323_v0__39_5" > /dev/null 2>&1
    pkg_exists__322_v0 "lowdown";
    __AF_pkg_exists322_v0__41_8="$__AF_pkg_exists322_v0";
    if [ "$__AF_pkg_exists322_v0__41_8" != 0 ]; then
        __AF_build_lowdown341_v0=0;
        return 0
fi
    pull_source_file__313_v0 "lowdown" "${source_root}/lowdown";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_lowdown341_v0=''
return $__AS
fi;
    __AF_pull_source_file313_v0__44_5="$__AF_pull_source_file313_v0";
    echo "$__AF_pull_source_file313_v0__44_5" > /dev/null 2>&1
    (cd ${source_root}/lowdown && build_lowdown_inner__340_v0);
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_lowdown341_v0=''
return $__AS
fi
}
build_nlohmann_json__350_v0() {
    get_source_root__324_v0 ;
    __AF_get_source_root324_v0__16_23="${__AF_get_source_root324_v0}";
    local source_root="${__AF_get_source_root324_v0__16_23}"
    get_cache_root__297_v0 ;
    __AF_get_cache_root297_v0__17_22="${__AF_get_cache_root297_v0}";
    local cache_root="${__AF_get_cache_root297_v0__17_22}"
    step_title__323_v0 "nlohmann_json";
    __AF_step_title323_v0__19_5="$__AF_step_title323_v0";
    echo "$__AF_step_title323_v0__19_5" > /dev/null 2>&1
    pkg_exists__322_v0 "nlohmann_json";
    __AF_pkg_exists322_v0__21_8="$__AF_pkg_exists322_v0";
    if [ "$__AF_pkg_exists322_v0__21_8" != 0 ]; then
        __AF_build_nlohmann_json350_v0=0;
        return 0
fi
    pull_source_file__313_v0 "nlohmann_json" "${source_root}/nlohmann_json";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_nlohmann_json350_v0=''
return $__AS
fi;
    __AF_pull_source_file313_v0__24_5="$__AF_pull_source_file313_v0";
    echo "$__AF_pull_source_file313_v0__24_5" > /dev/null 2>&1
    __AMBER_VAL_60=$(grep "^version:" ${source_root}/nlohmann_json/wsjcpp.yml | cut -d '"' -f 2 | cut -d 'v' -f 2);
    __AS=$?;
    local version="${__AMBER_VAL_60}"
    file_write__35_v0 "${cache_root}/nix-deps/lib/pkgconfig/nlohmann_json.pc" "Name: nlohmann_json
Version: ${version}
Description: JSON for Modern C++
Cflags: -I${source_root}/nlohmann_json/include";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_nlohmann_json350_v0=''
return $__AS
fi;
    __AF_file_write35_v0__28_5="${__AF_file_write35_v0}";
    echo "${__AF_file_write35_v0__28_5}" > /dev/null 2>&1
}
__AMBER_ARRAY_61=("predef" "chrono" "container" "context" "coroutine" "system" "thread");
__29_modules=("${__AMBER_ARRAY_61[@]}")
find_boost_libs__359_v0() {
    local libs=("${!1}")
    for lib in "${libs[@]}"; do
        local libname="libboost_${lib}*"
        file_exists__33_v0 "/usr/lib/${libname}";
        __AF_file_exists33_v0__23_20="$__AF_file_exists33_v0";
        file_exists__33_v0 "/usr/local/lib/${libname}";
        __AF_file_exists33_v0__24_20="$__AF_file_exists33_v0";
        if [ $(echo  '!' $(echo "$__AF_file_exists33_v0__23_20" '||' "$__AF_file_exists33_v0__24_20" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            __AF_find_boost_libs359_v0=0;
            return 0
fi
        dir_exists__32_v0 "/usr/include/boost/${lib}";
        __AF_dir_exists32_v0__26_20="$__AF_dir_exists32_v0";
        dir_exists__32_v0 "/usr/local/include/boost/${lib}";
        __AF_dir_exists32_v0__27_20="$__AF_dir_exists32_v0";
        if [ $(echo  '!' $(echo "$__AF_dir_exists32_v0__26_20" '||' "$__AF_dir_exists32_v0__27_20" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            __AF_find_boost_libs359_v0=0;
            return 0
fi
done
    __AF_find_boost_libs359_v0=1;
    return 0
}
build_boost_inner__360_v0() {
    __AMBER_ARRAY_62=("variant=release" "link=static" "--stagedir=.");
    local args=("${__AMBER_ARRAY_62[@]}")
    for mod in "${__29_modules[@]}"; do
        __AMBER_ARRAY_63=("--with-${mod}");
        args+=("${__AMBER_ARRAY_63[@]}")
done
    ./bootstrap.sh;
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_boost_inner360_v0=''
return $__AS
fi
    ./b2 "${args[@]}";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_boost_inner360_v0=''
return $__AS
fi
}
build_boost__361_v0() {
    get_source_root__324_v0 ;
    __AF_get_source_root324_v0__52_23="${__AF_get_source_root324_v0}";
    local source_root="${__AF_get_source_root324_v0__52_23}"
    step_title__323_v0 "boost";
    __AF_step_title323_v0__54_5="$__AF_step_title323_v0";
    echo "$__AF_step_title323_v0__54_5" > /dev/null 2>&1
    __AMBER_ARRAY_64=("atomic");
    __AMBER_ARRAY_ADD_65=("${__AMBER_ARRAY_64[@]}" "${__29_modules[@]}");
    find_boost_libs__359_v0 __AMBER_ARRAY_ADD_65[@];
    __AF_find_boost_libs359_v0__56_8="$__AF_find_boost_libs359_v0";
    if [ "$__AF_find_boost_libs359_v0__56_8" != 0 ]; then
        __AF_build_boost361_v0=0;
        return 0
fi
    pull_source_file__313_v0 "boost" "${source_root}/boost";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_boost361_v0=''
return $__AS
fi;
    __AF_pull_source_file313_v0__59_5="$__AF_pull_source_file313_v0";
    echo "$__AF_pull_source_file313_v0__59_5" > /dev/null 2>&1
    (cd ${source_root}/boost && build_boost_inner__360_v0);
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_boost361_v0=''
return $__AS
fi
    env_var_set__90_v0 "BOOST_ROOT" "${source_root}/boost";
    __AS=$?;
    __AF_env_var_set90_v0__63_11="$__AF_env_var_set90_v0";
    echo "$__AF_env_var_set90_v0__63_11" > /dev/null 2>&1
    export BOOST_ROOT;
    __AS=$?
}
build_autoconf_dep__369_v0() {
    local lib_name=$1
    local inc_prefix=$2
    get_source_root__324_v0 ;
    __AF_get_source_root324_v0__19_23="${__AF_get_source_root324_v0}";
    local source_root="${__AF_get_source_root324_v0__19_23}"
    get_cache_root__297_v0 ;
    __AF_get_cache_root297_v0__20_22="${__AF_get_cache_root297_v0}";
    local cache_root="${__AF_get_cache_root297_v0__20_22}"
    local my_source="${source_root}/${lib_name}"
    step_title__323_v0 "${lib_name}";
    __AF_step_title323_v0__24_5="$__AF_step_title323_v0";
    echo "$__AF_step_title323_v0__24_5" > /dev/null 2>&1
    pkg_exists__322_v0 "${lib_name}";
    __AF_pkg_exists322_v0__26_8="$__AF_pkg_exists322_v0";
    if [ "$__AF_pkg_exists322_v0__26_8" != 0 ]; then
        __AF_build_autoconf_dep369_v0='';
        return 0
fi
    pull_source_file__313_v0 "${lib_name}" "${my_source}";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_autoconf_dep369_v0=''
return $__AS
fi;
    __AF_pull_source_file313_v0__29_5="$__AF_pull_source_file313_v0";
    echo "$__AF_pull_source_file313_v0__29_5" > /dev/null 2>&1
    ( unset C_INCLUDE_PATH CPLUS_INCLUDE_PATH     && cd ${my_source}     && ./configure --prefix=${cache_root}/nix-deps     && make && make install );
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_autoconf_dep369_v0=''
return $__AS
fi
}
build_nix_inner__379_v0() {
    get_source_root__324_v0 ;
    __AF_get_source_root324_v0__16_23="${__AF_get_source_root324_v0}";
    local source_root="${__AF_get_source_root324_v0__16_23}"
    local venv="${source_root}/nix/venv"
    mkdir build && cd build;
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_nix_inner379_v0=''
return $__AS
fi
    ${venv}/bin/meson setup -Dlibstore:seccomp-sandboxing=disabled                             -Dlibcmd:readline-flavor=editline                             -Dlibexpr:gc=disabled                             -Dlibutil:cpuid=disabled                             -Ddoc-gen=false                             -Dunit-tests=false                             -Dbindings=false                             ..;
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_nix_inner379_v0=''
return $__AS
fi
    ${venv}/bin/ninja;
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_nix_inner379_v0=''
return $__AS
fi
}
build_nix__380_v0() {
    get_source_root__324_v0 ;
    __AF_get_source_root324_v0__39_23="${__AF_get_source_root324_v0}";
    local source_root="${__AF_get_source_root324_v0__39_23}"
    get_cache_root__297_v0 ;
    __AF_get_cache_root297_v0__40_22="${__AF_get_cache_root297_v0}";
    local cache_root="${__AF_get_cache_root297_v0__40_22}"
    local venv="${source_root}/nix/venv"
    step_title__323_v0 "nix";
    __AF_step_title323_v0__44_5="$__AF_step_title323_v0";
    echo "$__AF_step_title323_v0__44_5" > /dev/null 2>&1
    pull_source_file__313_v0 "nix" "${source_root}/nix";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_nix380_v0=''
return $__AS
fi;
    __AF_pull_source_file313_v0__46_5="$__AF_pull_source_file313_v0";
    echo "$__AF_pull_source_file313_v0__46_5" > /dev/null 2>&1
    python3 -m venv --system-site-packages "${venv}";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_nix380_v0=''
return $__AS
fi
    export LIBRARY_PATH=${cache_root}/nix-deps/lib:$LIBRARY_PATH;
    __AS=$?
    export PKG_CONFIG_PATH=${cache_root}/nix-deps/lib/pkgconfig:${cache_root}/nix-deps/share/pkgconfig:$PKG_CONFIG_PATH;
    __AS=$?
    ${venv}/bin/pip install meson ninja;
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_nix380_v0=''
return $__AS
fi
    (cd ${source_root}/nix && build_nix_inner__379_v0);
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_build_nix380_v0=''
return $__AS
fi
    mv "${source_root}/nix/src/nix/nix" "${cache_root}/nix-static"
__AS=$?
}
darwin_export_sdk__382_v0() {
    __AMBER_VAL_66=$(xcrun --show-sdk-path);
    __AS=$?;
    local sdk_path="${__AMBER_VAL_66}"
    dir_exists__32_v0 "${sdk_path}";
    __AF_dir_exists32_v0__30_12="$__AF_dir_exists32_v0";
    if [ $(echo  '!' "$__AF_dir_exists32_v0__30_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        bail__140_v0 "The macOS SDK from Xcode or CommandLineTools is required to build Nix." 0;
        __AF_bail140_v0__31_9="$__AF_bail140_v0";
        echo "$__AF_bail140_v0__31_9" > /dev/null 2>&1
fi
    local sdk_libs="${sdk_path}/usr/lib"
    local sdk_cflags="-I${sdk_path}/usr/include"
    env_var_set__90_v0 "LIBCURL_LIBS" "${sdk_libs}";
    __AS=$?;
    __AF_env_var_set90_v0__36_11="$__AF_env_var_set90_v0";
    echo "$__AF_env_var_set90_v0__36_11" > /dev/null 2>&1
    env_var_set__90_v0 "LIBCURL_CFLAGS" "${sdk_cflags}";
    __AS=$?;
    __AF_env_var_set90_v0__37_11="$__AF_env_var_set90_v0";
    echo "$__AF_env_var_set90_v0__37_11" > /dev/null 2>&1
    env_var_set__90_v0 "LIBARCHIVE_LIBS" "${sdk_libs}";
    __AS=$?;
    __AF_env_var_set90_v0__38_11="$__AF_env_var_set90_v0";
    echo "$__AF_env_var_set90_v0__38_11" > /dev/null 2>&1
    env_var_set__90_v0 "LIBARCHIVE_CFLAGS" "${sdk_cflags}";
    __AS=$?;
    __AF_env_var_set90_v0__39_11="$__AF_env_var_set90_v0";
    echo "$__AF_env_var_set90_v0__39_11" > /dev/null 2>&1
    env_var_set__90_v0 "OPENSSL_LIBS" "${sdk_libs}";
    __AS=$?;
    __AF_env_var_set90_v0__40_11="$__AF_env_var_set90_v0";
    echo "$__AF_env_var_set90_v0__40_11" > /dev/null 2>&1
    env_var_set__90_v0 "OPENSSL_CFLAGS" "${sdk_cflags}";
    __AS=$?;
    __AF_env_var_set90_v0__41_11="$__AF_env_var_set90_v0";
    echo "$__AF_env_var_set90_v0__41_11" > /dev/null 2>&1
    export LIBCURL_LIBS LIBCURL_CFLAGS                   LIBARCHIVE_LIBS LIBARCHIVE_CFLAGS                   OPENSSL_LIBS OPENSSL_CFLAGS;
    __AS=$?
}
try_build_nix__383_v0() {
    get_cache_root__159_v0 ;
    __AF_get_cache_root159_v0__55_22="${__AF_get_cache_root159_v0}";
    local cache_root="${__AF_get_cache_root159_v0__55_22}"
    __AMBER_ARRAY_67=("cc" "c++" "pkg-config" "make" "flex" "bison" "perl");
    check_deps__144_v0 __AMBER_ARRAY_67[@];
    __AS=$?;
if [ $__AS != 0 ]; then
        bail__140_v0 "Missing required dependencies to build from source." 0;
        __AF_bail140_v0__58_18="$__AF_bail140_v0";
        echo "$__AF_bail140_v0__58_18" > /dev/null 2>&1
fi;
    __AF_check_deps144_v0__57_5="$__AF_check_deps144_v0";
    echo "$__AF_check_deps144_v0__57_5" > /dev/null 2>&1
    get_osname__154_v0 ;
    __AF_get_osname154_v0__60_8="${__AF_get_osname154_v0}";
    if [ $([ "_${__AF_get_osname154_v0__60_8}" != "_Darwin" ]; echo $?) != 0 ]; then
        darwin_export_sdk__382_v0 ;
        __AF_darwin_export_sdk382_v0__61_9="$__AF_darwin_export_sdk382_v0";
        echo "$__AF_darwin_export_sdk382_v0__61_9" > /dev/null 2>&1
fi
    env_var_set__90_v0 "step_total" "9";
    __AS=$?;
    __AF_env_var_set90_v0__63_11="$__AF_env_var_set90_v0";
    echo "$__AF_env_var_set90_v0__63_11" > /dev/null 2>&1
    get_source_root__302_v0 ;
    __AF_get_source_root302_v0__65_16="${__AF_get_source_root302_v0}";
    dir_create__38_v0 "${__AF_get_source_root302_v0__65_16}";
    __AF_dir_create38_v0__65_5="$__AF_dir_create38_v0";
    echo "$__AF_dir_create38_v0__65_5" > /dev/null 2>&1
    dir_create__38_v0 "${cache_root}/nix-deps/lib/pkgconfig";
    __AF_dir_create38_v0__66_5="$__AF_dir_create38_v0";
    echo "$__AF_dir_create38_v0__66_5" > /dev/null 2>&1
    build_openssl__330_v0 ;
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_try_build_nix383_v0=''
return $__AS
fi;
    __AF_build_openssl330_v0__68_5="$__AF_build_openssl330_v0";
    echo "$__AF_build_openssl330_v0__68_5" > /dev/null 2>&1
    build_boost__361_v0 ;
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_try_build_nix383_v0=''
return $__AS
fi;
    __AF_build_boost361_v0__69_5="$__AF_build_boost361_v0";
    echo "$__AF_build_boost361_v0__69_5" > /dev/null 2>&1
    build_nlohmann_json__350_v0 ;
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_try_build_nix383_v0=''
return $__AS
fi;
    __AF_build_nlohmann_json350_v0__70_5="$__AF_build_nlohmann_json350_v0";
    echo "$__AF_build_nlohmann_json350_v0__70_5" > /dev/null 2>&1
    build_lowdown__341_v0 ;
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_try_build_nix383_v0=''
return $__AS
fi;
    __AF_build_lowdown341_v0__71_5="$__AF_build_lowdown341_v0";
    echo "$__AF_build_lowdown341_v0__71_5" > /dev/null 2>&1
    build_autoconf_dep__369_v0 "libbrotlicommon" "c/include";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_try_build_nix383_v0=''
return $__AS
fi;
    __AF_build_autoconf_dep369_v0__73_5="$__AF_build_autoconf_dep369_v0";
    echo "$__AF_build_autoconf_dep369_v0__73_5" > /dev/null 2>&1
    build_autoconf_dep__369_v0 "libsodium" "src/libsodium/include";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_try_build_nix383_v0=''
return $__AS
fi;
    __AF_build_autoconf_dep369_v0__74_5="$__AF_build_autoconf_dep369_v0";
    echo "$__AF_build_autoconf_dep369_v0__74_5" > /dev/null 2>&1
    build_autoconf_dep__369_v0 "libeditline" "include";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_try_build_nix383_v0=''
return $__AS
fi;
    __AF_build_autoconf_dep369_v0__75_5="$__AF_build_autoconf_dep369_v0";
    echo "$__AF_build_autoconf_dep369_v0__75_5" > /dev/null 2>&1
    build_autoconf_dep__369_v0 "libarchive" "libarchive";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_try_build_nix383_v0=''
return $__AS
fi;
    __AF_build_autoconf_dep369_v0__76_5="$__AF_build_autoconf_dep369_v0";
    echo "$__AF_build_autoconf_dep369_v0__76_5" > /dev/null 2>&1
    build_nix__380_v0 ;
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_try_build_nix383_v0=''
return $__AS
fi;
    __AF_build_nix380_v0__77_5="$__AF_build_nix380_v0";
    echo "$__AF_build_nix380_v0__77_5" > /dev/null 2>&1
}
is_nix_installed__385_v0() {
    env_var_test__87_v0 "nosystem";
    __AF_env_var_test87_v0__24_8="$__AF_env_var_test87_v0";
    if [ "$__AF_env_var_test87_v0__24_8" != 0 ]; then
        __AF_is_nix_installed385_v0=0;
        return 0
fi
    dir_exists__32_v0 "/nix/store";
    __AF_dir_exists32_v0__29_8="$__AF_dir_exists32_v0";
    if [ "$__AF_dir_exists32_v0__29_8" != 0 ]; then
        __AF_is_nix_installed385_v0=1;
        return 0
fi
    __AF_is_nix_installed385_v0=0;
    return 0
}
get_nix__386_v0() {
    get_cache_root__159_v0 ;
    __AF_get_cache_root159_v0__44_22="${__AF_get_cache_root159_v0}";
    local cache_root="${__AF_get_cache_root159_v0__44_22}"
    get_osname__154_v0 ;
    __AF_get_osname154_v0__45_18="${__AF_get_osname154_v0}";
    local osname="${__AF_get_osname154_v0__45_18}"
    get_system__156_v0 ;
    __AF_get_system156_v0__46_18="${__AF_get_system156_v0}";
    local system="${__AF_get_system156_v0__46_18}"
    local nix_path="${cache_root}/nix-static"
    local fakedir_path="${cache_root}/nix-deps/lib/libfakedir.dylib"
    enter_alt_buffer__134_v0 ;
    __AF_enter_alt_buffer134_v0__51_5="$__AF_enter_alt_buffer134_v0";
    echo "$__AF_enter_alt_buffer134_v0__51_5" > /dev/null 2>&1
    set_title__133_v0 "Building Nix...";
    __AF_set_title133_v0__52_5="$__AF_set_title133_v0";
    echo "$__AF_set_title133_v0__52_5" > /dev/null 2>&1
    trap "teardown__136_v0; exit 1" SIGKILL SIGTERM SIGINT SIGABRT;
    __AS=$?
    file_exists__33_v0 "${fakedir_path}";
    __AF_file_exists33_v0__58_35="$__AF_file_exists33_v0";
    if [ $(echo $([ "_${osname}" != "_Darwin" ]; echo $?) '&&' $(echo  '!' "$__AF_file_exists33_v0__58_35" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        dir_create__38_v0 "${cache_root}/nix-deps/lib";
        __AF_dir_create38_v0__59_9="$__AF_dir_create38_v0";
        echo "$__AF_dir_create38_v0__59_9" > /dev/null 2>&1
        pull_binary__241_v0 "libfakedir.dylib" "${fakedir_path}";
        __AS=$?;
if [ $__AS != 0 ]; then
            teardown__136_v0 1;
            __AF_teardown136_v0__61_13="$__AF_teardown136_v0";
            echo "$__AF_teardown136_v0__61_13" > /dev/null 2>&1
            __AF_get_nix386_v0='';
            return 1
fi;
        __AF_pull_binary241_v0__60_9="$__AF_pull_binary241_v0";
        echo "$__AF_pull_binary241_v0__60_9" > /dev/null 2>&1
fi
    get_self__141_v0 ;
    __AF_get_self141_v0__67_62="${__AF_get_self141_v0}";
    exists_newer__139_v0 "${fakedir_path}" "${__AF_get_self141_v0__67_62}";
    __AF_exists_newer139_v0__67_35="$__AF_exists_newer139_v0";
    if [ $(echo $([ "_${osname}" != "_Darwin" ]; echo $?) '&&' $(echo  '!' "$__AF_exists_newer139_v0__67_35" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        pull_binary__241_v0 "libfakedir.dylib" "${fakedir_path}";
        __AS=$?;
        __AF_pull_binary241_v0__68_15="$__AF_pull_binary241_v0";
        echo "$__AF_pull_binary241_v0__68_15" > /dev/null 2>&1
fi
    file_exists__33_v0 "${nix_path}";
    __AF_file_exists33_v0__71_8="$__AF_file_exists33_v0";
    if [ "$__AF_file_exists33_v0__71_8" != 0 ]; then
        teardown__136_v0 0;
        __AF_teardown136_v0__72_9="$__AF_teardown136_v0";
        echo "$__AF_teardown136_v0__72_9" > /dev/null 2>&1
        __AF_get_nix386_v0=0;
        return 0
fi
    env_var_test__87_v0 "nobins";
    __AF_env_var_test87_v0__76_8="$__AF_env_var_test87_v0";
    if [ "$__AF_env_var_test87_v0__76_8" != 0 ]; then
        try_build_nix__383_v0 ;
        __AS=$?;
if [ $__AS != 0 ]; then
            teardown__136_v0 1;
            __AF_teardown136_v0__78_13="$__AF_teardown136_v0";
            echo "$__AF_teardown136_v0__78_13" > /dev/null 2>&1
            __AF_get_nix386_v0='';
            return 1
fi;
        __AF_try_build_nix383_v0__77_9="$__AF_try_build_nix383_v0";
        echo "$__AF_try_build_nix383_v0__77_9" > /dev/null 2>&1
fi
    pull_binary__241_v0 "nix.${system}" "${nix_path}";
    __AS=$?;
if [ $__AS != 0 ]; then
        try_build_nix__383_v0 ;
        __AS=$?;
if [ $__AS != 0 ]; then
            teardown__136_v0 1;
            __AF_teardown136_v0__86_13="$__AF_teardown136_v0";
            echo "$__AF_teardown136_v0__86_13" > /dev/null 2>&1
            __AF_get_nix386_v0='';
            return 1
fi;
        __AF_try_build_nix383_v0__85_9="$__AF_try_build_nix383_v0";
        echo "$__AF_try_build_nix383_v0__85_9" > /dev/null 2>&1
fi;
    __AF_pull_binary241_v0__84_5="$__AF_pull_binary241_v0";
    echo "$__AF_pull_binary241_v0__84_5" > /dev/null 2>&1
    chmod +x ${nix_path};
    __AS=$?
    teardown__136_v0 0;
    __AF_teardown136_v0__93_5="$__AF_teardown136_v0";
    echo "$__AF_teardown136_v0__93_5" > /dev/null 2>&1
    __AF_get_nix386_v0=0;
    return 0
}
migrate_nix_store__387_v0() {
    local nix_root=""
    get_nix_root__158_v0 ;
    __AF_get_nix_root158_v0__105_30="${__AF_get_nix_root158_v0}";
    __AMBER_VAL_68=$(readlink -f ${__AF_get_nix_root158_v0__105_30});
    __AS=$?;
if [ $__AS != 0 ]; then
        get_nix_root__158_v0 ;
        __AF_get_nix_root158_v0__106_20="${__AF_get_nix_root158_v0}";
        nix_root="${__AF_get_nix_root158_v0__106_20}"
fi;
    nix_root="${__AMBER_VAL_68}"
    dir_exists__32_v0 "${nix_root}/nix/store";
    __AF_dir_exists32_v0__109_12="$__AF_dir_exists32_v0";
    if [ $(echo  '!' "$__AF_dir_exists32_v0__109_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_migrate_nix_store387_v0=0;
        return 0
fi
    echo "Migrating Nix store to system-wide install..."
    nix copy --from ${nix_root} --all --no-check-sigs;
    __AS=$?
    if [ $(echo $__AS '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        chmod -R +wx ${nix_root} && rm -rf ${nix_root};
        __AS=$?
fi
}
unpack_channels__388_v0() {
    get_repo_root__160_v0 ;
    __AF_get_repo_root160_v0__123_21="${__AF_get_repo_root160_v0}";
    local repo_root="${__AF_get_repo_root160_v0__123_21}"
    get_self__141_v0 ;
    __AF_get_self141_v0__125_52="${__AF_get_self141_v0}";
    exists_newer__139_v0 "${repo_root}/.nixie/channels" "${__AF_get_self141_v0__125_52}";
    __AF_exists_newer139_v0__125_8="$__AF_exists_newer139_v0";
    if [ "$__AF_exists_newer139_v0__125_8" != 0 ]; then
        env_var_get__91_v0 "NIX_PATH";
        __AS=$?;
        __AF_env_var_get91_v0__126_30="${__AF_env_var_get91_v0}";
        local NIX_PATH="${__AF_env_var_get91_v0__126_30}"
        env_var_set__90_v0 "NIX_PATH" "${repo_root}/.nixie/channels:${NIX_PATH}";
        __AS=$?;
        __AF_env_var_set90_v0__127_15="$__AF_env_var_set90_v0";
        echo "$__AF_env_var_set90_v0__127_15" > /dev/null 2>&1
        export NIX_PATH;
        __AS=$?
        __AF_unpack_channels388_v0=0;
        return 0
fi
    echo "Unpacking Nix channels, hang tight..."
    dir_create__38_v0 "${repo_root}/.nixie";
    __AF_dir_create38_v0__133_5="$__AF_dir_create38_v0";
    echo "$__AF_dir_create38_v0__133_5" > /dev/null 2>&1
    untar__143_v0 "channels -C ${repo_root}/.nixie" 0;
    __AS=$?;
if [ $__AS != 0 ]; then
        mkdir ${repo_root}/.nixie/channels;
        __AS=$?
fi;
    __AF_untar143_v0__134_5="${__AF_untar143_v0}";
    echo "${__AF_untar143_v0__134_5}" > /dev/null 2>&1
}
populate_extras__389_v0() {
    __AMBER_ARRAY_69=();
    local args=("${__AMBER_ARRAY_69[@]}")
    env_var_get__91_v0 "EXTRA_FEATURES";
    __AS=$?;
    __AF_env_var_get91_v0__146_43="${__AF_env_var_get91_v0}";
    local EXTRA_FEATURES="${__AF_env_var_get91_v0__146_43}"
    env_var_get__91_v0 "EXTRA_SUBSTITUTERS";
    __AS=$?;
    __AF_env_var_get91_v0__147_43="${__AF_env_var_get91_v0}";
    local EXTRA_SUBSTITUTERS="${__AF_env_var_get91_v0__147_43}"
    env_var_get__91_v0 "EXTRA_TRUSTED_PUBLIC_KEYS";
    __AS=$?;
    __AF_env_var_get91_v0__148_43="${__AF_env_var_get91_v0}";
    local EXTRA_TRUSTED_PUBLIC_KEYS="${__AF_env_var_get91_v0__148_43}"
    get_nix_root__158_v0 ;
    __AF_get_nix_root158_v0__150_20="${__AF_get_nix_root158_v0}";
    local nix_root="${__AF_get_nix_root158_v0__150_20}"
    if [ $([ "_${EXTRA_FEATURES}" == "_" ]; echo $?) != 0 ]; then
        __AMBER_ARRAY_70=("--extra-experimental-features" "${EXTRA_FEATURES}");
        args+=("${__AMBER_ARRAY_70[@]}")
fi
    if [ $([ "_${EXTRA_SUBSTITUTERS}" == "_" ]; echo $?) != 0 ]; then
        __AMBER_ARRAY_71=("--extra-substituters" "${EXTRA_SUBSTITUTERS}");
        args+=("${__AMBER_ARRAY_71[@]}")
fi
    if [ $([ "_${EXTRA_TRUSTED_PUBLIC_KEYS}" == "_" ]; echo $?) != 0 ]; then
        __AMBER_ARRAY_72=("--extra-trusted-public-keys" "${EXTRA_TRUSTED_PUBLIC_KEYS}");
        args+=("${__AMBER_ARRAY_72[@]}")
fi
    get_osname__154_v0 ;
    __AF_get_osname154_v0__161_8="${__AF_get_osname154_v0}";
    is_nix_installed__385_v0 ;
    __AF_is_nix_installed385_v0__161_41="$__AF_is_nix_installed385_v0";
    if [ $(echo $([ "_${__AF_get_osname154_v0__161_8}" == "_Darwin" ]; echo $?) '&&' $(echo  '!' "$__AF_is_nix_installed385_v0__161_41" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_VAL_74=$(readlink -f ${nix_root});
        __AS=$?;
        __AMBER_ARRAY_73=("--store" "${__AMBER_VAL_74}");
        args+=("${__AMBER_ARRAY_73[@]}")
fi
    __AF_populate_extras389_v0=("${args[@]}");
    return 0
}
launch_darwin_workaround__390_v0() {
    local name=$1
    local nix_path=$2
    local args=("${!3}")
    get_cache_root__159_v0 ;
    __AF_get_cache_root159_v0__176_22="${__AF_get_cache_root159_v0}";
    local cache_root="${__AF_get_cache_root159_v0__176_22}"
    get_nix_root__158_v0 ;
    __AF_get_nix_root158_v0__177_20="${__AF_get_nix_root158_v0}";
    local nix_root="${__AF_get_nix_root158_v0__177_20}"
    local fakedir_path="${cache_root}/nix-deps/lib/libfakedir.dylib"
    env_var_set__90_v0 "FAKEDIR_PATTERN" "/nix";
    __AS=$?;
    __AF_env_var_set90_v0__181_11="$__AF_env_var_set90_v0";
    echo "$__AF_env_var_set90_v0__181_11" > /dev/null 2>&1
    env_var_set__90_v0 "FAKEDIR_TARGET" "${nix_root}/nix";
    __AS=$?;
    __AF_env_var_set90_v0__182_11="$__AF_env_var_set90_v0";
    echo "$__AF_env_var_set90_v0__182_11" > /dev/null 2>&1
    export FAKEDIR_PATTERN FAKEDIR_TARGET;
    __AS=$?
     _NIX_TEST_NO_SANDBOX=1             DYLD_INSERT_LIBRARIES="${fakedir_path}"             DYLD_LIBRARY_PATH="${cache_root}/nix-deps/lib"                 exec -a ${name} ${nix_path} "${args[@]}";
    __AS=$?
}
launch_shell_command__391_v0() {
    local nix_path=$1
    local cmd=$2
    local extras=("${!3}")
    local args=("${!4}")
    get_repo_root__160_v0 ;
    __AF_get_repo_root160_v0__205_21="${__AF_get_repo_root160_v0}";
    local repo_root="${__AF_get_repo_root160_v0__205_21}"
    env_var_get__91_v0 "PWD";
    __AS=$?;
    __AF_env_var_get91_v0__206_21="${__AF_env_var_get91_v0}";
    local pwd="${__AF_env_var_get91_v0__206_21}"
    local name="nix-shell"
    __AMBER_ARRAY_75=("${repo_root}/shell.nix" "--command" "${cmd} ${args[@]}");
    local shell_cmd=("${__AMBER_ARRAY_75[@]}")
    file_exists__33_v0 "${pwd}/flake.nix";
    __AF_file_exists33_v0__210_8="$__AF_file_exists33_v0";
    if [ "$__AF_file_exists33_v0__210_8" != 0 ]; then
        name="nix"
        __AMBER_ARRAY_76=("develop" "${pwd}" "-c" "${cmd}");
        __AMBER_ARRAY_ADD_77=("${__AMBER_ARRAY_76[@]}" "${args[@]}");
        shell_cmd=("${__AMBER_ARRAY_ADD_77[@]}")
else
        file_exists__33_v0 "${repo_root}/flake.nix";
        __AF_file_exists33_v0__213_16="$__AF_file_exists33_v0";
        if [ "$__AF_file_exists33_v0__213_16" != 0 ]; then
            name="nix"
            __AMBER_ARRAY_78=("develop" "${repo_root}" "-c" "${cmd}");
            __AMBER_ARRAY_ADD_79=("${__AMBER_ARRAY_78[@]}" "${args[@]}");
            shell_cmd=("${__AMBER_ARRAY_ADD_79[@]}")
else
            file_exists__33_v0 "${pwd}/shell.nix";
            __AF_file_exists33_v0__216_16="$__AF_file_exists33_v0";
            if [ "$__AF_file_exists33_v0__216_16" != 0 ]; then
                __AMBER_ARRAY_80=("${pwd}/shell.nix" "--command" "${cmd} ${args[@]}");
                shell_cmd=("${__AMBER_ARRAY_80[@]}")
fi
fi
fi
    get_osname__154_v0 ;
    __AF_get_osname154_v0__220_8="${__AF_get_osname154_v0}";
    is_nix_installed__385_v0 ;
    __AF_is_nix_installed385_v0__220_41="$__AF_is_nix_installed385_v0";
    if [ $(echo $([ "_${__AF_get_osname154_v0__220_8}" != "_Darwin" ]; echo $?) '&&' $(echo  '!' "$__AF_is_nix_installed385_v0__220_41" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_ADD_81=("${extras[@]}" "${shell_cmd[@]}");
        launch_darwin_workaround__390_v0 "${name}" "${nix_path}" __AMBER_ARRAY_ADD_81[@];
        __AF_launch_darwin_workaround390_v0__221_9="$__AF_launch_darwin_workaround390_v0";
        echo "$__AF_launch_darwin_workaround390_v0__221_9" > /dev/null 2>&1
else
        exec -a ${name} ${nix_path} "${extras[@]}" "${shell_cmd[@]}";
        __AS=$?
fi
}
launch_nix_shebang__392_v0() {
    local nix_path=$1
    local file=$2
    local extras=("${!3}")
    local args=("${!4}")
    local shebang=""
    i=0;
while IFS= read -r line; do
        if [ $(echo ${i} '==' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            shebang="${line}"
            break
fi
    (( i++ )) || true
done <"${file}"
    starts_with__20_v0 "${shebang}" "#"'!'"";
    __AF_starts_with20_v0__247_12="$__AF_starts_with20_v0";
    if [ $(echo  '!' "$__AF_starts_with20_v0__247_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AF_launch_nix_shebang392_v0='';
        return 0
fi
    slice__22_v0 "${shebang}" 2 0;
    __AF_slice22_v0__249_27="${__AF_slice22_v0}";
    split__3_v0 "${__AF_slice22_v0__249_27}" " ";
    __AF_split3_v0__249_21=("${__AF_split3_v0[@]}");
    local bang_args=("${__AF_split3_v0__249_21[@]}")
    array_shift__120_v0 bang_args;
    __AF_array_shift120_v0__250_16="${__AF_array_shift120_v0}";
    local name="${__AF_array_shift120_v0__250_16}"
    i=0;
for arg in "${bang_args[@]}"; do
        if [ $([ "_${arg}" != "_-i" ]; echo $?) != 0 ]; then
            bang_args[${i}]="--command"
            bang_args[$(echo ${i} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]="${bang_args[$(echo ${i} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]} ${file} ${args[@]}"
            break
fi
    (( i++ )) || true
done
    get_osname__154_v0 ;
    __AF_get_osname154_v0__261_8="${__AF_get_osname154_v0}";
    is_nix_installed__385_v0 ;
    __AF_is_nix_installed385_v0__261_41="$__AF_is_nix_installed385_v0";
    if [ $(echo $([ "_${__AF_get_osname154_v0__261_8}" != "_Darwin" ]; echo $?) '&&' $(echo  '!' "$__AF_is_nix_installed385_v0__261_41" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_ADD_82=("${extras[@]}" "${bang_args[@]}");
        launch_darwin_workaround__390_v0 "${name}" "${nix_path}" __AMBER_ARRAY_ADD_82[@];
        __AF_launch_darwin_workaround390_v0__262_9="$__AF_launch_darwin_workaround390_v0";
        echo "$__AF_launch_darwin_workaround390_v0__262_9" > /dev/null 2>&1
else
        exec -a ${name} ${nix_path} "${extras[@]}" "${bang_args[@]}";
        __AS=$?
fi
}
launch_nix__393_v0() {
    local self=$1
    local args=("${!2}")
    get_cache_root__159_v0 ;
    __AF_get_cache_root159_v0__272_22="${__AF_get_cache_root159_v0}";
    local cache_root="${__AF_get_cache_root159_v0__272_22}"
    get_nix_root__158_v0 ;
    __AF_get_nix_root158_v0__273_20="${__AF_get_nix_root158_v0}";
    local nix_root="${__AF_get_nix_root158_v0__273_20}"
    local nix_path="${cache_root}/nix-static"
    populate_extras__389_v0 ;
    __AF_populate_extras389_v0__277_18=("${__AF_populate_extras389_v0[@]}");
    local extras=("${__AF_populate_extras389_v0__277_18[@]}")
    split__3_v0 "${self}" "/";
    __AF_split3_v0__278_27=("${__AF_split3_v0[@]}");
    array_last__116_v0 __AF_split3_v0__278_27[@];
    __AF_array_last116_v0__278_16="${__AF_array_last116_v0}";
    local name="${__AF_array_last116_v0__278_16}"
    starts_with__20_v0 "${name}" "nix-";
    __AF_starts_with20_v0__280_8="$__AF_starts_with20_v0";
    if [ "$__AF_starts_with20_v0__280_8" != 0 ]; then
        unpack_channels__388_v0 ;
        __AF_unpack_channels388_v0__281_15="$__AF_unpack_channels388_v0";
        echo "$__AF_unpack_channels388_v0__281_15" > /dev/null 2>&1
fi
    is_nix_installed__385_v0 ;
    __AF_is_nix_installed385_v0__283_8="$__AF_is_nix_installed385_v0";
    if [ "$__AF_is_nix_installed385_v0__283_8" != 0 ]; then
        migrate_nix_store__387_v0 ;
        __AF_migrate_nix_store387_v0__284_9="$__AF_migrate_nix_store387_v0";
        echo "$__AF_migrate_nix_store387_v0__284_9" > /dev/null 2>&1
        nix_path="nix"
else
        get_nix__386_v0 ;
        __AS=$?;
if [ $__AS != 0 ]; then
            bail__140_v0 "Failed to obtain Nix. Check your internet connection." 0;
            __AF_bail140_v0__288_13="$__AF_bail140_v0";
            echo "$__AF_bail140_v0__288_13" > /dev/null 2>&1
fi;
        __AF_get_nix386_v0__287_9="$__AF_get_nix386_v0";
        echo "$__AF_get_nix386_v0__287_9" > /dev/null 2>&1
fi
    export NIX_SSL_CERT_FILE;
    __AS=$?
    file_exists__33_v0 "${args[0]}";
    __AF_file_exists33_v0__294_8="$__AF_file_exists33_v0";
    ends_with__21_v0 "${args[0]}" ".nix";
    __AF_ends_with21_v0__294_37="$__AF_ends_with21_v0";
    if [ $(echo "$__AF_file_exists33_v0__294_8" '&&' $(echo  '!' "$__AF_ends_with21_v0__294_37" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        local args_shebang=("${args[@]}")
        array_shift__120_v0 args_shebang;
        __AF_array_shift120_v0__296_9="${__AF_array_shift120_v0}";
        echo "${__AF_array_shift120_v0__296_9}" > /dev/null 2>&1
        launch_nix_shebang__392_v0 "${nix_path}" "${args[0]}" extras[@] args_shebang[@];
        __AF_launch_nix_shebang392_v0__297_9="$__AF_launch_nix_shebang392_v0";
        echo "$__AF_launch_nix_shebang392_v0__297_9" > /dev/null 2>&1
fi
    starts_with__20_v0 "${name}" "nix";
    __AF_starts_with20_v0__300_12="$__AF_starts_with20_v0";
    if [ $(echo  '!' "$__AF_starts_with20_v0__300_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        launch_shell_command__391_v0 "${nix_path}" "${name}" extras[@] args[@];
        __AF_launch_shell_command391_v0__301_9="$__AF_launch_shell_command391_v0";
        echo "$__AF_launch_shell_command391_v0__301_9" > /dev/null 2>&1
fi
    get_osname__154_v0 ;
    __AF_get_osname154_v0__304_8="${__AF_get_osname154_v0}";
    is_nix_installed__385_v0 ;
    __AF_is_nix_installed385_v0__304_41="$__AF_is_nix_installed385_v0";
    if [ $(echo $([ "_${__AF_get_osname154_v0__304_8}" != "_Darwin" ]; echo $?) '&&' $(echo  '!' "$__AF_is_nix_installed385_v0__304_41" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        __AMBER_ARRAY_ADD_83=("${extras[@]}" "${args[@]}");
        launch_darwin_workaround__390_v0 "${name}" "${nix_path}" __AMBER_ARRAY_ADD_83[@];
        __AF_launch_darwin_workaround390_v0__305_9="$__AF_launch_darwin_workaround390_v0";
        echo "$__AF_launch_darwin_workaround390_v0__305_9" > /dev/null 2>&1
else
        exec -a ${name} ${nix_path} "${extras[@]}" "${args[@]}";
        __AS=$?
fi
}
__0_SOURCE_CACHE=""
__1_SOURCE_DERIVATION=""
__2_NIX_BINS_DERIVATION=""
__3_EXTRA_FEATURES=""
__4_EXTRA_SUBSTITUTERS=""
__5_EXTRA_TRUSTED_PUBLIC_KEYS=""
__6_NIXIE_VERSION=""
__AMBER_ARRAY_84=();
__7_args=("${__AMBER_ARRAY_84[@]}")
__AMBER_ARRAY_85=("tar" "gzip" "uname");
check_deps__144_v0 __AMBER_ARRAY_85[@];
__AS=$?;
if [ $__AS != 0 ]; then
    exit 1
fi;
__AF_check_deps144_v0__26_1="$__AF_check_deps144_v0";
echo "$__AF_check_deps144_v0__26_1" > /dev/null 2>&1
load_features__395_v0() {
    untar__143_v0 "features" 1;
    __AS=$?;
if [ $__AS != 0 ]; then
        bail__140_v0 "The resource archive is missing or malformed." 1;
        __AF_bail140_v0__39_9="$__AF_bail140_v0";
        echo "$__AF_bail140_v0__39_9" > /dev/null 2>&1
fi;
    __AF_untar143_v0__38_19="${__AF_untar143_v0}";
    local envfile="${__AF_untar143_v0__38_19}"
    eval ${envfile};
    __AS=$?;
if [ $__AS != 0 ]; then
        bail__140_v0 "The environment file in the resource archive is malformed." 1;
        __AF_bail140_v0__43_9="$__AF_bail140_v0";
        echo "$__AF_bail140_v0__43_9" > /dev/null 2>&1
fi
    env_var_get__91_v0 "SOURCE_CACHE";
    __AS=$?;
    __AF_env_var_get91_v0__46_33="${__AF_env_var_get91_v0}";
    __0_SOURCE_CACHE="${__AF_env_var_get91_v0__46_33}"
    env_var_get__91_v0 "SOURCE_DERIVATION";
    __AS=$?;
    __AF_env_var_get91_v0__47_33="${__AF_env_var_get91_v0}";
    __1_SOURCE_DERIVATION="${__AF_env_var_get91_v0__47_33}"
    env_var_get__91_v0 "NIX_BINS_DERIVATION";
    __AS=$?;
    __AF_env_var_get91_v0__48_33="${__AF_env_var_get91_v0}";
    __2_NIX_BINS_DERIVATION="${__AF_env_var_get91_v0__48_33}"
    env_var_get__91_v0 "EXTRA_FEATURES";
    __AS=$?;
    __AF_env_var_get91_v0__50_41="${__AF_env_var_get91_v0}";
    __3_EXTRA_FEATURES="${__AF_env_var_get91_v0__50_41}"
    env_var_get__91_v0 "EXTRA_SUBSTITUTERS";
    __AS=$?;
    __AF_env_var_get91_v0__51_41="${__AF_env_var_get91_v0}";
    __4_EXTRA_SUBSTITUTERS="${__AF_env_var_get91_v0__51_41}"
    env_var_get__91_v0 "EXTRA_TRUSTED_PUBLIC_KEYS";
    __AS=$?;
    __AF_env_var_get91_v0__52_41="${__AF_env_var_get91_v0}";
    __5_EXTRA_TRUSTED_PUBLIC_KEYS="${__AF_env_var_get91_v0__52_41}"
    env_var_get__91_v0 "NIXIE_VERSION";
    __AS=$?;
    __AF_env_var_get91_v0__54_27="${__AF_env_var_get91_v0}";
    __6_NIXIE_VERSION="${__AF_env_var_get91_v0__54_27}"
}
declare -r cmdl=("$0" "$@")
    __7_args=("${cmdl[@]}")
    load_features__395_v0 ;
    __AF_load_features395_v0__62_5="$__AF_load_features395_v0";
    echo "$__AF_load_features395_v0__62_5" > /dev/null 2>&1
    catch_args__182_v0 __7_args;
    __AF_catch_args182_v0__63_5="$__AF_catch_args182_v0";
    echo "$__AF_catch_args182_v0__63_5" > /dev/null 2>&1
    array_shift__120_v0 __7_args;
    __AF_array_shift120_v0__65_16="${__AF_array_shift120_v0}";
    self="${__AF_array_shift120_v0__65_16}"
    file_exists__33_v0 "/etc/pki/tls/certs/ca-bundle.crt";
    __AF_file_exists33_v0__69_5="$__AF_file_exists33_v0";
    get_osname__154_v0 ;
    __AF_get_osname154_v0__71_5="${__AF_get_osname154_v0}";
    if [ "$__AF_file_exists33_v0__69_5" != 0 ]; then
        env_var_set__90_v0 "NIX_SSL_CERT_FILE" "/etc/pki/tls/certs/ca-bundle.crt";
        __AS=$?;
        __AF_env_var_set90_v0__70_15="$__AF_env_var_set90_v0";
        echo "$__AF_env_var_set90_v0__70_15" > /dev/null 2>&1
elif [ $([ "_${__AF_get_osname154_v0__71_5}" != "_Darwin" ]; echo $?) != 0 ]; then
        env_var_set__90_v0 "NIX_SSL_CERT_FILE" "/etc/ssl/cert.pem";
        __AS=$?;
        __AF_env_var_set90_v0__72_15="$__AF_env_var_set90_v0";
        echo "$__AF_env_var_set90_v0__72_15" > /dev/null 2>&1
fi
    launch_nix__393_v0 "${self}" __7_args[@];
    __AF_launch_nix393_v0__75_5="$__AF_launch_nix393_v0";
    echo "$__AF_launch_nix393_v0__75_5" > /dev/null 2>&1
exit 0
cat <<DONOTPARSE

-----BEGIN ARCHIVE SECTION-----[?1049h
‹«¦¿gÿ íÎÍn‚@`Ö>…q¯!,\ NÓIm`0vEFpùÑ‚Šáé‹MÓ}›4=ßæNîœ{gäZOÅºT~ièšv«ï•ŒŒÑãÜöñp¨t‰òNåQÍ“ÊÿD—Üµ‚'jqß¥Ş¤—Ç—~¸Ï2‘G]™Šd]ö:mÆóm3îsê6¹{—»¾Çé4xóíWæ/ôıvéÍ}×¡c9Ï´]Zâ0E¸/ƒ}±yD¦Ôe‹³ùlë¡)âCTurÙ©«ècoÓZ7ª(ÊHªwflØlæ}ªW†©%¡‘å¦Ö!µyŞª‘Í”’”×!FƒEóëk\%êx@Ô¾P;
                 À_ö	–Ë¡ö (  [?1049l [2K[37;2m# (tarball data)[0m