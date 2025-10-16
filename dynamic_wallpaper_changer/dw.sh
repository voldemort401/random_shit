#!/bin/bash 

_help(){
  echo "${0} --dir | -d  --image| -i --time| -t"
}

set_wall() {
  local dir="$1"
  local image_files=()

  # List image files and store them in an array
  while IFS= read -r file; do
    image_files+=("$file")
  done < <(find "$dir" -type f -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" )

  # Check if there are any image files
  if [[ ${#image_files[@]} -eq 0 ]]; then
    echo "No image files found in the directory."
    exit 1
  fi

  # Pick a random image file
  random_image="${image_files[RANDOM % ${#image_files[@]}]}"

  feh --bg-fill "${random_image}"
  printf "Setting wall: ${random_image}"
}

_main(){
  local wall_dir=
  #default to 1hour
  local time=3600
  local img=""
  while [[ "${#}" -gt 0 ]]; do
    case "${1}" in 

    --image|-i)
      img=${2:-}
      [ ! -f "${img}" ] && printf "File not found" && exit 1 
      
      exit 0 
    ;;

    --dir|-d) 
      wall_dir="${2:-}"

    [[ -z "${wall_dir}" ]] && printf "%s must have a value" && exit 1 
    [[ ! -d "${wall_dir}" ]] && printf "directory doesn't exist" && exit 1 

    shift 2
    ;; 

  --time|-t)
    time=${2:-}
  ;; 
  *)
    _help
    exit 1
  ;;
  esac 
 done 
  
 set_wall "${wall_dir}"
 sleep "$time"
}

## inf loop
while true; do 
  _main $@
done
