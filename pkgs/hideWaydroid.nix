{
  writeShellScriptBin,
}:

writeShellScriptBin "waydroid-hide-desktop-entries" /*sh*/
  ''
    export a=`ls -m $HOME/.local/share/applications/waydroid.* | tr '\n' ' ' | sed 's/ //g'`;
    function info { GREEN="\033[1;32m" RESET="\033[0m" echo -e "$GREEN> $@$RESET" }
    function warn { RED="\033[1;33m" RESET="\033[0m" echo -e "$RED> $@$RESET" }
    arr=(''${a//,/ })
    for data in ''${arr[@]}
    do
      if [ -e "$data" ]; then
        filename=`echo "$data" | tr '/' ' ' | xargs | tr ' ' '\n' | tail -1`
        case `grep -Fx "NoDisplay=true" "$data" >/dev/null; echo $?` in
          0) # code if found
            warn "W: '$filename' already hidden. [KO!]"
            ;;
          1) # code if not found
            info "I: Hide '$filename' success [OK]"
            echo 'NoDisplay=true' >> "$data"
            ;;
          *) # code if an error occurred
            echo "E: '$filename' HAS FAILED [ERROR]"
            ;;
        esac
      fi
    done
  ''
