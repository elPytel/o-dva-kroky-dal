---
layout: post
title:  "Objective Bash"
author: "Jarda"
description: "Bash: Když chcete objekty tam, kde nejsou"
categories: 
    - programming
    - Github
tags: 
    - Bash
thumbnail: assets/pc/Bash-logo.png
---

- [Objective Bash](#objective-bash)
	- [Ukázka použití](#ukázka-použití)
- [Tests](#tests)
	- [Příklad testů](#příklad-testů)


# Objective Bash

Odkaz na [github](https://github.com/elPytel/Shell/blob/main/tools/class/class.sh)


Bash verze 4.0 podporuje asociativní pole, která umožňují vytvářet náhradu za vícerozměrná pole:

```bash
declare -A a # deklaruje asociativní pole 'a'
key="mykey"
a[$key]=5 # asociuje hodnotu "5" s klíči "mykey"
echo ${a[$key]} # vypíše uložené hodnoty na klíči "mykey"
```

Asociativní pole se mi staly základem pro implementaci objektů v Bashi. Vytvořil jsem jednoduchou knihovnu, která umožňuje vytvářet objekty s metodami a vlastnostmi.

Celý soubor `class.sh`:
```bash
#!/bin/bash
# By Pytel

indir_keys() {
    eval "echo \${!$1[@]}"
}

indir_val() {
    eval "echo \${$1[$2]}"
}

# get atribut
function get () { # ( instance.atribut )
	declare -n object=$(echo $1 | cut -d "." -f 1)
	local atribut=$(echo $1 | cut -d "." -f 2)
	echo -e "${object["$atribut"]}"
}

# set atribut
function sat () { # ( instance.atribut = "value" )
	declare -n object=$(echo $1 | cut -d "." -f 1) 
	local atribut=$(echo $1 | cut -d "." -f 2)
	shift; if [ "$1" == "=" ]; then shift; fi
	object["$atribut"]="$1"
}

# run function
function rfn () { # ( instance func atributs )
	local this=$1; shift
	local fun=$1; shift
	local code=$(get $this.$fun)
	eval $code
}

# run object function
function rof () { # ( instance.func atributs ... )
	local this=$(echo $1 | cut -d "." -f1)
	local fun=$(echo $1 | cut -d "." -f2 ); shift
	local code=$(get $this.$fun)
	#$DEBUG && echo -e "Code: \n$code"
	eval $code 
}

# copy class
function copy () { # ( object class )
	declare -n object=$1
	declare -n class=$2

	for atribut in "${!class[@]}"; do 
		object["$atribut"]="${class[$atribut]}"; 
	done
}

# exnteds class
function extend () { # ( object class )
	copy $@
}

# generic contructor
function new () { # ( object = class )
	local args=$(echo $@ | tr -d " " )
	local object=$(echo $args | cut -d "=" -f 1)
	local class=$(echo $args | cut -d "=" -f 2)
	declare -gA $object
	copy $object $class
}

function delete () { # ( object ) 
	unset $1
}

# END
```

## Ukázka použití

```bash
!/bin/bash
# By Pytel
source class.sh

# Definice "tridy"
declare -A ServerClass
ServerClass["name"]="GenericServer"
ServerClass["start"]='echo "Starting server: $(get $this.name)..."'

# Vytvoreni instance
new MyServer = ServerClass

# Zmena atributu
sat MyServer.name = "WebProduction"

# Zavolani metody
rof MyServer.start
# Vystup: Starting server: WebProduction...
```

# Tests

Odkaz na [github](https://github.com/elPytel/Shell/blob/main/tools/bashtest/test.sh)

TDD - test driven development - je přístup k vývoji software, který jde ruku v ruce s objektově orientovaným programováním. 

Vytvořil jsem jednoduchou testovací knihovnu pro Bash, která umožňuje psát testy pro mé objekty. Testy jsou psány jako funkce, které volají metody objektů a porovnávají výsledky s očekávanými hodnotami.

Testovací knihovna `test.sh` má asi 150 řádků a obsahuje funkce pro definici testů, spouštění testů a reportování výsledků.

```bash
#!/bin/bash
# By Pytel
# framework for testing bash scripts
# testing files: test_...sh
# testing metodes: test_... ()

#DEBUG=true
DEBUG=false
VERBOSE=false

function printHelp () {
	echo -e "COMMANDS:"
	echo -e "  -h, --help \t\t print this text"
	echo -e "  -d, --debug\t\t enable debug output"
	echo -e "  -v, --verbose\t\t increase verbosity"
}

function run_function () { # ( function ) 
	local function=$1
	eval $function
	return $?
}

function print_function_and_error_line () { # ( file function errno )
	# print function & error line
	local file=$1
	local function=$2
	local errno=$3

	indexes=$(cat -n $file | grep "function" | grep "()" | tr "\t" " " | tr -s " ")
	len=$(cat $file | wc -l)
	indexes="${indexes}\n ${len}"

	start_end=$(echo -e "$indexes" | grep -A 1 $function | cut -d " " -f 2 | tr "\n" " ")
	start=$(echo $start_end | cut -d " " -f 1)
	end=$(echo $start_end | cut -d " " -f 2)
	end=$(( $end - 1 ))

	code=$(sed -n ${start},${end}p $file)
	faigled_line=$(echo -e "$code" | grep -n "return $errno" | cut -d ":" -f1)

	echo -e "${Red}=== FAILURE ===${NC}\n"
	echo "$code" | sed 's/^/\t/' | sed "${faigled_line}s/^/>/" 
	
	echo -e "\n${Red}ERROR${NC} in: ${Blue}$file${NC} on line: $(( $start + $faigled_line - 1 ))."
}

function test_function () { # ( file function )
	local file=$1
	local function=$2
	local output

	output=$(run_function $function); errno=$?
	
	if [ $errno -ne 0 ]; then
		print_function_and_error_line $file $function $errno
	fi
	
	if $VERBOSE; then
		echo -e "\nFunction output:"
		echo -e "$output"
	fi

	if [ $errno -ne 0 ]; then
		return 1
	fi
	return 0
}

function find_test_functions () { # ( file )
    local file=$1
    local functions=$(cat $file | grep "function test_" | cut -d " " -f 2)
	echo $functions
}

function test_file () { # ( file )
	local file=$@
	local functions=$(find_test_functions $file)
	
	# load functions
	source $file

	local progres=""
	local pass="${Green}.${NC}"
	local fail="${Red}F${NC}"

	$DEBUG && echo -e "All func: $functions"
	for function in $functions; do
		$DEBUG && echo -e "\nFunction: ${Blue}$function${NC}"

		test_function $file $function
		ret=$?
		if [ $ret -eq 0 ]; then
			passed=$((passed+1))
			progres=$progres$pass
		else
			faigled=$((faigled+1))
			progres=$progres$fail
		fi
	done

	# return stats (passed faigled)
	echo -e "Progress: $progres"
	return 0
}

# kazdou funkci spusti a odchyti jeji nermolni a chybovy vystup

# chyby funkci se posilaji na chybovy vystup
# vse ostatni je na normalnim

# standardni format chybovych vystupu

# kdyz funkce chybuje, tak vypisuji do konzole jeji kod
# zvyrazneni radku, ktery navraci danou chybovou hodnotu

# colors
source ../colors.sh

passed=0
faigled=0
files=""

# parse input
$DEBUG && echo "Args: [$@]"
arg=$1
while [ $# -gt 0 ] ; do
	$DEBUG && echo "Arg: $arg remain: $#"

	# vyhodnoceni
	case $arg in
		-h | --help) 	printHelp; exit 2;;
		-d | --debug) 	DEBUG=true;;
		-v | --verbose) VERBOSE=true;;
		*) files=$arg;;
	esac

	# next arg
	shift
	arg=$1
done

# are files set?
if [ -z $files ]; then
	files=$(ls $pwd | tr " " "\n" | grep ".sh" | grep "test_")
fi

number=$(echo $files | tr " " "\n" | wc -l)
echo -e "${Green}=== test session starts ===${NC}"
echo -e "rootdir: ${Blue}$(pwd)${NC}"
echo -e "collected: ${Blue}$number${NC} files"

for file in $files; do
	echo -e "File: ${Blue}$file${NC}"
	# do file exist?
	if [ ! -f $file ]; then
		$VERBOSE && echo "ERROR: $file do not exist!"
		continue
	fi
	test_file $file
done

echo -e "=== ${Green}$passed passed${NC}, ${Red}$faigled failed${NC} ==="

$VERBOSE && echo -e "Done"
exit 0
#END
```

## Příklad testů
Ukazá jak může vypadat test pro funkci `add`:

```bash
#!/bin/bash

inA=( 1 1 4 ) 
inB=( 1 2 2 )
out=( 2 3 42 )

function add () {
	echo $(( $1 + $2 ))
}

function test_add () {
	local len=${#out[@]}
	echo "len: $len"
	for i in $(seq 1 $len); do
		A=${inA[$i]}
		B=${inB[$i]}
		echo "A: $A"
		echo "B: $B"
		sum=$(add $A $B)
		if [ $sum -gt ${out[$i]} ]; then
			return 1
		elif [ $sum -lt ${out[$i]} ]; then
			return 2
		fi
	done
	return 0
}

#END
```