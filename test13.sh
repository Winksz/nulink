#!/bin/bash

print_menu() {
    tput --clear --title "Оберіть опцію" --backtitle "NuLink" \
    --menu "Виберіть опцію:" 15 50 4 \
    1 "Опція 1" \
    2 "Опція 2" \
    3 "Опція 3" \
    4 "Вихід" \
    2>&1 >/dev/tty
}

while true; do
    choice=$(print_menu)
    case "$choice" in
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
        *)
            echo "Неправильний вибір. Будь ласка, виберіть опцію від 1 до 4."
            ;;
    esac
done
