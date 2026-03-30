#!/bin/bash
set -e
# defining associative array
declare ROOTDIR
config="config.bruh"
CLANGD="compile_flags.txt"

declare -A colors
colors=(
    [black]='\033[0;30m'    [red]='\033[0;31m'  [green]='\033[0;32m'    [yellow]='\033[0;33m'   [blue]='\033[0;34m'   [purple]='\033[0;35m'     [cyan]='\033[0;36m'
    [white]='\033[0;37m'

# bold 
    [bred]='\033[1;31m'    [bgreen]='\033[1;32m'    [byellow]='\033[1;33m'      [bblue]='\033[1;34m'

# underline
    [ured]='\033[4;31m'     [ugreen]='\033[4;32m'

# backgrounds (highlight)
    [bg_red]='\033[41m'     [bg_green]='\033[42m'   
    
   # for resetting terminal colour 
    [reset]='\033[0m'
)


declare -A syntax
syntax=(
   [Compiler]="gcc"  [Flags]="-O2"  [appName]="Yo"    [Header]="heads"     [Source]="src"    [extraFlags]=""
)

cSpeak() {
    local color_code=${colors[$1]:-${colors[reset]}}
    printf "%b%s%b\n" "$color_code" "$2" "${colors[reset]}"
}

cSpeak red "Sentient Program rising from the abyss! ...."


# --- 1. config & setup ---
checkConfig() {
    if [ ! -f "$config" ]; then

        for attribute in "${!syntax[@]}"; do
           local value=${syntax[$attribute]}
           echo "${attribute} = \"${value}\"" >> $config
        done
        
        cSpeak yellow "Put your Config in the file I created."

      [ ! -f "main.c" ] && touch main.c
    fi

    if [ ! -f "$CLANGD" ]; then
      echo -e "-Iheads\n-Wall\n-Wextra\n--target=x86_64-w64-windows-gnu" > $CLANGD

      cSpeak green "$CLANGD Initialized!"
    fi
}


ensureFolders() {
   mkdir -p "${syntax[Source]}" "${syntax[Header]}" && mkdir -p "build/release" && mkdir -p "build/debug"
}

# --- 2. parsing ---
get_val() {
    grep "$1" "$config" | sed 's/.*"\(.*\)".*/\1/'
}

updateSyntaxDict(){
            
  for attribute in "${!syntax[@]}"; do
     syntax[attribute]=$(get_val "$attribute")
     echo "attribute: $attribute"
     echo "Value: ${syntax[attribute]}"
  done

  echo "WHAT: ${syntax[extraFlags]}"
}

checkProject(){
  checkConfig 
  ensureFolders 
}

buildProject(){
   [[ -z "$1" ]] && updateSyntaxDict 

  local sources=$(find "${syntax[Source]}" -name "*.c" 2>/dev/null | tr '\n' ' ')
  [ -f "main.c" ] && sources="main.c $sources"
  
  local exe="build/${syntax[appName]}.exe"
   
echo "DEBUG: extraFlags = '${syntax[extraFlags]}'"
  echo "I am building :O ... : $exe"
   echo "Flags are: ${syntax[Flags]}"
   echo "${syntax[Compiler]} ${syntax[Flags]} -I ${syntax[Header]} $sources -o $exe ${syntax[extraFlags]}"
${syntax[Compiler]} ${syntax[Flags]} -I ${syntax[Header]} $sources ${syntax[extraFlags]} -o "$exe"
    if [[ $? -eq 0 && ! -z "$1" ]]; then
       cSpeak green "Built It! :()"
        ./"$exe"
    fi
}


Initiate(){
  mkdir "$1" && cd "$1"
  ROOTDIR=$(PWD)
  checkProject 
}

SpitHelp(){
      echo "
'-i | init' = To Create A Project
'-b | build' = To build Your Project
'-r | run | (no arguments)' = Build And Run 
'-c | check' = Check Syntax Mistakes
"
}

checkArgs(){
  case "$1" in
     -i|init)
      # -z Checks if The Variable Is Empty 
      if [[ -z "$2" ]]; then
        cSpeak red "DAMMIT, Specify The Project Name!"
        exit 1
      fi
      Initiate $2
      cSpeak green "Default Base Has Been Formed -_-"
      exit 0
   ;;

   -b|build) 
      checkProject 
      buildProject 
   ;;
   -r|run)
      checkProject 
      syntax[Flags]="-O0 -Wall -Wextra"
      buildProject "IgnoreBuildConfig"
   ;;
   -c|check)
      checkProject 
      syntax[Flags]="-fsyntax-only -Wall -Wextra"
      buildProject "IgnoreBuildConfig"
   ;;
   -h|help)
      SpitHelp
   ;;
   *) 
      if [[ ! -z "$1" ]]; then
         cSpeak bred "-O- What Do You Meannn? -_-..."
         cSpeak cyan "Also .. Say 'help' If You Want to --"
         exit
      fi
         checkProject 
         syntax[Flags]="-fsyntax-only -Wall -Wextra"
         buildProject "IgnoreBuildConfig"
      exit 
   ;;
  esac
   
}

# --- 4. execution ---



checkArgs "$@" # $@ = Every Single CLI Argument 

