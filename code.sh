#!/bin/bash
usage="$(basename "$0") [-l linker] [-f filename] -- compile c, cpp files 

where:
    -h  display help
    -l  linker
    -f  file name"
    
while getopts ":hf:l:" opt; do
  case $opt in
    h) 
      echo "$usage"
      exit
      ;;
    f)
      echo "Input File : $OPTARG"
      file=$OPTARG
      ;;
    l)  
      flags+=("$OPTARG")
      ;;
    d) 
      not_delete=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "-f requires an input file" >&2
      exit 1
      ;;
  esac
done

# allflags=""
for val in "${flags[@]}"; do
  allflags="$allflags -$val"
done

echo "$allflags"


if [ -z "$file" ]
then
  echo "$usage"
  echo "Please specify an input file using -f flag"
  echo "For eg. $ ./$(basename "$0") -f main.c"
  exit
fi

if [ ! -f ./${file} ]; then
	echo "${file} does not exist";
	exit 1
fi

extension="${file##*.}"
fileName="${file%.*}"


case $extension in

  "c")
    echo "C File"
    echo "compiling ${fileName}"
    

    echo "gcc ${fileName}.c -o ${fileName} $allflags"
    gcc ${fileName}.c -o ${fileName} $allflags

    if [ ! -f ./${fileName} ]; then
    	echo "compilation failed!!"
    else 
    	echo "==============="
    	echo "running ${file}"
    	echo "==============="
      ./${fileName} ${@:3}
    fi
    ;;

  "cpp")
    echo "Cpp File"
    echo "compiling ${fileName}"
    

    echo "g++ ${fileName}.cpp -o ${fileName} $allflags"
    g++ ${fileName}.cpp -o ${fileName} $allflags

    if [ ! -f ./${fileName} ]; then
    	echo "compilation failed!!"
    else 
    	echo "==============="
    	echo "running ${file}"
    	echo "==============="
      ./${fileName} ${@:3}
    fi
    ;;

  "l")
      echo "Lex File"
      echo "compiling ${fileName}"

      echo "flex -o ${fileName}.yy.c ${fileName}.l"
      flex -o ${fileName}.yy.c ${fileName}.l

      echo "gcc -o ${fileName} ${fileName}.yy.c"
      gcc -o ${fileName} ${fileName}.yy.c

      if [ ! -f ./${fileName} ]; then
        echo "compilation failed!!"
      else 
        echo "==============="
        echo "running ${file}"
        echo "==============="
        ./${fileName} ${@:3}
      fi
      ;;

  *)
    echo "unsupported file format"
    echo "Can compile only c and cpp files"
    ;;
esac

# Remove compiled source after running
if [ -z "$not_delete" ]
then
  if [ -f ./${fileName} ]; then
    rm ${fileName}
  fi
fi


