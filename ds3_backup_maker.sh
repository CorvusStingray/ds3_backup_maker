#!/usr/bin/bash

# save_path=~/Games/SteamLibrary/steamapps/compatdata/374320/pfx/drive_c/users/steamuser/AppData/Roaming/DarkSoulsIII/0110000143c49f1b
save_path=~/Documents/ds3_saves # Test directory
backup_path=~/Documents/ds3_backups

export_import_() {
    operation=$1

    if [ "$operation" == "Export" ]; then
        local select_choices=($(ls $save_path) Back)
        local PS3="[>] Select a save (\"${#select_choices[@]}\" - back to operations): "
    else
        local select_choices=($(ls $backup_path) Back)
        local PS3="[>] Select a backup (\"${#select_choices[@]}\" - back to operations): "
    fi

    select choice in ${select_choices[@]}; do
        case $choice in
            *.sl2)
                if [ "$operation" == "Export" ]; then
                    read -p "[>>] Enter backup name: " backup_name

                    backup=$backup_path/$backup_name[$(date +"%H-%M_%d-%m-%Y")].sl2

                    cp $save_path/$choice $backup

                    echo -e "[+] Backup \"$backup\" successfully saved"
                else
                    read -p "[>>] Enter save slot index in XXXX format (for example - \"0002\"): " save_slot_index

                    save=$save_path/DS3$save_slot_index.sl2

                    if [ -f $save ]; then
                        read -p "[>>] Save slot with index \"$save_slot_index\" exists. Replace it? (type \"YES\" with capital letters to confirm): " replace

                        if [ "$replace" == "YES" ]; then
                            :
                        else
                            echo -e "[!] Backup \"$choice\" will not be imported"

                            continue
                        fi
                    fi

                    cp $backup_path/$choice $save

                    echo -e "[+] Save \"$save\" successfully imported from \"$choice\""
                fi
            ;;
            Back)
                break;;
            *)
                echo -e "[-] Wrong index";;
        esac
    done
}

main() {
    PS3="[>] Choose an operation (\"3\" - quit): "

    select operation in Export Import Quit; do
        case $operation in
            Export | Import)
                export_import_ $operation;;
            Quit)
                exit 0;;
            *)
                echo -e "[-] Wrong index";;
        esac
    done
}

main
