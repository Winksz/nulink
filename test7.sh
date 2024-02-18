#!/bin/bash

print_menu() {
    dialog --clear --backtitle "Оберіть опцію:" \
           --menu "Виберіть одну з наступних опцій:" 15 50 4 \
           1 "Опція 1" \
           2 "Опція 2" \
           3 "Опція 3" \
           4 "Вихід" \
           2> /tmp/menu_choice.txt
    choice=$(cat /tmp/menu_choice.txt)
    rm /tmp/menu_choice.txt
    echo "$choice"
}

while true; do
    current_choice=$(print_menu)
    case "$current_choice" in
        1)
            echo "Ви обрали Опцію 1"
            ;;
        2)
            echo "Ви обрали Опцію 2"
            ;;
        3)
            echo "Ви обрали Опцію 3"
            ;;
        4)
            echo "Ви обрали Вихід. До побачення!"
            exit 0
            ;;
    esac
done
